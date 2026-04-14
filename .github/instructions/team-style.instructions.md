---
applyTo: "**/*.{sql,tsql}"
---

# Team Style Guide for T-SQL Stored Procedures and Functions

## Scope and Intent
- These rules apply to all SQL files that define or alter stored procedures and user-defined functions.
- Prefer clarity and predictable behavior over clever or compact SQL.

## Naming Conventions
- Use schema-qualified object names in definitions and references.
- Stored procedures: `dbo.Up_<Entity><Action>`.
- Scalar and Table-valued functions: `dbo.fn<Entity>_<Purpose>`.
- Views: `dbo.v<Entity><Purpose>`.
- Parameters: prefix with `@`, use descriptive camelCase consistently.
- Local variables: `@<name>` with descriptive intent, avoid single-letter names except loop counters.

## File and Definition Structure
- One main object definition per file whenever practical.
- Start with `CREATE OR ALTER` for procedures and functions.
- Include a short header comment with:
  - Purpose
  - Inputs/outputs
  - Side effects
  - Error behavior
- Keep deterministic logic in functions. Move data-changing logic to procedures.

## Required Session Settings
- Include `SET ANSI_NULLS ON` and `SET QUOTED_IDENTIFIER ON` before object definitions when your deployment model requires them.
- Avoid changing global session settings inside routines unless absolutely necessary.

## Parameter and Data Type Rules
- Match parameter data types and lengths to target columns.
- Never use unspecified lengths for variable-length types.
- Prefer precise types (`datetime2`, `decimal(p,s)`, `nvarchar(n)`) over ambiguous or legacy defaults.
- Validate parameter assumptions early in procedures and return clear errors for invalid input.

## Query and Join Style
- Always qualify table names with schema.
- Use explicit column lists; do not use `SELECT *` in production code.
- Use explicit `JOIN` syntax with clear predicates.
- Keep predicates sargable; avoid wrapping indexed columns in functions in `WHERE` clauses.
- Prefer set-based operations over cursors and loops.

## Stored Procedure Patterns
- Start with `SET NOCOUNT ON;` unless there is a specific reason not to.
- Keep procedures focused on a single business operation.
- For write operations, use explicit transactions only when needed and keep transaction scope minimal.
- Use consistent upsert strategy approved by the team; avoid race-prone patterns.
- Return stable result shapes for callers; document any intentional changes.

## Function Patterns
- Default to inline table-valued functions for composability and optimizer friendliness.
- Avoid scalar UDFs in hot paths unless validated for performance.
- Functions must not rely on non-deterministic behavior unless explicitly required and documented.
- Do not perform data modifications in functions.

## Error Handling
- Use `THROW` for new code.
- In procedures that need structured handling, use `BEGIN TRY ... END TRY / BEGIN CATCH ... END CATCH`.
- In `CATCH`, preserve original error context where possible.
- Never silently ignore errors.

## Concurrency and Locking
- Choose the least restrictive locking behavior that preserves correctness.
- Do not use table hints by default.
- If hints are required, document the reason and expected effect in comments.
- Consider isolation level and lock duration in transactional procedures.

## Performance Guidelines
- Ensure predicates align with available indexes when feasible.
- Avoid RBAR patterns.
- Avoid unnecessary temp objects; when used, index temp tables intentionally.
- Revisit parameter-sensitive queries and document mitigation strategy when needed.
- Measure performance-critical changes with representative data.

## Security Guidelines
- Minimize dynamic SQL usage.
- For dynamic SQL, use `sp_executesql` with parameters; never concatenate untrusted input.
- Apply least privilege principles for execution and object access.
- Avoid exposing internal error details to external callers.

## Output and Return Conventions
- Use output parameters only when they improve API clarity.
- Use return codes consistently for status when required by calling conventions.
- Document expected result sets and error contract.

## Formatting Rules
- Use uppercase for SQL keywords (`SELECT`, `FROM`, `WHERE`, `JOIN`, `GROUP BY`, `ORDER BY`).
- One column per line in large `SELECT` lists.
- Align joins and predicates for readability.
- Keep line length readable; break complex expressions across lines.

## Testing Expectations
- Add tests for happy path, boundary cases, and failure path.
- Validate null handling, data type boundaries, and collation-sensitive logic where relevant.
- Include at least one performance sanity check for high-impact routines.

## Change Management
- Keep backward compatibility for stable interfaces unless versioning is planned.
- For breaking changes, coordinate deployment and consumer updates.
- Include migration notes for signature changes, result shape changes, or behavior changes.

## Review Checklist
- Names and schema qualification follow conventions.
- No `SELECT *` and no unspecified string/binary lengths.
- Error handling and transaction scope are correct.
- Dynamic SQL is parameterized.
- Performance and concurrency implications were considered.
- Tests were added or updated.
