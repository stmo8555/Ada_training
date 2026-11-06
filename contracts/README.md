# Contracts

Contracts checked at run time (no SPARK). `-gnata` in the `.gpr` turns
the checks on.

## Steps

1. **Predicates.** `subtype Even is Integer with Dynamic_Predicate =>
   Even mod 2 = 0;` and a `Static_Predicate` on an enumeration (e.g.
   `Weekend` as a subtype of `Weekday`). Assign a bad value and read the
   error.
2. **A bank account** as a private type with `Deposit`, `Withdraw` and
   `Balance`. Give `Withdraw` a `Pre` (enough money) and a `Post` using
   `'Old`: the balance went down by exactly the amount.
3. **`'Result`.** A function `Max (A, B)` with a `Post` that says the
   result is one of the two and not smaller than either.
4. **`Type_Invariant`.** A `Date_Range` (`First`, `Last`) whose invariant
   is `First <= Last`. Find out when it is checked and when it is not
   (hint: inside the package's own subprograms).
5. **`Contract_Cases`** (GNAT) on a `Sign` function: one case each for
   negative, zero and positive.

## You'll learn

`Pre`, `Post`, `'Old`, `'Result`, `Dynamic_Predicate`,
`Static_Predicate`, `Type_Invariant`, `Contract_Cases`, and which
exception each one raises.

## Done when

You've triggered every kind of contract failure on purpose, and can say
which line is blamed each time: the caller or the callee.
