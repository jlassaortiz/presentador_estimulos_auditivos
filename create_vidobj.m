%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esta funcion genera el objeto de video que va a renderizar el input
% de la webcam. USA 'winvideo', habria que cambiar en caso de que se cambie
% el OS de medicion. El formato 'YUY2_640x480' deberia soportarlo cualquier
% webcam moderna. El trigger manual es para poder prender y apagar con un 
% boton desde la GUI.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [video imagen] = create_vidobj(ejes)
video = videoinput('winvideo', 1, 'YUY2_640x480');
% only capture one frame per trigger, we are not recording a video

triggerconfig(video, 'manual');
% we need this to know the image height and width
 
vidRes = get(video, 'VideoResolution');
% image width
 
imWidth = vidRes(1);
% image height
 
imHeight = vidRes(2);
% number of bands of our image (should be 3 because it's RGB)
 
nBands = get(video, 'NumberOfBands');
% create an empty image container and show it on axPreview
 
imagen = image(zeros(imHeight, imWidth, nBands), 'parent', ejes);

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end

