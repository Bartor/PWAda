with TaskItem;
use TaskItem;

package Tasking is
   type Service_Job is
      record
         machine: Integer;
         repairman: Integer;
      end record;
   
   task type Machine is
      entry Id (id: in Integer);
      entry newTask (newTask: in myTask);
      entry backdoor;
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
   
   task Service is
      entry brokenMachine (machine: in Integer);
      entry fixedMachine (job: in Service_Job);
   end Service;
   
   task type Repairman is
      entry Id (id: in Integer);
      entry repair (machine: in Integer);
   end Repairman;
   
   
end tasking;
