# Streams and the OS

Saving data and talking to the operating system.

## Steps

1. **Command line.** A todo-list program: `main add "buy milk"`, `main
   list`, `main done 2`, using `Ada.Command_Line`. Set the exit status
   on errors.
2. **Saving with streams.** Store the list in a file with
   `Ada.Streams.Stream_IO` and `'Write`/`'Read`. Then switch to
   `'Output`/`'Input`: what's the difference for a `String`?
3. **Your own stream format.** Override `'Write` and `'Read` for the
   todo item type, so you decide the file layout.
4. **Files and folders.** Use `Ada.Directories` to store the file in a
   folder that is created if missing, and to list backup files.
5. **Environment.** Read the save location from an environment variable
   with `Ada.Environment_Variables`, with a default if it's not set.

## You'll learn

`Ada.Command_Line`, `Ada.Streams.Stream_IO`, `'Read`/`'Write`/
`'Input`/`'Output`, overriding stream attributes, `Ada.Directories`,
`Ada.Environment_Variables`.

## Done when

The todo list survives between runs, and a missing folder, a missing
file or a bad command each gives a clear message and a non-zero exit
status.
