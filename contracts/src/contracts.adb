package body Contracts is

    procedure Deposit (b : in out Bank_Account; a : Natural) is
    begin
        b := b + Bank_Account (a);
    end Deposit;

    procedure Withdraw (b : in out Bank_Account; a : Natural) is
    begin
        b := b - Bank_Account (a);
    end Withdraw;

    procedure Set (R : in out Data_Range; First, Last : Natural) is
    begin
        R.First := First;
        R.Last := Last;
    end Set;

    function Sign (X : Integer) return Integer is
    begin
        if X < 0 then
            return -1;
        elsif X = 0 then
            return 0;
        else
            return 1;
        end if;
    end Sign;

    function Max (A, B : T) return T is
    begin
        return (if A > B then A else B);
    end Max;

end Contracts;
