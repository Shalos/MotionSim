function varargout = AnimateData(varargin)
% ANIMATEDATA MATLAB code for AnimateData.fig
%      ANIMATEDATA, by itself, creates a new ANIMATEDATA or raises the existing
%      singleton*.
%
%      H = ANIMATEDATA returns the handle to a new ANIMATEDATA or the handle to
%      the existing singleton*.
%
%      ANIMATEDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANIMATEDATA.M with the given input arguments.
%
%      ANIMATEDATA('Property','Value',...) creates a new ANIMATEDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AnimateData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AnimateData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AnimateData

% Last Modified by GUIDE v2.5 31-Jul-2012 19:34:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AnimateData_OpeningFcn, ...
                   'gui_OutputFcn',  @AnimateData_OutputFcn, ...
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


% --- Executes just before AnimateData is made visible.
function AnimateData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AnimateData (see VARARGIN)

% Choose default command line output for AnimateData
handles.output = hObject;
if ~isempty(varargin)
     handles.parent = varargin{1};
 end

parentdata = guidata(handles.parent);
handles.currentfig = figure('Position',[300 600 500 400]);
plot(0,0);

handles.sysmodel = parentdata.sysmodelres;
set(handles.AXESCALE,'String', handles.sysmodel.info.axissize);
AXESCALE_Callback(handles.AXESCALE, eventdata, handles)


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AnimateData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AnimateData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SNAPXY.
function SNAPXY_Callback(hObject, eventdata, handles)
% hObject    handle to SNAPXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


figure(handles.currentfig)
view (0,90)


% --- Executes on button press in SNAPYZ.
function SNAPYZ_Callback(hObject, eventdata, handles)
% hObject    handle to SNAPYZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(handles.currentfig)
view (0,0)

% --- Executes on button press in SNAPXZ.
function SNAPXZ_Callback(hObject, eventdata, handles)
% hObject    handle to SNAPXZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(handles.currentfig)
view (180-90,0)

% --- Executes on button press in GRID.
function GRID_Callback(hObject, eventdata, handles)
% hObject    handle to GRID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GRID
figure(handles.currentfig)
if get(hObject,'Value')
    grid on
else
    grid off
end

% --- Executes on button press in BDYAXES.
function BDYAXES_Callback(hObject, eventdata, handles)
% hObject    handle to BDYAXES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BDYAXES


% --- Executes on button press in SQUARE.
function SQUARE_Callback(hObject, eventdata, handles)
% hObject    handle to SQUARE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SQUARE
figure(handles.currentfig)
if get(hObject,'Value')
    axis square
else
   axis normal
end

% --- Executes on button press in EXITBTN.
function EXITBTN_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(handles.currentfig)
close gcf
close gcf

% --- Executes on button press in PLAYBTN.
function PLAYBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLAYBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%setup animation
figure(handles.currentfig)
hold on
rotate3d on


if ~handles.sysmodel.info.spatial

view (0,90) 
end

axis(eval(get(handles.AXESCALE,'String')))
cla
figh = generatehandles(handles.sysmodel);
set(handles.STOPBTN,'enable','on');
x = 0;
while x < length(handles.sysmodel.results.T) && strcmp(get(handles.STOPBTN,'enable'),'on')
    x=x+round(get(handles.STEPSLIDER,'Value'));
    if x >= length(handles.sysmodel.results.T)
        pause(.01);
    else
        tscale = 1/get(handles.SPEEDSLIDER,'Value');
        pause(tscale*(handles.sysmodel.results.T(x+1)- handles.sysmodel.results.T(x)));
        figh.bodyaxes = get(handles.BDYAXES,'Value');
        set(handles.ANIMTIME,'String', ['Animations Time: ' num2str( handles.sysmodel.results.T(x))]);
        generateframe(x,figh,handles);
    end
    

end

set(handles.STOPBTN,'enable','off'); 
    

% --- Executes on button press in STOPBTN.
function STOPBTN_Callback(hObject, eventdata, handles)
% hObject    handle to STOPBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.STOPBTN,'ENABLE','off');

% --- Executes on slider movement.
function SPEEDSLIDER_Callback(hObject, eventdata, handles)
% hObject    handle to SPEEDSLIDER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.SPEEDTXT,'String', ['Speed: ' num2str(get(hObject, 'Value'))]);

% --- Executes during object creation, after setting all properties.
function SPEEDSLIDER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPEEDSLIDER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function STEPSLIDER_Callback(hObject, eventdata, handles)
% hObject    handle to STEPSLIDER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
num = round(get(hObject, 'Value'));
set(hObject,'Value',num);
set(handles.SLIDERSTEPTXT,'String', ['Frame Step: ' num2str(num)]);
% --- Executes during object creation, after setting all properties.
function STEPSLIDER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STEPSLIDER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function AXESCALE_Callback(hObject, eventdata, handles)
% hObject    handle to AXESCALE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AXESCALE as text
%        str2double(get(hObject,'String')) returns contents of AXESCALE as a double
figure(handles.currentfig)
axis(eval(get(hObject,'String')))

% --- Executes during object creation, after setting all properties.
function AXESCALE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AXESCALE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
