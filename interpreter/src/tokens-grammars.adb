package body Tokens.Grammars is
    function Multiply return Long_Float is
        Sum : Long_Float := Tokens (Current_Index - 1).Literal.Num;
    begin
        while Peek in MULT | DIV loop
            declare
                Operation : constant Token_Type :=
                   Tokens (Current_Index).T_Type;
            begin
                Current_Index := Current_Index + 1;
                if Peek /= NUMBER then
                    raise Constraint_Error
                       with
                          "Invalid character after "
                          & (if Operation = MULT then "*" else "/");
                end if;

                if Operation = MULT then
                    Sum := Sum * Tokens (Current_Index).Literal.Num;
                else
                    Sum := Sum / Tokens (Current_Index).Literal.Num;
                end if;

                Current_Index := Current_Index + 1;
            end;
        end loop;

        return sum;
    end Multiply;

    function Parse_Expression return Long_Float is
        Sum : Long_Float := 0.0;
    begin
        if Peek = NUMBER then
            Current_Index := Current_Index + 1;

            case Peek is
                when DIV | MULT         =>
                    Sum := Multiply;

                when PLUS | MINUS | EOF =>
                    Sum := Tokens (Current_Index - 1).Literal.Num;

                when others             =>
                    raise Constraint_Error with "Invalid Expression";
            end case;

            while Peek in PLUS | MINUS loop
                declare
                    Operation : Token_Type := Peek;
                begin
                    Current_Index := Current_index + 1;
                    if Peek = NUMBER then
                        Current_Index := Current_index + 1;
                    else
                        raise Constraint_Error
                           with
                              "Must be a number after "
                              & (if Operation = PLUS then "+" else "-");
                    end if;

                    case Peek is
                        when DIV | MULT         =>
                            Sum :=
                               Sum
                               + (if Operation = PLUS
                                  then Multiply
                                  else -Multiply);

                        when PLUS | MINUS | EOF =>
                            declare
                                val : Long_Float :=
                                   Tokens (Current_Index - 1).Literal.Num;
                            begin
                                Sum :=
                                   Sum
                                   + (if Operation = PLUS then Val else -Val);
                            end;

                        when others             =>
                            raise Program_Error
                               with "Invalid token type in case";
                    end case;
                end;
            end loop;

            return Sum;
        end if;
        raise Constraint_Error with "Error in Parse_Expression";
    end Parse_Expression;

    function Interpret (Token_V : Vector) return Long_Float is
        Sum : Long_Float := 0.0;
    begin
        Tokens := Token_V;
        Current_Index := Token_V.First_Index;
        pragma Assert (Token_Vector.Element (Tokens.Last).T_Type = EOF);

        if Tokens (Current_Index).T_Type = EOF then
            raise Constraint_Error with "No Expression given";
        end if;

        Sum := Parse_Expression;

        return Sum;
    end Interpret;
end Tokens.Grammars;
