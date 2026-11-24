# Expression Interpreter

Build a small calculator language. New topics: tokenizing, recursive-descent
parsing, operator precedence, and reporting errors with positions.
Use `Long_Float` for values. No parser library is needed.

## Steps

1. **Tokenizer.** Turn input into tokens: numbers (including decimals),
   names, `+ - * / ( ) =`, and an end-of-input marker. Ignore spaces and
   tabs. Each token remembers its character position. Print the tokens
   for `12 + 3.5 * 2`. Do not evaluate anything yet.
2. **Arithmetic.** Parse and evaluate numbers with `+ - * /`.
   Multiplication and division take precedence over addition and
   subtraction. Operators at the same precedence group left to right.
   Check `2 + 3 * 4 = 14`, `8 / 4 / 2 = 1`, and `10 - 3 - 2 = 5`.
3. **Recursion.** Support parentheses and unary minus:
   `(2 + 3) * 4 = 20`, `-2 * 3 = -6`, and `2 * -(3 + 1) = -8`.
   This is where recursive-descent parsing becomes useful.
4. **Variables.** `let price = 12.5` stores a value; `price * 2` returns
   `25`. Reassignment is allowed. A failed assignment must preserve the
   previous value. Keep variables between input lines.
5. **Interactive use and errors.** Read one line at a time until `quit`
   or EOF. Empty lines do nothing. Invalid characters, unknown names,
   missing operands or parentheses, division by zero, and trailing tokens
   produce a helpful message with a character position. The next input
   must still work after an error.

Start with step 1 only. Keep tokenizing and parsing in separate packages;
the rest of the structure is your choice.

## Done when

The examples above work, invalid input such as `2 +`, `2 3`, `(1 + 2`,
and `1 / 0` is rejected, and you can explain how precedence and recursion
work in your parser. Run Valgrind after exiting normally.

Optional afterwards: build an expression tree before evaluating, so the
same parsed expression can be evaluated repeatedly with different variables.

Build with `gprbuild -P interpreter.gpr`, then run `./main`.
