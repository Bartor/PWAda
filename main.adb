with Ada.Containers.Vectors;
with Ada.Text_IO;
with TaskItem;
with Tasking;
with Config;

use Tasking;
use TaskItem;
use Ada.Text_IO;

procedure Main is
   ce: Ceo;
   w: array (0..Config.workers) of Worker;
   c: array (0..Config.clients) of Client;
   input: String(1..128);
   last: Natural;
begin
   TaskQueue.size(Config.taskSize);
   ItemQueue.size(Config.itemSize);

   ce.Verbose(Config.verbose);
   ce.Timeout(Config.ceoDelay);

   for i in w'Range loop
      w(i).Verbose(Config.verbose);
      w(i).Timeout(Config.workerDelay);
      w(i).Id(i);
   end loop;

   for i in c'Range loop
      c(i).Verbose(Config.verbose);
      c(i).Timeout(Config.clientDelay);
      c(i).Id(i);
   end loop;

   if not Config.verbose then
      loop
         Get_Line(input, last);

         case input(1) is
            when 't' =>
               TaskQueue.state(True);
            when 'i' =>
               ItemQueue.state(True);
            when 'h' =>
               Put_Line("i - item list");
               Put_Line("t - task list");
            when others =>
               Put_Line("type h for help");
         end case;
      end loop;
   end if;
end Main;
