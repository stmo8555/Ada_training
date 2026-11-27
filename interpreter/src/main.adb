with Ada.Text_IO; use Ada.Text_IO;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Exceptions;        use Ada.Exceptions;
with Ada.Long_Float_Text_IO;
with Tokens.Scanners;       use Tokens.Scanners;
--  with Tokens.Grammars; use Tokens.Grammars;
with Tokens;                use Tokens;
with Expressions;           use Expressions;
with Expressions.Printers;  use Expressions.Printers;
with Parsers;               use Parsers;
with Evaluaters;            use Evaluaters;
with Expression_Variant.Evaluation;

procedure Main is
begin
    loop
        Put ("> ");
        Flush;
        exit when End_Of_File;

        declare
            Line : constant String := Get_Line;
        begin
            exit when Line = "quit";

            if Line'Length > 0 then
                declare
                    S            : Scanner := Create_Scanner (Line);
                    Found_Tokens : Token_Vector.Vector;
                    Expr         : Expression_Access;
                    ExprV        : Expression_Variant.Expression_Access;
                    P            : Printer;
                    E            : Evaluater;
                    Ev           : Expression_Variant.Evaluation.Evaluater;
                begin
                    Found_Tokens := S.Scan;
                    Expr := Parse (Found_Tokens);
                    ExprV := Expression_Variant.Parse (Found_Tokens);

                    if not S.Has_Error then
                        --  Ada.Long_Float_Text_IO.Put
                        --     (Interpret (Found_Tokens),
                        --      Fore => 0,
                        --      Aft  => 2,
                        --      Exp  => 0);
                        --  New_Line;
                        Ada.Long_Float_Text_IO.Put
                           (E.Evaluate (Expr.all),
                            Fore => 0,
                            Aft  => 2,
                            Exp  => 0);
                        New_Line;
                        Ada.Long_Float_Text_IO.Put
                           (Expression_Variant.Evaluation.Evaluate
                               (Ev, Exprv.all),
                            Fore => 0,
                            Aft  => 2,
                            Exp  => 0);
                        New_Line;
                    end if;
                    --  for E of S.Scan loop
                    --      Put_Line (E'Image);
                    --  end loop;
                end;
            end if;
        exception
            when E : Interpreter_Error =>
                Put_Line (Standard_Error, "Error: " & Exception_Message (E));
        end;
    end loop;
end Main;
