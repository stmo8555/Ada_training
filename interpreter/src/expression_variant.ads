with Ada.Containers; use Ada.Containers;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;
with Tokens;         use Tokens;

package Expression_Variant is
    type Node_Kind is (Number_Node, Binary_Node, Unary_Node, Grouping_Node);
    type Binary_Operator is (Add, Subtract, Multiply, Divide);

    type Expression (Kind : Node_Kind);
    type Expression_Access is access Expression;

    package LF_Maps is new
       Indefinite_Hashed_Maps
          (Key_Type        => String,
           Element_Type    => Expression_Access,
           Hash            => Ada.Strings.Hash,
           Equivalent_Keys => "=");
    use LF_Maps;
    use Token_Vector;

    type Expression (Kind : Node_Kind) is record
        case Kind is
            when Number_Node =>
                Value : Long_Float;

            when Binary_Node =>
                Operator : Binary_Operator;
                Left     : not null Expression_Access;
                Right    : not null Expression_Access;

            when Unary_Node =>
                Operand : Not null Expression_Access;

            when Grouping_Node =>
                Expr : not null Expression_Access;

        end case;
    end record;

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
end Expression_Variant;
