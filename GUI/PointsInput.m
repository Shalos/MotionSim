function varargout = PointsInput(varargin)
% POINTSINPUT MATLAB code for PointsInput.fig
%      POINTSINPUT, by itself, creates a new POINTSINPUT or raises the existing
%      singleton*.
%
%      H = POINTSINPUT returns the handle to a new POINTSINPUT or the handle to
%      the existing singleton*.
%
%      POINTSINPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POINTSINPUT.M with the given input arguments.
%
%      POINTSINPUT('Property','Value',...) creates a new POINTSINPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PointsInput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PointsInput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PointsInput

% Last Modified by GUIDE v2.5 01-Aug-2012 19:01:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PointsInput_OpeningFcn, ...
                   'gui_OutputFcn',  @PointsInput_OutputFcn, ...
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


% --- Executes just before PointsInput is made visible.
function PointsInput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PointsInput (see VARARGIN)

% Choose default command line output for PointsInput
handles.output = hObject;

 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.sysmodelres = parentdata.sysmodelres;
handles.currentpointnum = 1;
handles = refreshdata(handles);
if ~handles.sysmodelres.info.spatial
    set(handles.PZ, 'ENABLE', 'off');
end
POINTLISTBOX_Callback(handles.POINTLISTBOX, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PointsInput wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function handles = refreshdata(handles)
sysmodelres = handles.sysmodelres;
pointlistboxval = {'none'};
%enumerate list box of bodies
for x = 1:sysmodelres.info.numpts
    pointlistboxval{x} = [ num2str(sysmodelres.points(x).num), '-', sysmodelres.points(x).label];
end
set(handles.POINTLISTBOX, 'Value', handles.currentpointnum);
set(handles.POINTLISTBOX,'String', pointlistboxval);


%enumerate bodies
handles.bodylist = {'none'};
%enumerate list box of bodies
for x = 1:sysmodelres.info.bodies
    
   handles.bodylist{x} = [num2str(sysmodelres.body(x).num), '-', sysmodelres.body(x).label];
  
end
set(handles.BDYLIST,'String', handles.bodylist);


if sysmodelres.info.numpts ==0
    SetAllEnable(handles,'off');
else
    SetAllEnable(handles,'on');
end

%pass data back to figure and parent figure
handles.sysmodelres = sysmodelres;
updateparent(handles);


function SetAllEnable(handles,arg)
set(handles.BDYLIST, 'ENABLE',arg);
set(handles.PTLABEL, 'ENABLE',arg);
set(handles.PX, 'ENABLE',arg);
set(handles.PY, 'ENABLE',arg);


if handles.sysmodelres.info.spatial
    set(handles.PZ, 'ENABLE',arg);
end


function updateparent(handles)
z = guidata(handles.parent);
z.sysmodelres = handles.sysmodelres;
guidata(handles.parent, z);

% --- Outputs from this function are returned to the command line.
function varargout = PointsInput_OutputFcn(hObject, eventdata, handles) 
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
close gcf


function PX_Callback(hObject, eventdata, handles)
% hObject    handle to PX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PX as text
%        str2double(get(hObject,'String')) returns contents of PX as a double
num = handles.currentpointnum;
handles.sysmodelres.points(num).vect(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BDYLIST.
function BDYLIST_Callback(hObject, eventdata, handles)
% hObject    handle to BDYLIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BDYLIST contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BDYLIST
num = handles.currentpointnum;
handles.sysmodelres.points(num).body = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function BDYLIST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDYLIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PTLABEL_Callback(hObject, eventdata, handles)
% hObject    handle to PTLABEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PTLABEL as text
%        str2double(get(hObject,'String')) returns contents of PTLABEL as a double
num = handles.currentpointnum;
handles.sysmodelres.points(num).label = get(hObject,'String');
handles = refreshdata(handles);
updateparent(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PTLABEL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PTLABEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PY_Callback(hObject, eventdata, handles)
% hObject    handle to PY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PY as text
%        str2double(get(hObject,'String')) returns contents of PY as a double
num = handles.currentpointnum;
handles.sysmodelres.points(num).vect(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PZ_Callback(hObject, eventdata, handles)
% hObject    handle to PZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PZ as text
%        str2double(get(hObject,'String')) returns contents of PZ as a double
num = handles.currentpointnum;
handles.sysmodelres.points(num).vect(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ADDPT.
function ADDPT_Callback(hObject, eventdata, handles)
% hObject    handle to ADDPT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pointnum = length(handles.sysmodelres.points)+1;

if isempty(handles.sysmodelres.points)
    handles.sysmodelres.points= handles.sysmodelres.info.templates.points;
else
    handles.sysmodelres.points(pointnum)= handles.sysmodelres.info.templates.points;
end
handles.sysmodelres.info.numpts = handles.sysmodelres.info.numpts+1;
handles.sysmodelres.points(pointnum).num = pointnum-1;
handles.sysmodelres.points(pointnum).label = 'PNT';
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in DELETEPOINT.
function DELETEPOINT_Callback(hObject, eventdata, handles)
% hObject    handle to DELETEPOINT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pointnum = get(handles.POINTLISTBOX,'Value');

if handles.sysmodelres.info.numpts == 0
    return
end

index = 1;
for x = 1:handles.sysmodelres.info.numpts
    if x ~= pointnum
        temppnt(index) = handles.sysmodelres.points(x);
        temppnt(index).num = index-1;
        index = index+1;
    end
end
if handles.sysmodelres.info.numpts == 1
    handles.sysmodelres.points= [];
else
handles.sysmodelres.points= temppnt;   
end

handles.sysmodelres.info.numpts = handles.sysmodelres.info.numpts-1;
handles.currentpointnum = 1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on selection change in POINTLISTBOX.
function POINTLISTBOX_Callback(hObject, eventdata, handles)
% hObject    handle to POINTLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POINTLISTBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POINTLISTBOX
if isempty(handles.sysmodelres.points) 
    return
end

pointnum = get(hObject,'Value');
pointinfo = handles.sysmodelres.points(pointnum);
handles.currentpointnum = pointnum;

set(handles.PX, 'String',pointinfo.vect(1));
set(handles.PY, 'String',pointinfo.vect(2));
if handles.sysmodelres.info.spatial
    set(handles.PZ, 'String',pointinfo.vect(3));
end
set(handles.BDYLIST, 'Value', pointinfo.body);
set(handles.PTLABEL, 'String',pointinfo.label);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function POINTLISTBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POINTLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MOVEUP.
function MOVEUP_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEUP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pointnum = get(handles.POINTLISTBOX,'Value');
if pointnum == 1 
    return
end
index = 1;
for x = 1:handles.sysmodelres.info.numpts
    if x == pointnum - 1 
        temppoints(index) = handles.sysmodelres.points(x+1);
        temppoints(index).num = index-1;
        index = index+1;
        
        temppoints(index) = handles.sysmodelres.points(x);
        temppoints(index).num = index-1;
        index = index+1;
    
    elseif x ~= pointnum-1 && x ~= pointnum
        temppoints(index) = handles.sysmodelres.points(x);
        temppoints(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodelres.points= temppoints;

handles.currentpointnum = pointnum-1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in MOVEDOWN.
function MOVEDOWN_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEDOWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pointnum = get(handles.POINTLISTBOX,'Value');
if pointnum == length(handles.sysmodelres.points)
    return
end
index = 1;
for x = 1:handles.sysmodelres.info.numpts
    if x == pointnum 
        temppoints(index) = handles.sysmodelres.points(x+1);
        temppoints(index).num = index-1;
        index = index+1;
        
        temppoints(index) = handles.sysmodelres.points(x);
        temppoints(index).num = index-1;
        index = index+1;
    
    elseif x ~= pointnum+1 && x ~= pointnum
        temppoints(index) = handles.sysmodelres.points(x);
        temppoints(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodelres.points= temppoints;

handles.currentpointnum = pointnum+1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);


% --- Executes on button press in EVALPNTS.
function EVALPNTS_Callback(hObject, eventdata, handles)
% hObject    handle to EVALPNTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sysmodelres.info.waitmsg = 'Evaluating Points';
handles.sysmodelres.info.waith = waitbar(0,handles.sysmodelres.info.waitmsg);
handles.sysmodelres.results = ProcessResults( handles.sysmodelres );
close(handles.sysmodelres.info.waith);
updateparent(handles);
guidata(hObject, handles);
