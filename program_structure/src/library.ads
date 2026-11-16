package Library is
    --  pragma Elaborate_Body;
    type Table is array (1 .. 2, 1 .. 3) of Integer;
    procedure Hello;
    T : Table;

    function Table_Str return String;
end Library;
