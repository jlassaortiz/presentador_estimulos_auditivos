%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esta es una GUI simple pensada para llevar a cabo los experimentos de   %
% selectividad en HVC con animal dormido/anestesiado. Puede ajustarse fa- %
% cilmente a otras necesidades.                                           %
% Autor: Santiago Boari.         Version 1.0: Enero 2015.                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = Programa_INTAN(varargin)
% Programa MATLAB countitlde for Programa.fig
%      Programa, by itself, creates a new Programa or raises the existing
%      singleton*.
%      H = Programa returns the handle to a new Programa or the handle to
%      the existing singleton*.
%      Programa('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Programa.M with the given input arguments.
%      Programa('Property','Value',...) creates a new Programa or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Programa_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Programa_OpeningFcn via varargin.
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Programa

% Last Modified by GUIDE v2.5 03-Aug-2015 14:45:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Programa_INTAN_OpeningFcn, ...
                   'gui_OutputFcn',  @Programa_INTAN_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Codigos a ejecutar antes de que aparezca el programa.               %
% NOTA: aca creo los 'objetos' necesarios que puedo llamar desde los      %
% distintos botones y funciones. P.ej, el objeto de video que genera el   %
% archivo 'create_vidobj.m' crea un elemento de video 'winvideo' para usar%
% con la camara.                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Programa_INTAN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Programa (see VARARGIN)

% Choose default command line output for Programa
handles.output = hObject;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esta seccion es la que contiene todas las variables 'de fondo' que      %
% se almacenen para mandar a los distintos scripts o funciones.           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[handles.vid,handles.hImage] = create_vidobj(handles.axPreview);
set(handles.axPreview,'YTickLabel',[]);
set(handles.axPreview,'XTickLabel',[]);
currentfolder=pwd;
set(handles.txt_basefolder,'String',currentfolder);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Programa wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Programa_INTAN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLBACKS SECTION: En la seccion que sigue estan listadas todas las     %
% funciones 'callback' para cada uno de los elementos de la GUI. En caso  %
% de tener que modificar alguno, usar Ctrl+F y buscarlo por su nombre en  %
% GUIDE (o por su nombre, todos tienen nombres relacionados con lo que    %
% hacen.                                                                  %
% NOTA: Muchas callbacks llaman a otros .m que estan en el mismo          %
% directorio, esto lo hice asi para que cada subrutina no quedara nesteada%
% en medio de todas las callbacks.                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- tbOnOff es un 'toggle button', que significa que puede tener        %
% comportamientos distintos si esta presionado o no. Uso este tipo de     %
% boton para el boton de encendido/apagado de la webcam.                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbOnOff_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value'); % Se fija en que estado esta el boton
if button_state == get(hObject,'Max') % Si el boton esta presionado...
    set(handles.tbOnOff,'String','ON'); % Cambia el texto a 'ON?
    set(handles.tbOnOff,'BackgroundColor', [0 1 0]); % pone color verde
    preview(handles.vid, handles.hImage); % Empieza el preview de la webcam
    elseif button_state == get(hObject,'Min') % Si el boton no esta ON.
        set(handles.tbOnOff,'String','OFF'); % Cambia el texto a 'OFF'
        set(handles.tbOnOff,'BackgroundColor', [1 0 0]); % pone color rojo
        stoppreview(handles.vid); % Termina la preview
        %!NOTA: Por algun motivo se queda congelada la imagen en el ultimo
        %frame que habia antes de stoppreview. Todavia no se como hacer 
        %para que vuelva a poner una imagen en negro.
end
% hObject    handle to tbOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tbOnOff

function txt_basefolder_Callback(hObject, eventdata, handles)
% hObject    handle to txt_basefolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_basefolder as text
%        str2double(get(hObject,'String')) returns contents of txt_basefolder as a double


% --- Executes during object creation, after setting all properties.
function txt_basefolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_basefolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbBrowse.
function pbBrowse_Callback(hObject, eventdata, handles)
 indir=uigetdir;
 if indir ~= 0
    set(handles.txt_basefolder,'string',indir)
 else
     currentfolder=pwd;
     set(handles.txt_basefolder,'string',currentfolder)
 end
 
% hObject    handle to pbBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txt_repet_Callback(hObject, eventdata, handles)
% hObject    handle to txt_repet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_repet as text
%        str2double(get(hObject,'String')) returns contents of txt_repet as a double


% --- Executes during object creation, after setting all properties.
function txt_repet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_repet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_Nrep_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Nrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Nrep as text
%        str2double(get(hObject,'String')) returns contents of txt_Nrep as a double


% --- Executes during object creation, after setting all properties.
function txt_Nrep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Nrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_tiempo_file_Callback(hObject, eventdata, handles)
% hObject    handle to txt_tiempo_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_tiempo_file as text
%        str2double(get(hObject,'String')) returns contents of txt_tiempo_file as a double


% --- Executes during object creation, after setting all properties.
function txt_tiempo_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_tiempo_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Ejecuta el llamado para hacer las mediciones en el experimento.
% Utiliza las variables 'txt_basefolder' para determinar la carpeta base,
% 'txt_repet', para obtener el numero de repeticion, 'txt_Nrep' para
% obtener el numero de veces de repeticion de cada estimulo y
% 'txt_tiempo_file' para el tiempo de cada file. Con eso, llama a cada uno
% de los subscripts que hacen cada parte:
% * namegen.m -> toma las variables y genera el nombre de la carpeta
% * crealista.m -> generador de la lista de estimulos a presentar y
% 'estimulos.txt'. !NOTA: esta version quedo igual que estaba antes, me
% estoy centrando en poner todo en la GUI antes de modificar mucho las
% subrutinas involucradas.
% 
function pbGo_Callback(hObject, eventdata, handles)
%if isempty(daq.getDevices)==1
%    msgbox('No se detectaron dispositivos DAQ en el sistema', 'Error', 'error')
%    return
% end
par.base_folder=get(handles.txt_basefolder,'String');
par.repeticion=str2double(get(handles.txt_repet,'String'));
par.Nrep=str2double(get(handles.txt_Nrep,'String'));
par.tiempo_file=str2double(get(handles.txt_tiempo_file,'String'));
[status,exp.foldername]=namegen(par);
% Chequeo si se pudo crear el directorio nuevo o no
if status==0 % Si no se creo....
    return   % No ejecuta nada mas
end
[par.stimulus_folder,exp.estimulos,exp.lista]=crealista(par,exp.foldername);
acquiredataINTAN(par,exp,handles);
% hObject    handle to pbGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pbTest.
function pbTest_Callback(hObject, eventdata, handles)
%if isempty(daq.getDevices)==1
%    msgbox('No se detectaron dispositivos DAQ en el sistema', 'Error', 'error')
%    return
% end
par.base_folder=get(handles.txt_basefolder,'String');
par.Nrep=1;
[par.stimulus_folder,exp.estimulos,exp.lista]=crealista_test(par);
presentdata(par,exp);


% hObject    handle to pbTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pbEspontanea.
function pbEspontanea_Callback(hObject, eventdata, handles)
% hObject    handle to pbEspontanea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if isempty(daq.getDevices)==1 || isempty(daqhwinfo.InstalledAdaptors)==1
%    msgbox('No se detectaron dispositivos DAQ en el sistema', 'Error', 'error')
%    return
par.base_folder=get(handles.txt_basefolder,'String');
par.repeticion=str2double(get(handles.txt_repet,'String'));
par.tiempo_file=str2double(get(handles.txt_tiempo_file,'String'));
acquirespdata(par,handles)


% --- Executes on button press in pbAbort.
function pbAbort_Callback(hObject, eventdata, handles)
% hObject    handle to pbAbort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
