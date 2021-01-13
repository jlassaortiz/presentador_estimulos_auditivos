% Script que genera el nombre de la carpeta en los experimentos. 
% Como quedaba fijo, lo saque del programa principal.
% Retorna ademas la repeticion y la foldername como variables.
function[state,folder]=namegen(par)
aux=fix(clock);
date=[num2str(aux(3)),'.',num2str(aux(2)),'.',num2str(aux(1))]; %i.e.: 21.1.2014
repet=int2str(par.repeticion); % convierte a string 'par.repeticion'
foldername=[date,'-',repet]; %crea el nombre de carpeta
% Chequea el tipo de OS para saber si la carpeta hay que definirla con '/'
% o '\'.
if isunix==1
    folder=[par.base_folder,'/',foldername];
    else
    folder=[par.base_folder,'\',foldername];
end
% Chequea si la carpeta existe ya o no, para no sobreescribir datos!
if (isempty(dir(folder))==1)
     mkdir(par.base_folder,foldername);
     state=1;
     else
      msgbox('La carpeta ya existe!! Cambiar "Repeticion"', 'Error', 'error')
      state=0;
  return
end
end