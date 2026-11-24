with GNAT.Sockets;
with Ada.Containers.Vectors;
with Ada.Interrupts.Names;
with Ada.Unchecked_Deallocation;

package Connection_P is
    package GS renames GNAT.Sockets;

    protected Runner is
        entry Wait_For_Stop;
        procedure Start;
        procedure Stop
        with Attach_Handler => Ada.Interrupts.Names.SIGINT;
        function Go return Boolean;
    private
        Run : Boolean := False;
    end Runner;

    task type Connection is
        entry Start (New_Sock : GS.Socket_Type);
    end;

    type Connection_Access is access all Connection;

    package C_Vector is new
       Ada.Containers.Vectors (Positive, Connection_Access);

    procedure Free is new
       Ada.Unchecked_Deallocation (Connection, Connection_Access);
end Connection_P;
