generic
    type T is private;
package Nodes is
    type Node;
    type Node_Access is access all Node;
    type Node is record
        Val  : T;
        Next : Node_Access;
    end record;
end Nodes;
