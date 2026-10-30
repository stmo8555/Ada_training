with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with Unique_Strings;   use Unique_Strings;
with Ada.Finalization; use Ada.Finalization;
with Ada.Exceptions;   use Ada.Exceptions;

procedure Main is
    counter : Natural := 1;

    type Person is new Ada.Finalization.Controlled with record
        Name  : Unique_String;
        Email : Unique_String;
    end record;
    type Person_Access is access all Person;

    overriding
    procedure Initialize (Str : in out Person);
    overriding
    procedure Adjust (Str : in out Person);
    overriding
    procedure Finalize (Str : in out Person);

    procedure Free is new Ada.Unchecked_Deallocation (Person, Person_Access);

    procedure Initialize (Str : in out Person) is
    begin
        raise Constraint_Error with "Error in Intitialize";
        Put_Line ("Person: Initalize");
    end Initialize;

    procedure Adjust (Str : in out Person) is
    begin
        --  raise Constraint_Error with "Error in Adjust";
        Put_Line ("Person: Adjust");
    end Adjust;

    procedure Finalize (Str : in out Person) is
    begin
        Put_Line ("Person: Finalize");
    end Finalize;

    --  P : Person;
    --  Q : Person := P;
    Ptr : Person_Access;
    --  Ptr2 : Person_Access := new Person;
begin
    --  Ptr2.All := Ptr.All;
    Ptr := new Person;
exception
    when E : Constraint_Error =>

        Put_Line ("My error: " & Exception_Message (E));

        --  u init
        --  u init
        --  P init
        --  q u adjust
        --  q u adjust
        --  q adjust
        --
        --  p finalize
        --  p u finalize
        --  p u finalize
        --  q finalize
        --  q u Finalize
        --  q u finalize

        Put_Line ("freeing");
        --  Free (Ptr);
        Put_Line ("working");
end Main;
