with Ada.Text_IO; use Ada.Text_IO;
with Ring_Buffers;

procedure Main is
    --  a generic must be instantiated before it can be used
    package Int_Buffers is new Ring_Buffers (Integer);
    use Int_Buffers;

    Buffer : Ring_Buffer;
    Sum    : Integer := 0;
    Loops  : Natural := 0;
begin
    --  empty buffer: the loop body runs zero times
    for E of Buffer loop
        Loops := Loops + 1;
    end loop;
    pragma Assert (Loops = 0);

    --  read only loop
    Buffer.Push (1);
    Buffer.Push (2);
    Buffer.Push (3);
    for E of Buffer loop
        Sum := Sum + E;
    end loop;
    pragma Assert (Sum = 6);

    --  writing through E changes the items in the buffer
    for E of Buffer loop
        E := E * 2;
    end loop;
    pragma Assert (Buffer.Pop = 2);
    pragma Assert (Buffer.Pop = 4);
    pragma Assert (Buffer.Pop = 6);
    pragma Assert (Buffer.Size = 0);

    --  12 pushes into 10 slots: 1 and 2 are overwritten,
    --  so iteration starts at the oldest remaining item, 3
    for I in 1 .. 12 loop
        Buffer.Push (I);
    end loop;
    pragma Assert (Buffer.Size = 10);
    Loops := 0;
    for E of Buffer loop
        Loops := Loops + 1;
        pragma Assert (E = Loops + 2);
        Put (E'Image);
    end loop;
    New_Line;
    pragma Assert (Loops = 10);

    Put_Line ("All asserts passed");
end Main;
