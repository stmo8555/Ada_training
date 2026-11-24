package body Tokens is
    function Number_Literal (Value : Long_Float) return Literal_Value is
    begin
        return (L_Type => NUMERIC_VALUE, Num => Value);
    end Number_Literal;

    function Text_Literal (Value : String) return Literal_Value is
    begin
        return (L_Type => TEXT_VALUE, Str => To_Unbounded_String (Value));
    end Text_Literal;

    function No_Literal return Literal_Value is
    begin
        return (L_Type => NO_VALUE);
    end No_Literal;
end Tokens;
