with Ada.Iterator_Interfaces;

generic
    type T is private;
package Ring_Buffers is
    --  The aspects must be on the public (partial) view, so users of the
    --  package can see that "for E of Buffer loop" is allowed.
    --  They only name functions; the functions themselves are declared below.
    type Ring_Buffer is tagged private
    with
       --  "for E of Buffer" calls Iterate to get an iterator
       Default_Iterator  => Iterate,
       --  the type of E in the loop (T, not T'Class: T is not tagged)
       Iterator_Element  => T,
       --  Buffer (C) on a constant buffer calls Element_Value, so E is read only
       Constant_Indexing => Element_Value,
       --  Buffer (C) on a variable buffer calls Reference, so E is writable
       Variable_Indexing => Reference;

    Empty_Error : exception;

    --  adds Val as the newest item; when full, the oldest item is overwritten
    procedure Push (rb : in out Ring_Buffer; val : T);
    --  removes and returns the oldest item
    function Pop (rb : in out Ring_Buffer) return T;
    function Size (rb : Ring_Buffer) return Natural;

    --  A cursor is a position in the buffer. The loop only ever passes the
    --  cursor around, so the cursor must know by itself when it is done.
    type Cursor is private;
    function Has_Element (Pos : Cursor) return Boolean;

    --  The standard library defines the iterator interface (First, Next).
    --  Instantiating it with our Cursor gives us Forward_Iterator to implement.
    package Ring_Iterators is new
       Ada.Iterator_Interfaces (Cursor, Has_Element);

    function Iterate
       (Container : Ring_Buffer) return Ring_Iterators.Forward_Iterator'Class;

    --  read access: returns a copy of the item at Pos
    function Element_Value (Container : Ring_Buffer; Pos : Cursor) return T;

    --  Write access: a Reference_Type holds a pointer to the item, and
    --  Implicit_Dereference makes the compiler use it as if it were the
    --  item itself, so "E := E * 2" writes straight into the buffer.
    type Reference_Type (E : not null access T) is limited null record
    with Implicit_Dereference => E;

    --  "aliased" lets us safely return a pointer into Container
    function Reference
       (Container : aliased in out Ring_Buffer; Pos : Cursor)
        return Reference_Type;

private
    type Arr_Size is mod 10;
    Capacity : constant := Arr_Size'Modulus;

    --  aliased, so Reference can point at an item
    type Arr_T is array (Arr_Size) of aliased T;

    type Ring_Buffer is tagged record
        List  : Arr_T;
        First : Arr_Size := 0;   --  index of the oldest item
        Count : Natural := 0;    --  number of items, 0 .. Capacity
    end record;

    --  Index is where we are, Remaining is how many items are left
    --  including this one. Remaining = 0 means the loop is finished.
    type Cursor is record
        Index     : Arr_Size := 0;
        Remaining : Natural := 0;
    end record;

    --  The iterator remembers where to start and how many items to visit.
    type Iterator is new Ring_Iterators.Forward_Iterator with record
        Start : Arr_Size;
        Count : Natural;
    end record;

    overriding
    function First (It : Iterator) return Cursor;
    overriding
    function Next (It : Iterator; Pos : Cursor) return Cursor;

end Ring_Buffers;
