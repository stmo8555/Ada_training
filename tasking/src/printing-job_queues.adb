package body Printing.Job_Queues is
    protected body Queue is
        function Is_Empty return Boolean is
        begin
            return (for all L of Jobs => L.Is_Empty);
        end Is_Empty;

        entry Get (V : out Maybe_Job) when Done or not Is_Empty is
        begin
            for P in reverse Priority_Level loop
                if not Jobs (P).Is_Empty then
                    V := (Has_Job => True, J => Jobs (P).First_Element);
                    Jobs (P).Delete_First;
                    return;
                end if;
            end loop;
            V := (Has_Job => False);
        end Get;

        procedure Close is
        begin
            Done := true;
        end Close;

        procedure Put (V : Job) is
        begin
            Jobs (V.Priority).Append (V);
        end Put;
    end Queue;
end Printing.Job_Queues;
