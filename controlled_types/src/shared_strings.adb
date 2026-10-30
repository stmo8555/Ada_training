with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Shared_Strings is
    procedure Free is new
       Ada.Unchecked_Deallocation (Shared_Data, Shared_Data_Access);
    procedure Free is new Ada.Unchecked_Deallocation (String, String_Access);

    procedure Append (Str : in out Shared_String; text : String) is
        old : String_Access := Str.Data.Val;
    begin
        Str.Data.Val :=
           new String'((if old = null then "" else old.All) & text);
        free (old);
    end Append;

    procedure Initialize (Str : in out Shared_String) is
    begin
        Str.Data := new Shared_Data;
        Put_Line ("Initialize...");
        Put_Line ("Ref Count: " & Str.Data.Count'Image);
    end Initialize;

    procedure Adjust (Str : in out Shared_String) is
    begin
        Str.Data.Count := Str.Data.Count + 1;
        Put_Line ("Adjust...");
        Put_Line ("Ref Count: " & Str.Data.Count'Image);
    end Adjust;

    procedure Finalize (Str : in out Shared_String) is
    begin
        if Str.Data = null then
            return;
        end if;

        Str.Data.Count := Str.Data.Count - 1;
        Put_Line ("Finalize...");
        Put_Line ("Ref Count: " & Str.Data.Count'Image);
        if Str.Data.Count = 0 then
            Free (Str.Data.Val);
            Free (Str.Data);
        end if;

        --  this object no longer owns a share, so a second Finalize is a no-op
        Str.Data := null;
    end Finalize;
end Shared_Strings;
