package Contracts is
    subtype Even is Integer with Dynamic_Predicate => Even mod 2 = 0;

    type Weekday is
       (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);

    subtype Weekend is Weekday range Saturday .. Sunday
    with Static_Predicate => Weekend in Saturday | Sunday;

    type Data_Range is private;
    procedure Set (R : in out Data_Range; First, Last : Natural);
    function First_Of (R : Data_Range) return Natural;
    function Last_Of (R : Data_Range) return Natural;

    type Bank_Account is private;
    procedure Withdraw (b : in out Bank_Account; a : Natural)
    with Pre => Balance (b) >= a, post => Balance (b)'Old - a = Balance (b);

    function Balance (b : Bank_Account) return Natural;
    procedure Deposit (b : in out Bank_Account; a : Natural);

    generic
        type T is (<>);
    function Max (A, B : T) return T
    with
       Post =>
          Max'Result >= A
          and Max'Result >= B
          and (Max'Result = A or Max'Result = B);

    --  exactly one condition must be true on entry; its consequence
    --  is checked on exit
    function Sign (X : Integer) return Integer
    with
       Contract_Cases =>
          (X < 0 => Sign'Result = -1,
           X = 0 => Sign'Result = 0,
           X > 0 => Sign'Result = 1);
private
    --  the invariant is on the full view, where the fields are visible
    type Data_Range is record
        First, Last : Natural := 0;
    end record
    with Type_Invariant => Data_Range.First <= Data_Range.Last;

    function First_Of (R : Data_Range) return Natural
    is (R.First);
    function Last_Of (R : Data_Range) return Natural
    is (R.Last);

    type Bank_Account is new Natural with Default_Value => 0;

    function Balance (b : Bank_Account) return Natural
    is (Natural (b));
end Contracts;
