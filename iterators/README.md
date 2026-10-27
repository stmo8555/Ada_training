# Iterators

**Goal:** make `for X of List loop` work on your own container.

**Implement:** a generic `Ring_Buffer` (fixed capacity, overwrites the oldest item when full) with:
- `for E of Buffer loop` (read only)
- `for E of Buffer loop E := E * 2;` (write through, via `Variable_Indexing`)
- a cursor type with `Has_Element` and `Next`

**Learn:** the aspects `Default_Iterator`, `Iterator_Element`, `Constant_Indexing` and `Variable_Indexing`, and the package `Ada.Iterator_Interfaces`.

**Done when:** both loops work, iteration starts at the oldest item, and an empty buffer runs zero times.
