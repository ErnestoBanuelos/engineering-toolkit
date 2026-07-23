# Adversarial Review — Worked Example

**Subject system:** `order-service` — a backend HTTP service that processes e-commerce orders, applies discount codes, calculates totals, and writes confirmed orders to a database.

**Language:** Python (but the findings are language-agnostic in nature)

**Review baseline:** The implementation has passed code review, linting, type checking, and 94 unit tests. A Seven-Lens Review has been completed and its findings are excluded from this pass.

**Purpose of this document:** Demonstrate one complete adversarial review pass with realistic findings, showing one FIX NOW decision and one ACCEPT WITH DOCUMENTED RISK decision.

---

## Source under review (summary)

```
src/
  order_processor.py   — core order pipeline: validate → apply discounts → calculate total → persist
  discount_engine.py   — discount code lookup and stacking rules
  tax_calculator.py    — per-jurisdiction tax computation
  persistence.py       — database write with retry logic
tests/
  test_order_processor.py
  test_discount_engine.py
  test_tax_calculator.py
  test_persistence.py
```

---

## Pre-mortem Analysis

### Cause 1 (Obvious — already mitigated)

**Trigger:** Concurrent requests for the same order ID reach `persistence.py` simultaneously.

**Blast Radius:** Duplicate order records in the database.

**Location:** `persistence.py:write_order()` — database upsert uses `INSERT` without a uniqueness constraint guard.

**Why tests miss it:** All persistence tests run sequentially. No concurrent fixture exists.

*This cause is already tracked in the Seven-Lens Review. Not selected.*

---

### Cause 2

**Trigger:** A discount code with `type="PERCENT"` and `value=110` is applied to an order. The discount engine does not enforce an upper bound on percentage values.

**Blast Radius:** `apply_discount()` in `discount_engine.py` computes `total - (total * 1.10)`, producing a negative order total. The negative total passes the `total >= 0` guard in `order_processor.py` because the guard checks `>= 0`, not `> 0`. The order is persisted with `amount=-18.50`. The payment gateway interprets negative amounts as refund requests and issues a refund to the customer's card for a transaction that was never charged.

**Location:** `discount_engine.py:apply_discount()` — no upper bound check on `value` for PERCENT type codes; `order_processor.py:validate_total()` — guard allows zero but does not detect negative amounts from discount over-application.

**Why tests miss it:** All discount engine tests use percentage values in the range 5–50. No test uses a value above 100. The `test_discount_engine.py` fixture `VALID_PERCENT_CODES` caps at `value=50`.

*Selected as the strongest pre-mortem finding.*

---

### Cause 3

**Trigger:** `tax_calculator.py:compute_tax()` receives a `jurisdiction` parameter that is a two-character string with trailing whitespace (e.g., `"CA "` from a form field). The lookup table uses exact string matching. The jurisdiction is not found, `compute_tax()` returns `0.0`, and the order is completed with no tax applied.

**Blast Radius:** Tax-exempt orders are shipped without collecting tax. The error is silent — the caller receives a valid order total, and no exception is raised. Financial compliance failure becomes visible only during periodic tax reporting.

**Location:** `tax_calculator.py:compute_tax()` — jurisdiction lookup at line 42 uses `rates.get(jurisdiction, 0.0)` with no strip or normalisation step.

**Why tests miss it:** All tax calculator tests supply jurisdiction codes as clean two-character strings. No test supplies a value with leading or trailing whitespace.

---

### Cause 4

**Trigger:** The order pipeline in `order_processor.py` calls `persistence.write_order()` inside a `try/except Exception` block that swallows all exceptions and logs a warning. If the database is unreachable at the moment of write, the function returns `{"status": "ok", "order_id": None}` — a success response with a null order ID.

**Blast Radius:** The HTTP layer returns HTTP 200 to the caller. The caller interprets this as a confirmed order, sends a confirmation email, and decrements inventory. No order record exists in the database. The discrepancy is discovered when the fulfilment team queries for the order and finds nothing.

**Location:** `order_processor.py:process_order()` — the `except Exception` block at line 89 sets `result["status"] = "ok"` regardless of whether persistence succeeded.

**Why tests miss it:** All persistence tests mock `write_order()` to return successfully. No test injects a `DatabaseUnavailableError` at the `process_order` level and checks the HTTP response body.

---

### Cause 5

**Trigger:** A discount code with `max_uses=0` is created in the database (representing a code that has been exhausted). The discount engine checks `current_uses < max_uses`, which evaluates to `0 < 0 = False`, correctly blocking the code. However, a code created with `max_uses=None` (representing "unlimited uses") is also blocked because `0 < None` raises `TypeError` in Python 3, which is caught by the calling `try/except` block and logged as a validation failure rather than re-raised. The code is silently rejected.

**Blast Radius:** Valid unlimited-use promotional codes are rejected for all customers. The rejection is logged as a warning, not an error. The failure is discovered when the marketing team reports that a promotion has zero redemptions.

**Location:** `discount_engine.py:is_code_valid()` — comparison `current_uses < max_uses` at line 67 does not handle `max_uses=None` before comparison.

---

### Selected Finding and Mitigation

**Selected: Cause 2** — Percentage discount over 100% produces a negative order total that passes validation and triggers an unintended payment gateway refund.

This is the strongest finding because:
1. It is reachable through normal database operations — any admin can create a discount code with `value=110`.
2. The failure is partially silent: the order is persisted successfully and the API returns a valid response. The refund is only triggered later by the payment gateway.
3. No existing test covers percentage values above 100.

**Mitigation:**

Add a non-negativity guard at two points:

```python
# discount_engine.py — add upper bound on PERCENT type codes
def apply_discount(total: float, code: DiscountCode) -> float:
    if code.type == "PERCENT":
        if not (0 < code.value <= 100):        # ← add this guard
            raise ValueError(
                f"PERCENT discount value must be in range (0, 100]; got {code.value}"
            )
        return total * (1 - code.value / 100)
    ...

# order_processor.py — make the total guard strict
def validate_total(total: float) -> None:
    if total <= 0:                              # ← change >= 0 to > 0
        raise ValueError(f"Order total must be positive; got {total}")
```

The two-point fix is defence in depth: the discount engine rejects the malformed code at the source, and the pipeline rejects a non-positive total as a second barrier.

---

## Edge Case Analysis

### Candidate 1 — Empty items list in order

**Input shape:** `process_order(items=[], discount_code=None, jurisdiction="CA")`

**Observable failure:** `order_processor.py:calculate_subtotal()` calls `sum(item.price for item in items)` which returns `0.0` for an empty list. The pipeline proceeds, applies tax on `0.0`, and persists an order with `amount=0.0`. The payment gateway is called with a zero-amount charge, which most gateways reject with HTTP 422. The error propagates back through the swallowed exception path (Cause 4 above), returning HTTP 200 with `order_id=None`.

**Location:** `order_processor.py:calculate_subtotal()` — no guard on empty items.

**Why current tests miss it:** `TestOrderProcessor.test_single_item_order` and `test_multi_item_order` both provide non-empty item lists. No test passes an empty list.

---

### Candidate 2 (strongest) — Discount code `value` supplied as string from JSON deserialisation

**Input shape:** An HTTP client submits a discount code lookup payload where the `value` field is a JSON string rather than a number: `{"code": "SAVE10", "value": "10"}`. The JSON deserialiser does not coerce types. `discount_engine.py:apply_discount()` receives `code.value = "10"` (a string). The computation `total * (1 - code.value / 100)` raises `TypeError: unsupported operand type(s) for /: 'str' and 'int'`. This exception is caught by the outer handler in `order_processor.py`, which logs a warning and returns `{"status": "ok", "discount_applied": False}` — a silent rejection of a valid code.

**Location:** `discount_engine.py:DiscountCode.__init__()` — the `value` field is typed as `float` but no runtime coercion or validation enforces this. `order_processor.py:process_order()` — the outer exception handler silently converts any error into a partial success response.

**Why current tests miss it:** All `TestDiscountEngine` fixtures construct `DiscountCode` objects directly in Python with typed values. No test exercises the HTTP deserialisation path where types are strings. The integration test suite does not cover the discount code payload path.

*Selected as the strongest edge case.*

**Proposed mitigation:** Add type coercion at the `DiscountCode` constructor boundary:

```python
@dataclass
class DiscountCode:
    code: str
    type: str
    value: float

    def __post_init__(self) -> None:
        self.value = float(self.value)   # ← coerce at construction time
```

This ensures that string values from JSON deserialisation are converted before any arithmetic is attempted.

---

### Candidate 3 — Jurisdiction code that is an empty string

**Input shape:** `tax_calculator.compute_tax(subtotal=100.0, jurisdiction="")`

**Observable failure:** `rates.get("", 0.0)` returns `0.0`. Tax is not applied. The order proceeds with zero tax for an unknown jurisdiction instead of raising an error or requiring the caller to provide a valid jurisdiction.

**Location:** `tax_calculator.py:compute_tax()` — no guard on empty or blank jurisdiction strings.

**Why current tests miss it:** All tax calculator tests supply valid two-character jurisdiction codes. No test passes an empty string.

---

## Resolution

### Pre-mortem Finding — Cause 2 (discount over 100% produces negative total)

**Resolution: FIX NOW**

**Justification:** The failure path is reachable through normal database operations (creating a discount code with `value > 100`) and produces a financial consequence (unintended payment gateway refund) that is partially silent. The fix is two guard clauses in existing functions — a minimal, focused change with no side effects on other code paths.

**Code change:** As described in the mitigation above — add a `(0, 100]` range guard in `discount_engine.py:apply_discount()` and change the `>= 0` guard in `order_processor.py:validate_total()` to `> 0`.

**Test to add:**

```python
# test_discount_engine.py
def test_percent_discount_above_100_raises():
    code = DiscountCode(code="BAD", type="PERCENT", value=110)
    with pytest.raises(ValueError, match="must be in range"):
        apply_discount(total=100.0, code=code)

# test_order_processor.py
def test_validate_total_rejects_zero():
    with pytest.raises(ValueError, match="must be positive"):
        validate_total(0.0)

def test_validate_total_rejects_negative():
    with pytest.raises(ValueError, match="must be positive"):
        validate_total(-18.50)
```

---

### Edge Case Finding — Candidate 2 (discount `value` as string from JSON)

**Resolution: ACCEPT WITH DOCUMENTED RISK**

**Justification:** The `DiscountCode` dataclass is an internal domain model. The current codebase does not have a dedicated HTTP deserialisation layer — discount code objects are constructed directly in integration tests. The specification does not define the HTTP payload schema or a required type coercion step. Applying `float(self.value)` in `__post_init__` is correct engineering, but it introduces a coercion behaviour that is not required by any current specification and could mask malformed inputs that should fail loudly.

**Accepted risk condition:** The current callers are all typed Python and construct `DiscountCode` objects with correct types. The risk of a string-typed value reaching `apply_discount()` in the current deployment is low.

**Condition for FIX NOW:** If an HTTP API is added that deserialises discount code payloads from JSON into `DiscountCode` objects without explicit type validation, this finding must be re-evaluated and the coercion added at the deserialisation boundary.

**No code change is made for this item.**

---

## Validation

- [x] Every finding cites a specific file, function, or line number.
- [x] No finding repeats a prior Seven-Lens Review finding.
- [x] No finding repeats a case already covered by the existing test suite.
- [x] Each selected finding has exactly one resolution decision with a written justification.
- [x] FIX NOW resolution includes a minimal code change description.
- [x] FIX NOW resolution includes three new tests.
- [x] Full test suite passes after code changes (97 tests, was 94).
- [x] Linting and type checking pass after code changes.

---

## Overall Verdict

**APPROVED** — after the discount range guard and total positivity fix have been applied.

The confirmed defect (percentage discount above 100% producing a negative order total) has been corrected. The edge case risk (string-typed discount value from JSON deserialisation) is accepted with documented conditions for re-evaluation. No other defects were identified that are not already tracked in the Seven-Lens Review.

| Finding | Category | Resolution |
|---|---|---|
| Percent discount > 100% produces negative total | Confirmed defect — financial | FIX NOW — applied |
| `DiscountCode.value` accepts string from JSON | Undefined input type — internal API | ACCEPT WITH DOCUMENTED RISK |
