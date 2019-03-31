with Ada.Text_IO;
with TaskItem;

use TaskItem;
use Ada.Text_IO;

procedure Main is
   t: myTask;
   i: Integer;
begin
   t := newTask;
   i := solveTask(t);
   Put_Line(Integer'Image(i));
end Main;
