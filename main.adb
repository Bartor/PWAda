with Ada.Containers.Vectors;
with Ada.Text_IO;
with TaskItem;
with Tasking;

use Tasking;
use TaskItem;
use Ada.Text_IO;

procedure Main is
   ce: Ceo;
   w: array (0..10) of Worker;
   c: array (0..10) of Client;
   size: Integer := 10;
   dur: Duration := Duration(1);
begin
   TaskQueue.size(size);
   ItemQueue.size(size);

   ce.Verbose(True);
   ce.Timeout(dur);

   for i in w'Range loop
      w(i).Verbose(True);
      w(i).Timeout(dur);
      w(i).Id(i);
   end loop;

   for i in c'Range loop
      c(i).Verbose(True);
      c(i).Timeout(dur);
      c(i).Id(i);
   end loop;

end Main;
