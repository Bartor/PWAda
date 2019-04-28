with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;

package body TaskItem is

   function solveTask(This: myTask'Access) is
   begin
      This.Res := This.Opr(This.Fst, This.Snd);
   end solveTask;
   
   function newTask return myTask is
      subtype OprRange is Integer range 0..2;
      subtype ValRange is Integer range 0..1000;
      
      package RandomOpr is new Ada.Numerics.Discrete_Random(OprRange);
      package RandomVal is new Ada.Numerics.Discrete_Random(ValRange);
      
      OprGenerator: RandomOpr.Generator;
      ValGenerator: RandomVal.Generator;
            
      Fst: Integer;
      Snd: Integer;
      Opr: Integer;
      
      OprAccess: OperationAccess;
      
      newTask: myTask;
   begin   
      RandomVal.Reset(ValGenerator);
      RandomOpr.Reset(OprGenerator);
      
      Fst := RandomVal.Random(ValGenerator);
      Snd := RandomVal.Random(ValGenerator);
      
      Opr := RandomOpr.Random(OprGenerator);
            
           
      case Opr is    
         when 0 => OprAccess := add'Access;
         when 1 => OprAccess := sub'Access;
         when 2 => OprAccess := mul'Access;
         when others => OprAccess := add'Access;    
      end case;
      
      newTask := (Fst, Snd, OprAccess, 0, -1);
      
      return newTask;
            
   end newTask;
   
   function printItem(This: myItem) return String is
   begin
      return "Item {" & Integer'Image(This.Value) & " }";
   end printItem;
   
   function printTask(This: myTask) return String is
   begin
      return "Task {" & Integer'Image(This.Fst) & "," & Integer'Image(This.Snd) & " }";
   end printTask;
   
   function add(A, B: Integer) return Integer is
   begin
      return A + B;
   end add;
   
   function sub(A, B: Integer) return Integer is
   begin
      return A - B;
   end sub;
   
   function mul(A, B: Integer) return Integer is
   begin
      return A * B;
   end mul;
   
end TaskItem;
