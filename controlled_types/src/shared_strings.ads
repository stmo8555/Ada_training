with Ada.Finalization;

package Shared_Strings is

    type Shared_String is tagged private;
    function To_String (Str : Shared_String) return String;

    procedure Append (Str : in out Shared_String; text : String);
private
    type String_Access is access all String;

    type Shared_Data is record
        Count : Natural := 1;
        Val   : String_Access;
    end record;
    type Shared_Data_Access is access all Shared_Data;

    type Shared_String is new Ada.Finalization.Controlled with record
        Data : Shared_Data_Access;
    end record;

    overriding
    procedure Initialize (Str : in out Shared_String);

    overriding
    procedure Adjust (Str : in out Shared_String);

    overriding
    procedure Finalize (Str : in out Shared_String);

    function To_String (Str : Shared_String) return String
    is (if Str.Data.Val = null then "" else Str.Data.Val.All);

end Shared_Strings;
