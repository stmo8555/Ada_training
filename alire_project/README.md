# Alire

Ada's package manager: creates projects, fetches libraries ("crates")
and toolchains. No `.gpr` here on purpose: Alire generates its own.

## Steps

1. In this folder, run `alr init --bin word_tool` and look at what it
   created (`alire.toml`, the `.gpr`, `src/`).
2. `alr build` and `alr run`.
3. Find a crate with `alr search json` (or `alr search --list`) and add
   one with `alr with <crate>`. Look at what changed in `alire.toml`.
4. Port your word counter from `containers/` into the new project, and
   use a crate for something you wrote by hand (e.g. command-line
   arguments or output formatting).
5. Run `alr update` and `alr show` and read what they print.

## You'll learn

Project layout, `alire.toml`, dependencies and versions, `alr build`,
`alr run`, `alr with`, `alr update`.

## Done when

The word counter builds and runs with `alr run -- <file>`, using at least
one crate.
