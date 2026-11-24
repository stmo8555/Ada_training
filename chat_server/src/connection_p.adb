with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Exceptions;        use Ada.Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Rooms;                 use Rooms;

package body Connection_P is
    use type GS.Selector_Status;

    protected body Runner is
        function Go return Boolean
        is (Run);

        entry Wait_For_Stop when not Run is
        begin
            null;
        end;

        procedure Start is
        begin
            Run := True;
        end;

        procedure Stop is
        begin
            Run := False;
        end;
    end Runner;
    task body Connection is
        Message        : Unbounded_String;
        Sock           : GS.Socket_Type;
        Channel        : GS.Stream_Access;
        Quit_Requested : Boolean;
        Ch             : Character;
        Discarding     : Boolean := False;
        Selector       : GS.Selector_Type;
        Status         : GS.Selector_Status;
        Sock_Set       : GS.Socket_Set_Type;
        Not_Used       : GS.Socket_Set_Type;
    begin
        accept Start (New_Sock : GS.Socket_Type) do
            Sock := New_Sock;
        end;
        GS.Create_Selector (Selector);
        begin
            Channel := GS.Stream (Sock);
            while Runner.Go loop
                GS.Empty (Sock_Set);
                GS.Set (Sock_Set, Sock);
                GS.Check_Selector (Selector, Sock_Set, Not_Used, Status, 0.1);

                if Status = GS.Completed then

                    Ch := Character'Input (Channel);
                    if Discarding then
                        Discarding := Ch /= ASCII.LF;
                    elsif Length (Message) < MAX_MESSAGE_LENGTH then
                        Append (Message, Ch);
                        if Ch = ASCII.LF then
                            declare
                                Text : constant String := To_String (Message);
                            begin
                                if Text in Message_T then
                                    Room.Recv_Message
                                       (Sock, Text, Quit_Requested);
                                    exit when Quit_Requested;
                                else
                                    String'Write
                                       (Channel, "Invalid message" & ASCII.LF);
                                end if;
                            end;
                            Message := Null_Unbounded_String;
                        end if;
                    else
                        Message := Null_Unbounded_String;
                        Discarding := Ch /= ASCII.LF;
                        String'Write
                           (Channel,
                            "Your input is too long. Maximum length:"
                            & MAX_MESSAGE_LENGTH'Image
                            & " characters, including LF."
                            & ASCII.LF);
                    end if;
                end if;
            end loop;
        exception
            when End_Error =>
                Ada.Text_IO.Put_Line ("Client disconnected");
            when E : GS.Socket_Error =>
                Ada.Text_IO.Put_Line
                   ("The connection broke unexpectedly. Error: "
                    & Exception_Message (E));
        end;

        if not Runner.Go then
            String'Write (Channel, "server stopping");
        end if;

        Room.Remove (Sock);
        GS.Close_Selector (Selector);
        GS.Free (Channel);
        GS.Close_Socket (Sock);
    exception
        when E : others =>
            Put_Line (Exception_Information (E));
    end;
end Connection_P;
