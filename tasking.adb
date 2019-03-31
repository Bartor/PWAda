with TaskItem;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;

use Ada.Text_IO;
with Ada.Containers.Vectors;

package body Tasking is

   task body ItemQueue is
      package ItemList is new Ada.Containers.Vectors(Natural, myItem);
      il: ItemList.Vector;
      s: Integer;
      
   begin
      
      accept size (size : in Integer) do
         s := size;
      end size;
      
      loop
         select
            when Integer(il.Length) < s => 
               accept newItem (newItem : in myItem) do
                  il.Append(newItem);
               end newItem;
               
         or
            when Integer(il.Length) > 0 =>
               accept getItem (newItem : out myItem) do
                  newItem := il.First_Element;
               end getItem;
               il.Delete_First;
         or
            accept state (state : in Boolean) do
               Put_Line("Items n: " & Integer'Image(Integer(il.Length)));
            end state;
         end select;
      end loop;
      
   end ItemQueue;
   
   task body TaskQueue is
      package TaskList is new Ada.Containers.Vectors(Natural, myTask);
      tl: TaskList.Vector;
      s: Integer;
   begin
      accept size (size : in Integer) do
         s := size;
      end size;
      loop
         select
            when Integer(tl.Length) < s =>
               accept newTask (newTask : in myTask) do
                  tl.Append(newTask);
               end newTask;
         or
            when Integer(tl.Length) > 0 =>
               accept getTask (newTask : out myTask) do
                  newTask := tl.First_Element;
               end getTask;
               tl.Delete_First;
               
         or
            accept state (state : in Boolean) do
               Put_Line("Tasks n: " & Integer'Image(Integer(tl.Length)));
            end state;
         end select;
      end loop;
   end TaskQueue;
   
   task body Ceo is
      newTask: myTask;
      v: Boolean;
      hiD: Float;
      loD: Float;
      gen: Ada.Numerics.Float_Random.Generator;
      rnd: Float;
   begin
      accept Verbose (verbose : in Boolean) do
         v := verbose;
      end Verbose;
      
      accept Hi (delayHi : in Float) do
         hiD := delayHi;
      end Hi;
      
      accept Lo (delayLo : in Float) do
         loD := delayLo;
      end Lo;
      
      loop
         Ada.Numerics.Float_Random.Reset(gen);
         
         newTask := TaskItem.newTask;
         TaskQueue.newTask(newTask);
         
         if v then
            Put_Line("[CEO] " & TaskItem.printTask(newTask));
         end if;
         
         rnd := Ada.Numerics.Float_Random.Random(gen)*hiD + loD;
         
         delay Duration(rnd);
         
      end loop;
      
   end Ceo;
   
   task body Worker is
      myId: Integer;
      v: Boolean;
      t: Duration;
      currentTask: myTask;
      value: Integer;
      currentItem: myItem;
   begin
      accept Verbose (verbose : in Boolean) do
         v := verbose;
      end Verbose;
      
      accept Timeout (timeout : in Duration) do
         t := timeout;
      end Timeout;
         
      accept Id (id : in Integer) do
         myId := id;
      end Id;
      
      loop
         TaskQueue.getTask(currentTask);
         value := TaskItem.solveTask(currentTask);
         currentItem := (Value => value);
         
         ItemQueue.newItem(currentItem);
         
         if v then
            Put_Line("[WOR " & Integer'Image(myId) & "] solved and got " & TaskItem.printItem(currentItem));
         end if;
         delay t;
      end loop;
      
   end Worker;
   
   task body Client is
      myId: Integer;
      v: Boolean;
      t: Duration;
      currentItem: myItem;
   begin
      accept Verbose (verbose : in Boolean) do
         v := verbose;
      end Verbose;
      
      accept Timeout (timeout : in Duration) do
         t := timeout;
      end Timeout;
      
      accept Id (id : in Integer) do
         myId := id;
      end Id;
      
      loop
         ItemQueue.getItem(currentItem);
         
         if v then
            Put_Line("[CLI " & Integer'Image(myId) & "] bought " & TaskItem.printItem(currentItem));
         end if;
         delay t;
         
      end loop;
   end Client;
   

end tasking;
