function varargout = SysParam(varargin)
% SYSPARAM MATLAB code for SysParam.fig
%      SYSPARAM, by itself, creates a new SYSPARAM or raises the existing
%      singleton*.
%
%      H = SYSPARAM returns the handle to a new SYSPARAM or the handle to
%      the existing singleton*.
%
%      SYSPARAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYSPARAM.M with the given input arguments.
%
%      SYSPARAM('Property','Value',...) creates a new SYSPARAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SysParam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SysParam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SysParam

% Last Modified by GUIDE v2.5 24-Aug-2012 23:13:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SysParam_OpeningFcn, ...
                   'gui_OutputFcn',  @SysParam_OutputFcn, ...
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


% --- Executes just before SysParam is made visible.
function SysParam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SysParam (see VARARGIN)
 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.newsys = parentdata.newmodel;
if handles.newsys
    uipanel1_SelectionChangeFcn(handles.uipanel1, eventdata,  handles);
    set(handles.CreateSys,'Visible','on');
    set(handles.Dynamic,'ENABLE','on');
    set(handles.Kinematic,'ENABLE','on');
    set(handles.Planar,'ENABLE','on');
    set(handles.Spatial,'ENABLE','on');
else
handles.sysmodel = parentdata.sysmodel;
handles.output = hObject;
handles.currentbodynum = 1;
handles = refreshdata(handles);
guidata(hObject, handles);
end




% UIWAIT makes BodyInput wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = refreshdata(handles)
sysmodel = handles.sysmodel;
if sysmodel.info.spatial == 1
    set(handles.Spatial, 'Value', 1);
else
    set(handles.Planar, 'Value',1);
end
    
if sysmodel.info.dynamic == 1
    set(handles.Dynamic, 'Value', 1);
    set(handles.Enablestab,'ENABLE','on');
    set(handles.edit7,'ENABLE','on');
else
    set(handles.Kinematic, 'Value', 1);
    set(handles.Enablestab,'ENABLE','off');
    set(handles.edit7,'ENABLE','off');
end

if sysmodel.info.stabilize == 1
    set(handles.Enablestab, 'Value', 1);
end
units = sysmodel.info.units;
    set(handles.Length,'String',units.length)
    set(handles.Time,'String',units.time)
    set(handles.Deg,'String',units.angle)
    set(handles.Force,'String',units.force)
    set(handles.ACCELG,'String',units.G)

unitlist = {'Custom','IPS','FPS','MKS','mmgS'};
set(handles.Unitspopup,'String', unitlist);
%pass data back to figure and parent figure
handles.sysmodel = sysmodel;
updateparent(handles);

function updateparent(handles)
z = guidata(handles.parent);
z.sysmodel = handles.sysmodel;
guidata(handles.parent, z);

% UIWAIT makes SysParam wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SysParam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in EXITBTN.
function EXITBTN_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes on selection change in Unitspopup.
function Unitspopup_Callback(hObject, eventdata, handles)
% hObject    handle to Unitspopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Unitspopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Unitspopup
unitselect = get(hObject,'Value');

if unitselect == 2 
    set(handles.Length,'String','in')
    set(handles.Time,'String','s')
    set(handles.Deg,'String','Deg')
    set(handles.Force,'String','Lb')
    set(handles.ACCELG,'String',386)
elseif unitselect == 3
        set(handles.Length,'String','Ft')
    set(handles.Time,'String','s')
    set(handles.Deg,'String','Deg')
    set(handles.Force,'String','Lb')
    set(handles.ACCELG,'String',32.174)
elseif unitselect == 4
    set(handles.Length,'String','m')
    set(handles.Time,'String','s')
    set(handles.Deg,'String','Deg')
    set(handles.Force,'String','N')
    set(handles.ACCELG,'String',9.81)
elseif unitselect == 5
        set(handles.Length,'String','mm')
    set(handles.Time,'String','s')
    set(handles.Deg,'String','Deg')
    set(handles.Force,'String','N')
    set(handles.ACCELG,'String',9.81)
end
ACCELG_Callback(handles.ACCELG, eventdata, handles);
Length_Callback(handles.Length, eventdata, handles);
Time_Callback(handles.Time, eventdata, handles);
Deg_Callback(handles.Deg, eventdata, handles);
Force_Callback(handles.Force, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function Unitspopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Unitspopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Length_Callback(hObject, eventdata, handles)
% hObject    handle to Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Length as text
%        str2double(get(hObject,'String')) returns contents of Length as a double
handles.sysmodel.info.units.length =get(hObject,'String');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Time_Callback(hObject, eventdata, handles)
% hObject    handle to Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time as text
%        str2double(get(hObject,'String')) returns contents of Time as a double
handles.sysmodel.info.units.time =get(hObject,'String');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Deg_Callback(hObject, eventdata, handles)
% hObject    handle to Deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Deg as text
%        str2double(get(hObject,'String')) returns contents of Deg as a double
handles.sysmodel.info.units.angle =get(hObject,'String');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Deg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Force_Callback(hObject, eventdata, handles)
% hObject    handle to Force (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Force as text
%        str2double(get(hObject,'String')) returns contents of Force as a double
handles.sysmodel.info.units.force =get(hObject,'String');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Force_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Force (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Enablestab.
function Enablestab_Callback(hObject, eventdata, handles)
% hObject    handle to Enablestab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Enablestab

handles.sysmodel.info.stabilize = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ACCELG_Callback(hObject, eventdata, handles)
% hObject    handle to ACCELG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ACCELG as text
%        str2double(get(hObject,'String')) returns contents of ACCELG as a double
handles.sysmodel.info.units.G =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ACCELG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ACCELG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CreateSys.
function CreateSys_Callback(hObject, eventdata, handles)
% hObject    handle to CreateSys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = inputdlg('Enter file name');
%sysmodel = handles.sysmodel;
handles.sysmodel.info.name = filename{1};
%handles.sysmodel.info.name = handles.sysmodel.info.name{1};
Enablestab_Callback(handles.Enablestab, eventdata, handles);
ACCELG_Callback(handles.ACCELG, eventdata, handles);
Length_Callback(handles.Length, eventdata, handles);
Time_Callback(handles.Time, eventdata, handles);
Deg_Callback(handles.Deg, eventdata, handles);
Force_Callback(handles.Force, eventdata, handles);
%save(strcat('Results\',handles.sysmodel.info.name,'.mat'),'sysmodel');
%handles.newsys = filename;
%z = guidata(handles.parent);
%z.newmodel = filename{1};
%z.sysmodel.info.name = filename{1};
%guidata(handles.parent, z);

updateparent(handles);
close gcf;
% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.Planar,'Value') == 1
    load(strcat('Models\','TEMPLATE2D.mat'),'sysmodel');
    sysmodel.info.spatial = 0;
else
  load(strcat('Models\','TEMPLATE3D.mat'),'sysmodel');
  sysmodel.info.spatial = 1;
end
if get(handles.Dynamic,'Value')
    sysmodel.info.dynamic = 1;
    
else
    sysmodel.info.dynamic = 0;
end
    handles.sysmodel = sysmodel;
    
handles.sysmodel = sysmodel;
handles.output = hObject;
handles.currentbodynum = 1;
handles = refreshdata(handles);
Enablestab_Callback(handles.Enablestab, eventdata, handles);
ACCELG_Callback(handles.ACCELG, eventdata, handles);
Length_Callback(handles.Length, eventdata, handles);
Time_Callback(handles.Time, eventdata, handles);
Deg_Callback(handles.Deg, eventdata, handles);
Force_Callback(handles.Force, eventdata, handles);



guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
uipanel1_SelectionChangeFcn(handles.uipanel1, eventdata, handles);
