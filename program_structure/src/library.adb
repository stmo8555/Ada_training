with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Library.Books;

package body Library is

    procedure Hello is
    begin
        null;
    end Hello;

    function Table_Str return String is
        tmp : Unbounded_String;
    begin
        for e of T loop
            Append (tmp, e'Image);
        end loop;
        return To_String (tmp);
    end;
begin
    Library.Books.Very_Long_Proc;
    T := [others => [others => 0]];
end Library;
