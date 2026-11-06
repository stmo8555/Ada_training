package Printing.Paper_Trays is
    type Paper_Counts is array (Paper_Size) of Papers;

    protected Paper_Tray is
        entry Take (Paper_Size) (Pages : Papers);
        entry Wait_For_Paper (Paper_Size) (Pages : Papers);
        procedure Refill;
    private
        Paper : Paper_Counts := [others => Papers'Last];
    end Paper_Tray;
end Printing.Paper_Trays;
