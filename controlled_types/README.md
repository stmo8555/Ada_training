# Controlled Types

**Goal:** automatic cleanup (like a C++ destructor) and safe copying.

**Implement:** a `Unique_String` type that owns a heap-allocated `String`:
- `Finalize` frees the memory when the object goes out of scope
- `Adjust` makes a deep copy on `:=`, so two objects never share memory
- a second type, `Shared_String`, that uses reference counting instead

**Learn:** `Ada.Finalization.Controlled` vs `Limited_Controlled`, `Initialize`/`Adjust`/`Finalize`, `Ada.Unchecked_Deallocation`.

**Done when:** you print a line in each of `Initialize`/`Adjust`/`Finalize`, can predict the order they run in, and `valgrind` reports no leaks.
