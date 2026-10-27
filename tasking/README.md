# More Tasking

**Goal:** the tasking features you haven't used yet.

**Implement:** a print-job simulator:
- a protected `Job_Queue` with an entry `Get` that blocks while the queue is empty
- 3 printer tasks from a task type, each taking jobs from the queue
- a printer that runs out of paper uses `requeue` to hand the job back
- an entry family `Priority (High .. Low)` so high-priority jobs go first
- time it with `Ada.Real_Time` and stop everything cleanly with `terminate`

**Learn:** task types and arrays of tasks, `requeue`, entry families, `Ada.Real_Time`, timed and conditional entry calls (`select ... or delay`, `select ... else`).

**Done when:** every job is printed exactly once, high priority first, and the program exits on its own.
