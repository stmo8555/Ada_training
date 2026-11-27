package body Tokens.Grammars is
    procedure Input_Error
       (Message : String; At_Token : Positive := Current_Index)
    is
        Position : constant Positive := Tokens (At_Token).Position;
    begin
        raise Interpreter_Error
           with Message & " at character" & Position'Image;
    end Input_Error;

    function Parse_Identifier return Long_Float is
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
    end;

    function Parse_Assignment return Long_Float is
        Var   : Unbounded_String;
        Value : Long_Float;
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

    function Parse_Unary return Long_Float is
    begin
        if Peek in MINUS then
            Current_Index := Current_Index + 1;
            return -Parse_Grouping;
        else
            return Parse_Grouping;
        end if;
    end;

    function Parse_Grouping return Long_Float is
        Sum : Long_Float := 0.0;
    begin
        if Peek = LEFT_PAREN then
            Current_Index := Current_Index + 1;
            Sum := Sum + Parse_Expression;
            if Peek = EOF then
                Input_Error ("Missing closing parenthesis");
            elsif Peek /= RIGHT_PAREN then
                Input_Error
                   ("Expected ), found "
                    & Tokens (Current_Index).Lexeme'Image);
            end if;
            return Sum;

        end if;

        return Parse_Identifier;
    end;

    function Parse_Number return Long_Float is
    begin
        if Peek /= NUMBER then
            Input_Error ("Expected a number");
        end if;
        return Tokens (Current_Index).Literal.Num;
    end;

    function Parse_Term return Long_Float is
        Sum : Long_Float := Parse_Unary;
    begin
        Current_Index := Current_Index + 1;

        while Peek in MULT | DIV loop
            declare
                Operation      : constant Token_Type := Peek;
                Operator_Index : constant Positive := Current_Index;
            begin
                Current_Index := Current_Index + 1;

                if Operation = MULT then
                    Sum := Sum * Parse_Unary;
                else
                    declare
                        Result : constant Long_Float := Parse_Unary;
                    begin
                        if Result = 0.0 then
                            Input_Error
                               ("Divide by 0 is not allowed", Operator_Index);
                        end if;

                        Sum := Sum / Result;
                    end;
                end if;

                Current_Index := Current_Index + 1;
            end;
        end loop;

        return sum;
    end Parse_Term;

    function Parse_Expression return Long_Float is
        Sum : Long_Float := 0.0;
    begin
        Sum := Parse_Term;

        while Peek in PLUS | MINUS loop
            declare
                Op : constant Token_Type := Peek;
            begin
                Current_Index := Current_Index + 1;
                Sum := Sum + (if OP = PLUS then Parse_Term else -Parse_Term);
            end;
        end loop;

        return Sum;
    end Parse_Expression;

    function Interpret (Token_V : Vector) return Long_Float is
        Sum : Long_Float := 0.0;
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
    end Interpret;
end Tokens.Grammars;
