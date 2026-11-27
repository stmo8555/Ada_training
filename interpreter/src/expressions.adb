package body Expressions is
    overriding
    procedure Accept_Visitor
       (Self : Binary; Visitor : in out Expression_Visitor'Class) is
    begin
        Visitor.Visit_Binary (Self);
    end;
    overriding
    procedure Accept_Visitor
       (Self : Unary; Visitor : in out Expression_Visitor'Class) is
    begin
        Visitor.Visit_Unary (Self);
    end;
    overriding
    procedure Accept_Visitor
       (Self : Grouping; Visitor : in out Expression_Visitor'Class) is
    begin
        Visitor.Visit_Grouping (Self);
    end;
    overriding
    procedure Accept_Visitor
       (Self : Literal; Visitor : in out Expression_Visitor'Class) is
    begin
        Visitor.Visit_Literal (Self);
    end;
end Expressions;
