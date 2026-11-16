--  Preelaborate: no code runs at elaboration, so no elaboration errors.
package Tables is
    pragma Preelaborate;
    type Table is array (1 .. 3) of Integer;
    T : Table := [others => 0];
    function Compute return Integer is (42);
    --  U : Integer := Compute;
    --  error: non-preelaborable call not allowed in preelaborated unit
end Tables;
