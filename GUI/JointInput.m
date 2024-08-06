function varargout = JointInput(varargin)
% JOINTINPUT MATLAB code for JointInput.fig
%      JOINTINPUT, by itself, creates a new JOINTINPUT or raises the existing
%      singleton*.
%
%      H = JOINTINPUT returns the handle to a new JOINTINPUT or the handle to
%      the existing singleton*.
%
%      JOINTINPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JOINTINPUT.M with the given input arguments.
%
%      JOINTINPUT('Property','Value',...) creates a new JOINTINPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before JointInput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to JointInput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help JointInput

% Last Modified by GUIDE v2.5 28-Jul-2012 09:56:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @JointInput_OpeningFcn, ...
                   'gui_OutputFcn',  @JointInput_OutputFcn, ...
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


% --- Executes just before JointInput is made visible.
function JointInput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to JointInput (see VARARGIN)

% Choose default command line output for JointInput
 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
 handles.bodyi = 1;
 handles.bodyj = 1;
parentdata = guidata(handles.parent);
handles.sysmodel = parentdata.sysmodel;
handles.currentjointnum = 1;
if handles.sysmodel.info.spatial
    handles.jointnames = {'Spherical'; 'Revolute'; 'Cylindrical'; 'S-S'; 'Prismatic'};
else
     handles.jointnames = {'Revolute'; 'Translational';};
end

handles.output = hObject;

handles = refreshdata(handles);

if ~handles.sysmodel.info.spatial
    set(handles.PIZ, 'ENABLE', 'off');
    set(handles.QIZ, 'ENABLE', 'off');
    set(handles.PJZ, 'ENABLE', 'off');
    set(handles.QJZ, 'ENABLE', 'off');
end

if ~handles.sysmodel.info.dynamic
    set(handles.ALPHA, 'ENABLE', 'off');
    set(handles.BETA, 'ENABLE', 'off');
end

JOINTLISTBOX_Callback(handles.JOINTLISTBOX, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes JointInput wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function handles = refreshdata(handles)
sysmodel = handles.sysmodel;
jointlistboxval = {'none'};
%enumerate list box of bodies
for x = 1:sysmodel.info.joints
    jointlistboxval{x} = [ num2str(sysmodel.joint(x).num), '-', sysmodel.joint(x).label];
end
set(handles.JOINTLISTBOX, 'Value', handles.currentjointnum);
set(handles.JOINTLISTBOX,'string', jointlistboxval);

if sysmodel.info.joints ==0
    SetAllEnable(handles,'off');
else
    SetAllEnable(handles,'on');
end

set(handles.ALPHA,'string', sysmodel.info.alpha);
set(handles.BETA,'string',  sysmodel.info.beta);

%enumerate bodies
handles.bodylist = {'none'};
%enumerate list box of bodies
for x = 1:sysmodel.info.bodies
    
   handles.bodylist{x} = [num2str(sysmodel.body(x).num), '-', sysmodel.body(x).label];
  
end
set(handles.BODYISELECT,'String', handles.bodylist);
set(handles.BODYJSELECT,'String', handles.bodylist);
set(handles.BODYISELECT,'Value', handles.bodyi);
set(handles.BODYJSELECT,'Value', handles.bodyj);
set(handles.JOINTTYPE,'String', handles.jointnames);

%pass data back to figure and parent figure
handles.sysmodel = sysmodel;
updateparent(handles);

function SetAllEnable(handles,arg)
set(handles.PIX, 'ENABLE',arg);
set(handles.PIY, 'ENABLE',arg);
set(handles.PJX, 'ENABLE',arg);
set(handles.PJY, 'ENABLE',arg);

set(handles.QIX, 'ENABLE',arg);
set(handles.QIY, 'ENABLE',arg);
set(handles.QJX, 'ENABLE',arg);
set(handles.QJY, 'ENABLE',arg);

set(handles.BODYISELECT, 'ENABLE',arg);
set(handles.BODYJSELECT, 'ENABLE',arg);


set(handles.JOINTTYPE, 'ENABLE',arg);
set(handles.LENGTH, 'ENABLE',arg);
set(handles.CNSTLABEL, 'ENABLE',arg);
set(handles.ALPHA, 'ENABLE',arg);
set(handles.BETA, 'ENABLE',arg);
if handles.sysmodel.info.spatial
    set(handles.PIZ, 'ENABLE',arg);
    set(handles.PJZ, 'ENABLE',arg);
    set(handles.QIZ, 'ENABLE',arg);
    set(handles.QJZ, 'ENABLE',arg);
end

function updateparent(handles)
z = guidata(handles.parent);
z.sysmodel = handles.sysmodel;
guidata(handles.parent, z);

% --- Outputs from this function are returned to the command line.
function varargout = JointInput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in JOINTTYPE.
function JOINTTYPE_Callback(hObject, eventdata, handles)
% hObject    handle to JOINTTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns JOINTTYPE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from JOINTTYPE
num = handles.currentjointnum;
handles.sysmodel.joint(num).Type = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function JOINTTYPE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JOINTTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LENGTH_Callback(hObject, eventdata, handles)
% hObject    handle to LENGTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LENGTH as text
%        str2double(get(hObject,'String')) returns contents of LENGTH as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).L = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function LENGTH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LENGTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QJZ_Callback(hObject, eventdata, handles)
% hObject    handle to QJZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QJZ as text
%        str2double(get(hObject,'String')) returns contents of QJZ as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).qj(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function QJZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QJZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QJY_Callback(hObject, eventdata, handles)
% hObject    handle to QJY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QJY as text
%        str2double(get(hObject,'String')) returns contents of QJY as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).qj(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function QJY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QJY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QJX_Callback(hObject, eventdata, handles)
% hObject    handle to QJX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QJX as text
%        str2double(get(hObject,'String')) returns contents of QJX as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).qj(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function QJX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QJX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PJZ_Callback(hObject, eventdata, handles)
% hObject    handle to PJZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PJZ as text
%        str2double(get(hObject,'String')) returns contents of PJZ as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).pj(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PJZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PJZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PJY_Callback(hObject, eventdata, handles)
% hObject    handle to PJY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PJY as text
%        str2double(get(hObject,'String')) returns contents of PJY as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).pj(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PJY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PJY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PJX_Callback(hObject, eventdata, handles)
% hObject    handle to PJX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PJX as text
%        str2double(get(hObject,'String')) returns contents of PJX as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).pj(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PJX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PJX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BODYJSELECT.
function BODYJSELECT_Callback(hObject, eventdata, handles)
% hObject    handle to BODYJSELECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BODYJSELECT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BODYJSELECT
num = handles.currentjointnum;
handles.sysmodel.joint(num).Bodyj = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BODYJSELECT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BODYJSELECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GROUNDJ.
function GROUNDJ_Callback(hObject, eventdata, handles)
% hObject    handle to GROUNDJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GROUNDJ



function PIX_Callback(hObject, eventdata, handles)
% hObject    handle to PIX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PIX as text
%        str2double(get(hObject,'String')) returns contents of PIX as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).pi(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PIX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PIX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PIY_Callback(hObject, eventdata, handles)
% hObject    handle to PIY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PIY as text
%        str2double(get(hObject,'String')) returns contents of PIY as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).pi(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PIY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PIY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PIZ_Callback(hObject, eventdata, handles)
% hObject    handle to PIZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PIZ as text
%        str2double(get(hObject,'String')) returns contents of PIZ as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).pi(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PIZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PIZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QIX_Callback(hObject, eventdata, handles)
% hObject    handle to QIX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QIX as text
%        str2double(get(hObject,'String')) returns contents of QIX as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).qi(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function QIX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QIX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QIY_Callback(hObject, eventdata, handles)
% hObject    handle to QIY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QIY as text
%        str2double(get(hObject,'String')) returns contents of QIY as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).qi(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function QIY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QIY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QIZ_Callback(hObject, eventdata, handles)
% hObject    handle to QIZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QIZ as text
%        str2double(get(hObject,'String')) returns contents of QIZ as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).qi(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function QIZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QIZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ADDJOINT.
function ADDJOINT_Callback(hObject, eventdata, handles)
% hObject    handle to ADDJOINT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cnstnum = length(handles.sysmodel.joint)+1;

if isempty(handles.sysmodel.joint)
    handles.sysmodel.joint= handles.sysmodel.info.templates.joint;
else
    handles.sysmodel.joint(cnstnum)= handles.sysmodel.info.templates.joint;
end
handles.sysmodel.info.joints = handles.sysmodel.info.joints+1;
handles.sysmodel.joint(cnstnum).num = cnstnum-1;
handles.sysmodel.joint(cnstnum).label = 'CNST';
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in DELETJOINT.
function DELETJOINT_Callback(hObject, eventdata, handles)
% hObject    handle to DELETJOINT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cnstnum = get(handles.JOINTLISTBOX,'Value');

if handles.sysmodel.info.joints == 0
    return
end

index = 1;
for x = 1:handles.sysmodel.info.joints
    if x ~= cnstnum
        tempcnst(index) = handles.sysmodel.joint(x);
        tempcnst(index).num = index-1;
        index = index+1;
    end
end
if handles.sysmodel.info.joints == 1
    handles.sysmodel.joint= [];
else
handles.sysmodel.joint= tempcnst;   
end

handles.sysmodel.info.joints = handles.sysmodel.info.joints-1;
handles.currentjointnum = 1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on selection change in JOINTLISTBOX.
function JOINTLISTBOX_Callback(hObject, eventdata, handles)
% hObject    handle to JOINTLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns JOINTLISTBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from JOINTLISTBOX
if isempty(handles.sysmodel.joint) 
    return
end

jointnum = get(hObject,'Value');
jointinfo = handles.sysmodel.joint(jointnum);
handles.currentjointnum = jointnum;
set(handles.CNSTLABEL, 'String',jointinfo.label);

set(handles.PIX, 'String',jointinfo.pi(1));
set(handles.PIY, 'String',jointinfo.pi(2));

set(handles.LENGTH,'String',jointinfo.L);
set(handles.QIX, 'String',jointinfo.qi(1));
set(handles.QIY, 'String',jointinfo.qi(2));


set(handles.PJX, 'String',jointinfo.pj(1));
set(handles.PJY, 'String',jointinfo.pj(2));


set(handles.QJX, 'String',jointinfo.qj(1));
set(handles.QJY, 'String',jointinfo.qj(2));

if handles.sysmodel.info.spatial
    set(handles.PIZ, 'String',jointinfo.pi(3));
    set(handles.QIZ, 'String',jointinfo.qi(3));
    set(handles.PJZ, 'String',jointinfo.pj(3));
  set(handles.QJZ, 'String',jointinfo.qj(3));  
end
set(handles.BODYISELECT, 'Value', jointinfo.Bodyi);
set(handles.BODYJSELECT, 'Value', jointinfo.Bodyj);

set(handles.JOINTTYPE,'Value', jointinfo.Type);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function JOINTLISTBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JOINTLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EXIT.
function EXIT_Callback(hObject, eventdata, handles)
% hObject    handle to EXIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf);

function ALPHA_Callback(hObject, eventdata, handles)
% hObject    handle to ALPHA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ALPHA as text
%        str2double(get(hObject,'String')) returns contents of ALPHA as a double

handles.sysmodel.info.alpha = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ALPHA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ALPHA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BETA_Callback(hObject, eventdata, handles)
% hObject    handle to BETA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BETA as text
%        str2double(get(hObject,'String')) returns contents of BETA as a double
handles.sysmodel.info.beta = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BETA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BETA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BODYISELECT.
function BODYISELECT_Callback(hObject, eventdata, handles)
% hObject    handle to BODYISELECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BODYISELECT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BODYISELECT
num = handles.currentjointnum;
handles.sysmodel.joint(num).Bodyi = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function BODYISELECT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BODYISELECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in JOINTENABLED.
function JOINTENABLED_Callback(hObject, eventdata, handles)
% hObject    handle to JOINTENABLED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of JOINTENABLED


% --- Executes on button press in MOVEUP.
function MOVEUP_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEUP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cnstnum = get(handles.JOINTLISTBOX,'Value');
if cnstnum == 1 
    return
end
index = 1;
for x = 1:handles.sysmodel.info.joints
    if x == cnstnum - 1 
        tempcnst(index) = handles.sysmodel.joint(x+1);
        tempcnst(index).num = index-1;
        index = index+1;
        
        tempcnst(index) = handles.sysmodel.joint(x);
        tempcnst(index).num = index-1;
        index = index+1;
    
    elseif x ~= cnstnum-1 && x ~= cnstnum
        tempcnst(index) = handles.sysmodel.joint(x);
        tempcnst(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.joint= tempcnst;

handles.currentjointnum = cnstnum-1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in MOVEDOWN.
function MOVEDOWN_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEDOWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cnstnum = get(handles.JOINTLISTBOX,'Value');
if cnstnum == length(handles.sysmodel.joint)
    return
end
index = 1;
for x = 1:handles.sysmodel.info.joints
    if x == cnstnum 
        tempcnst(index) = handles.sysmodel.joint(x+1);
        tempcnst(index).num = index-1;
        index = index+1;
        
        tempcnst(index) = handles.sysmodel.joint(x);
        tempcnst(index).num = index-1;
        index = index+1;
    
    elseif x ~= cnstnum+1 && x ~= cnstnum
        tempcnst(index) = handles.sysmodel.joint(x);
        tempcnst(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.joint= tempcnst;

handles.currentjointnum = cnstnum+1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);


function CNSTLABEL_Callback(hObject, eventdata, handles)
% hObject    handle to CNSTLABEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CNSTLABEL as text
%        str2double(get(hObject,'String')) returns contents of CNSTLABEL as a double
num = handles.currentjointnum;
handles.sysmodel.joint(num).label = get(hObject,'String');
handles = refreshdata(handles);
updateparent(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function CNSTLABEL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CNSTLABEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
