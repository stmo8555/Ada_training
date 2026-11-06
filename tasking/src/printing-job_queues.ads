with Ada.Containers; use Ada.Containers;
with Ada.Containers.Doubly_Linked_Lists;

package Printing.Job_Queues is

    Jobs_Done_Exception : Exception;

    package Job_Lists is new
       Ada.Containers.Doubly_Linked_Lists (Element_Type => Job);
    use Job_Lists;

    type Priority_Lists is array (Priority_Level) of List;

    protected Queue is
        entry Get (V : out Maybe_Job);
        procedure Close;
        procedure Put (V : Job);
    private
        Jobs : Priority_Lists;
        Done : Boolean := false;

        function Is_Empty return Boolean;
    end Queue;
end Printing.Job_Queues;
