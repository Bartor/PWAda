package Config is

   verbose: constant Boolean := True;
   workers: constant Integer := 5;
   clients: constant Integer := 5;
   
   itemSize: constant Integer := 10;
   taskSize: constant Integer := 10;
   
   workerDelay: constant Duration := Duration(10);
   clientDelay: constant Duration := Duration(2);
   ceoDelay: constant Duration := Duration(1);

end Config;
