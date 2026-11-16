--  Pure: no state, only types and constants. Can only `with` Pure units.
package Config is
    pragma Pure;
    Max : constant := 10;
    --  Count : Integer := 0;
    --  error: declaration of variable not allowed in pure unit
end Config;
