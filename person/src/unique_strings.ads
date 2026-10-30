with Ada.Finalization;

package Unique_Strings is

    type Unique_String is tagged private;
    function To_String (Str : Unique_String) return String;

    procedure Append (Str : in out Unique_String; text : String);
private
    type String_Access is access all String;
    type Unique_String is new Ada.Finalization.Controlled with record
        Val : String_Access;
    end record;

    overriding
    procedure Initialize (Str : in out Unique_String);

    overriding
    procedure Adjust (Str : in out Unique_String);

    overriding
    procedure Finalize (Str : in out Unique_String);

    function To_String (Str : Unique_String) return String
    is (if Str.val = null then "" else Str.Val.All);

end Unique_Strings;
