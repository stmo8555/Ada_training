with Tokens;
with ada.Text_IO; use ada.Text_IO;
use type Tokens.Token_Type;

package body Evaluaters is
    function Evaluate
       (Self : in out Evaluater; Expr : Expression'Class) return Long_Float is
    begin
        Self.Visit_Expression (Expr);
        return Self.Sum;
    end Evaluate;

    overriding
    procedure Visit_Expression
       (Self : in out Evaluater; Node : Expression'Class) is
    begin
        Node.Accept_Visitor (Self);
    end Visit_Expression;

    overriding
    procedure Visit_Binary (Self : in out Evaluater; Node : Binary'Class) is
        Left, Right : Long_Float;
    begin
        Node.Left.Accept_Visitor (Self);
        Left := Self.Sum;
        Node.Right.Accept_Visitor (Self);
        Right := Self.Sum;
        case Node.Op.T_Type is
            when Tokens.PLUS  =>
                Self.Sum := Left + Right;

            when Tokens.MINUS =>
                Self.Sum := Left - Right;

            when Tokens.MULT  =>
                Self.Sum := Left * Right;

            when Tokens.DIV   =>
                if Right = 0.0 then
                    raise Constraint_Error with "Divide by 0 is not allowed";
                end if;
                Self.Sum := Left / Right;

            when others       =>
                raise Constraint_Error
                   with "Binary op can not be " & Node.Op.T_Type'Image;

        end case;
    end Visit_Binary;

    overriding
    procedure Visit_Unary (Self : in out Evaluater; Node : Unary'Class) is
    begin
        Node.Right.Accept_Visitor (Self);
        if Node.Op.T_Type = Tokens.MINUS then
            Self.Sum := -Self.Sum;
        end if;

    end Visit_Unary;

    overriding
    procedure Visit_Grouping (Self : in out Evaluater; Node : Grouping'Class)
    is
    begin
        Node.Expr.Accept_Visitor (Self);
    end Visit_Grouping;

    overriding
    procedure Visit_Literal (Self : in out Evaluater; Node : Literal'Class) is
    begin
        if Node.Op.T_Type /= Tokens.NUMBER then
            raise Constraint_Error
               with "Only number literal is allowed for now";
        end if;

        Self.Sum := Node.Op.Literal.Num;
    end Visit_Literal;
end Evaluaters;
