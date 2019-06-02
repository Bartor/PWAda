with RandGen;
with TaskItem;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;
with Ada.Containers.Synchronized_Queue_Interfaces;
with Ada.Containers.Vectors;
with Config;

use RandGen;
use Ada.Text_IO;

package body Tasking is
      
   r: array (0..Config.repairMan) of Repairman;
   m: array (0..Config.machines) of Machine;
   w: array (0..Config.workers) of Worker;
   
   ce: Ceo;
   
   c: array (0..Config.clients) of Client;
   
   input: String(1..128);
   last: Natural;
   
   task body Machine is
      myId: Integer;
      v: Boolean;
      t: Duration;
      currentTask: myTask;
      b: Boolean;
   begin
      accept Id (id : in Integer) do
         myId := id;
      end Id;
      
      b := False;
      
      v := Config.verbose;
      t := Config.machineDelay;
      
      loop
         select
            accept backdoor  do
               b := False;
            end backdoor;
         else
            null;
         end select;
         
         accept newTask (newTask : in myTask) do
            currentTask := newTask;
         end newTask;
         
         if b then
            currentTask.Brk := True;
         else
            currentTask.Brk := False;
            currentTask := TaskItem.solveTask(currentTask);
         end if;
         
         select
            w(currentTask.Author).Notify(currentTask);
            if v then
               Put_Line("[MCH " & Integer'Image(myId) & "] solved " & TaskItem.printTask(currentTask));
            end if;
         or
            delay 0.001;
         end select;

         if not b and RandGen.get_random(100) < Config.breakingProbability then
            b := True;
         end if;
         
         
         delay t;
         
      end loop;
   end Machine;

   task body ItemQueue is
      package ItemList is new Ada.Containers.Vectors(Natural, myItem);
      il: ItemList.Vector;
      s: Integer;
      
   begin
      
      s := Config.itemSize;
      
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
            accept state do
               Put_Line("Items:");
               for i in il.Iterate loop
                  Put_Line(TaskItem.printItem(il.Reference(i)));
               end loop;
               
            end state;
         end select;
      end loop;
      
   end ItemQueue;
   
   task body TaskQueue is
      package TaskList is new Ada.Containers.Vectors(Natural, myTask);
      tl: TaskList.Vector;
      s: Integer;
   begin
      
      s := Config.taskSize;
      
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
            accept state do
               Put_Line("Tasks:");
               for i in tl.Iterate loop
                  Put_Line(TaskItem.printTask(tl.Reference(i)));
               end loop;            
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
      v := Config.verbose;
      hiD := Config.ceoDelayHi;
      loD := Config.ceoDelayLo;      
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
      currentItem: myItem;
      currentMachine: Integer;
      tasks: Integer;
      patient: Boolean;
      done: Boolean;
   begin
      patient := RandGen.get_random(2) = 0;
      tasks := 0;
      
      v := Config.verbose;
      t := Config.workerDelay;
         
      accept Id (id : in Integer) do
         myId := id;
      end Id;
      
      loop
         select
            accept Status do
               Put_Line(Integer'Image(tasks) & " " & Boolean'Image(patient));
            end Status;
         else
            null;
         end select;
                  
         TaskQueue.getTask(currentTask);
         currentTask.Author := myId;
         
         if patient then
            currentMachine := myId mod Config.machines;
            m(currentMachine).newTask(currentTask);
            accept Notify (n : in myTask) do
               currentTask := n;
            end Notify;
         else
            done := False;
            currentMachine := myId mod Config.machines;
            while not done loop
               currentMachine := (currentMachine + 1) mod Config.machines;
               m(currentMachine).newTask(currentTask);
               select
                  accept Notify (n : in myTask) do
                     currentTask := n;
                     done := True;
                  end Notify;
               or
                  delay Config.workerWait;
               end select;
            end loop;
         end if;
         
         if currentTask.Brk then
            if v then
               Put_Line("[WOR " & Integer'Image(myId) & "] found broken machine " & Integer'Image(currentMachine));
            end if;
            Service.brokenMachine(currentMachine);
         else
            tasks := tasks + 1;
            
            currentItem := (Value => currentTask.Res);
         
            ItemQueue.newItem(currentItem);
            if v then
               Put_Line("[WOR " & Integer'Image(myId) & "] solved and got " & TaskItem.printItem(currentItem));
            end if;
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
      
      v := Config.verbose;
      t := Config.clientDelay;
      
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
   
   task body Service is
      package machineQueue is new Ada.Containers.Vectors(Natural, Integer);
      queue: machineQueue.Vector;
      
      v: Boolean;
      mach: Integer;
      
      flag: Boolean;
      takenMen: array (0..Config.repairMan) of Boolean;
      brokenMachines: array (0..Config.machines) of Boolean;
   begin
      v := Config.verbose;
      
      loop
         select
            when True => accept fixedMachine (job : in Service_Job) do
               brokenMachines(job.machine) := False;
               if Integer(queue.Length) > 0 then
                  mach := queue(0);
                  queue.Delete_First;
                  r(job.repairman).repair(mach);
               else
                  takenMen(job.repairman) := False;
               end if;
            end fixedMachine;
         or
            when True => accept brokenMachine (machine : in Integer) do
               if not brokenMachines(machine) then
                  brokenMachines(machine) := True;
                  flag := False;
                  for I in takenMen'Range loop
                     if not takenMen(I) then
                        takenMen(I) := True;
                        flag := True;
                        r(I).repair(machine);
                     end if;
                  end loop;
                  if not flag then
                     queue.Append(machine);
                  end if;
               end if;
            end brokenMachine;
         end select;
      end loop;
   end Service;
   
   task body Repairman is
      v: Boolean;
      t: Duration;
      
      myId: Integer;
      job: Service_Job;
   begin
      v := Config.verbose;
      t := Config.repairTime;
      
      accept Id (id : in Integer) do
         myId := id;
      end Id;
      
      loop
         accept repair (machine : in Integer) do
            delay t;
            m(machine).backdoor;
            if v then
               Put_Line("[SER " & Integer'Image(myId) & "] fixes " & Integer'Image(machine));
            end if;
            job := (machine, myId);
            Service.fixedMachine(job);
         end repair;
      end loop;
   end Repairman;
   
   
   
begin
   for i in w'Range loop
      w(i).Id(i);
   end loop;
   
   for i in m'Range loop
      m(i).Id(i);
   end loop;
   
   for i in c'Range loop
      c(i).Id(i);
   end loop;
   
   for i in r'Range loop
      r(i).Id(i);
   end loop;
   
   
   if not Config.verbose then
      loop
         Get_Line(input, last);

         case input(1) is
            when 's' =>
               for i in w'Range loop
                  w(i).Status;
               end loop;
            when 't' =>
               TaskQueue.state;
            when 'i' =>
               ItemQueue.state;
            when 'h' =>
               Put_Line("i - item list");
               Put_Line("t - task list");
               Put_Line("s - task list");
            when others =>
               Put_Line("type h for help");
         end case;
      end loop;
   end if;

end tasking;
