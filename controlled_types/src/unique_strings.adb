with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Unique_Strings is
    procedure Free is new Ada.Unchecked_Deallocation (String, String_Access);
    procedure Append (Str : in out Unique_String; text : String) is
        old : String_Access := Str.Val;
    begin
        Str.Val := new String'((if old = null then "" else old.All) & text);
        free (old);
    end Append;

    procedure Initialize (Str : in out Unique_String) is
    begin
        Put_Line ("Initialize...");
    end Initialize;

    procedure Adjust (Str : in out Unique_String) is

    begin
        Str.Val := new String'(Str.To_String);
        Put_Line ("Adjust...");
    end Adjust;

    procedure Finalize (Str : in out Unique_String) is
    begin
        Free (Str.Val);
        Put_Line ("Finalize...");
    end Finalize;
end Unique_Strings;
