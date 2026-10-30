with Ada.Text_IO; use Ada.Text_Io;

procedure Main is
    type Meters is new Float;
    type Seconds is new Float;
    type Meters_Per_Second is new Float;
    subtype Percent is Integer range 0 .. 100;
    type Counter is mod 256;
    type Weekday is
       (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);

    function "/" (Left : Meters; Right : Seconds) return Meters_Per_Second
    is (Meters_Per_Second (float (left) / float (right)));
    m   : Meters;
    s   : Seconds;
    mps : Meters_Per_Second;
    p   : Percent;
    i   : Integer := 49;
    c   : Counter := 255;
    w   : Weekday := Wednesday;
begin
    m := 5.0;
    s := 10.0;
    mps := m / s;
    p := 50;
    p := p + i;

    pragma Assert (Weekday'Last = Sunday);
    pragma Assert (Weekday'Succ (w) = Thursday);
    pragma Assert (Weekday'First = Monday);
    pragma Assert (Weekday'Pred (w) = Tuesday);
    pragma Assert (Weekday'Value ("Wednesday") = w);
    pragma Assert (c + 1 = 0);

    Put_Line (mps'Image);

end Main;
