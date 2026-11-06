# More Tasking

A print-job simulator, built in small steps. Get each step
running before starting the next.

## Steps

1. **Job queue.** A job is a record: `Id`, `Pages`, `Priority`.
   Make a protected `Job_Queue` with a procedure `Put (Job)`
   and an entry `Get (Job : out ...)` whose barrier blocks
   while the queue is empty.

2. **Printers.** A task type `Printer (Id : Positive)` and an
   array of 3. Each one loops: `Get` a job, `delay` 0.1 s per
   page, then print something like `Printer 2: job 7 (3
   pages)`.

3. **Producer and shutdown.** A `Producer` task puts 20 jobs
   into the queue with short delays between them, then calls
   `Close`. `Get` must also open when the queue is closed and
   empty, and tell the printer there is no job, so the printer
   leaves its loop and the program can exit. (`terminate` only
   works inside a task's `select ... accept`, so it can't be
   used for tasks that call a protected object.)

4. **Paper and `requeue`.** A protected `Paper_Tray` with an
   entry `Take (Pages)`. If there isn't enough paper, `requeue`
   the call to an entry `Wait_For_Paper`, which opens when the
   tray is refilled. A `Refiller` task adds paper every few
   seconds. Why `requeue`: a barrier can't look at the entry's
   parameters, so `Take` can't wait for "enough paper for
   *this* job" by itself.

5. **Paper sizes with an entry family.** Give each job a
   `Size` (`A4`, `A3`) and give the tray a paper count per
   size. Turn `Take` into `entry Take (Paper_Size) (Pages :
   Papers)`: one entry per size, each with its own barrier, so
   a printer waiting for A3 doesn't block one that needs A4. A
   printer calls `Paper_Tray.Take (tmp.J.Size) (tmp.J.Pages)`.
   Optional: let the `Refiller` use a timed or conditional
   call (`select ... or delay`, `select ... else`) somewhere.

6. **Timing.** Use `Ada.Real_Time.Clock` to print how long each
   job took and the total run time.

## You'll learn

Task types and arrays of tasks, protected entries and barriers,
`requeue`, entry families, conditional and timed entry calls,
`Ada.Real_Time`.

## Done when

- every job is printed exactly once (check the `Id`s)
- when jobs of several priorities are waiting, `High` is
  printed first
- printers wait when the paper runs out and continue after a
  refill
- the program exits by itself when all jobs are printed
