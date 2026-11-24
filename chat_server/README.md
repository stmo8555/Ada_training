# Chat Server

A small multi-user chat server you connect to with `nc localhost 5555`.
Uses tasks, protected objects, sockets, streams and contracts.

## Steps

1. **Echo server.** With `GNAT.Sockets`, accept one client and send back
   every line it sends. Test with `nc localhost 5555`. You'll need to read
   one line at a time from the socket's stream.
2. **Many clients.** One task per client, so several `nc` windows can
   connect at once. The main task only accepts connections.
3. **The chat room.** A protected `Room` that keeps the connected clients.
   A line from one client is sent to all the others. What happens if a
   client disconnects while a message is being sent to it?
4. **Commands.** `/nick name`, `/list` (who is online) and `/quit`. Anything
   else is a chat message, shown as `name: text`. Unknown commands get an
   error back, only to that client.
5. **Limits and contracts.** A maximum number of clients (extra ones get
   "server full" and are disconnected), a maximum line length, and nick
   names checked with a predicate. Add `Pre`/`Post` to the `Room`
   operations.
6. **Clean shutdown.** Ctrl-C, or an admin command, tells every client
   "server stopping", closes all sockets and ends all tasks, so the
   program exits on its own.

## You'll learn

`GNAT.Sockets`, a task per connection, protected objects shared by many
tasks, line-based protocols over streams, error handling for broken
connections, task termination.

## Done when

Three `nc` windows can chat with each other, nicks and commands work, a
client that disconnects suddenly doesn't crash or hang the server, and the
server shuts down cleanly.
