package Shapes.Rectangles is
    type Rectangle is new Shape with null record;

    overriding
    function Create (W, H : Natural) return Rectangle;

    overriding
    function Area (Self : Rectangle) return Float;

    --  overriding
    function Name (Self : Rectangle) return String
    is ("Rectangle");
private
    overriding
    function Area (Self : Rectangle) return Float
    is (Float (Self.W * Self.H));
end Shapes.Rectangles;
