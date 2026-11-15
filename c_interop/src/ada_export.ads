with Interfaces.C.Strings; use Interfaces.C.Strings;
with Interfaces.C;         use Interfaces.C;

package Ada_Export is
    procedure Greeting (Name : chars_ptr)
    with Export => True, Convention => C;
    type Point is record
        x, y : int;
    end record
    with Convention => C_Pass_By_Copy;
    function Init_Point (x, y : int) return Point
    is (Point'(x => x, y => y))
    with Export, Convention => C;
end Ada_Export;
