with Ada.Text_IO;                           use Ada.Text_IO;
with Ada.Strings.Text_Buffers;
with Ada.Numerics.Big_Numbers.Big_Integers;
use Ada.Numerics.Big_Numbers.Big_Integers;

procedure Main is
    type A is array (1 .. 5) of Natural;
    Decl : Integer :=
       (declare
           X : constant Integer := 3;
        begin
           X * X);
    type P is record
        Age : Positive;
    end record;

    type Custom_Image is new Integer with Put_Image => Custom_Put_Image;

    procedure Custom_Put_Image
       (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
        Arg    : Custom_Image);

    procedure Custom_Put_Image
       (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
        Arg    : Custom_Image) is
    begin
        Buffer.Put ("Integer with value:" & Integer (Arg)'Image);
    end Custom_Put_Image;

    Person     : P := (Age => 10);
    Old_Person : P := (Person with delta Age => Person.Age + 100);

    Arr : A := [for I in A'Range => I];

    procedure Max_N (Curr : in out Natural; Value : Natural) is
    begin
        if Value > Curr then
            Curr := Value;
        end if;
    end Max_N;

    Big_N : Big_Natural := 1;

    package Moneys is
        type Money is record
            val : Float;
        end record
        with Real_Literal => From_Real, Integer_Literal => From_Integer;

        function From_Real (Value : String) return Money
        is (val => Float'Value (Value));

        function From_Integer (Value : String) return Money renames From_Real;
    end Moneys;

    Empty_String : String := [];
begin
    pragma Assert (Decl = 9);
    pragma Assert (Person.Age = 10);
    pragma Assert (Old_Person.Age = Person.Age + 100);
    for I in A'Range loop
        pragma Assert (Arr (I) = I);
    end loop;
    pragma
       Assert ([for X of Arr when X > 3 => X]'Reduce ("-", Integer'(0)) = -9);
    pragma Assert (Arr'Reduce ("+", 0) = Natural'(1 + 2 + 3 + 4 + 5));
    pragma Assert (Arr'Reduce (Max_N, Natural'(0)) = 5);
    pragma Assert (Arr'Reduce (Max_N, Natural'(10)) = 10);
    pragma Assert (Person'Image = ASCII.LF & "(AGE =>  10)");
    pragma Assert (Custom_Image'(10)'Image = "Integer with value: 10");

    for I in 1 .. 100 loop
        Big_N := Big_N * To_Big_Integer (I);
    end loop;
    pragma
       Assert
          (Big_N
           = 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000);

    declare
        M  : Moneys.Money := 12.50;
        M2 : Moneys.Money := 12;
    begin
        pragma Assert (M.Val = Float'(12.50));
        pragma Assert (M2.Val = Float'(12.0));
    end;
end Main;
