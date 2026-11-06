# Program Structure

How bigger Ada programs are organised.

## Steps

1. **Private child packages.** A `Library` package with a public child
   `Library.Books` and a `private package Library.Storage` that only the
   `Library` family can use. Try to `with` it from `Main` and read the
   error.
2. **`limited with`.** `Authors` and `Books` each need an access to the
   other (an author has books, a book has an author). Plain `with` both
   ways fails; fix it with `limited with`.
3. **`separate`.** Move one long subprogram body into its own file with
   `is separate;`. When is this useful?
4. **Elaboration.** A package whose body initialises a table at startup,
   and another package that uses that table during its own elaboration.
   Trigger an elaboration error, then fix it with `pragma
   Elaborate_All`. Also try `pragma Preelaborate` and `pragma Pure` on a
   package and see what they forbid.

## You'll learn

Public and private children, `private with`, `limited with`,
`separate`, elaboration order and its pragmas.

## Done when

You can explain why each pragma or keyword was needed, and what the
compiler said without it.
