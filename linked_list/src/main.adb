with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Exceptions;        use Ada.Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Nodes;
with Nodes.Linked_Lists;

-- [x] todo: make first impl
-- [x] todo: remove leaks
-- [x] todo: make package
-- [x] todo: make it pre and post conditions
-- [x] todo: make it generic
-- [x] todo: make it a class
-- [x] todo: use exceptions
-- [x] todo: use concurrency. some sort of dummy loop

procedure Main is
    package Natural_Nodes is new Nodes (Natural);
    package Natural_Lists is new Natural_Nodes.Linked_Lists;
    use Natural_Nodes, Natural_Lists;
    List : Linked_List;

    generic
        type T (<>) is limited private;
        with function Image (Item : T) return String;
    procedure Printer (Val : T);

    procedure Printer (Val : T) is
    begin
        Put_Line (Image (Val));
    end Printer;

    function Node_Image (L : Linked_List) return String is
        Ret : Unbounded_String := To_Unbounded_String ("[");
    begin
        if L.Size = 0 then
            return "[]";
        end if;

        begin
            for I in 0 .. L.Size - 1 loop
                if I /= 0 then
                    Append (Ret, ", ");
                end if;
                Append (Ret, L.Get (I).Val'Image);
            end loop;
        end;

        Append (Ret, "]");

        return To_String (Ret);
    end Node_Image;
    procedure Print is new Printer (Natural, Natural'Image);
    procedure Print is new Printer (Linked_List, Node_Image);

    protected Protected_List is
        procedure AddLast (Val : Natural);
        function Size return Natural;
        function Get (Index : Natural) return Natural;
        function Image return String;
    private
        PList : Linked_List;
    end Protected_List;

    protected body Protected_List is
        procedure AddLast (Val : Natural) is
        begin
            Plist.Add_Last (Val);
        end AddLast;
        function Size return Natural is
        begin
            return Plist.Size;
        end Size;
        function Get (Index : Natural) return Natural is
        begin
            return Plist.Get (Index).Val;
        end Get;
        function Image return String is
        begin
            return Node_Image (Plist);
        end Image;
    end Protected_List;

    task Safe_List is
        entry AddLast (Val : Natural);
        entry RemoveLast;
        entry P;
    end Safe_List;

    task body Safe_List is
        CList : Linked_List;
    begin
        loop
            select
                accept AddLast (Val : Natural) do
                    CList.Add_Last (Val);
                end AddLast;
            or
                accept RemoveLast do
                    CList.Remove_Last;
                end RemoveLast;
            or
                accept P do
                    Print (CList);
                end P;
            or
                terminate;
            end select;
        end loop;
    end Safe_List;

    task P1_Adder;
    task body P1_Adder is
    begin
        Protected_List.AddLast (0);
        delay 1.0;
        Protected_List.AddLast (2);
        delay 1.0;
        Protected_List.AddLast (4);
        delay 1.0;
        Protected_List.AddLast (6);
        delay 1.0;
        Protected_List.AddLast (8);
        delay 1.0;
    end P1_Adder;

    task P2_Adder;
    task body P2_Adder is
    begin
        Protected_List.AddLast (1);
        delay 1.0;
        Protected_List.AddLast (3);
        delay 1.0;
        Protected_List.AddLast (5);
        delay 1.0;
        Protected_List.AddLast (7);
        delay 1.0;
        Protected_List.AddLast (9);
        delay 1.0;
    end P2_Adder;

    task Adder;
    task body Adder is
    begin
        for I in 0 .. 10 loop
            Safe_List.AddLast (I);
            delay 1.0;
        end loop;
    end Adder;

    task Deleter;
    task body Deleter is
    begin
        for I in 0 .. 10 loop
            Safe_List.RemoveLast;
            delay 2.0;
        end loop;
    end Deleter;

    task Prints;
    task body Prints is
    begin
        for I in 0 .. 20 loop
            Safe_List.P;
            delay 1.0;
        end loop;

        Put_Line ("Protected List Contents");
        Put_Line (Protected_List.Image);
    end Prints;

begin
    List.Add_First (1);
    pragma Assert (List.Get (0).Val = 1);
    List.Add_Last (2);
    pragma Assert (List.Get (0).Val = 1);
    pragma Assert (List.Get (1).Val = 2);
    List.Add_First (3);
    pragma Assert (List.Get (0).Val = 3);
    pragma Assert (List.Get (1).Val = 1);
    pragma Assert (List.Get (2).Val = 2);
    List.Remove_First;
    pragma Assert (List.Get (0).Val = 1);
    pragma Assert (List.Get (1).Val = 2);
    List.Remove_Last;
    pragma Assert (List.Get (0).Val = 1);
    pragma Assert (List.Size = 1);
    List.Remove_First;
    pragma Assert (List.Size = 0);
    List.Remove_First;
    List.Remove_Last;

    List.Add_First (1);
    List.Insert (Val => 2, Index => List.Size);
    pragma Assert (List.Get (0).Val = 1);
    pragma Assert (List.Get (1).Val = 2);
    List.Insert (Val => 0, Index => 0);
    pragma Assert (List.Get (0).Val = 0);
    pragma Assert (List.Get (1).Val = 1);
    pragma Assert (List.Get (2).Val = 2);
    List.Insert (Val => 4, Index => List.Size);
    pragma Assert (List.Get (0).Val = 0);
    pragma Assert (List.Get (1).Val = 1);
    pragma Assert (List.Get (2).Val = 2);
    pragma Assert (List.Get (3).Val = 4);
    List.Insert (Val => 3, Index => List.Size - 1);
    pragma Assert (List.Get (0).Val = 0);
    pragma Assert (List.Get (1).Val = 1);
    pragma Assert (List.Get (2).Val = 2);
    pragma Assert (List.Get (3).Val = 3);
    pragma Assert (List.Get (4).Val = 4);

    List.Clear;

    List.Add_Last (7);
    pragma Assert (List.Get (0).Val = 7);
    pragma Assert (List.Size = 1);
    List.Remove_Last;
    pragma Assert (List.Size = 0);

    pragma Assert (List.Get_First = null);
    pragma Assert (List.Get_Last = null);
    pragma Assert (not List.Contains (1));
    pragma Assert (List.Size = 0);
    List.Add_Last (1);
    List.Add_Last (2);
    List.Add_Last (3);
    pragma Assert (List.Get_First.Val = 1);
    pragma Assert (List.Get_Last.Val = 3);
    pragma Assert (List.Contains (2));
    pragma Assert (not List.Contains (4));
    pragma Assert (List.Size = 3);

    List.Delete (1);
    pragma Assert (List.Get (0).Val = 1);
    pragma Assert (List.Get (1).Val = 3);
    pragma Assert (List.Size = 2);
    List.Delete (0);
    pragma Assert (List.Get (0).Val = 3);
    pragma Assert (List.Size = 1);

    List.Clear;
    pragma Assert (List.Size = 0);

    List.Add_Last (1);
    List.Add_Last (2);
    List.Add_Last (3);
    List.Add_Last (4);

    Print (List);

    Print (List.Size);

    begin
        List.Delete (List.Size);
        pragma Assert (False, "Delete should have raised");
    exception
        when E : Index_Out_Of_Range_Exception =>
            Put_Line ("Caught: " & Exception_Message (E));
    end;

    begin
        List.Insert (Val => 9, Index => List.Size + 1);
        pragma Assert (False, "Insert should have raised");
    exception
        when Index_Out_Of_Range_Exception =>
            null;
    end;

    begin
        pragma Assert (List.Get (10) = null);
        pragma Assert (False, "Get should have raised");
    exception
        when Index_Out_Of_Range_Exception =>
            null;
    end;

    pragma Assert (List.Size = 4);

    Put_Line ("No errors");
end Main;
