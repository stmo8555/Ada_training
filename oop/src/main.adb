with Ada.Text_IO;        use Ada.Text_IO;
with Shapes;             use Shapes;
with Shapes.Circles;     use Shapes.Circles;
with Shapes.Circles.Red; use Shapes.Circles.Red;
with Shapes.Rectangles;  use Shapes.Rectangles;
with Ada.Containers;     use Ada.Containers;
with Ada.Containers.Indefinite_Vectors;

procedure Main is
    package Shape_Vectors is new
       Indefinite_Vectors (Index_Type => Natural, Element_Type => Shape'Class);
    use Shape_Vectors;

    V  : Vector;
    C  : Circle;
    RC : Red_Circle;
    R  : Rectangle;
begin
    C := Create (2, 2);
    R := Create (5, 2);
    RC := Create (4, 4);
    V.Append (C);
    V.Append (R);
    V.Append (RC);

    Put_Line ("Loop");
    for e of V loop
        Put_Line (e.Name & " has area" & e.Area'Image);
    end loop;
    Put_Line ("End loop");
    Drawable'Class (C).Draw;

    R.Hello;
end Main;
