# Object-Oriented Ada

## Steps

1. **An abstract base.** `type Shape is abstract tagged private;` with
   `function Area (S : Shape) return Float is abstract;` and a normal
   `Name` function.
2. **Derived types.** `Circle` and `Rectangle` in child packages
   (`Shapes.Circles`, `Shapes.Rectangles`), each overriding `Area`.
3. **Class-wide types.** A vector of `Shape'Class` (needs
   `Indefinite_Vectors`, why?) and a loop that prints every area.
   That call is dispatching.
4. **Interfaces.** `type Drawable is interface;` with `procedure Draw (D
   : Drawable) is abstract;`. Make `Circle` implement both `Shape` and
   `Drawable`.
5. **Static vs dispatching.** Call `Name` on a `Circle` from inside
   `Shape`'s own code, once normally and once with
   `Shape'Class (S).Name`. Override `Name` in `Circle` and see the
   difference.
6. **Constructors.** Give each type a `Create` function. What happens
   when a type derived from `Circle` doesn't override it?

## You'll learn

Abstract types, `'Class`, dispatching, interfaces, `overriding`,
redispatching, and why Ada makes dispatching visible in the code.

## Done when

You can add a new shape without changing any existing package.
