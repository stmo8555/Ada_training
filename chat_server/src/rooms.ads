with GNAT.Sockets;          use GNAT.Sockets;
with Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers;        use Ada.Containers;
with Ada.Containers.Vectors;

package Rooms is
    MAX_CLIENTS        : constant := 3;
    MAX_MESSAGE_LENGTH : constant := 30;

    subtype Message_T is String
    with
       Dynamic_Predicate =>
          Message_T'Length > 0
          and then Message_T (Message_T'Last) = ASCII.LF
          and then Message_T'Length <= MAX_MESSAGE_LENGTH;

    subtype Nick_Name is Unbounded_String
    with
       Dynamic_Predicate =>
          Nick_Name = Null_Unbounded_String
          or
             (Length (Nick_Name) in 1 .. 10
              and Index (Nick_Name, String'(1 => ASCII.LF)) = 0);

    type Client is record
        Sock    : Socket_Type;
        Name    : Nick_Name;
        Channel : Stream_Access;
    end record;

    function "=" (Left, Right : Client) return Boolean
    is (Left.Sock = Right.Sock);
    package CV is new Vectors (Index_Type => Positive, Element_Type => Client);
    use CV;
    protected Room is
        function Count return Count_Type;
        function Contains (Sock : Socket_Type) return Boolean;

        procedure Add (Sock : Socket_Type; Accepted : out Boolean)
        with
           Pre  => Sock /= No_Socket,
           Post =>
              Count = Count'Old + (if Accepted then 1 else 0)
              and then Count <= MAX_CLIENTS;

        procedure Remove (Sock : Socket_Type)
        with Pre => Sock /= No_Socket, Post => not Contains (Sock);
        procedure Recv_Message
           (Sock           : Socket_Type;
            Message        : Message_T;
            Quit_Requested : out Boolean)
        with Pre => Sock /= No_Socket;
    private
        Members : Vector;
    end Room;
private
end Rooms;
