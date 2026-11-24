with GNAT.String_Split; use GNAT.String_Split;
with Ada.Text_IO;       use Ada.Text_IO;

package body Rooms is
    protected body Room is
        function Count return Count_Type is
        begin
            return Members.Length;
        end Count;

        function Contains (Sock : Socket_Type) return Boolean is
        begin
            return
               Members.Contains (Client'(Sock, Null_Unbounded_String, null));
        end;

        procedure Recv_Message
           (Sock           : Socket_Type;
            message        : Message_T;
            Quit_Requested : out Boolean)
        is
            Dead_Members  : Vector;
            Member_Cursor : constant Cursor :=
               Members.Find (Client'(Sock, Null_Unbounded_String, null));
        begin
            Quit_Requested := False;
            pragma Assert (Message'Length > 0);
            pragma Assert (Has_Element (Member_Cursor));

            if Message (Message'First) = '/' then
                declare
                    Subs      : Slice_Set;
                    Seps      : constant String := " " & ASCII.HT;
                    Member    : Client renames Members (Member_Cursor);
                    Cmd_Index : constant := 1;
                begin
                    Create
                       (Subs,
                        Message
                           (Message'First .. Message'Last - 1),  -- Removing LF
                        seps,
                        Multiple);
                    if Slice_Count (Subs) >= 2
                       and then Slice (Subs, Cmd_Index) = "/nick"
                    then
                        declare
                            New_Name : Unbounded_String;
                        begin
                            for I in 2 .. Slice_Count (Subs) loop
                                if I > 2 then
                                    Append (New_Name, ' ');
                                end if;
                                Append (New_Name, Slice (Subs, I));
                            end loop;
                            if New_Name in Nick_Name then
                                Member.Name := New_Name;
                                String'Write
                                   (Member.Channel,
                                    "You've changed your nick to "
                                    & To_String (Member.Name)
                                    & ASCII.LF);
                            else
                                String'Write
                                   (Member.Channel,
                                    "Invalid nickname" & ASCII.LF);
                            end if;
                        end;
                    elsif Slice (Subs, Cmd_Index) = "/list" then
                        String'Write (Member.Channel, "Members: " & ASCII.LF);
                        for E of Members loop
                            String'Write
                               (Member.Channel, To_String (E.Name) & ASCII.LF);
                        end loop;
                    elsif Slice (Subs, Cmd_Index) = "/quit" then
                        String'Write
                           (Member.Channel,
                            "Bye " & To_String (Member.Name) & ASCII.LF);
                        Quit_Requested := true;
                    else
                        String'Write
                           (Member.Channel,
                            """"
                            & Message (Message'First .. Message'Last - 1)
                            & """"
                            & " is not a valid command. Commands: /nick <name...>, /list, /quit. Everything after /nick is the name; quotes are not needed."
                            & ASCII.LF);
                    end if;
                end;
                return;
            end if;

            for Receiving_Member of Members loop
                declare
                    Member : Client renames Members (Member_Cursor);
                    FM     : constant String :=
                       To_String (Member.Name) & ": " & Message;
                begin
                    if Receiving_Member /= Member then
                        String'Write (Receiving_Member.Channel, FM);
                    end if;
                exception
                    when Socket_Error =>
                        begin
                            Dead_Members.Append (Receiving_Member);
                        end;
                end;
            end loop;
            for Dead of Dead_Members loop
                Remove (Dead.Sock);
            end loop;
        end Recv_message;

        procedure Add (Sock : Socket_Type; Accepted : out Boolean) is
        begin
            Accepted := False;
            if Members.Length < MAX_CLIENTS then
                Members.Append
                   (Client'
                       (sock, To_Unbounded_String ("No_Name"), stream (sock)));
                Accepted := True;
            end if;
        end Add;

        procedure Remove (Sock : Socket_Type) is
            Location : Cursor :=
               Members.Find (Client'(Sock, Null_Unbounded_String, null));
        begin
            Put_Line ("Trying to remove");
            if Has_Element (Location) then

                Free (Members (Location).Channel);
                Members.Delete (Location);
                Put_Line ("Removed");
            end if;
        end Remove;

    end Room;
end Rooms;
