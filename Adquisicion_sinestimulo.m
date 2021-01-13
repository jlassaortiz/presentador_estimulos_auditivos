%uso este para ver los valores de umbral y pa calibrar el trigger
carpeta_base='C:\Users\usuario\Desktop\Santi.2014\Experimentos';
repet=1;
rep=int2str(repet);
ch=0; %canal que se quiere monitorear
duration = 16; %tiempo que se quiere monitorear
daqreset;
AI = analoginput('nidaq','Dev2');
chan = addchannel(AI,0);
set(AI,'SampleRate',20000);
ActualRate = get(AI,'SampleRate');
set(AI,'SamplesPerTrigger',floor(duration*ActualRate))
set(AI,'TriggerType','Manual')
blocksize = get(AI,'SamplesPerTrigger');
Fs = ActualRate;
SamplesPerTrigger = duration * ActualRate;
start(AI)
trigger(AI)
wait(AI,duration + 1)
[data time] = getdata(AI);
delete(AI)
clear AI
plot(time,data);
%-------------------------------------------------------------------------
% Escribo el archivo
%-------------------------------------------------------------------------
cuando=fix(clock);
  fecha=[num2str(cuando(4)),'.',num2str(cuando(5)),'.',num2str(cuando(6))];     
  fecha2=[num2str(cuando(3)),'.',num2str(cuando(2)),'.',num2str(cuando(1))];  
  nombrecarpeta=[fecha2,'-','actividad']
  nombrearchiv=[fecha,'-',rep,'.dat']
  carpeta_actividad=[carpeta_base '\' nombrecarpeta];
  if (length(dir(carpeta_actividad))==0)
  mkdir(carpeta_base,nombrecarpeta);
  end
  
  cd(nombrecarpeta)
     file=fopen(nombrearchiv,'w');
     for i=1:SamplesPerTrigger
     fprintf(file,'%d\n',data(i));
     end
     fclose(file)
 cd(carpeta_base)