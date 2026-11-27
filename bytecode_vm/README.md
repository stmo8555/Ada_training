# Stack-Based Bytecode VM

Build a small virtual machine that runs instructions on a stack of
`Long_Float` values.

## Step 1: Run hand-written instructions

- `Push`: put a value on the stack.
- `Add`: pop two values and push their sum.
- `Multiply`: pop two values and push their product.
- `Halt`: stop running the program.

Represent instructions with a variant record: only `Push` needs a value.
Write one loop that reads instructions in order and dispatches on their kind.

Start with this program:

```text
Push 2
Push 3
Push 4
Multiply
Add
Halt
```

After `Halt`, the stack should contain exactly one value: `14`.

Use an instruction list written directly in Ada. Don't add a parser or a
bytecode file format yet. Once this works, one of the interpreter's ASTs
can emit the same instructions.
