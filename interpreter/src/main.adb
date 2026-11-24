with Ada.Text_IO;     use Ada.Text_IO;
with Ada.Exceptions;  use Ada.Exceptions;
with Ada.Long_Float_Text_IO;
with Tokens.Scanners; use Tokens.Scanners;
with Tokens.Grammars; use Tokens.Grammars;

procedure Main is
begin
    loop
        Put ("> ");
        Flush;
        exit when End_Of_File;

        declare
            Line : constant String := Get_Line;
        begin
            exit when Line = "quit";

            if Line'Length > 0 then
                declare
                    S      : Scanner := Create_Scanner (Line);
                    Result : constant Long_Float := Interpret (S.Scan);
                begin
                    Ada.Long_Float_Text_IO.Put
                       (Result, Fore => 0, Aft => 2, Exp => 0);
                    New_Line;
                end;
            end if;
        exception
            when E : Constraint_Error =>
                Put_Line (Standard_Error, "Error: " & Exception_Message (E));
        end;
    end loop;
end Main;
