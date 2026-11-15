package Shapes is
    type Drawable is interface;
    procedure Draw (Self : Drawable) is abstract;
    type Shape is abstract tagged private;

    procedure Hello (Self : Shape);
    function Create (W, H : Natural) return Shape is abstract;
    function Area (Self : Shape) return Float is abstract;
    function Name (Self : Shape) return String
    is ("Shape");
private
    type Shape is abstract tagged record
        H, W : Natural;
    end record;
end Shapes;
