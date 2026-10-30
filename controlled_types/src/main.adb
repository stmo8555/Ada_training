with Ada.Text_IO;    use Ada.Text_IO;
with Unique_Strings; use Unique_Strings;
with Shared_Strings; use Shared_Strings;

procedure Main is
begin
    Put_Line ("--- Unique_String ---");
    declare
        A, B : Unique_String;
    begin
        pragma Assert (A.To_String = "");

        A.Append ("Hello");
        pragma Assert (A.To_String = "Hello");
        A.Append (" World");
        pragma Assert (A.To_String = "Hello World");

        --  copy must be deep: changing B must not change A
        B := A;
        pragma Assert (B.To_String = "Hello World");
        B.Append ("!");
        pragma Assert (B.To_String = "Hello World!");
        pragma Assert (A.To_String = "Hello World");

        --  a copy going out of scope must not free A's string
        declare
            C : constant Unique_String := A;
        begin
            pragma Assert (C.To_String = "Hello World");
        end;
        pragma Assert (A.To_String = "Hello World");

        --  assigning an empty string
        declare
            Empty : Unique_String;
        begin
            A := Empty;
            pragma Assert (A.To_String = "");
        end;
    end;

    Put_Line ("--- Shared_String ---");
    declare
        A, B : Shared_String;
    begin
        pragma Assert (A.To_String = "");

        A.Append ("Hello");
        pragma Assert (A.To_String = "Hello");

        B := A;
        pragma Assert (B.To_String = "Hello");
        B.Append ("!");
        pragma Assert (B.To_String = "Hello!");
        pragma Assert (A.To_String = "Hello!");

        --  a copy going out of scope must not free the shared string
        declare
            C : constant Shared_String := A;
        begin
            pragma Assert (C.To_String = "Hello!");
        end;
        pragma Assert (A.To_String = "Hello!");
    end;

    Put_Line ("All asserts passed");
end Main;
