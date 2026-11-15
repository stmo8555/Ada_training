package body Shapes.Rectangles is

    function Create (W, H : Natural) return Rectangle is
        s : Rectangle;
    begin
        s.W := W;
        s.H := H;
        return s;
    end create;

end Shapes.Rectangles;
