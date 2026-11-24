package Tokens.Grammars is
    use Token_Vector;
    function Interpret (Token_V : Vector) return Long_Float;

private
    Current_Index : Positive;
    Tokens        : Vector;

    function Peek return Token_Type
    is (Tokens (Current_Index).T_Type);

    function Multiply return Long_Float;
    function Parse_Expression return Long_Float;
end Tokens.Grammars;
