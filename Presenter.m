%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programa para experimentos de selectividad - v2                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changelog v2, 21/01/2015: cambie la logica del programa un 
% poco, optimice algunas operaciones y genere archivos .m aparte para las 
% distintas subrutinas. 
% - Nuevos archivos .m:
% * namegen.m: rutina de varias lineas para generar el nombre de la carpeta
%              donde se van a guardar las mediciones de esa repeticion.
% *
% - Esto deja a este programa mas limpio y que aca solo pueda editarse las 
% cosas que se necesitan para el experimento. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
par.base_folder=pwd;
%par.base_folder='C:\Users\usuario\Desktop\Santi.2014\Experimentos';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%Carpeta base: es donde genera las carpetas con la fecha
par.repeticion=1; %Nro de repeticion del experimento durante el dia
par.Nrep=20; %cantidad de veces que se quiere repetir cada estimulo (default=20)
par.tiempo_file=10; %define la cantidad de tiempo de cada archivo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crea el directorio donde guardar las mediciones o tira un warning en caso
% de que el directorio ya exista
exp.foldername=namegen(par);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% 1. Genero la cadena al azar de la presentación de estímulos.            %
% Busco los archivos de estímulo en carpeta_base\estimulos.               %
%--------------------------------------------------------------------------
carpeta_estimulos= [carpeta_base '\' 'estimulos']; % defino la subcarpeta donde se encuentran los estimulos
lista=dir(fullfile(carpeta_estimulos,'*.wav')); %chequea por estimulos en formato 'txt' y los lista
n=length(lista); %cantidad de estimulos que se encuentran en la carpeta al momento de empezar el exp
N=zeros(1,n);
Ntot=0; %Ntot=contador de cuántos estímulos se van presentando en la cadena
while(Ntot<(n*Nrep)) % !!!! acá cambio la cantidad de estímulos que quiera presentar
for i=1:(n+1)
intervalo(i)=(i-1)/n;
end
r=rand; % Nos quedamos con rand nomàs?
j=n+1;
while(r<intervalo(j))
    j=j-1;
end
if(N(j)<Nrep)
estimulo_selec(Ntot+1)=j; % aca habria que abrir el archivo respectivo
N(j)=N(j)+1;
else
    N(j)=N(j);
end
Ntot=sum(N);
end
%N %chequeo el N
%estimulo_selec %chequeo la cadena al azar
cd(carpeta_mediciones)
fin=fopen('estimulos.txt','w');
for i=1:Ntot
    fprintf(fin, '%d\t %s\n',estimulo_selec(i), lista(estimulo_selec(i)).name);
end
fclose(fin);
clear n j; %libero variables
cd(carpeta_base)
%--------------------------------------------------------------------------
% Listo generación de cadena                                              %
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 2. Seteo los parámetros de las mediciones                               %
%--------------------------------------------------------------------------

t_start=clock;
n=1;

daqreset % Importante resetear el daq antes de arrancar.

%-------------------------------------------------------------------------
% Seteo el input
%-------------------------------------------------------------------------
while(n<Ntot+1) %DA EL N�MERO DE ARCHIVOS TOTALES A GRABAR
    
     ai = analoginput('nidaq','Dev2');    % set the device

     Duration          =  tiempo_file;        
     SampleRate        = 20000;        % en Samples/sec (S/s)
     SamplesPerTrigger = Duration * SampleRate;   % number of total Samples

%-------------------------------------------------------------------------
  addchannel(ai, 0);           
  set(ai, 'SampleRate',        SampleRate); 
  set(ai, 'SamplesPerTrigger', SamplesPerTrigger);
  ai.TriggerType = 'Immediate'; %asegura que el input empiece cuando se manda el comando START
  ai.ExternalTriggerDriveLine = 'RTSI0'; %Set the analog input system to signal on RTSI line 0 when it starts.
                                         % será 0 porque el ejemplo usa
                                         % canal 0?
  ai
%-------------------------------------------------------------------------
% Seteo el output
%-------------------------------------------------------------------------
%----------- Leo el archivo que corresponda
nombre_estimulo=lista(estimulo_selec(n)).name;
cd(carpeta_estimulos);
[output_signal,fs]=wavread(nombre_estimulo);
cd(carpeta_base);
%----------- Seteo parámetros (canales, trigger, samplerate)
ao=analogoutput('nidaq','Dev2');
addchannel(ao,0);
ao.SampleRate = fs;
ao
ao.TriggerType = 'HwDigital'; % Recibe el trigger de una línea de hardware (RTSI0)
ao.HwDigitalTriggerSource = 'RTSI0';
ao.TriggerCondition = 'PositiveEdge'; % triggerea al comienzo del pulso
%-------------------------------------------------------------------------
% Arranco la placa, notar que el output se arranca antes que el input
%-------------------------------------------------------------------------
%Primero : asegurarse que el output arranca en 0
putsample(ao,0)
%Segundo : mando la señal al buffer de salida
putdata(ao,output_signal)
% Tercero: comienza la adquisición
start(ao)
start(ai)  
  
  [data, time] = getdata(ai);
  %[data2, time2] = getdata(ao); esto queda para ver como testeamos
  wait([ai,ao],2) % espera a que termine
  stop(ai)
  stop(ao)
%-------------------------------------------------------------------------
  channel0 = data(:,1);
  delete(ai);
  clear ai ao;
%-------------------------------------------------------------------------
% Escribo el archivo
%-------------------------------------------------------------------------
     a=int2str(estimulo_selec(n));
     s=int2str(n);   %pase de numeri a string
     nombrearchiv=['trigger','n_',s,'_estimulo_',a,'.dat']
     cd(carpeta_mediciones)
     file=fopen(nombrearchiv,'w');
     for i=1:SamplesPerTrigger
     fprintf(file,'%d\n',channel0(i));
     end
     fclose(file)
     cd(carpeta_base)
     
     n=n+1;
end

beep
