---
name: strict-tool-implementer
version: 0.1.0
description: Specialized skill for implementing strict tool use mode with guaranteed parameter validation. Covers tool schema design, multi-tool agentic workflows, validation patterns, and production agent systems. Use after structured-outputs-advisor determines strict tool use is the right mode.
author: Connor
category: api-features
---

# Strict Tool Implementer

## Overview

This skill specializes in implementing Anthropic's strict tool use mode (`strict: true`), which guarantees tool input parameters strictly follow your schema. It guides you through tool schema design, multi-tool agent workflows, testing, and production deployment for reliable agentic systems.

**What This Skill Provides:**
- ✅ Production-ready tool schema design
- ✅ Multi-tool workflow patterns
- ✅ Agentic system architecture
- ✅ Validation and error handling
- ✅ Complete agent implementation examples

**Prerequisites:**
- You've decided strict tool use is the right mode (via `structured-outputs-advisor`)
- Model: Claude Sonnet 4.5 or Opus 4.1
- Beta header: `structured-outputs-2025-11-13`

## When to Use This Skill

**This skill is for strict tool use mode specifically:**
- ✅ Building multi-step agentic workflows
- ✅ Validating function call parameters
- ✅ Ensuring type-safe tool execution
- ✅ Complex tools with nested properties
- ✅ Critical operations requiring guaranteed types

**NOT for:**
- ❌ Extracting data from text/images (use `json-outputs-implementer`)
- ❌ Formatting API responses (use `json-outputs-implementer`)
- ❌ Classification tasks (use `json-outputs-implementer`)

## Response Style

- **Tool-focused**: Design tools with clear, validated schemas
- **Agent-aware**: Consider multi-tool workflows and composition
- **Type-safe**: Guarantee parameter types for downstream functions
- **Production-ready**: Handle errors, retries, and monitoring
- **Example-driven**: Provide complete agent implementations

## Workflow

### Phase 1: Tool Schema Design

**Objective**: Design validated tool schemas for your agent

**Steps:**

1. **Identify Required Tools**

   Ask the user:
   - "What actions should the agent be able to perform?"
   - "What external systems will the agent interact with?"
   - "What parameters does each tool need?"

   Example agent: Travel booking
   - `search_flights` - Find available flights
   - `book_flight` - Reserve a flight
   - `search_hotels` - Find hotels
   - `book_hotel` - Reserve accommodation

2. **Design Tool Schema with `strict: true`**

   **Template:**
   ```python
   {
       "name": "tool_name",
       "description": "Clear description of what this tool does",
       "strict": True,  # ← Enables strict mode
       "input_schema": {
           "type": "object",
           "properties": {
               "param_name": {
                   "type": "string",
                   "description": "Clear parameter description"
               }
           },
           "required": ["param_name"],
           "additionalProperties": False  # ← Required
       }
   }
   ```

   **Example: Flight Search Tool**
   ```python
   {
       "name": "search_flights",
       "description": "Search for available flights between two cities",
       "strict": True,
       "input_schema": {
           "type": "object",
           "properties": {
               "origin": {
                   "type": "string",
                   "description": "Departure city (e.g., 'San Francisco, CA')"
               },
               "destination": {
                   "type": "string",
                   "description": "Arrival city (e.g., 'Paris, France')"
               },
               "departure_date": {
                   "type": "string",
                   "format": "date",
                   "description": "Departure date in YYYY-MM-DD format"
               },
               "return_date": {
                   "type": "string",
                   "format": "date",
                   "description": "Return date in YYYY-MM-DD format (optional)"
               },
               "travelers": {
                   "type": "integer",
                   "enum": [1, 2, 3, 4, 5, 6],
                   "description": "Number of travelers"
               },
               "class": {
                   "type": "string",
                   "enum": ["economy", "premium", "business", "first"],
                   "description": "Flight class preference"
               }
           },
           "required": ["origin", "destination", "departure_date", "travelers"],
           "additionalProperties": False
       }
   }
   ```

3. **Apply JSON Schema Limitations**

   **✅ Supported:**
   - All basic types (object, array, string, integer, number, boolean)
   - `enum` for constrained values
   - `format` for strings (date, email, uri, uuid, etc.)
   - Nested objects and arrays
   - `required` fields
   - `additionalProperties: false` (required!)

   **❌ NOT Supported:**
   - Recursive schemas
   - Numerical constraints (minimum, maximum)
   - String length constraints
   - Complex regex patterns

4. **Add Clear Descriptions**

   Good descriptions help Claude:
   - Understand when to call the tool
   - Know what values to provide
   - Format parameters correctly

   ```python
   # ✅ Good: Clear and specific
   "origin": {
       "type": "string",
       "description": "Departure city and state/country (e.g., 'San Francisco, CA')"
   }

   # ❌ Vague: Not helpful
   "origin": {
       "type": "string",
       "description": "Origin"
   }
   ```

**Output**: Well-designed tool schemas

---

### Phase 2: Multi-Tool Agent Implementation

**Objective**: Implement agent with multiple validated tools

**Python Implementation:**

```python
from anthropic import Anthropic
from typing import Dict, Any, List

client = Anthropic()

# Define tools
TOOLS = [
    {
        "name": "search_flights",
        "description": "Search for available flights",
        "strict": True,
        "input_schema": {
            "type": "object",
            "properties": {
                "origin": {"type": "string", "description": "Departure city"},
                "destination": {"type": "string", "description": "Arrival city"},
                "departure_date": {"type": "string", "format": "date"},
                "travelers": {"type": "integer", "enum": [1, 2, 3, 4, 5, 6]}
            },
            "required": ["origin", "destination", "departure_date", "travelers"],
            "additionalProperties": False
        }
    },
    {
        "name": "book_flight",
        "description": "Book a selected flight",
        "strict": True,
        "input_schema": {
            "type": "object",
            "properties": {
                "flight_id": {"type": "string", "description": "Flight identifier"},
                "passengers": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "name": {"type": "string"},
                            "passport": {"type": "string"}
                        },
                        "required": ["name", "passport"],
                        "additionalProperties": False
                    }
                }
            },
            "required": ["flight_id", "passengers"],
            "additionalProperties": False
        }
    },
    {
        "name": "search_hotels",
        "description": "Search for hotels in a city",
        "strict": True,
        "input_schema": {
            "type": "object",
            "properties": {
                "city": {"type": "string", "description": "City name"},
                "check_in": {"type": "string", "format": "date"},
                "check_out": {"type": "string", "format": "date"},
                "guests": {"type": "integer", "enum": [1, 2, 3, 4]}
            },
            "required": ["city", "check_in", "check_out", "guests"],
            "additionalProperties": False
        }
    }
]

# Tool execution functions
def search_flights(origin: str, destination: str, departure_date: str, travelers: int) -> Dict:
    """Execute flight search - calls actual API."""
    # Implementation here
    return {"flights": [...]}

def book_flight(flight_id: str, passengers: List[Dict]) -> Dict:
    """Book the flight - calls actual API."""
    # Implementation here
    return {"confirmation": "ABC123", "status": "confirmed"}

def search_hotels(city: str, check_in: str, check_out: str, guests: int) -> Dict:
    """Search hotels - calls actual API."""
    # Implementation here
    return {"hotels": [...]}

# Tool registry
TOOL_FUNCTIONS = {
    "search_flights": search_flights,
    "book_flight": book_flight,
    "search_hotels": search_hotels,
}

# Agent loop
def run_agent(user_request: str, max_turns: int = 10):
    """Run agent with tool validation."""
    messages = [{"role": "user", "content": user_request}]

    for turn in range(max_turns):
        response = client.beta.messages.create(
            model="claude-sonnet-4-5",
            max_tokens=2048,
            betas=["structured-outputs-2025-11-13"],
            messages=messages,
            tools=TOOLS,
        )

        # Process response
        if response.stop_reason == "end_turn":
            # Agent finished
            return extract_final_answer(response)

        if response.stop_reason == "tool_use":
            # Execute tools
            tool_results = []

            for block in response.content:
                if block.type == "tool_use":
                    # Tool input is GUARANTEED to match schema
                    tool_name = block.name
                    tool_input = block.input  # Already validated!

                    # Execute tool
                    tool_function = TOOL_FUNCTIONS[tool_name]
                    result = tool_function(**tool_input)  # Type-safe!

                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": str(result)
                    })

            # Add assistant response and tool results to conversation
            messages.append({"role": "assistant", "content": response.content})
            messages.append({"role": "user", "content": tool_results})

        else:
            raise Exception(f"Unexpected stop reason: {response.stop_reason}")

    raise Exception("Max turns reached")

# Usage
result = run_agent("Book a flight from SF to Paris for 2 people, departing May 15")
print(result)
```

**TypeScript Implementation:**

```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

const TOOLS: Anthropic.Tool[] = [
  {
    name: "search_flights",
    description: "Search for available flights",
    strict: true,
    input_schema: {
      type: "object",
      properties: {
        origin: { type: "string", description: "Departure city" },
        destination: { type: "string", description: "Arrival city" },
        departure_date: { type: "string", format: "date" },
        travelers: { type: "integer", enum: [1, 2, 3, 4, 5, 6] }
      },
      required: ["origin", "destination", "departure_date", "travelers"],
      additionalProperties: false
    }
  },
  // ... other tools
];

async function runAgent(userRequest: string, maxTurns: number = 10) {
  const messages: Anthropic.MessageParam[] = [
    { role: "user", content: userRequest }
  ];

  for (let turn = 0; turn < maxTurns; turn++) {
    const response = await client.beta.messages.create({
      model: "claude-sonnet-4-5",
      max_tokens: 2048,
      betas: ["structured-outputs-2025-11-13"],
      messages,
      tools: TOOLS,
    });

    if (response.stop_reason === "end_turn") {
      return extractFinalAnswer(response);
    }

    if (response.stop_reason === "tool_use") {
      const toolResults: Anthropic.ToolResultBlockParam[] = [];

      for (const block of response.content) {
        if (block.type === "tool_use") {
          // Input guaranteed to match schema!
          const result = await executeTool(block.name, block.input);

          toolResults.push({
            type: "tool_result",
            tool_use_id: block.id,
            content: JSON.stringify(result)
          });
        }
      }

      messages.push({ role: "assistant", content: response.content });
      messages.push({ role: "user", content: toolResults });
    }
  }

  throw new Error("Max turns reached");
}
```

**Output**: Working multi-tool agent

---

### Phase 3: Error Handling & Validation

**Objective**: Handle errors and edge cases in agent workflows

**Key Error Scenarios:**

1. **Tool Execution Failures**

   ```python
   def execute_tool_safely(tool_name: str, tool_input: Dict) -> Dict:
       """Execute tool with error handling."""
       try:
           tool_function = TOOL_FUNCTIONS[tool_name]
           result = tool_function(**tool_input)
           return {"success": True, "data": result}

       except Exception as e:
           logger.error(f"Tool {tool_name} failed: {e}")
           return {
               "success": False,
               "error": str(e),
               "message": "Tool execution failed. Please try again."
           }
   ```

2. **Safety Refusals**

   ```python
   if response.stop_reason == "refusal":
       logger.warning("Agent refused request")
       # Don't retry - respect safety boundaries
       return {"error": "Request cannot be completed"}
   ```

3. **Max Turns Exceeded**

   ```python
   if turn >= max_turns:
       logger.warning("Agent exceeded max turns")
       return {
           "error": "Task too complex",
           "partial_progress": extract_progress(messages)
       }
   ```

4. **Invalid Tool Name**

   ```python
   # With strict mode, tool names are guaranteed valid
   # But external factors can cause issues
   if tool_name not in TOOL_FUNCTIONS:
       logger.error(f"Unknown tool: {tool_name}")
       return {"error": f"Tool {tool_name} not implemented"}
   ```

**Output**: Robust error handling

---

### Phase 4: Testing Agent Workflows

**Objective**: Validate agent behavior with realistic scenarios

**Test Strategy:**

```python
import pytest
from unittest.mock import Mock, patch

@pytest.fixture
def mock_tool_functions():
    """Mock external tool functions."""
    return {
        "search_flights": Mock(return_value={"flights": [{"id": "F1", "price": 500}]}),
        "book_flight": Mock(return_value={"confirmation": "ABC123"}),
        "search_hotels": Mock(return_value={"hotels": [{"id": "H1", "price": 150}]}),
    }

def test_simple_flight_search(mock_tool_functions):
    """Test agent handles simple flight search."""
    with patch.dict('agent.TOOL_FUNCTIONS', mock_tool_functions):
        result = run_agent("Find flights from SF to LA on May 15 for 2 people")

        # Verify search_flights was called
        mock_tool_functions["search_flights"].assert_called_once()
        call_args = mock_tool_functions["search_flights"].call_args[1]

        # Strict mode guarantees these match schema
        assert call_args["origin"] == "San Francisco, CA"  # or similar
        assert call_args["destination"] == "Los Angeles, CA"
        assert call_args["travelers"] == 2
        assert "2024-05-15" in call_args["departure_date"]

def test_multi_step_booking(mock_tool_functions):
    """Test agent completes multi-step booking."""
    with patch.dict('agent.TOOL_FUNCTIONS', mock_tool_functions):
        result = run_agent(
            "Book a round trip from SF to Paris for 2 people, "
            "May 15-22, and find a hotel"
        )

        # Verify correct tool sequence
        assert mock_tool_functions["search_flights"].called
        assert mock_tool_functions["book_flight"].called
        assert mock_tool_functions["search_hotels"].called

def test_tool_failure_handling(mock_tool_functions):
    """Test agent handles tool failures gracefully."""
    mock_tool_functions["search_flights"].side_effect = Exception("API down")

    with patch.dict('agent.TOOL_FUNCTIONS', mock_tool_functions):
        result = run_agent("Find flights to Paris")

        # Should handle error gracefully
        assert "error" in result or "failed" in str(result).lower()

def test_parameter_validation():
    """Test that strict mode guarantees valid parameters."""
    # With strict mode, parameters are guaranteed to match schema
    # This test verifies the guarantee holds

    response = client.beta.messages.create(
        model="claude-sonnet-4-5",
        betas=["structured-outputs-2025-11-13"],
        messages=[{"role": "user", "content": "Search flights for 2 people"}],
        tools=TOOLS,
    )

    for block in response.content:
        if block.type == "tool_use":
            # These assertions should NEVER fail with strict mode
            assert isinstance(block.input, dict)
            assert "travelers" in block.input
            assert isinstance(block.input["travelers"], int)
            assert block.input["travelers"] in [1, 2, 3, 4, 5, 6]
```

**Output**: Comprehensive test coverage

---

### Phase 5: Production Agent Patterns

**Objective**: Production-ready agent architectures

**Pattern 1: Stateful Agent with Memory**

```python
class StatefulTravelAgent:
    """Agent that maintains state across interactions."""

    def __init__(self):
        self.conversation_history: List[Dict] = []
        self.booking_state: Dict[str, Any] = {}

    def chat(self, user_message: str) -> str:
        """Process user message and return response."""
        self.conversation_history.append({
            "role": "user",
            "content": user_message
        })

        response = client.beta.messages.create(
            model="claude-sonnet-4-5",
            betas=["structured-outputs-2025-11-13"],
            max_tokens=2048,
            messages=self.conversation_history,
            tools=TOOLS,
        )

        # Process tools and update state
        final_response = self._process_response(response)

        self.conversation_history.append({
            "role": "assistant",
            "content": final_response
        })

        return final_response

    def _process_response(self, response) -> str:
        """Process tool calls and maintain state."""
        # Implementation...
        pass

# Usage
agent = StatefulTravelAgent()
print(agent.chat("I want to go to Paris"))
print(agent.chat("For 2 people"))  # Remembers context
print(agent.chat("May 15 to May 22"))  # Continues booking
```

**Pattern 2: Tool Retry Logic**

```python
def execute_tool_with_retry(
    tool_name: str,
    tool_input: Dict,
    max_retries: int = 3
) -> Dict:
    """Execute tool with exponential backoff retry."""
    import time

    for attempt in range(max_retries):
        try:
            result = TOOL_FUNCTIONS[tool_name](**tool_input)
            return {"success": True, "data": result}

        except Exception as e:
            if attempt == max_retries - 1:
                return {"success": False, "error": str(e)}

            wait_time = 2 ** attempt  # Exponential backoff
            logger.warning(f"Tool {tool_name} failed, retrying in {wait_time}s")
            time.sleep(wait_time)
```

**Pattern 3: Tool Result Validation**

```python
def validate_tool_result(tool_name: str, result: Any) -> bool:
    """Validate tool execution result."""
    validators = {
        "search_flights": lambda r: "flights" in r and len(r["flights"]) > 0,
        "book_flight": lambda r: "confirmation" in r,
        "search_hotels": lambda r: "hotels" in r,
    }

    validator = validators.get(tool_name)
    if validator:
        return validator(result)

    return True  # No validator = assume valid
```

**Output**: Production-ready agent patterns

---

## Common Agentic Patterns

### Pattern 1: Sequential Workflow

Tools execute in sequence (search → book → confirm):

```python
# User: "Book a flight to Paris"
# Agent executes:
1. search_flights(origin="SF", destination="Paris", ...)
2. book_flight(flight_id="F1", passengers=[...])
3. send_confirmation(confirmation_id="ABC123")
```

### Pattern 2: Parallel Tool Execution

Multiple independent tools (flights + hotels):

```python
# User: "Find flights and hotels for Paris trip"
# Agent can call in parallel (if your implementation supports it):
1. search_flights(destination="Paris", ...)
2. search_hotels(city="Paris", ...)
```

### Pattern 3: Conditional Branching

Tool selection based on context:

```python
# User: "Plan my trip"
# Agent decides which tools to call based on conversation:
if budget_conscious:
    search_flights(class="economy")
else:
    search_flights(class="business")
```

---

## Success Criteria

- [ ] Tool schemas designed with `strict: true`
- [ ] All tools have `additionalProperties: false`
- [ ] Clear descriptions for tools and parameters
- [ ] Required fields properly specified
- [ ] Multi-tool workflow implemented
- [ ] Error handling for tool failures
- [ ] Refusal scenarios handled
- [ ] Agent tested with realistic scenarios
- [ ] Production patterns applied (retry, validation)
- [ ] Monitoring in place

## Important Reminders

1. **Always set `strict: true`** - This enables validation
2. **Require `additionalProperties: false`** - Enforced by strict mode
3. **Use enums for constrained values** - Better than free text
4. **Clear descriptions matter** - Claude uses these to decide when to call tools
5. **Tool inputs are guaranteed valid** - No validation needed in tool functions
6. **Handle tool execution failures** - External APIs can fail
7. **Test multi-step workflows** - Edge cases appear in tool composition
8. **Monitor agent behavior** - Track tool usage patterns and failures

---

**Official Documentation**: https://docs.anthropic.com/en/docs/build-with-claude/structured-outputs

**Related Skills**:
- `structured-outputs-advisor` - Choose the right mode
- `json-outputs-implementer` - For data extraction use cases
