-- Okay that package is leaking
with Tokens; use Tokens;

package Expressions is
    type Expression is interface;
    type Binary is tagged;
    type Unary is tagged;
    type Grouping is tagged;
    type Literal is tagged;

    type Expression_Visitor is interface;

    procedure Visit_Expression
       (Self : in out Expression_Visitor; Node : Expression'Class)
    is abstract;
    procedure Visit_Binary
       (Self : in out Expression_Visitor; Node : Binary'Class)
    is abstract;
    procedure Visit_Unary
       (Self : in out Expression_Visitor; Node : Unary'Class)
    is abstract;
    procedure Visit_Grouping
       (Self : in out Expression_Visitor; Node : Grouping'Class)
    is abstract;
    procedure Visit_Literal
       (Self : in out Expression_Visitor; Node : Literal'Class)
    is abstract;

    procedure Accept_Visitor
       (Self : Expression; Visitor : in out Expression_Visitor'Class)
    is abstract;

    type Expression_Access is access Expression'Class; -- dispatching

    subtype Child_Ref is not null Expression_Access;
    type Expression_List is array (Positive range <>) of Child_Ref;

    type Binary is new Expression with record
        Left  : Child_Ref;
        Right : Child_Ref;
        Op    : Token;
    end record;
    type Unary is new Expression with record
        Right : Child_Ref;
        Op    : Token;
    end record;
    type Grouping is new Expression with record
        Expr : Child_Ref;
    end record;
    type Literal is new Expression with record
        Op : Token;
    end record;

    function Make_Binary (Left, Right : Child_Ref; Op : Token) return Binary
    is (Expression with Left => Left, Right => Right, Op => Op);

    function Make_Unary (Right : Child_Ref; Op : Token) return Unary
    is (Expression with Right => Right, Op => Op);

    function Make_Grouping (Expr : Child_Ref) return Grouping
    is (Expression with Expr => Expr);

    function Make_Literal (Op : Token) return Literal
    is (Expression with Op => Op)
    with Pre => OP.T_Type in NUMBER | IDENTIFIER;

    overriding
    procedure Accept_Visitor
       (Self : Binary; Visitor : in out Expression_Visitor'Class);

    overriding
    procedure Accept_Visitor
       (Self : Unary; Visitor : in out Expression_Visitor'Class);

    overriding
    procedure Accept_Visitor
       (Self : Grouping; Visitor : in out Expression_Visitor'Class);

    overriding
    procedure Accept_Visitor
       (Self : Literal; Visitor : in out Expression_Visitor'Class);
end Expressions;
