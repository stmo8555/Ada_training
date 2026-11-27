package body Expressions.Printers is
    procedure Parenthesize
       (Self : in out Printer; Name : String; Exprs : Expression_List) is
    begin
        Append (Self.Buffer, "(" & Name);
        for E of Exprs loop
            Append (Self.Buffer, " ");
            E.Accept_Visitor (Self);
        end loop;
        Append (Self.Buffer, ")");
    end Parenthesize;

    function Print
       (Self : in out Printer; Expr : Expression'Class) return String is
    begin
        Self.Buffer := null_unbounded_string;
        Self.Visit_Expression (expr);
        return To_String (Self.Buffer);
    end Print;

    overriding
    procedure Visit_Expression (Self : in out Printer; Node : Expression'Class)
    is
    begin
        Node.Accept_Visitor (Visitor => Self);
    end Visit_Expression;

    overriding
    procedure Visit_Binary (Self : in out Printer; Node : Binary'Class) is
    begin
        Parenthesize
           (Self, To_String (Node.Op.Lexeme), [Node.Left, Node.Right]);
    end Visit_Binary;

    overriding
    procedure Visit_Unary (Self : in out Printer; Node : Unary'Class) is
    begin
        Parenthesize (Self, To_String (Node.Op.Lexeme), [Node.Right]);
    end Visit_Unary;

    overriding
    procedure Visit_Grouping (Self : in out Printer; Node : Grouping'Class) is
    begin
        Parenthesize (Self, "Group", [Node.Expr]);
    end Visit_Grouping;

    overriding
    procedure Visit_Literal (Self : in out Printer; Node : Literal'Class) is
    begin
        Append (Self.Buffer, Node.Op.Lexeme);
    end Visit_Literal;
end Expressions.Printers;
