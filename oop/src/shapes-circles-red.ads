with Ada.Strings.Bounded;

package Shapes.Circles.Red is
    pragma Elaborate_Body;

    package Color_Strings is new
       Ada.Strings.Bounded.Generic_Bounded_Length (Max => 3);
    use Color_Strings;

    type Red_Circle is new Circle with record
        Color : Bounded_String := To_Bounded_String ("RED");
    end record;

    overriding
    function Create (W, H : Natural) return Red_Circle;

    overriding
    function Name (Self : Red_Circle) return string
    is ("Red_Circle");
end Shapes.Circles.Red;
