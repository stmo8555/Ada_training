with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

package Tokens.Grammars is
    package LF_Maps is new
       Indefinite_Hashed_Maps
          (Key_Type        => String,
           Element_Type    => Long_Float,
           Hash            => Ada.Strings.Hash,
           Equivalent_Keys => "=");
    use LF_Maps;
    use Token_Vector;
    Interpreter_Error : exception;

    function Interpret (Token_V : Vector) return Long_Float;

private
    Current_Index : Positive;
    Tokens        : Vector;
    Memory        : Map;

    function Peek return Token_Type
    is (Tokens (Current_Index).T_Type);

    procedure Input_Error
       (Message : String; At_Token : Positive := Current_Index)
    with No_Return;

    function Parse_Identifier return Long_Float;
    function Parse_Assignment return Long_Float
    with Pre => Peek = LET;
    function Parse_Unary return Long_Float;
    function Parse_Grouping return Long_Float;
    function Parse_Number return Long_Float;
    function Parse_Term return Long_Float;
    function Parse_Expression return Long_Float;
end Tokens.Grammars;
