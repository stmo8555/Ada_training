with Expressions; use Expressions;

package Evaluaters is

    type Evaluater is new Expression_Visitor with private;

    function Evaluate
       (Self : in out Evaluater; Expr : Expression'Class) return Long_Float;

private
    overriding
    procedure Visit_Expression
       (Self : in out Evaluater; Node : Expression'Class);
    overriding
    procedure Visit_Binary (Self : in out Evaluater; Node : Binary'Class);
    overriding
    procedure Visit_Unary (Self : in out Evaluater; Node : Unary'Class);
    overriding
    procedure Visit_Grouping (Self : in out Evaluater; Node : Grouping'Class);
    overriding
    procedure Visit_Literal (Self : in out Evaluater; Node : Literal'Class);

    type Evaluater is new Expression_Visitor with record
        Sum : Long_Float := 0.0;
    end record;
end Evaluaters;
