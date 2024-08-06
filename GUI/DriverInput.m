function varargout = DriverInput(varargin)
% DRIVERINPUT MATLAB code for DriverInput.fig
%      DRIVERINPUT, by itself, creates a new DRIVERINPUT or raises the existing
%      singleton*.
%
%      H = DRIVERINPUT returns the handle to a new DRIVERINPUT or the handle to
%      the existing singleton*.
%
%      DRIVERINPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRIVERINPUT.M with the given input arguments.
%
%      DRIVERINPUT('Property','Value',...) creates a new DRIVERINPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DriverInput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DriverInput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DriverInput

% Last Modified by GUIDE v2.5 29-Jul-2012 09:29:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DriverInput_OpeningFcn, ...
                   'gui_OutputFcn',  @DriverInput_OutputFcn, ...
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


% --- Executes just before DriverInput is made visible.
function DriverInput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DriverInput (see VARARGIN)

 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.sysmodel = parentdata.sysmodel;

handles.output = hObject;
handles.currentdrivernum = 1;
handles = refreshdata(handles);

if ~handles.sysmodel.info.spatial
   set(handles.Z,'ENABLE','off'); 
set(handles.e1,'ENABLE','off'); 
   set(handles.e2,'ENABLE','off');  
end

DRIVERLISTBOX_Callback(handles.DRIVERLISTBOX, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BodyInput wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = refreshdata(handles)
sysmodel = handles.sysmodel;
driverlistboxval = {'none'};
%enumerate list box of bodies
for x = 1:length(sysmodel.drivers)
   driverlistboxval{x} = [num2str(sysmodel.drivers(x).num), '-', sysmodel.drivers(x).label];
end
handles.driverlist = driverlistboxval;
set(handles.DRIVERLISTBOX,'String',handles.driverlist);
set(handles.DRIVERLISTBOX,'Value', handles.currentdrivernum);

if isempty(sysmodel.drivers)
    SetAllEnable(handles,'off');
else
    SetAllEnable(handles,'on');
end
%enum bodies
bdylistboxval = {'none'};
%enumerate list box of bodies
for x = 1:sysmodel.info.bodies
    
   bdylistboxval{x} = [num2str(sysmodel.body(x).num), '-', sysmodel.body(x).label];
  
end

set(handles.BDYMENU,'String',bdylistboxval);



%pass data back to figure and parent figure
handles.sysmodel = sysmodel;
updateparent(handles);

function SetAllEnable(handles,arg)
set(handles.FT, 'ENABLE',arg);
set(handles.FDT, 'ENABLE',arg);
set(handles.FDDT, 'ENABLE',arg);
set(handles.LABEL, 'ENABLE',arg);
set(handles.BDYMENU, 'ENABLE',arg);

set(handles.X, 'ENABLE',arg);
set(handles.Y, 'ENABLE',arg);
set(handles.e3, 'ENABLE',arg);

if handles.sysmodel.info.spatial
    set(handles.Z, 'ENABLE',arg);
    set(handles.e1, 'ENABLE',arg);
    set(handles.e2, 'ENABLE',arg);
end
function updateparent(handles)
z = guidata(handles.parent);
z.sysmodel = handles.sysmodel;
guidata(handles.parent, z);

% UIWAIT makes DriverInput wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DriverInput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function FT_Callback(hObject, eventdata, handles)
% hObject    handle to FT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FT as text
%        str2double(get(hObject,'String')) returns contents of FT as a double
num = handles.currentdrivernum;
handles.sysmodel.drivers(num).ft = get(hObject,'String');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FDT_Callback(hObject, eventdata, handles)
% hObject    handle to FDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FDT as text
%        str2double(get(hObject,'String')) returns contents of FDT as a double
num = handles.currentdrivernum;
handles.sysmodel.drivers(num).fdt = get(hObject,'String');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FDT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FDDT_Callback(hObject, eventdata, handles)
% hObject    handle to FDDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FDDT as text
%        str2double(get(hObject,'String')) returns contents of FDDT as a double
num = handles.currentdrivernum;
handles.sysmodel.drivers(num).fddt = get(hObject,'String');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FDDT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FDDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BDYMENU.
function BDYMENU_Callback(hObject, eventdata, handles)
% hObject    handle to BDYMENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BDYMENU contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BDYMENU
num = handles.currentdrivernum;
handles.sysmodel.drivers(num).body = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BDYMENU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDYMENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ADDDRIVER.
function ADDDRIVER_Callback(hObject, eventdata, handles)
% hObject    handle to ADDDRIVER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drivernum = length(handles.sysmodel.drivers)+1;

if isempty(handles.sysmodel.drivers)
    handles.sysmodel.drivers = handles.sysmodel.info.templates.driver;
else
    
    handles.sysmodel.drivers(drivernum) = handles.sysmodel.info.templates.driver;
end
handles.sysmodel.info.drivers = handles.sysmodel.info.drivers+1;
handles.sysmodel.drivers(drivernum).num = drivernum-1;
handles.sysmodel.drivers(drivernum).label = 'DCNST';
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in DELETEDRIVER.
function DELETEDRIVER_Callback(hObject, eventdata, handles)
% hObject    handle to DELETEDRIVER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drivernum = get(handles.DRIVERLISTBOX,'Value');
if handles.sysmodel.info.drivers == 0
   return 
end
index = 1;
for x = 1:handles.sysmodel.info.drivers
    if x ~= drivernum
        tempcnst(index) = handles.sysmodel.drivers(x);
        tempcnst(index).num = index-1;
        index = index+1;
    end
end
if handles.sysmodel.info.drivers == 1
    handles.sysmodel.drivers= [];
else
handles.sysmodel.drivers= tempcnst;    
end

handles.sysmodel.info.drivers = handles.sysmodel.info.drivers-1;
handles.currentdrivernum = 1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on selection change in DRIVERLISTBOX.
function DRIVERLISTBOX_Callback(hObject, eventdata, handles)
% hObject    handle to DRIVERLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DRIVERLISTBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DRIVERLISTBOX

drivernum = get(hObject,'Value');
handles.currentdrivernum = drivernum;

if isempty(handles.sysmodel.drivers)
    return
end
driverinfo = handles.sysmodel.drivers(drivernum);

set(handles.FT, 'String', driverinfo.ft);
set(handles.FDT, 'String', driverinfo.fdt);
set(handles.FDDT, 'String', driverinfo.fddt);
set(handles.LABEL, 'String', driverinfo.label);
if strcmp(driverinfo.coord, 'X');
    set(handles.X,'Value',1);
elseif strcmp(driverinfo.coord, 'Y');
    set(handles.Y,'Value',1);
elseif strcmp(driverinfo.coord, 'Z');
    set(handles.Z,'Value',1);
elseif strcmp(driverinfo.coord, 'e1');
    set(handles.e1,'Value',1);
elseif strcmp(driverinfo.coord, 'e2');
    set(handles.e2,'Value',1);
elseif strcmp(driverinfo.coord, 'e3') || strcmp(driverinfo.coord, 'PHI');
    set(handles.e3,'Value',1);
end

set(handles.BDYMENU,'Value',driverinfo.body);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function DRIVERLISTBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DRIVERLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EXITBTN.
function EXITBTN_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


% --- Executes when selected object is changed in uipanel3.
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel3 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
num = handles.currentdrivernum;


if get(handles.X,'Value')
    handles.sysmodel.drivers(num).coord = 'X';
elseif get(handles.Y,'Value')
    handles.sysmodel.drivers(num).coord = 'Y';
elseif get(handles.Z,'Value')
    handles.sysmodel.drivers(num).coord = 'Z';
elseif get(handles.e1,'Value')
    handles.sysmodel.drivers(num).coord = 'e1';
elseif get(handles.e2,'Value')
    handles.sysmodel.drivers(num).coord = 'e2';
elseif get(handles.e3,'Value')
    if handles.sysmodel.info.spatial
        handles.sysmodel.drivers(num).coord = 'e3';
    else
        handles.sysmodel.drivers(num).coord = 'PHI';
    end
end

updateparent(handles);
guidata(hObject, handles);


% --- Executes on button press in MOVEUP.
function MOVEUP_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEUP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drivernum = get(handles.DRIVERLISTBOX,'Value');
if drivernum == 1 
    return
end
index = 1;
for x = 1:handles.sysmodel.info.drivers
    if x == drivernum - 1 
        tempdrivers(index) = handles.sysmodel.drivers(x+1);
        tempdrivers(index).num = index-1;
        index = index+1;
        
        tempdrivers(index) = handles.sysmodel.drivers(x);
        tempdrivers(index).num = index-1;
        index = index+1;
    
    elseif x ~= drivernum-1 && x ~= drivernum
        tempdrivers(index) = handles.sysmodel.drivers(x);
        tempdrivers(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.drivers= tempdrivers;

handles.currentdrivernum = drivernum-1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in MOVEDOWN.
function MOVEDOWN_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEDOWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drivernum = get(handles.DRIVERLISTBOX,'Value');
if drivernum == length(handles.sysmodel.drivers)
    return
end
index = 1;
for x = 1:handles.sysmodel.info.drivers
    if x == drivernum 
        tempdrivers(index) = handles.sysmodel.drivers(x+1);
        tempdrivers(index).num = index-1;
        index = index+1;
        
        tempdrivers(index) = handles.sysmodel.drivers(x);
        tempdrivers(index).num = index-1;
        index = index+1;
    
    elseif x ~= drivernum+1 && x ~= drivernum
        tempdrivers(index) = handles.sysmodel.drivers(x);
        tempdrivers(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.drivers= tempdrivers;

handles.currentdrivernum = drivernum+1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);



function LABEL_Callback(hObject, eventdata, handles)
% hObject    handle to LABEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LABEL as text
%        str2double(get(hObject,'String')) returns contents of LABEL as a double

num = handles.currentdrivernum;
handles.sysmodel.drivers(num).label = get(hObject,'String');
handles = refreshdata(handles);
updateparent(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function LABEL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LABEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
