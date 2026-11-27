with Ada.Containers;        use Ada.Containers;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

with Tokens;      use Tokens;
with Expressions; use Expressions;

package Parsers is
    package LF_Maps is new
       Indefinite_Hashed_Maps
          (Key_Type        => String,
           Element_Type    => Expression_Access,
           Hash            => Ada.Strings.Hash,
           Equivalent_Keys => "=");
    use LF_Maps;
    use Token_Vector;
    Interpreter_Error : exception;

    function Parse (Token_V : Vector) return Expression_Access;

private
    Current_Index : Positive;
    Tokens        : Vector;
    Memory        : Map;

    function Peek return Token_Type
    is (Tokens (Current_Index).T_Type);

    function Parse_Identifier return Expression_Access;
    function Parse_Assignment return Expression_Access
    with Pre => Peek = LET;
    function Parse_Unary return Expression_Access;
    function Parse_Grouping return Expression_Access;
    function Parse_Number return Expression_Access;
    function Parse_Term return Expression_Access;
    function Parse_Expression return Expression_Access;
end Parsers;
