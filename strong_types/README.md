# Strong Types

**Goal:** let the compiler catch unit and range mistakes.

**Implement:** a small physics/units calculator:
- `Meters`, `Seconds`, `Meters_Per_Second` as distinct types (`type X is new Float`)
- your own `"/"` so that `Meters / Seconds` returns `Meters_Per_Second`
- `subtype Percent is Integer range 0 .. 100` and see what an out-of-range value does
- a `mod 256` type for a wrapping counter
- a `Weekday` enumeration using `'Succ`, `'Pred`, `'First`, `'Last`, `'Value`

**Learn:** derived types vs subtypes, user-defined operators, `Constraint_Error`, modular arithmetic, enumeration attributes.

**Done when:** `Meters + Seconds` fails to compile, and you can explain why.
