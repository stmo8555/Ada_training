with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Containers;        use Ada.Containers;
with Ada.Containers.Vectors;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings.Maps;      use Ada.Strings.Maps;
with Ada.Strings.Hash;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling;

procedure Main is

    package Natural_Hashed_Maps is new
       Ada.Containers.Indefinite_Hashed_Maps
          (Key_Type        => String,
           Element_Type    => Natural,
           Hash            => Ada.Strings.Hash,
           Equivalent_Keys => "=");

    use Natural_Hashed_Maps;

    type Word_Freq is record
        Word : Unbounded_String;
        Freq : Natural;
    end record;

    package WF_Vectors is new
       Ada.Containers.Vectors
          (Index_Type   => Natural,
           Element_Type => Word_Freq);
    function Before (Left, Right : Word_Freq) return Boolean
    is (Left.Freq > Right.Freq);

    package WF_Vector_Sortings is new
       WF_Vectors.Generic_Sorting ("<" => Before);

    use WF_Vectors;
    use WF_Vector_Sortings;

    WF_Vector : Vector;
    M         : Map;
    F_Type    : File_Type;
    File_Name : constant String := "text.txt";
    --  only ASCII letters: Letter_Set is Latin-1, so the bytes of UTF-8
    --  characters like ’ would otherwise be counted as letters
    Letters   : constant Character_Set :=
       To_Set (Character_Ranges'(('a', 'z'), ('A', 'Z')));
begin
    Open (F_Type, In_File, File_Name);
    while not End_Of_File (F_Type) loop
        declare
            S : constant String := Get_Line (F_Type);
            F : Positive;
            L : Natural;
            I : Natural := 1;
            C : Natural_Hashed_Maps.Cursor;
        begin
            while I in S'Range loop
                Find_Token
                   (Source => S,
                    Set    => Letters,
                    From   => I,
                    Test   => Inside,
                    First  => F,
                    Last   => L);
                exit when L = 0;

                declare
                    Word : constant String :=
                       Ada.Characters.Handling.To_Lower (S (F .. L));
                begin
                    C := M.Find (Word);
                    if Has_Element (C) then
                        M (C) := M (C) + 1;
                    else
                        M.Insert (Word, 1);
                    end if;
                end;
                I := L + 1;
            end loop;
        end;
    end loop;
    Close (F_Type);

    for C in M.Iterate loop
        declare
            WF : Word_Freq;
        begin
            WF.Word := To_Unbounded_String (Key (C));
            WF.Freq := M (C);
            WF_Vector.Append (WF);
        end;
    end loop;

    Sort (WF_Vector);
    for I in 0 .. Natural'Min (Natural (WF_Vector.Length), 10) - 1 loop
        Put_Line
           (To_String (WF_Vector (I).Word) & " : " & WF_Vector (I).Freq'Image);
    end loop;
end Main;
