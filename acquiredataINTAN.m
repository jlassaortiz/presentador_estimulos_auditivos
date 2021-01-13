function [] = acquiredataINTAN(par,exp,handles)
% Esta funcion se encarga de todo lo relacionado con la DAQ (presentacion
% de estimulos y Adquisicion de datos).
% INPUTS:
% OUTPUTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setea los parametros de las mediciones                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_start=clock;
n=1;
set(handles.txt_presden,'String',num2str(length(exp.estimulos)));
% pone cantidad de estimulos totales a presentar.
%daqreset % Importante resetear la daq antes de arrancar.
while(n<length(exp.estimulos)+1) %Da el numero de archivos totales a grabar
    set(handles.txt_presnum,'String',num2str(n)); % actualiza el contador
%     ai = analoginput('nidaq','Dev2');    % Inicializo el dispositivo
                                          % !NOTA: El address 'Dev2' puede 
                                          % cambiar de maquina a maquina
%     Duration          = par.tiempo_file;        
%     SampleRate        = 20000;        % en samples/sec (S/s)
%     SamplesPerTrigger = Duration * SampleRate; % numero de samples/trigger

%     addchannel(ai, 0);           
%  set(ai, 'SampleRate', SampleRate); 
%  set(ai, 'SamplesPerTrigger', SamplesPerTrigger);
%  ai.TriggerType = 'Immediate'; % asegura que el input empiece 
                                % cuando se manda el comando START
%  ai.ExternalTriggerDriveLine = 'RTSI0'; % AI inicializa con RTSI0
  %ai;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setea el output                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nombre_estimulo=exp.lista(exp.estimulos(n)).name; % Lee el archivo 
                                                  % que corresponda                                                  
set(handles.txt_stimulus,'string',nombre_estimulo);
cd(par.stimulus_folder);
[output_signal,fs]=audioread(nombre_estimulo);
cd(par.base_folder);
% Ahora genero el pulso cuadrado para mandar junto con la senal
f=(2000)+(exp.estimulos(n)-1)*250; % genero la frecuencia para el pulso cuadrado
%f=2500*exp.estimulos(n);
% f1=10 Hz estimulo1, f2=20 Hz estimulo2, etc
n_samples=length(output_signal);
%square_pulse=square(2*pi*f*(0:(1/fs):(n_samples-1)/fs))'+1;
square_pulse=0.5*sin(2*pi*f*(0:(1/fs):(n_samples-1)/fs))';
% Setea parametros (canales, trigger, samplerate)
%ao=analogoutput('nidaq','Dev2');
%ch=addchannel(ao,0:1);
%ao.SampleRate = fs;
%ao
%ao.TriggerType = 'Immediate'; % Recibe el trigger del hardware (RTSI0)
%ao.HwDigitalTriggerSource = 'RTSI0';
%ao.TriggerCondition = 'PositiveEdge'; % triggerea al comienzo del pulso

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arranca la placa, notar que el output se arranca antes que el input     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Primero : asegurarse que el output arranca en 0
%putsample(ao,0)
%Segundo : mando la senal al buffer de salida
%putdata(ao,[output_signal square_pulse])
% Tercero: comienza la adquisicion
%start(ao)
%start(ai)  
%salida=[output_signal output_signal];
%salida=[square_pulse output_signal];
salida=[square_pulse output_signal];
tic;
sound(salida,fs)
%pause(8.0000-toc);
pause(22.000-toc);
disp(toc);
%  [data, time] = getdata(ai);
%  wait([ai,ao],2) % espera a que termine
%  stop(ai)
%wait(ao,length(output_signal)/fs)
%stop(ao)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  channel0 = data(:,1);
%  delete(ai);
  clear ai ao;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Escribo el archivo                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     a=int2str(exp.estimulos(n));
%     s=int2str(n);   %paso de numero a string
%     nombrearchiv=['trigger','n_',s,'_estimulo_',a,'.dat'];
%     cd(exp.foldername)
%     file=fopen(nombrearchiv,'w');
%     for i=1:SamplesPerTrigger
%     fprintf(file,'%d\n',channel0(i));
%     end
%     fclose(file);
%     cd(par.base_folder)
     
     n=n+1;
%chequea si aborte
if get(handles.pbAbort,'Value') == 1
    return
end

%beep


end

