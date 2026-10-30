# Person

**Goal:** learn the order in which `Initialize`/`Adjust`/`Finalize` run when a controlled type contains controlled fields, plus the exception rules.

`src/unique_strings.ad?` is a copy of your `Unique_String` from `controlled_types`.

**Implement:** a `Person` type, derived from `Ada.Finalization.Controlled`, with two `Unique_String` fields, `Name` and `Email`.
- Print a line in every `Initialize`/`Adjust`/`Finalize` of both types, including which object it is (e.g. `"Finalize Person"`, `"Finalize Unique_String"`).
- **Before running**, write down the order you expect for:
  1. `P : Person;`
  2. `Q := P;`
  3. the end of the block
  4. `Free (Ptr)` on a `Person` allocated with `new` (`Ada.Unchecked_Deallocation`)
- Raise an exception in `Person`'s `Adjust`, catch it in `Main`, and see what you get (hint: not your own exception).
- Raise an exception in `Person`'s `Initialize`. Which `Finalize` calls still happen?
- Bonus: make it `type Person (<>) is ... private;` with a `Create (Name, Email : String) return Person` function, so a `Person` can't be declared without one.

**Read first:** the "Adjustment of Subcomponents", "Finalization" and "Controlled Types and Exception Handling" sections of
https://learn.adacore.com/courses/advanced-ada/parts/resource_management/controlled_types.html

**Done when:** your predictions match the output, and you can explain every difference.
