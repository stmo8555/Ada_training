package Printing is
    type Priority_Level is (Low, Mid, High);
    type Paper_Size is (A4, A3);
    subtype Papers is Integer range 0 .. 5;

    type Job is record
        Id       : Integer;
        Pages    : Papers;
        Priority : Priority_Level;
        Size     : Paper_Size;
    end record;

    type Maybe_Job (Has_Job : Boolean := False) is record
        case Has_Job is
            when True =>
                J : Job;

            when False =>
                null;
        end case;
    end record;
end Printing;
