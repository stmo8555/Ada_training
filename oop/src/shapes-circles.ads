package Shapes.Circles is
    type Circle is new Shape and Drawable with record
        Pi : Float := 3.1415;
    end record;

    overriding
    function Create (W, H : Natural) return Circle;

    overriding
    procedure Draw (Self : Circle);

    overriding
    function Name (Self : Circle) return string
    is ("Circle");

    overriding
    function Area (Self : Circle) return Float;
private

    overriding
    function Area (Self : Circle) return Float
    is (((Float (Self.W) / 2.0) ** 2) * Self.Pi);

end Shapes.Circles;
