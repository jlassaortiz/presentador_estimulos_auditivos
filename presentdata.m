function [] = presentdata(par,exp)
% Esta funcion se encarga de todo lo relacionado con la DAQ (presentacion
% de estimulos y Adquisicion de datos).
% INPUTS:
% OUTPUTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setea los parametros de las mediciones                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_start=clock;
n=1;
%daqreset % Importante resetear la daq antes de arrancar.
while(n<length(exp.estimulos)+1) %Da el numero de archivos totales a grabar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setea el output                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nombre_estimulo=exp.lista(exp.estimulos(n)).name; % Lee el archivo 
                                                  % que corresponda
cd(par.stimulus_folder);
[output_signal,fs]=audioread(nombre_estimulo);
cd(par.base_folder);
% Setea parametros (canales, trigger, samplerate)
%ao=analogoutput('nidaq','Dev2');
%addchannel(ao,0);
%ao.SampleRate = fs;
%ao
%ao.TriggerType = 'Immediate'; 
salida=[output_signal output_signal];
tic
sound(salida,fs);
pause(22.00000-toc);
%disp(toc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arranca la placa, notar que el output se arranca antes que el input     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Primero : asegurarse que el output arranca en 0
%putsample(ao,0)
%Segundo : mando la senal al buffer de salida
%putdata(ao,output_signal)
% Tercero: comienza la adquisicion
%start(ao)
%  wait([ao],30) % espera a que termine
%  stop(ao)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear ao;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     n=n+1;
    % pause(3);
end

%beep


end

