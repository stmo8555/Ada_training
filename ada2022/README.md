# Ada 2022

Newer features. The `.gpr` already uses `-gnat2022`.

## Steps

1. **Declare expressions.** An expression function that needs a local
   value: `(declare X : constant Integer := ...; begin X * X)`.
2. **Delta aggregates.** Copy a record with one field changed:
   `(P with delta Age => P.Age + 1)`.
3. **Reductions.** Sum and max of an array with `'Reduce`, then
   `[for X of A when X > 0 => X]'Reduce ("+", 0)`.
4. **Square-bracket aggregates and `'Image`.** `[]` for an empty
   array, `[for I in 1 .. 10 => I * I]`, and `'Image` on a whole record.
5. **Big numbers.** Factorial of 100 with
   `Ada.Numerics.Big_Numbers.Big_Integers`.
6. **User-defined literals.** A `Money` type with the `Integer_Literal`
   or `Real_Literal` aspect, so `M : Money := 12.50;` works.

## You'll learn

Declare expressions, delta aggregates, `'Reduce`, iterated aggregates,
`'Image` on composite types, big numbers, user-defined literals.

## Done when

Each feature has a small example in `main.adb` with a `pragma Assert`
proving it does what you expect.
