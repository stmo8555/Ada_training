package body Shapes.Circles.Red is
    function Create (W, H : Natural) return Red_Circle is
        s : Red_Circle;
    begin
        s.W := W;
        s.H := H;
        return s;
    end Create;
end Shapes.Circles.Red;
