with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Real_Time;        use Ada.Real_Time;
with Printing;             use Printing;
with Printing.Job_Queues;  use Printing.Job_Queues;
with Printing.Paper_Trays; use Printing.Paper_Trays;

procedure Main is
    function Next_Id return Positive;

    task Refiller is
        entry Done;
    end;

    task body Refiller is
    begin
        loop
            Paper_Tray.Refill;
            select
                accept Done;
                exit;
            or
                delay 2.0;
            end select;
        end loop;
    end Refiller;

    task type Printer (Id : Positive := Next_Id);
    task body Printer is
        tmp         : Maybe_Job;
        Start, Stop : Time;
    begin
        loop
            Queue.Get (tmp);

            exit when not tmp.Has_Job;
            Start := Clock;
            Paper_Tray.Take (tmp.J.Size) (tmp.J.Pages);

            Put_Line
               ("Printer "
                & Id'Image
                & ": job "
                & tmp.J.Id'Image
                & " with prio "
                & tmp.J.Priority'Image
                & " ("
                & tmp.J.Pages'Image
                & " pages "
                & tmp.J.Size'Image
                & ")");
            delay 0.1 * tmp.J.Pages;
            Stop := Clock;

            Put_Line
               ("Job "
                & tmp.J.Id'Image
                & " run time: "
                & Duration'Image (To_Duration (Stop - Start))
                & " seconds");
        end loop;
    end Printer;

    task Producer;
    task body Producer is
    begin
        for I in 1 .. 20 loop
            Queue.Put
               (Job'
                   (Id       => I,
                    Pages    => 1 + I mod 5,
                    Priority => Priority_Level'Val (i mod 3),
                    Size     => (if I mod 2 = 0 then A4 else A3)));
            delay 0.3;
        end loop;
        Queue.Close;
    end;

    Next : Positive := 1;
    function Next_Id return Positive is
    begin
        return Id : constant Positive := Next do
            Next := Next + 1;
        end return;
    end Next_Id;

    Start, Stop : Time;
begin
    Start := Clock;
    declare

        Printers : array (1 .. 3) of Printer;
    begin
        null;
    end;
    Stop := Clock;
    Put_Line
       ("Total run time: "
        & Duration'Image (To_Duration (Stop - Start))
        & " seconds");
    Refiller.Done;
end Main;
