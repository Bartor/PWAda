package Config is

   verbose: constant Boolean := True;
   workers: constant Integer := 5;
   clients: constant Integer := 5;
   machines: constant Integer := 10;
   
   itemSize: constant Integer := 10;
   taskSize: constant Integer := 10;
   
   machineDelay: constant Duration := Duration(5);
   workerDelay: constant Duration := Duration(1);
   workerWait: constant Duration := Duration(3);
   clientDelay: constant Duration := Duration(2);
   ceoDelayHi: constant Float := 1.0;
   ceoDelayLo: constant Float := 0.1;
   
   breakingProbability: constant Integer := 5;
   repairMan: constant Integer := 2;
   
   repairTime: constant Duration := Duration(2);

end Config;
