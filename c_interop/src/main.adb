with Ada.Text_IO;          use Ada.Text_IO;
with Interfaces.C;         use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

procedure Main is
    type Cool_Object is record
        cool : C_bool;
    end record
    with Convention => C;

    function Add_C (A, B : int) return int
    with Import, Convention => c, External_Name => "add";

    function Init_Cool (is_cool : C_bool) return Cool_Object
    with Import, Convention => C;

    procedure Is_Cool (C : Cool_Object)
    with Import, Convention => C;

    function Add (a, b : int) return int
    with Import => True, Convention => C;

    function Count_Vowels (s : chars_ptr) return int
    with Import => True, Convention => C;

    --  Math.h
    function Cos (X : double) return double
    with Import, Convention => C, External_Name => "cos";

    S      : chars_ptr;
    C1, C2 : Cool_Object;
begin
    S := New_String ("Hello World!");
    Put_line (Add (1, 2)'Image);
    Put_line (Add_C (4, 2)'Image);

    Put_Line (Value (S) & " Contains " & Count_Vowels (S)'Image & " vowels");

    C1 := Init_Cool (True);
    C2 := Init_Cool (False);
    Is_Cool (C1);
    Is_Cool (C2);
    Free (S);

    Put_Line (Item => "cos(0) = " & Cos (0.0)'Image);
end Main;
