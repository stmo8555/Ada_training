with Ada.Text_IO;

package body Shapes is
    procedure Hello (Self : Shape) is
    begin
        Ada.Text_IO.Put_Line
           ("Hello I'm " & self.Name & " but also " & Shape'Class (Self).Name);
    end Hello;
end Shapes;
