package body Printing.Paper_Trays is
    protected body Paper_Tray is
        entry Take(for S in Paper_Size) (Pages : Papers) when True is
        begin
            if Pages > Paper (S) then
                requeue Wait_For_Paper (S);
            end if;

            Paper (S) := Paper (S) - Pages;
        end Take;

        entry Wait_For_Paper(for S in Paper_Size) (Pages : Papers)
           when Paper (S) = Papers'Last
        is
        begin
            requeue Take (S);
        end Wait_For_Paper;

        procedure Refill is
        begin
            Paper := [others => Papers'Last];
        end Refill;
    end Paper_Tray;
end Printing.Paper_Trays;
