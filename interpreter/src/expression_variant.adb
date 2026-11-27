with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Expression_Variant is

    procedure Input_Error
       (Message : String; At_Token : Positive := Current_Index)
    is
        Position : constant Positive := Tokens (At_Token).Position;
    begin
        raise Constraint_Error with Message & " at character" & Position'Image;
    end Input_Error;

    function Parse (Token_V : Vector) return Expression_Access is
        Sum : Expression_Access;
    begin
        Tokens := Token_V;
        Current_Index := Token_V.First_Index;
        pragma Assert (Token_Vector.Element (Tokens.Last).T_Type = EOF);

        if Tokens (Current_Index).T_Type = EOF then
            Input_Error ("No expression given");
        end if;

        if Peek = LET then
            return Parse_Assignment;
        end if;

        Sum := Parse_Expression;
        if Tokens (Current_Index).T_Type /= EOF then
            Input_Error ("Unexpected trailing token: " & Peek'Image);
        end if;
        return Sum;

    end Parse;

    function Parse_Identifier return Expression_Access is
        Var : Unbounded_String;
        C   : LF_Maps.Cursor;
    begin
        if Peek in IDENTIFIER then
            Var := Tokens (Current_index).Literal.Str;
            C := Memory.Find (To_String (Var));
            if Has_Element (C) then
                return Element (C);
            else
                Input_Error ("Could not find variable with name " & Var'Image);
            end if;
        end if;

        return Parse_Number;
    end Parse_Identifier;

    function Parse_Assignment return Expression_Access is
        Var   : Unbounded_String;
        Value : Expression_Access;
    begin
        Current_Index := Current_Index + 1;
        if Peek /= IDENTIFIER then
            Input_Error ("Expected a variable name after let");
        end if;

        Var := Tokens (Current_Index).Literal.Str;
        Current_Index := Current_Index + 1;
        if Peek /= EQUALS then
            Input_Error ("Expected = after " & To_String (Var));
        end if;

        Current_Index := Current_Index + 1;
        Value := Parse_Expression;
        if Peek /= EOF then
            Input_Error ("Unexpected token after assignment: " & Peek'Image);
        end if;

        Memory.Include (To_String (Var), Value);
        return Value;
    end Parse_Assignment;

    function Parse_Unary return Expression_Access is
    begin

        if Peek in MINUS then
            Current_Index := Current_Index + 1;
            return
               new Expression'(Kind => Unary_Node, Operand => Parse_Grouping);
        else
            return Parse_Grouping;
        end if;
    end Parse_Unary;

    function Parse_Grouping return Expression_Access is
        Expr : Expression_Access;
    begin
        if Peek = LEFT_PAREN then
            Current_Index := Current_Index + 1;
            Expr := Parse_Expression;
            if Peek = EOF then
                Input_Error ("Missing closing parenthesis");
            elsif Peek /= RIGHT_PAREN then
                Input_Error
                   ("Expected ), found "
                    & Tokens (Current_Index).Lexeme'Image);
            end if;
            return new Expression'(Kind => Grouping_Node, Expr => Expr);
        end if;

        return Parse_Identifier;
    end Parse_Grouping;

    function Parse_Number return Expression_Access is
    begin
        if Peek /= NUMBER then
            Input_Error ("Expected a number");
        end if;
        return
           new Expression'
              (Kind  => Number_Node,
               Value => Tokens (Current_Index).Literal.Num);
    end Parse_Number;

    function Parse_Term return Expression_Access is
        Expr : Expression_Access := Parse_Unary;
    begin
        Current_Index := Current_Index + 1;

        while Peek in MULT | DIV loop
            declare
                Op : constant Binary_Operator :=
                   (if Tokens (Current_Index).T_Type = MULT
                    then Multiply
                    else Divide);
            begin
                Current_Index := Current_Index + 1;
                Expr :=
                   new Expression'
                      (Kind     => Binary_Node,
                       Operator => Op,
                       Left     => Expr,
                       Right    => Parse_Unary);

                Current_Index := Current_Index + 1;
            end;
        end loop;

        return Expr;

    end Parse_Term;

    function Parse_Expression return Expression_Access is
        Expr : Expression_Access := Parse_Term;
    begin
        while Peek in PLUS | MINUS loop
            declare
                Op : constant Binary_Operator :=
                   (if Tokens (Current_Index).T_Type = PLUS
                    then Add
                    else Subtract);
            begin
                Current_Index := Current_Index + 1;
                Expr :=
                   new Expression'
                      (Kind     => Binary_Node,
                       Operator => Op,
                       Left     => Expr,
                       Right    => Parse_Term);
            end;
        end loop;
        return Expr;
    end Parse_Expression;
end Expression_Variant;
