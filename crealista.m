function [carpeta_estimulos,estimulos,lista] = crealista(par,carpeta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Genera la cadena al azar de la presentacion de estimulos.               %
% Busco los archivos de estimulo en carpeta_base\estimulos.               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
carpeta_estimulos= [par.base_folder '\' 'estimulos']; 
lista=dir(fullfile(carpeta_estimulos,'*.wav')); % listo los archivos.
n=length(lista); %cantidad de estimulos que se encuentran
                 %en la carpeta al momento de empezar el exp
N=zeros(1,n);
Ntot=0; %Ntot=contador de cuántos estímulos se van presentando en la cadena
while(Ntot<(n*par.Nrep)) % !!!! acá cambio la cantidad de estímulos que quiera presentar
for i=1:(n+1)
intervalo(i)=(i-1)/n;
end
r=rand; % Nos quedamos con rand nomàs?
j=n+1;
while(r<intervalo(j))
    j=j-1;
end
if(N(j)<par.Nrep)
estimulo_selec(Ntot+1)=j; % aca habria que abrir el archivo respectivo
N(j)=N(j)+1;
else
    N(j)=N(j);
end
Ntot=sum(N);
end
%N %chequeo el N
%estimulo_selec %chequeo la cadena al azar
cd(carpeta)
fin=fopen('estimulos.txt','w');
for i=1:Ntot
    fprintf(fin, '%d\t %s\n',estimulo_selec(i), lista(estimulo_selec(i)).name);
end
fclose(fin);
clear n j; %libero variables
cd ..;

estimulos=estimulo_selec; % Guardo el vector de numeros que representa cada
                      % estimulo en la variable de salida 'lista'.
end

