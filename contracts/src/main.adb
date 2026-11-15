with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Assertions; use Ada.Assertions;
with Contracts;      use Contracts;

procedure Main is
    procedure Test_Predicates is
        --  bad values for the checks to catch at run time
        One        : constant Integer := 1;
        Monday_Var : constant Weekday := Monday;
        E          : Even;
        W          : Weekend;
        Failed     : Boolean;
    begin
        E := 2;
        pragma Assert (E = 2);

        Failed := False;
        begin
            E := One;
        exception
            when Assertion_Error =>
                Failed := True;
        end;
        pragma Assert (Failed, "1 should fail Even's predicate");

        W := Sunday;
        pragma Assert (W = Sunday);

        --  Weekend has both a range and a predicate. The range is checked
        --  first, so Monday raises Constraint_Error, not Assertion_Error.
        Failed := False;
        begin
            W := Monday_Var;
        exception
            when Constraint_Error | Assertion_Error =>
                Failed := True;
        end;
        pragma Assert (Failed, "Monday should not be a Weekend");

        Put_Line ("Predicates: all asserts passed");
    end Test_Predicates;

    procedure Test_Bank_Account is
        A      : Bank_Account;
        Failed : Boolean := False;
    begin
        --  a new account starts empty
        pragma Assert (Balance (A) = 0);

        Deposit (A, 100);
        pragma Assert (Balance (A) = 100);

        Withdraw (A, 30);
        pragma Assert (Balance (A) = 70);

        --  taking out more than the balance must fail the Pre,
        --  and leave the balance unchanged
        begin
            Withdraw (A, 71);
        exception
            when Assertion_Error =>
                Failed := True;
        end;
        pragma Assert (Failed, "Withdraw should have failed its Pre");
        pragma Assert (Balance (A) = 70);

        --  taking out exactly everything is allowed
        Withdraw (A, 70);
        pragma Assert (Balance (A) = 0);

        --  depositing 0 changes nothing
        Deposit (A, 0);
        pragma Assert (Balance (A) = 0);

        Put_Line ("Bank account: all asserts passed");
    end Test_Bank_Account;

    procedure Test_Max is
        function Int_Max is new Max (Integer);
        function Day_Max is new Max (Weekday);
    begin
        pragma Assert (Int_Max (3, 7) = 7);
        pragma Assert (Int_Max (7, 3) = 7);
        pragma Assert (Int_Max (-5, -5) = -5);
        pragma Assert (Day_Max (Monday, Friday) = Friday);
        Put_Line ("Max: all asserts passed");
    end Test_Max;

    --  expects in Contracts:
    --    procedure Set (R : in out Data_Range; First, Last : Natural);
    --    function First_Of (R : Data_Range) return Natural;
    --    function Last_Of (R : Data_Range) return Natural;
    procedure Test_Data_Range is
        R      : Data_Range;   --  must not fail: needs default values
        Failed : Boolean := False;
    begin
        Set (R, 2, 5);
        pragma Assert (First_Of (R) = 2 and Last_Of (R) = 5);

        --  equal ends are allowed
        Set (R, 5, 5);
        pragma Assert (First_Of (R) = 5 and Last_Of (R) = 5);

        --  First after Last must break the invariant when Set returns
        begin
            Set (R, 5, 3);
        exception
            when Assertion_Error =>
                Failed := True;
        end;
        pragma Assert (Failed, "Set (5, 3) should break the invariant");

        Put_Line ("Data_Range: all asserts passed");
    end Test_Data_Range;

    procedure Test_Sign is
    begin
        pragma Assert (Sign (-7) = -1);
        pragma Assert (Sign (0) = 0);
        pragma Assert (Sign (42) = 1);
        Put_Line ("Sign: all asserts passed");
    end Test_Sign;

begin
    Test_Predicates;
    Test_Bank_Account;
    Test_Max;
    Test_Data_Range;
    Test_Sign;
end Main;
