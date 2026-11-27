Package body Expression_Variant.Evaluation is

    function Evaluate
       (Self : in out Evaluater; Node : Expression) return Long_Float is
    begin
        Visit_Node (Self, Node);
        return Self.Sum;
    end Evaluate;

    procedure Visit_Node (Self : in out Evaluater; Node : Expression) is
    begin
        case Node.Kind is
            when Number_Node   =>
                Literal (Self, Node);

            when Binary_Node   =>
                Binary (Self, Node);

            when Unary_Node    =>
                Unary (Self, Node);

            when Grouping_Node =>
                Grouping (Self, Node);
        end case;
    end Visit_Node;

    procedure Binary (Self : in out Evaluater; Node : Expression) is
        Left, Right : Long_Float;
    begin
        Visit_Node (Self, Node.Left.all);
        Left := Self.Sum;
        Visit_Node (Self, Node.Right.all);
        Right := Self.Sum;
        case Node.Operator is
            when Add      =>
                Self.Sum := Left + Right;

            when Subtract =>
                Self.Sum := Left - Right;

            when Multiply =>
                Self.Sum := Left * Right;

            when Divide   =>
                if Right = 0.0 then
                    raise Constraint_Error with "Divide by 0 is not allowed";
                end if;
                Self.Sum := Left / Right;
        end case;
    end Binary;

    procedure Unary (Self : in out Evaluater; Node : Expression) is
    begin
        Visit_Node (Self, Node.Operand.all);
        Self.Sum := -Self.Sum;
    end Unary;

    procedure Grouping (Self : in out Evaluater; Node : Expression) is
    begin
        Visit_Node (Self, Node.Expr.all);
    end Grouping;

    procedure Literal (Self : in out Evaluater; Node : Expression) is
    begin
        Self.Sum := Node.Value;
    end Literal;
end Expression_Variant.Evaluation;
