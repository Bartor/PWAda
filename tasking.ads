with TaskItem;
use TaskItem;

package Tasking is

   task type Machine is
      entry Id (id: in Integer);
      entry newTask (newTask: in myTask);
      entry Verbose(verbose: in Boolean);
      entry Timeout(timeout: in Duration);
   end Machine;
   
   task type Ceo is
      entry Verbose (verbose: in Boolean);
      entry Hi (delayHi: in Float);
      entry Lo (delayLo: in Float);
   end Ceo;
   
   task type Worker is
      entry Verbose (verbose: in Boolean);
      entry Timeout (timeout: in Duration);
      entry Notify (n: in Integer);
      entry Id (id: in Integer);
   end Worker;
   
   task type Client is
      entry Verbose (verbose: in Boolean);
      entry Timeout (timeout: in Duration);
      entry Id (id: in Integer);
   end Client;
   
   task TaskQueue is
      entry size (size: in Integer);
      entry newTask (newTask: in myTask);
      entry getTask (newTask: out myTask);
      entry state (state: in Boolean);
   end TaskQueue;
   
   task ItemQueue is
      entry size (size: in Integer);
      entry newItem (newItem: in myItem);
      entry getItem (newItem: out myItem);
      entry state (state: in Boolean);   
   end ItemQueue;
   
end tasking;
