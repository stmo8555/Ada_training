package Tokens.Scanners is
    type Scanner (Length : Natural) is tagged Record
        Source    : String (1 .. Length);
        Start     : Positive := 1;
        Current   : Positive := 1;
        Line      : Positive := 1;
        Tokens    : Token_Vector.Vector;
        Has_Error : Boolean := False;
    end record;

    function Create_Scanner (Line : String) return Scanner
    is (Scanner'(Length => Line'Length, Source => Line, others => <>));

    function Scan (S : in out Scanner) return Token_Vector.Vector;

private
    function Is_At_End (S : Scanner) return Boolean
    is (S.Current > S.Source'Length)
    with pre => S.Current in S.Source'First .. S.Source'Last + 1;
    procedure Scan_Token (S : in out Scanner);
    procedure Add_Token
       (S : in out Scanner; T_Type : Token_Type; Literal : Literal_Value)
    with Post => S.Tokens.Length = S.Tokens.Length'Old + 1;

    function Peek (S : Scanner) return Character
    is (if Is_At_End (S) then ASCII.NUL else S.Source (S.Current));

    function Peek_Next (S : Scanner) return Character
    is (if Is_At_End (S) or S.Current + 1 not in S.Source'Range
        then ASCII.NUL
        else S.Source (S.Current + 1));

    function Advance (S : in out Scanner) return Character
    with
       pre  => S.Current in S.Source'Range,
       Post => S.Current = S.Current'Old + 1;

    procedure Advance (S : in out Scanner);

end Tokens.Scanners;
