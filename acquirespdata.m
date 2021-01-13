function [] = acquirespdata(par,exp,handles)
% Esta funcion se encarga de todo lo relacionado con la DAQ (adquisicion de
% datos sin presentacion de estimulos).
% INPUTS:
% OUTPUTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setea los parametros de las mediciones                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_start=clock;
% pone cantidad de estimulos totales a presentar.
daqreset % Importante resetear la daq antes de arrancar.
     ai = analoginput('nidaq','Dev2');    % Inicializo el dispositivo
                                          % !NOTA: El address 'Dev2' puede 
                                          % cambiar de maquina a maquina
     Duration          = par.tiempo_file;        
     SampleRate        = 20000;        % en samples/sec (S/s)
     SamplesPerTrigger = Duration * SampleRate; % numero de samples/trigger

     addchannel(ai, 0);           
  set(ai, 'SampleRate', SampleRate); 
  set(ai, 'SamplesPerTrigger', SamplesPerTrigger);
  ai.TriggerType = 'Immediate'; % asegura que el input empiece 
                                % cuando se manda el comando START
  %ai;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arranca la placa                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(ai)  
  
  [data, time] = getdata(ai);
  wait([ai],par.tiempo_file+1) % espera a que termine
  stop(ai)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  channel0 = data(:,1);
  delete(ai);
  clear ai;
  figure(2)
  plot(time,data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Escribo el archivo                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cuando=fix(clock);
 fecha=[num2str(cuando(4)),'.',num2str(cuando(5)),'.',num2str(cuando(6))];     
  fecha2=[num2str(cuando(3)),'.',num2str(cuando(2)),'.',num2str(cuando(1))];  
  nombrecarpeta=[fecha2,'-','actividad'];
  nombrearchiv=[fecha,'-',num2str(par.repeticion),'.dat'];
  carpeta_actividad=[par.base_folder '\' nombrecarpeta];
  if (length(dir(carpeta_actividad))==0)
  mkdir(par.base_folder,nombrecarpeta);
  end
  
 cd(nombrecarpeta)
     file=fopen(nombrearchiv,'w');
     for i=1:SamplesPerTrigger
     fprintf(file,'%d\n',data(i));
     end
     fclose(file)
 cd(par.base_folder)
end
