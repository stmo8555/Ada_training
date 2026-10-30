package body Ring_Buffers is
    procedure Push (rb : in out Ring_Buffer; val : T) is
    begin
        if rb.Count < Capacity then
            --  room left: write just after the newest item.
            --  Arr_Size is modular, so the index wraps around by itself.
            rb.List (rb.First + Arr_Size (rb.Count)) := val;
            rb.Count := rb.Count + 1;
        else
            --  full: the slot of the oldest item becomes the newest,
            --  and the next item becomes the oldest
            rb.List (rb.First) := val;
            rb.First := rb.First + 1;
        end if;
    end Push;

    function Pop (rb : in out Ring_Buffer) return T is
    begin
        if rb.Count = 0 then
            raise Empty_Error with "Pop on empty ring buffer";
        end if;

        return ret : constant T := rb.List (rb.First) do
            rb.First := rb.First + 1;
            rb.Count := rb.Count - 1;
        end return;
    end Pop;

    function Size (rb : Ring_Buffer) return Natural
    is (rb.Count);

    function Has_Element (Pos : Cursor) return Boolean
    is (Pos.Remaining > 0);

    --  Called once at the start of the loop. The iterator gets a snapshot of
    --  where the items are; it does not need the buffer itself.
    function Iterate
       (Container : Ring_Buffer) return Ring_Iterators.Forward_Iterator'Class
    is (Iterator'(Start => Container.First, Count => Container.Count));

    --  first cursor: the oldest item, with all items still to visit.
    --  For an empty buffer Remaining is 0, so the loop body never runs.
    overriding
    function First (It : Iterator) return Cursor
    is (Index => It.Start, Remaining => It.Count);

    --  next cursor: one step forward (wrapping), one item fewer left
    overriding
    function Next (It : Iterator; Pos : Cursor) return Cursor
    is (Index => Pos.Index + 1, Remaining => Pos.Remaining - 1);

    function Element_Value (Container : Ring_Buffer; Pos : Cursor) return T
    is (Container.List (Pos.Index));

    function Reference
       (Container : aliased in out Ring_Buffer; Pos : Cursor)
        return Reference_Type
    is (E => Container.List (Pos.Index)'Access);
end Ring_Buffers;
