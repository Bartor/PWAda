with TaskItem;
use TaskItem;

package Tasking is

   task type Machine is
      entry Id (id: in Integer);
      entry newTask (newTask: in myTask);
   end Machine;
   
   task type Ceo is
   end Ceo;
   
   task type Worker is
      entry Notify (n: in myTask);
      entry Id (id: in Integer);
      entry Status;
   end Worker;
   
   task type Client is
      entry Id (id: in Integer);
   end Client;
   
   task TaskQueue is
      entry newTask (newTask: in myTask);
      entry getTask (newTask: out myTask);
      entry state;
   end TaskQueue;
   
   task ItemQueue is
      entry newItem (newItem: in myItem);
      entry getItem (newItem: out myItem);
      entry state;   
   end ItemQueue;
   
end tasking;
