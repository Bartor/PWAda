package Config is

   verbose: constant Boolean := True;
   workers: constant Integer := 5;
   clients: constant Integer := 5;
   machines: constant Integer := 3;
   
   itemSize: constant Integer := 10;
   taskSize: constant Integer := 10;
   
   machineDelay: constant Duration := Duration(5);
   workerDelay: constant Duration := Duration(10);
   clientDelay: constant Duration := Duration(2);
   ceoDelayHi: constant Float := 1.0;
   ceoDelayLo: constant Float := 0.1;

end Config;
