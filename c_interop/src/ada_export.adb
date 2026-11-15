with Ada.Text_IO; use Ada.Text_IO;

package body Ada_Export is
    procedure Greeting (Name : chars_ptr) is
    begin
        Put_Line ("Hello " & Value (Name) & " from C! Im Ada :)");
    end Greeting;
end Ada_Export;
