with Ada.Finalization;

generic
package Nodes.Linked_Lists is
    Index_Out_Of_Range_Exception : exception;
    type Linked_List is tagged limited private;

    procedure Add_First (List : in out Linked_List; Val : T)
    with Post => List.Get_First.Val = Val and List.Size = List.Size'Old + 1;
    procedure Add_Last (List : in out Linked_List; Val : T)
    with Post => List.Get_Last.Val = Val and List.Size = List.Size'Old + 1;
    procedure Insert (List : in out Linked_List; Val : T; Index : Natural)
    with Post => List.Get (Index).Val = Val and List.Size = List.Size'Old + 1;

    procedure Remove_First (List : in out Linked_List)
    with Post => List.Size = Natural'Max (List.Size'Old - 1, 0);
    procedure Remove_Last (List : in out Linked_List)
    with Post => List.Size = Natural'Max (List.Size'Old - 1, 0);
    procedure Delete (List : in out Linked_List; Index : Natural)
    with Post => List.Size = List.Size'Old - 1;

    function Get_First (List : Linked_List) return Node_Access
    with Post => (Get_First'Result = null) = (List.Size = 0);
    function Get_Last (List : Linked_List) return Node_Access
    with Post => (Get_Last'Result = null) = (List.Size = 0);
    function Get (List : Linked_List; Index : Natural) return Node_Access
    with Post => Get'Result /= null;

    function Contains (List : Linked_List; Val : T) return Boolean;
    function Size (List : Linked_List) return Natural;
    procedure Clear (List : in out Linked_List)
    with Post => List.Size = 0;

private
    type Linked_List is new Ada.Finalization.Limited_Controlled with record
        Head  : Node_Access;
        Count : Natural := 0;
    end record;

    overriding
    procedure Finalize (List : in out Linked_List);

    function Get_First (List : Linked_List) return Node_Access
    is (List.Head);
    function Size (List : Linked_List) return Natural
    is (List.Count);
end Nodes.Linked_Lists;
