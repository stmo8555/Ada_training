with Ada.Unchecked_Deallocation;

package body Nodes.Linked_Lists is
    procedure Free is new Ada.Unchecked_Deallocation (Node, Node_Access);
    procedure Add_First (List : in out Linked_List; Val : T) is
        New_Node : constant Node_Access := new Node'(Val, List.Head);
    begin
        List.Head := New_Node;
        List.Count := List.Count + 1;
    end Add_First;

    procedure Add_Last (List : in out Linked_List; Val : T) is
        Curr     : Node_Access := List.Head;
        New_Node : constant Node_Access := new Node'(Val, null);
    begin
        List.Count := List.Count + 1;
        if List.Head = null then
            List.Head := New_Node;
            return;
        end if;
        while Curr.Next /= null loop
            Curr := Curr.Next;
        end loop;

        Curr.Next := New_Node;
    end Add_Last;

    procedure Insert (List : in out Linked_List; Val : T; Index : Natural) is
        Prev : Node_Access;
    begin
        if Index not in 0 .. List.Count then
            raise Index_Out_Of_Range_Exception
               with
                  ("Index:"
                   & Index'Image
                   & " but must be in 0 -"
                   & List.Count'Image);
        end if;
        if Index = 0 then
            Add_First (List, Val);
            return;
        end if;

        Prev := Get (List, Index - 1);
        if Prev /= null then
            declare
                New_Node : constant Node_Access := new Node'(Val, null);
            begin
                New_Node.Next := Prev.Next;
                Prev.Next := New_Node;
                List.Count := List.Count + 1;
            end;
        end if;
    end Insert;

    procedure Remove_First (List : in out Linked_List) is
    begin
        if List.Head /= null then
            declare
                Tmp : Node_Access := List.Head;
            begin
                List.Head := Tmp.Next;
                Free (Tmp);
                List.Count := List.Count - 1;
            end;
        end if;
    end Remove_First;

    procedure Remove_Last (List : in out Linked_List) is
        Curr : Node_Access;
    begin
        Curr := List.Head;
        if Curr = null then
            return;
        end if;

        List.Count := List.Count - 1;
        if Curr.Next = null then
            Free (List.Head);
            return;
        end if;

        while Curr.Next.Next /= null loop
            Curr := Curr.Next;
        end loop;

        Free (Curr.Next);
    end Remove_Last;

    procedure Delete (List : in out Linked_List; Index : Natural) is
        Prev : Node_Access;
    begin
        if Index not in 0 .. List.Count - 1 then
            raise Index_Out_Of_Range_Exception
               with
                  ("Index:"
                   & Index'Image
                   & " but list size is"
                   & List.Count'Image);
        end if;
        if Index = 0 then
            Remove_First (List);
            return;
        end if;

        Prev := Get (List, Index - 1);
        if Prev /= null and then Prev.Next /= null then
            declare
                Tmp : Node_Access := Prev.Next;
            begin
                Prev.Next := Prev.Next.Next;
                Free (Tmp);
                List.Count := List.Count - 1;
            end;
        end if;
    end Delete;

    function Get_Last (List : Linked_List) return Node_Access is
        Curr : Node_Access := List.Head;
    begin
        while Curr /= null loop
            if Curr.Next = null then
                return Curr;
            end if;
            Curr := Curr.Next;
        end loop;

        return null;
    end Get_Last;

    function Get (List : Linked_List; Index : Natural) return Node_Access is
        Idx  : Natural := 0;
        Curr : Node_Access := List.Head;
    begin
        if Index not in 0 .. List.Count - 1 then
            raise Index_Out_Of_Range_Exception
               with
                  ("Index:"
                   & Index'Image
                   & " but list size is"
                   & List.Count'Image);
        end if;

        while Curr /= null loop
            if Idx = Index then
                return Curr;
            end if;
            Curr := Curr.Next;
            Idx := Idx + 1;
        end loop;

        return null;
    end Get;

    function Contains (List : Linked_List; Val : T) return Boolean is
        Curr : Node_Access;
    begin
        Curr := List.Head;

        while Curr /= null loop
            if Curr.Val = Val then
                return True;
            end if;

            Curr := Curr.Next;
        end loop;

        return False;
    end Contains;

    procedure Clear (List : in out Linked_List) is
    begin
        while List.Head /= null loop
            declare
                Curr : Node_Access := List.Head;
            begin
                List.Head := Curr.Next;
                Free (Curr);
            end;
        end loop;
        List.Count := 0;
    end Clear;

    overriding
    procedure Finalize (List : in out Linked_List) is
    begin
        List.Clear;
    end Finalize;
end Nodes.Linked_Lists;
