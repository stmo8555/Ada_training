# Calling C

The `.gpr` already lists `Languages ("Ada", "C")`, so `.c` files in `src/`
are compiled and linked too.

## Steps

1. **Ada calls C.** Write `src/mathlib.c` with `int add(int a, int b)`.
   In Ada: `function Add (A, B : Interfaces.C.int) return
   Interfaces.C.int with Import, Convention => C, External_Name =>
   "add";`.
2. **Strings.** A C function `int count_vowels(const char *s)`. Pass an
   Ada `String` using `Interfaces.C.Strings` (`New_String`, `Free`).
   Why can't you pass a `String` directly?
3. **C calls Ada.** Export an Ada procedure with `Export, Convention =>
   C`, and call it from C.
4. **Records.** A C `struct point { int x; int y; }` and a matching Ada
   record with `Convention => C_Pass_By_Copy`. Pass one each way.
5. **A real library.** Call something from libc or libm, e.g. `cos` or
   `getenv`, without writing any C yourself.

## You'll learn

`Interfaces.C`, `Interfaces.C.Strings`, `Import`/`Export`,
`Convention`, how Ada and C strings differ, mixed-language `.gpr` files.

## Done when

Data goes both ways (Ada to C and back), including a string and a
record, with no leaks in `valgrind`.
