with Ada.Characters.Handling; use Ada.Characters.Handling;

package body Tokens.Scanners is
    function Scan (S : in out Scanner) return Token_Vector.Vector is
    begin
        loop
            exit when S.Is_At_End;
            S.Scan_Token;
            S.Start := S.Current;
        end loop;

        S.Tokens.Append
           (Token'(EOF, Null_Unbounded_String, No_Literal, S.Line));
        return S.Tokens;
    end Scan;

    function Advance (S : in out Scanner) return Character is
    begin
        return Result : constant Character := S.Source (S.Current) do
            S.Current := S.Current + 1;
        end return;
    end Advance;

    procedure Advance (S : in out Scanner) is
        Ignore : Character;
    begin
        Ignore := S.Advance;
    end Advance;

    procedure Scan_Token (S : in out Scanner) is
        Letter : constant Character := S.Advance;
    begin
        case Letter is
            when '+'                       =>
                S.Add_Token (PLUS, No_Literal);

            when '-'                       =>
                S.Add_Token (MINUS, No_Literal);

            when '*'                       =>
                S.Add_Token (MULT, No_Literal);

            when '/'                       =>
                S.Add_Token (DIV, No_Literal);

            when '('                       =>
                S.Add_Token (LEFT_PAREN, No_Literal);

            when ')'                       =>
                S.Add_Token (RIGHT_PAREN, No_Literal);

            when '='                       =>
                S.Add_Token (EQUALS, No_Literal);

            when 'a' .. 'z' | 'A' .. 'Z'   =>
                raise Program_Error
                   with "TODO: identifier scanning not implemented";

            when '0' .. '9'                =>
                loop
                    exit when not Is_Digit (S.Peek);
                    S.Advance;
                end loop;

                if S.Peek = '.' and then Is_Digit (S.Peek_Next) then
                    S.Advance;
                    loop
                        exit when not Is_Digit (S.Peek);
                        S.Advance;
                    end loop;
                end if;

                S.Add_Token
                   (NUMBER,
                    Number_Literal
                       (Long_Float'Value
                           (S.Source (S.Start .. S.Current - 1))));

            when ASCII.LF | ASCII.HT | ' ' =>
                null;

            when others                    =>
                declare
                    End_Position : Positive := S.Current;
                    Error_At     : constant Positive := S.Current - 1;
                begin
                    while End_Position in S.Source'Range
                       and then
                          S.Source (End_Position)
                          not in ASCII.HT | ASCII.LF | ' '
                    loop
                        End_Position := End_Position + 1;
                    end loop;
                    declare
                        subtype Context_Range is
                           Positive range S.Source'First .. End_Position - 1;
                        Error_Marker : String (Context_Range) :=
                           [others => '-'];
                    begin
                        Error_Marker (Error_At) := '^';
                        raise Constraint_Error
                           with
                              """"
                              & Letter
                              & """ is not supported here"
                              & ASCII.LF
                              & S.Source (Context_Range)
                              & ASCII.LF
                              & Error_Marker
                              & " at line"
                              & S.Line'Image;
                    end;
                end;
        end case;
    end Scan_Token;

    procedure Add_Token
       (S : in out Scanner; T_Type : Token_Type; Literal : Literal_Value)
    is
        Lexeme : constant Unbounded_String :=
           To_Unbounded_String (S.Source (S.Start .. S.Current - 1));
    begin
        S.Tokens.Append (Token'(T_Type, Lexeme, Literal, S.Line));
    end Add_Token;
end Tokens.Scanners;
