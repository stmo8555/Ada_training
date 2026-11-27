with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Text_IO;             use Ada.Text_IO;

package body Tokens.Scanners is
    function Scan (S : in out Scanner) return Token_Vector.Vector is
    begin
        loop
            exit when S.Is_At_End;
            S.Scan_Token;
            S.Start := S.Current;
        end loop;

        S.Tokens.Append
           (Token'
               (EOF, Null_Unbounded_String, No_Literal, S.Line,
                Position => S.Current));
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

    function Scanned_Text (S : Scanner) return String is
        Last_Consumed : constant Natural := S.Current - 1;
    begin
        return S.Source (S.Start .. Last_Consumed);
    end Scanned_Text;

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
                loop
                    exit when not Is_Basic (S.Peek);
                    S.Advance;
                end loop;
                declare
                    Text : constant String := Scanned_Text (S);
                begin
                    if Text = "let" then
                        S.Add_Token (LET, Text_Literal (Scanned_Text (S)));
                    else
                        S.Add_Token
                           (IDENTIFIER, Text_Literal (Scanned_Text (S)));
                    end if;
                end;

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
                    Number_Literal (Long_Float'Value (Scanned_Text (S))));

            when ASCII.LF | ASCII.HT | ' ' =>
                null;

            when others                    =>
                S.Has_Error := True;
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
                        Put_line
                           (Standard_Error,
                            """"
                            & Letter
                            & """ is not supported here"
                            & ASCII.LF
                            & S.Source (Context_Range)
                            & ASCII.LF
                             & Error_Marker
                             & " at line"
                             & S.Line'Image
                             & ", character"
                             & Error_At'Image);
                    end;
                end;
        end case;
    end Scan_Token;

    procedure Add_Token
       (S : in out Scanner; T_Type : Token_Type; Literal : Literal_Value)
    is
        Lexeme : constant Unbounded_String :=
           To_Unbounded_String (Scanned_Text (S));
    begin
        S.Tokens.Append
           (Token'(T_Type, Lexeme, Literal, S.Line, Position => S.Start));
    end Add_Token;
end Tokens.Scanners;
