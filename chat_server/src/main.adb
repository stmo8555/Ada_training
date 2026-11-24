pragma Unreserve_All_Interrupts;

with Ada.Text_IO;    use Ada.Text_IO;
with GNAT.Sockets;
use type GNAT.Sockets.Selector_Status;
use type GNAT.Sockets.Socket_Type;
with Ada.Exceptions; use Ada.Exceptions;
with Rooms;          use Rooms;
with Connection_P;

procedure Main is
    package GS renames GNAT.Sockets;
    Group       : constant String := "127.0.0.1";
    Port        : constant := 5555;
    Connections : Connection_P.C_Vector.Vector;

    task Server is
        entry Start;
    end Server;

    task body Server is
        Address : GS.Sock_Addr_Type;
        Server  : GS.Socket_Type;
    begin
        Address.Addr := GS.Inet_Addr (group);

        Address.Port := PORT;
        GS.Create_Socket (Server);
        GS.Set_Socket_Option
           (Server, GS.Socket_Level, (GS.Reuse_Address, True));
        GS.Bind_Socket (Server, Address);
        GS.Listen_Socket (Server);

        accept Start;

        declare
            Socket   : GS.Socket_Type;
            Accepted : Boolean;
            Status   : GS.Selector_Status;
        begin
            while Connection_P.Runner.Go loop
                GS.Accept_Socket
                   (Server, Socket, Address, Timeout => 0.5, Status => Status);
                if Status = GS.Completed then
                    Room.Add (Socket, Accepted);
                    if Accepted then
                        Connections.Append (new Connection_P.Connection);
                        Connections (Connections.Last).Start (Socket);
                    else
                        declare
                            Channel : GS.Stream_Access := GS.Stream (Socket);
                        begin
                            String'Write (Channel, "server full");
                            GS.Free (Channel);
                            GS.Close_Socket (Socket);
                            Socket := GS.No_Socket;
                        end;
                    end if;
                end if;
            end loop;

            if Socket /= GS.No_Socket then
                GS.Close_Socket (Socket);
            end if;
        end;

        Put_Line ("Server is Closing");
        GS.Close_Socket (Server);
    exception
        when E : others =>
            Ada.Text_IO.Put_Line
               (Exception_Name (E) & ": " & Exception_Message (E));
    end Server;

begin
    Connection_P.Runner.Start;
    Server.Start;
    Connection_P.Runner.Wait_For_Stop;

    while not Connections.Is_Empty loop
        for I in reverse Connections.First_Index .. Connections.Last_Index loop
            if Connections (I).all'Terminated then
                Connection_P.Free (Connections (I));
                Connections.Delete (I);
            end if;
        end loop;

        delay 0.5;
    end loop;
end Main;
