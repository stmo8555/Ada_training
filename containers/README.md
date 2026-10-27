# Standard Containers

**Goal:** use the standard library instead of writing your own lists.

**Implement:** a word-frequency counter:
- read a text file with `Ada.Text_IO`
- count words in `Ada.Containers.Indefinite_Hashed_Maps` (String -> Natural)
- copy them into `Ada.Containers.Vectors` and sort by count with `Generic_Sorting`
- print the top 10

**Learn:** instantiating container generics, cursors, `Reference` / in-place updates, `Ada.Strings.Hash`, definite vs indefinite containers.

**Done when:** it prints the top 10 words of any text file, and you've compared the API with your own `Linked_List`.
