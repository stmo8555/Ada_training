package Expression_Variant.Evaluation is

    type Evaluater is private;

    function Evaluate
       (Self : in out Evaluater; Node : Expression) return Long_Float;
private
    procedure Visit_Node (Self : in out Evaluater; Node : Expression);
    procedure Binary (Self : in out Evaluater; Node : Expression);
    procedure Unary (Self : in out Evaluater; Node : Expression);
    procedure Grouping (Self : in out Evaluater; Node : Expression);
    procedure Literal (Self : in out Evaluater; Node : Expression);

    type Evaluater is record
        Sum : Long_Float := 0.0;
    end record;
end Expression_Variant.Evaluation;
