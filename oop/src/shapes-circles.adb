with Ada.Text_IO;

package body Shapes.Circles is

    function Create (W, H : Natural) return Circle is
        s : Circle;
    begin
        s.W := W;
        s.H := H;
        return s;
    end Create;

    procedure Draw (Self : Circle) is
    begin
        Ada.Text_IO.Put_Line ("Drawing circle");
    end Draw;
end Shapes.Circles;
