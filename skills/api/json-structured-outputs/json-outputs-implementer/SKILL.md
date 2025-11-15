---
name: json-outputs-implementer
version: 0.1.0
description: Specialized skill for implementing JSON outputs mode with guaranteed schema compliance. Covers schema design respecting limitations, SDK integration (Pydantic/Zod), validation, testing, and production optimization. Use after structured-outputs-advisor determines JSON outputs is the right mode.
author: Connor
category: api-features
---

# JSON Outputs Implementer

## Overview

This skill specializes in implementing Anthropic's JSON outputs mode (`output_format`), which guarantees Claude's responses match your JSON schema. It guides you through schema design, SDK integration, testing, and production deployment with focus on data extraction, classification, and API response formatting use cases.

**What This Skill Provides:**
- ✅ Production-ready JSON schema design
- ✅ SDK integration (Pydantic for Python, Zod for TypeScript)
- ✅ Validation and error handling patterns
- ✅ Performance optimization strategies
- ✅ Complete implementation examples

**Prerequisites:**
- You've decided JSON outputs is the right mode (via `structured-outputs-advisor`)
- Model: Claude Sonnet 4.5 or Opus 4.1
- Beta header: `structured-outputs-2025-11-13`

## When to Use This Skill

**This skill is for JSON outputs mode specifically:**
- ✅ Extracting structured data from text/images
- ✅ Classification tasks with guaranteed categories
- ✅ Generating API-ready responses
- ✅ Formatting reports with fixed structure
- ✅ Database inserts requiring type safety

**NOT for:**
- ❌ Validating tool inputs (use `strict-tool-implementer`)
- ❌ Agentic workflows (use `strict-tool-implementer`)

## Response Style

- **Schema-first**: Design schema before implementation
- **SDK-friendly**: Leverage Pydantic/Zod when available
- **Production-ready**: Consider performance, caching, errors
- **Example-driven**: Provide complete working code
- **Limitation-aware**: Respect JSON Schema constraints

## Workflow

### Phase 1: Schema Design

**Objective**: Create a production-ready JSON schema respecting all limitations

**Steps:**

1. **Define Output Structure**

   Ask the user:
   - "What fields do you need in the output?"
   - "Which fields are required vs. optional?"
   - "What are the data types for each field?"
   - "Are there nested objects or arrays?"

2. **Choose Schema Approach**

   **Option A: Pydantic (Python) - Recommended**
   ```python
   from pydantic import BaseModel
   from typing import List, Optional

   class ContactInfo(BaseModel):
       name: str
       email: str
       plan_interest: Optional[str] = None
       demo_requested: bool = False
       tags: List[str] = []
   ```

   **Option B: Zod (TypeScript) - Recommended**
   ```typescript
   import { z } from 'zod';

   const ContactInfoSchema = z.object({
     name: z.string(),
     email: z.string().email(),
     plan_interest: z.string().optional(),
     demo_requested: z.boolean().default(false),
     tags: z.array(z.string()).default([]),
   });
   ```

   **Option C: Raw JSON Schema**
   ```json
   {
     "type": "object",
     "properties": {
       "name": {"type": "string", "description": "Full name"},
       "email": {"type": "string", "description": "Email address"},
       "plan_interest": {"type": "string", "description": "Interested plan"},
       "demo_requested": {"type": "boolean"},
       "tags": {"type": "array", "items": {"type": "string"}}
     },
     "required": ["name", "email", "demo_requested"],
     "additionalProperties": false
   }
   ```

3. **Apply JSON Schema Limitations**

   **✅ Supported Features:**
   - All basic types: object, array, string, integer, number, boolean, null
   - `enum` (strings, numbers, bools, nulls only)
   - `const`
   - `anyOf` and `allOf` (limited)
   - `$ref`, `$def`, `definitions` (local only)
   - `required` and `additionalProperties: false`
   - String formats: date-time, time, date, email, uri, uuid, ipv4, ipv6
   - Array `minItems` (0 or 1 only)

   **❌ NOT Supported (SDK can transform these):**
   - Recursive schemas
   - Numerical constraints (minimum, maximum)
   - String constraints (minLength, maxLength)
   - Complex array constraints
   - External `$ref`

4. **Add AI-Friendly Descriptions**

   ```python
   class Invoice(BaseModel):
       invoice_number: str  # Field(description="Invoice ID, format: INV-XXXXX")
       date: str  # Field(description="Invoice date in YYYY-MM-DD format")
       total: float  # Field(description="Total amount in USD")
       items: List[LineItem]  # Field(description="Line items on the invoice")
   ```

   Good descriptions help Claude understand what to extract.

**Output**: Production-ready schema

---

### Phase 2: SDK Integration

**Objective**: Implement using SDK helpers for automatic validation

**Python Implementation:**

**Recommended: Use `client.beta.messages.parse()`**

```python
from pydantic import BaseModel, Field
from typing import List, Optional
from anthropic import Anthropic

class ContactInfo(BaseModel):
    name: str = Field(description="Full name of the contact")
    email: str = Field(description="Email address")
    plan_interest: Optional[str] = Field(
        None, description="Plan tier they're interested in"
    )
    demo_requested: bool = Field(
        False, description="Whether they requested a demo"
    )

client = Anthropic()

def extract_contact(text: str) -> ContactInfo:
    """Extract contact information from text."""
    response = client.beta.messages.parse(
        model="claude-sonnet-4-5",
        max_tokens=1024,
        betas=["structured-outputs-2025-11-13"],
        messages=[{
            "role": "user",
            "content": f"Extract contact information from: {text}"
        }],
        output_format=ContactInfo,
    )

    # Handle edge cases
    if response.stop_reason == "refusal":
        raise ValueError("Claude refused the request")

    if response.stop_reason == "max_tokens":
        raise ValueError("Response truncated - increase max_tokens")

    # Automatically validated
    return response.parsed_output

# Usage
contact = extract_contact("John Smith (john@example.com) wants Enterprise plan")
print(contact.name, contact.email)  # Type-safe access
```

**TypeScript Implementation:**

```typescript
import Anthropic from '@anthropic-ai/sdk';
import { z } from 'zod';
import { betaZodOutputFormat } from '@anthropic-ai/sdk/helpers/beta/zod';

const ContactInfoSchema = z.object({
  name: z.string().describe("Full name of the contact"),
  email: z.string().email().describe("Email address"),
  plan_interest: z.string().optional().describe("Plan tier interested in"),
  demo_requested: z.boolean().default(false).describe("Demo requested"),
});

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

async function extractContact(text: string) {
  const response = await client.beta.messages.parse({
    model: "claude-sonnet-4-5",
    max_tokens: 1024,
    betas: ["structured-outputs-2025-11-13"],
    messages: [{
      role: "user",
      content: `Extract contact information from: ${text}`
    }],
    output_format: betaZodOutputFormat(ContactInfoSchema),
  });

  if (response.stop_reason === "refusal") {
    throw new Error("Claude refused the request");
  }

  if (response.stop_reason === "max_tokens") {
    throw new Error("Response truncated - increase max_tokens");
  }

  return response.parsed_output;
}

// Usage
const contact = await extractContact("John Smith (john@example.com)...");
console.log(contact.name, contact.email);  // Fully typed
```

**Output**: Working implementation with SDK validation

---

### Phase 3: Error Handling

**Objective**: Handle refusals, token limits, and validation errors

**Key Error Scenarios:**

1. **Safety Refusals** (`stop_reason: "refusal"`)
   ```python
   if response.stop_reason == "refusal":
       logger.warning(f"Request refused: {input_text}")
       # Don't retry - respect safety boundaries
       return None  # or raise exception
   ```

2. **Token Limit Reached** (`stop_reason: "max_tokens"`)
   ```python
   if response.stop_reason == "max_tokens":
       # Retry with higher limit
       return extract_with_higher_limit(text, max_tokens * 1.5)
   ```

3. **Schema Validation Errors** (SDK raises exception)
   ```python
   from pydantic import ValidationError

   try:
       result = response.parsed_output
   except ValidationError as e:
       logger.error(f"Schema validation failed: {e}")
       # Should be rare - indicates schema mismatch
       raise
   ```

4. **API Errors** (400 - schema too complex)
   ```python
   from anthropic import BadRequestError

   try:
       response = client.beta.messages.parse(...)
   except BadRequestError as e:
       if "too complex" in str(e).lower():
           # Simplify schema
           logger.error("Schema too complex, simplifying...")
       raise
   ```

**Output**: Robust error handling

---

### Phase 4: Testing

**Objective**: Validate schema works with representative data

**Test Coverage:**

```python
import pytest

@pytest.fixture
def extractor():
    return ContactExtractor()

def test_complete_contact(extractor):
    """Test with all fields present."""
    text = "John Smith (john@example.com) interested in Enterprise plan, wants demo"
    result = extractor.extract(text)

    assert result.name == "John Smith"
    assert result.email == "john@example.com"
    assert result.plan_interest == "Enterprise"
    assert result.demo_requested is True

def test_minimal_contact(extractor):
    """Test with only required fields."""
    text = "Contact: jane@example.com"
    result = extractor.extract(text)

    assert result.email == "jane@example.com"
    assert result.name is not None  # Claude should infer or extract
    assert result.plan_interest is None  # Optional field
    assert result.demo_requested is False  # Default

def test_invalid_input(extractor):
    """Test with insufficient data."""
    text = "This has no contact information"
    # Depending on requirements, might raise or return partial data
    result = extractor.extract(text)
    # Define expected behavior

def test_refusal_scenario(extractor):
    """Test that refusals are handled."""
    # Test with potentially unsafe content
    # Verify graceful handling without crash
    pass

def test_token_limit(extractor):
    """Test with very long input."""
    text = "..." * 10000  # Very long text
    # Verify either succeeds or raises appropriate error
    pass
```

**Output**: Comprehensive test suite

---

### Phase 5: Production Optimization

**Objective**: Optimize for performance, cost, and reliability

**1. Grammar Caching Strategy**

The first request compiles a grammar from your schema (~extra latency). Subsequent requests use cached grammar (24-hour TTL).

**Cache Invalidation Triggers:**
- Schema structure changes
- Tool set changes (if using tools + JSON outputs together)
- 24 hours of non-use

**Best Practices:**
```python
# ✅ Good: Finalize schema before production
CONTACT_SCHEMA = ContactInfo  # Reuse same schema

# ❌ Bad: Dynamic schema generation
def get_schema(include_phone: bool):  # Different schemas = cache misses
    if include_phone:
        class Contact(BaseModel):
            phone: str
            ...
    ...
```

**2. Token Cost Management**

Structured outputs add tokens via system prompt:
```python
# Monitor token usage
response = client.beta.messages.parse(...)
print(f"Input tokens: {response.usage.input_tokens}")
print(f"Output tokens: {response.usage.output_tokens}")

# Optimize descriptions for token efficiency
# ✅ Good: Concise but clear
name: str = Field(description="Full name")

# ❌ Excessive: Too verbose
name: str = Field(description="The complete full name of the person including first name, middle name if available, and last name")
```

**3. Monitoring**

```python
import time
from dataclasses import dataclass

@dataclass
class StructuredOutputMetrics:
    latency_ms: float
    input_tokens: int
    output_tokens: int
    cache_hit: bool  # Infer from latency
    stop_reason: str

def track_metrics(response, start_time) -> StructuredOutputMetrics:
    latency = (time.time() - start_time) * 1000

    return StructuredOutputMetrics(
        latency_ms=latency,
        input_tokens=response.usage.input_tokens,
        output_tokens=response.usage.output_tokens,
        cache_hit=latency < 500,  # Heuristic: fast = cache hit
        stop_reason=response.stop_reason,
    )

# Track in production
metrics = track_metrics(response, start_time)
if metrics.latency_ms > 1000:
    logger.warning(f"Slow structured output: {metrics.latency_ms}ms")
```

**Output**: Production-optimized implementation

---

## Common Use Cases

### Use Case 1: Data Extraction

**Scenario**: Extract invoice data from text/images

```python
from pydantic import BaseModel
from typing import List

class LineItem(BaseModel):
    description: str
    quantity: int
    unit_price: float
    total: float

class Invoice(BaseModel):
    invoice_number: str
    date: str
    customer_name: str
    line_items: List[LineItem]
    subtotal: float
    tax: float
    total_amount: float

response = client.beta.messages.parse(
    model="claude-sonnet-4-5",
    betas=["structured-outputs-2025-11-13"],
    max_tokens=2048,
    messages=[{"role": "user", "content": f"Extract invoice:\n{invoice_text}"}],
    output_format=Invoice,
)

invoice = response.parsed_output
# Insert into database with guaranteed types
db.insert_invoice(invoice.model_dump())
```

### Use Case 2: Classification

**Scenario**: Classify support tickets

```python
class TicketClassification(BaseModel):
    category: str  # "billing", "technical", "sales"
    priority: str  # "low", "medium", "high", "critical"
    confidence: float
    requires_human: bool
    suggested_assignee: Optional[str] = None
    tags: List[str]

response = client.beta.messages.parse(
    model="claude-sonnet-4-5",
    betas=["structured-outputs-2025-11-13"],
    messages=[{"role": "user", "content": f"Classify:\n{ticket}"}],
    output_format=TicketClassification,
)

classification = response.parsed_output
if classification.requires_human or classification.confidence < 0.7:
    route_to_human(ticket)
else:
    auto_assign(ticket, classification.category)
```

### Use Case 3: API Response Formatting

**Scenario**: Generate API-ready responses

```python
class APIResponse(BaseModel):
    status: str  # "success" or "error"
    data: dict
    errors: Optional[List[dict]] = None
    metadata: dict

response = client.beta.messages.parse(
    model="claude-sonnet-4-5",
    betas=["structured-outputs-2025-11-13"],
    messages=[{"role": "user", "content": f"Process: {request}"}],
    output_format=APIResponse,
)

# Directly return as JSON API response
return jsonify(response.parsed_output.model_dump())
```

---

## JSON Schema Limitations Reference

**Supported:**
- ✅ All basic types (object, array, string, integer, number, boolean, null)
- ✅ `enum` (primitives only)
- ✅ `const`, `anyOf`, `allOf`
- ✅ `$ref`, `$def`, `definitions` (local)
- ✅ `required`, `additionalProperties: false`
- ✅ String formats: date-time, time, date, email, uri, uuid, ipv4, ipv6
- ✅ `minItems: 0` or `minItems: 1` for arrays

**NOT Supported:**
- ❌ Recursive schemas
- ❌ Numerical constraints (minimum, maximum, multipleOf)
- ❌ String constraints (minLength, maxLength, pattern with complex regex)
- ❌ Array constraints (beyond minItems 0/1)
- ❌ External `$ref`
- ❌ Complex types in enums

**SDK Transformation:**
Python and TypeScript SDKs automatically remove unsupported constraints and add them to descriptions.

---

## Success Criteria

- [ ] Schema designed with all required fields
- [ ] JSON Schema limitations respected
- [ ] SDK helper integrated (Pydantic/Zod)
- [ ] Beta header included in requests
- [ ] Error handling for refusals and token limits
- [ ] Tested with representative examples
- [ ] Edge cases covered (missing fields, invalid data)
- [ ] Production optimization considered (caching, tokens)
- [ ] Monitoring in place (latency, costs)
- [ ] Documentation provided

## Important Reminders

1. **Use SDK helpers** - `client.beta.messages.parse()` auto-validates
2. **Respect limitations** - No recursive schemas, no min/max constraints
3. **Add descriptions** - Helps Claude understand what to extract
4. **Handle refusals** - Don't retry safety refusals
5. **Monitor performance** - Watch for cache misses and high latency
6. **Set `additionalProperties: false`** - Required for all objects
7. **Test thoroughly** - Edge cases often reveal schema issues

---

**Official Documentation**: https://docs.anthropic.com/en/docs/build-with-claude/structured-outputs

**Related Skills**:
- `structured-outputs-advisor` - Choose the right mode
- `strict-tool-implementer` - For tool validation use cases
