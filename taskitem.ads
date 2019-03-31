package TaskItem is
   
   type OperationAccess is access function(A, B: Integer) return Integer;

   type myItem is
      record
         Value: Integer;
      end record;
      
   
   type myTask is
      record
         Fst: Integer;
         Snd: Integer;
         Opr: OperationAccess;
      end record;
   
   function solveTask(This: myTask) return Integer;
   
   function newTask return myTask;
   
   function printTask(This: myTask);
   function printItem(This: myItem);
   
private
   function add(A, B: Integer) return Integer;
   function sub(A, B: Integer) return Integer;
   function mul(A, B: Integer) return Integer;

end TaskItem;
