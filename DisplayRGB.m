function varargout = DisplayRGB(varargin)
% DISPLAYRGB MATLAB code for DisplayRGB.fig
%      DISPLAYRGB, by itself, creates a new DISPLAYRGB or raises the existing
%      singleton*.
%
%      H = DISPLAYRGB returns the handle to a new DISPLAYRGB or the handle to
%      the existing singleton*.
%
%      DISPLAYRGB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYRGB.M with the given input arguments.
%
%      DISPLAYRGB('Property','Value',...) creates a new DISPLAYRGB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DisplayRGB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DisplayRGB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DisplayRGB

% Last Modified by GUIDE v2.5 29-Jan-2021 08:24:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DisplayRGB_OpeningFcn, ...
                   'gui_OutputFcn',  @DisplayRGB_OutputFcn, ...
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


% --- Executes just before DisplayRGB is made visible.
function DisplayRGB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DisplayRGB (see VARARGIN)

handles.output = hObject;
set(gcf, 'units', 'normalized', 'position', [0.06 0.01 0.88 0.89])

%global tempRGB;
tempRGB = varargin{1};
bands = varargin{2};
filepath = varargin{3};

imshow(tempRGB,[])
hp = impixelinfo;
set(hp,'Position',[50 10 200 30], 'FontSize', 20);


band = strcat('Red: ',bands(1));
set(handles.Red, 'String',band);
band = strcat('Green: ',bands(2));
set(handles.Green, 'String',band);
band = strcat('Blue: ',bands(3));
set(handles.Blue, 'String',band);

 % set the slider range and step size
numSteps = 6;
set(handles.sliderRGB, 'Min', 1);
set(handles.sliderRGB, 'Max', numSteps);
set(handles.sliderRGB, 'Value', 1);
set(handles.sliderRGB, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
set(handles.SliderValue, 'String',1);

handles.filepath = filepath;
handles.currentRGBImage = tempRGB;
handles.tempRGB = tempRGB;
handles.bands = bands;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = DisplayRGB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sliderRGB_Callback(hObject, eventdata, handles)
handles.output = hObject;
tempRGB = handles.tempRGB;
bands = handles.bands;

sz = 6;

sliderVal = get(hObject,'Value');
sliderVal = ceil(sliderVal);
if sliderVal > sz
    sliderVal = sz;
    set(handles.sliderRGB,'Value',sliderVal);
end


set(handles.SliderValue, 'String',sliderVal);

axes(handles.axes1);

falseRGB = [];

if sliderVal == 1
    R_band = 1; 
    G_band = 2;
    B_band = 3;
end

if sliderVal == 2
    R_band = 1; 
    G_band = 3;
    B_band = 2;
end
    
if sliderVal == 3
    R_band = 2; 
    G_band = 3;
    B_band = 1;
end  

if sliderVal == 4
    R_band = 2; 
    G_band = 1;
    B_band = 3;
end 

if sliderVal == 5
    R_band = 3 ;
    G_band = 1;
    B_band = 2;
end 
    
if sliderVal == 6
    R_band = 3 ;
    G_band = 2;
    B_band = 1;
end     
    
falseRGB = tempRGB(:,:,R_band);
falseRGB(:,:,2) = tempRGB(:,:,G_band);
falseRGB(:,:,3) = tempRGB(:,:,B_band);


bandR = strcat('Red: ',bands(R_band));
set(handles.Red, 'String',bandR);
bandG = strcat('Green: ',bands(G_band));
set(handles.Green, 'String',bandG);
bandB = strcat('Blue: ',bands(B_band));
set(handles.Blue, 'String',bandB);

bands_to_save = ['{',bands{R_band}, ',', bands{G_band},',',bands{B_band},'}'];

%figure
imshow(falseRGB,[])

handles.currentRGBImage = falseRGB;
handles.bands_to_save = bands_to_save;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sliderRGB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in SaveRGB.
% function SaveRGB_Callback(hObject, eventdata, handles)
% % hObject    handle to SaveRGB (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% handles.output = hObject;
% currentRGBImage = handles.currentRGBImage;
% filepath = handles.filepath;
% 
% 
% 
% savename = [filepath,'nametobespecified','.png']
% [filename, foldername] = uiputfile(savename);
% 
% set(handles.figure1, 'pointer', 'watch')
% drawnow;
% 
% if filename~=0
%     complete_name = fullfile(foldername, filename);
%     %currentImage = double(currentImage)/255;
%     imwrite(currentRGBImage, complete_name); %,'BitDepth',16);
%     %print(complete_name,'-djpeg');
% end
% 
% set(handles.figure1, 'pointer', 'arrow')


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ENVI_Callback(hObject, eventdata, handles)
% hObject    handle to ENVI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
currentRGBImage = handles.currentRGBImage;
filepath = handles.filepath;
bands_to_save = handles.bands_to_save;


info = struct;
info.description= '{Saved by Spectral Analysis Toolset}';
info.samples= size(currentRGBImage,2);
info.lines= size(currentRGBImage,1);
info.bands= size(currentRGBImage,3);
info.header_offset= 0;
info.file_type= 'ENVI Standard';
info.data_type= 4;
info.interleave= 'bsq';
info.sensor_type= 'Unknown';
info.byte_order= 0;
info.band_names= bands_to_save;

savename = ['.img'];
[filename, foldername] = uiputfile([filepath,savename]);
if filename(end-3) == ','
    filename = filename(1:end-4)
end

set(handles.figure1, 'pointer', 'watch')
    drawnow;

datafile = [foldername, filename(1:end-4)];
hdrfile = [foldername, filename(1:end-4),'.hdr'];

enviwrite(currentRGBImage,info,datafile,hdrfile);

set(handles.figure1, 'pointer', 'arrow');

uiwait(msgbox('Image saved','Saved'));

% --------------------------------------------------------------------
function JPG_Callback(hObject, eventdata, handles)
% hObject    handle to JPG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
currentRGBImage = handles.currentRGBImage;
filepath = handles.filepath;

savename = ['.jpg'];
[filename, foldername] = uiputfile([filepath,savename]);
imwrite(currentRGBImage, [foldername,filename]);

uiwait(msgbox('Image saved','Saved'));

% --------------------------------------------------------------------
function PNG_Callback(hObject, eventdata, handles)
% hObject    handle to PNG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
currentRGBImage = handles.currentRGBImage;
filepath = handles.filepath;

savename = ['.png'];
[filename, foldername] = uiputfile([filepath,savename]);
imwrite(currentRGBImage, [foldername,filename]);

uiwait(msgbox('Image saved','Saved'));

% --------------------------------------------------------------------
function TIF_Callback(hObject, eventdata, handles)
% hObject    handle to TIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
currentRGBImage = handles.currentRGBImage;
filepath = handles.filepath;

savename = ['.tif'];
[filename, foldername] = uiputfile([filepath,savename]);
imwrite(currentRGBImage, [foldername,filename]);

uiwait(msgbox('Image saved','Saved'));
