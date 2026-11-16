with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Text_IO;       --    use Ada.Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Containers;        use Ada.Containers;
with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with Ada.Directories;       use Ada.Directories;
with Ada.Environment_Variables;
with Ada.Exceptions;        use Ada.Exceptions;
with Ada.IO_Exceptions;

procedure Main is
    package EV renames Ada.Environment_Variables;
    OP_INDEX          : constant := 1;
    TODO_INDEX        : constant := 2;
    TODO_FILE         : constant String := "Todo_List_Record";
    TODO_DUMMY_HEADER : constant String := "__TODO__";
    TODO_ENV          : constant String := "TODO_DIR";
    BACKUP_EXT        : constant String := "bak";
    MAX_TODO_LENGTH   : constant := 10_000;

    --  Raised for anything that should end the program with a message
    Todo_Error : exception;

    type Todo is record
        Str : Unbounded_String;
    end record
    with Write => Todo_Write, Read => Todo_Read;

    procedure Todo_Write
       (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
        Item   : in Todo);

    procedure Todo_Read
       (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
        Item   : out Todo);

    procedure Todo_Write
       (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
        Item   : in Todo) is
    begin
        String'Write (Stream, TODO_DUMMY_HEADER);
        Natural'Write (Stream, Length (Item.Str));
        String'Write (Stream, To_String (Item.Str));
    end;

    procedure Todo_Read
       (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
        Item   : out Todo)
    is
        Dummy_Header : String (TODO_DUMMY_HEADER'Range);
        Len          : Natural;
    begin
        String'Read (Stream, Dummy_Header);
        if Dummy_Header /= TODO_DUMMY_HEADER then
            raise Data_Error with "bad todo header";
        end if;
        Natural'Read (Stream, Len);
        --  A broken file could give a huge length and blow the stack
        if Len > MAX_TODO_LENGTH then
            raise Data_Error with "todo too long";
        end if;
        declare
            Str : String (1 .. Len);
        begin
            String'Read (Stream, Str);
            Item.Str := To_Unbounded_String (Str);
        end;
    end;

    package Todo_Vectors is new
       Indefinite_Vectors (Index_Type => Positive, Element_Type => Todo);
    use Todo_Vectors;
    type Ops is (add, list, done, backups);

    procedure Fail (Msg : String) is
    begin
        Ada.Text_IO.Put_Line (Ada.Text_IO.Standard_Error, Msg);
        Set_Exit_Status (Failure);
    end;

    procedure Usage is
    begin
        Fail ("Usage: main add ""text"" | list | done N | backups");
    end;

    --  Raises Todo_Error if no folder can be found or created
    function Todo_Dir return String is
    begin
        if EV.Exists (TODO_ENV) then
            return EV.Value (TODO_ENV);
        elsif EV.Exists ("HOME") then
            return EV.Value ("HOME");
        else
            raise Todo_Error with "Neither " & TODO_ENV & " nor HOME is set";
        end if;
    end;

    procedure Read_Lines (Path : String; Lines : in out Vector) is
        F : File_Type;
    begin
        if not Exists (Path) then
            return;
        end if;

        Open (F, In_File, Path);
        begin
            while not End_Of_File (F) loop
                declare
                    T : Todo;
                begin
                    Todo'Read (Stream (F), T);
                    Lines.Append (T);
                end;
            end loop;
        exception
            when Data_Error | End_Error =>
                Close (F);
                raise Todo_Error with "Todo file is corrupt: " & Path;
        end;
        Close (F);
    end;

    procedure Write_Lines (Path : String; Lines : Vector) is
        F : File_Type;
    begin
        Create (F, Out_File, Path);
        for T of Lines loop
            Todo'Write (Stream (F), T);
        end loop;
        Close (F);
    end;

    --  Copies the todo file to <file>.<N>.bak, N one higher than the last
    procedure Backup (Dir, Path : String) is
        Search : Search_Type;
        Item   : Directory_Entry_Type;
        Count  : Natural := 0;
    begin
        if not Exists (Path) then
            return;
        end if;
        Start_Search
           (Search,
            Dir,
            TODO_FILE & ".*." & BACKUP_EXT,
            [Ordinary_File => True, others => False]);
        while More_Entries (Search) loop
            Get_Next_Entry (Search, Item);
            Count := Count + 1;
        end loop;
        End_Search (Search);

        Copy_File
           (Path,
            Compose
               (Dir,
                TODO_FILE
                & "."
                & Ada.Strings.Fixed.Trim
                     (Natural'Image (Count + 1), Ada.Strings.Left),
                BACKUP_EXT));
    end;

    procedure List_Backups (Dir : String) is
        Search : Search_Type;
        Item   : Directory_Entry_Type;
        Found  : Boolean := False;
    begin
        Start_Search
           (Search,
            Dir,
            TODO_FILE & ".*." & BACKUP_EXT,
            [Ordinary_File => True, others => False]);
        while More_Entries (Search) loop
            Get_Next_Entry (Search, Item);
            Ada.Text_IO.Put_Line (Simple_Name (Item));
            Found := True;
        end loop;
        End_Search (Search);
        if not Found then
            Ada.Text_IO.Put_Line ("No backups");
        end if;
    end;

    procedure Run (Dir : String) is
        Path  : constant String := Compose (Dir, TODO_FILE);
        Op    : Ops;
        Lines : Vector;
    begin
        begin
            Op := Ops'Value (Argument (OP_INDEX));
        exception
            when Constraint_Error =>
                Fail (Argument (OP_INDEX) & " is not a valid operation");
                Usage;
                return;
        end;

        case Op is
            when add     =>
                if Argument_Count /= TODO_INDEX then
                    Fail ("add needs exactly one todo text");
                    return;
                end if;

                declare
                    F : File_Type;
                    T : constant Todo :=
                       Todo'
                          (Str => To_Unbounded_String (Argument (TODO_INDEX)));
                begin
                    if Exists (Path) then
                        Open (F, Mode => Append_File, Name => Path);
                    else
                        Create (F, Mode => Out_File, Name => Path);
                    end if;
                    Todo'Write (Stream (F), T);
                    Close (F);
                end;

            when list    =>
                Read_Lines (Path, Lines);
                if Lines.Is_Empty then
                    Ada.Text_IO.Put_Line ("No todos");
                end if;
                for I in Lines.First_Index .. Lines.Last_Index loop
                    Ada.Text_IO.Put_Line
                       ("Todo " & I'Image & ": " & To_String (Lines (I).Str));
                end loop;

            when done    =>
                if Argument_Count /= TODO_INDEX then
                    Fail ("done needs exactly one todo number");
                    return;
                end if;

                declare
                    Done_Index : Positive;
                begin
                    begin
                        Done_Index := Positive'Value (Argument (TODO_INDEX));
                    exception
                        when Constraint_Error =>
                            Fail
                               (Argument (TODO_INDEX)
                                & " is not a valid todo number");
                            return;
                    end;

                    Read_Lines (Path, Lines);

                    if Done_Index > Lines.Last_Index then
                        Fail ("Todo" & Done_Index'Image & " does not exist");
                        return;
                    end if;

                    Backup (Dir, Path);
                    Lines.Delete (Done_Index);
                    Write_Lines (Path, Lines);
                end;

            when backups =>
                List_Backups (Dir);
        end case;
    end Run;

begin
    if Argument_Count < OP_INDEX then
        Usage;
        return;
    end if;

    declare
        Dir : constant String := Todo_Dir;
    begin
        Create_Path (Dir);
        Run (Dir);
    end;
exception
    when E : Todo_Error =>
        Fail (Exception_Message (E));
    when E : Ada.IO_Exceptions.Use_Error | Ada.IO_Exceptions.Name_Error =>
        Fail ("Cannot use todo folder or file: " & Exception_Message (E));
end Main;
