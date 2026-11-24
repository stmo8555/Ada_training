with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers;        use Ada.Containers;
with Ada.Containers.Vectors;

package Tokens is
    type Token_Type is
       (PLUS,
        MINUS,
        MULT,
        DIV,
        LEFT_PAREN,
        RIGHT_PAREN,
        EQUALS,
        NUMBER,
        TEXT,
        EOF);

    type Literal_Kind is (NO_VALUE, NUMERIC_VALUE, TEXT_VALUE);

    type Literal_Value (L_Type : Literal_Kind := NO_VALUE) is record
        case L_Type is
            when NUMERIC_VALUE =>
                Num : Long_Float;

            when TEXT_VALUE =>
                Str : Unbounded_String;

            when NO_VALUE =>
                Null;
        end case;
    end record;

    function Number_Literal (Value : Long_Float) return Literal_Value;
    function Text_Literal (Value : String) return Literal_Value;
    function No_Literal return Literal_Value;

    type Token is record
        T_Type  : Token_Type;
        Lexeme  : Unbounded_String;
        Literal : Literal_Value;
        Line    : Natural;
    end record;

    package Token_Vector is new
       Vectors (Index_Type => Positive, Element_Type => Tokens.Token);
end Tokens;
