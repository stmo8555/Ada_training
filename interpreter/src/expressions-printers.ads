with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Expressions.Printers is

    type Printer is new Expression_Visitor with private;

    function Print
       (Self : in out Printer; Expr : Expression'Class) return String;

private
    overriding
    procedure Visit_Expression
       (Self : in out Printer; Node : Expression'Class);
    overriding
    procedure Visit_Binary (Self : in out Printer; Node : Binary'Class);
    overriding
    procedure Visit_Unary (Self : in out Printer; Node : Unary'Class);
    overriding
    procedure Visit_Grouping (Self : in out Printer; Node : Grouping'Class);
    overriding
    procedure Visit_Literal (Self : in out Printer; Node : Literal'Class);

    type Printer is new Expression_Visitor with record
        Buffer : Ada.Strings.Unbounded.Unbounded_String;
    end record;
end Expressions.Printers;
