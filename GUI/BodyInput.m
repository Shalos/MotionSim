function varargout = BodyInput(varargin)
% BODYINPUT MATLAB code for BodyInput.fig
%      BODYINPUT, by itself, creates a new BODYINPUT or raises the existing
%      singleton*.
%
%      H = BODYINPUT returns the handle to a new BODYINPUT or the handle to
%      the existing singleton*.
%
%      BODYINPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BODYINPUT.M with the given input arguments.
%
%      BODYINPUT('Property','Value',...) creates a new BODYINPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BodyInput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BodyInput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BodyInput

% Last Modified by GUIDE v2.5 08-Aug-2012 16:55:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BodyInput_OpeningFcn, ...
                   'gui_OutputFcn',  @BodyInput_OutputFcn, ...
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


% --- Executes just before BodyInput is made visible.
function BodyInput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BodyInput (see VARARGIN)

% Choose default command line output for BodyInput
 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.sysmodel = parentdata.sysmodel;

handles.output = hObject;
handles.currentbodynum = 1;
handles = refreshdata(handles);
BDYLISTBOX_Callback(handles.BDYLISTBOX, eventdata, handles);

if ~handles.sysmodel.info.spatial
set(handles.INITZ, 'ENABLE', 'off');
set(handles.INITZD, 'ENABLE', 'off');
set(handles.INITE1, 'ENABLE', 'off');
set(handles.INITE2, 'ENABLE', 'off');
set(handles.INITWX, 'ENABLE', 'off');
set(handles.INITWY, 'ENABLE', 'off');

set(handles.INITIXX, 'ENABLE', 'off');
set(handles.INITIYY, 'ENABLE', 'off');

set(handles.INITFZ, 'ENABLE', 'off');

set(handles.INITTX, 'ENABLE', 'off');
set(handles.INITTY, 'ENABLE', 'off');
end

if ~handles.sysmodel.info.dynamic
  set(handles.INITMASS, 'ENABLE', 'off');
set(handles.INITIZZ, 'ENABLE', 'off');  

set(handles.INITTZ, 'ENABLE', 'off');

set(handles.INITFX, 'ENABLE', 'off');
set(handles.INITFY, 'ENABLE', 'off');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BodyInput wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = refreshdata(handles)
sysmodel = handles.sysmodel;
bdylistboxval = {'none'};
%enumerate list box of bodies
for x = 1:sysmodel.info.bodies
   bdylistboxval{x} = [num2str(sysmodel.body(x).num), '-', sysmodel.body(x).label];
end
set(handles.BDYLISTBOX, 'Value', handles.currentbodynum );

set(handles.BDYLISTBOX,'string', bdylistboxval);

if sysmodel.info.bodies ==0
    SetAllEnable(handles,'off');
else
    SetAllEnable(handles,'on');
end

%pass data back to figure and parent figure
handles.sysmodel = sysmodel;
updateparent(handles);

function SetAllEnable(handles,arg)
set(handles.INITX, 'ENABLE',arg);
set(handles.INITY, 'ENABLE',arg);
set(handles.INITXD, 'ENABLE',arg);
set(handles.INITYD, 'ENABLE',arg);
set(handles.INITE3, 'ENABLE',arg);


set(handles.INITWZ, 'ENABLE',arg);


set(handles.INITMASS, 'ENABLE',arg);


set(handles.INITIZZ, 'ENABLE',arg);

set(handles.INITFX, 'ENABLE',arg);
set(handles.INITFY, 'ENABLE',arg);

set(handles.INITTZ, 'ENABLE',arg);

set(handles.FXGRAV, 'ENABLE',arg);
set(handles.FYGRAV, 'ENABLE',arg);

if handles.sysmodel.info.spatial
    set(handles.FZGRAV, 'ENABLE',arg);
    set(handles.INITZ, 'ENABLE',arg);
     set(handles.INITZD, 'ENABLE',arg);
    set(handles.INITE1, 'ENABLE',arg);
    set(handles.INITE2, 'ENABLE',arg);
    set(handles.INITWX, 'ENABLE',arg);
    set(handles.INITWY, 'ENABLE',arg);
    set(handles.INITIXX, 'ENABLE',arg);
set(handles.INITIYY, 'ENABLE',arg);
set(handles.INITFZ, 'ENABLE',arg);
set(handles.INITTX, 'ENABLE',arg);
set(handles.INITTY, 'ENABLE',arg);
end

function updateparent(handles)
z = guidata(handles.parent);
z.sysmodel = handles.sysmodel;
guidata(handles.parent, z);

% --- Outputs from this function are returned to the command line.
function varargout = BodyInput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ADDBODY.
function ADDBODY_Callback(hObject, eventdata, handles)
% hObject    handle to ADDBODY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bodynum = length(handles.sysmodel.body)+1;
if isempty(handles.sysmodel.body)
    handles.sysmodel.body= handles.sysmodel.info.templates.body;
else
    handles.sysmodel.body(bodynum)= handles.sysmodel.info.templates.body;
end
handles.sysmodel.info.bodies = handles.sysmodel.info.bodies+1;
handles.sysmodel.body(bodynum).num = bodynum-1;
handles.sysmodel.body(bodynum).label = 'BDY';
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);
% --- Executes on button press in DELETEBODY.
function DELETEBODY_Callback(hObject, eventdata, handles)
% hObject    handle to DELETEBODY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bodynum = get(handles.BDYLISTBOX,'Value');
if bodynum == 1
    return
end
index = 1;
for x = 1:handles.sysmodel.info.bodies
    if x ~= bodynum
        tempbodies(index) = handles.sysmodel.body(x);
        tempbodies(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.body= tempbodies;
handles.sysmodel.info.bodies = handles.sysmodel.info.bodies-1;
handles.currentbodynum = 1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BDYLISTBOX.
function BDYLISTBOX_Callback(hObject, eventdata, handles)
% hObject    handle to BDYLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BDYLISTBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BDYLISTBOX

bodynum = get(hObject,'Value');
handles.currentbodynum = bodynum;
if isempty(handles.sysmodel.body)
    return
end
bodyinfo = handles.sysmodel.body(bodynum);
set(handles.BDYNUM, 'String', bodyinfo.num);

set(handles.BDYNAME ,'String', bodyinfo.label);

set(handles.INITX, 'String',bodyinfo.R(1));
set(handles.INITY, 'String',bodyinfo.R(2));

set(handles.INITXD, 'String',bodyinfo.Rd(1));
set(handles.INITYD, 'String',bodyinfo.Rd(2));

set(handles.INITFX, 'String',bodyinfo.Force(1));
set(handles.INITFY, 'String',bodyinfo.Force(2));

if handles.sysmodel.info.spatial
set(handles.INITZ, 'String',bodyinfo.R(3));

set(handles.INITE1, 'String',bodyinfo.P(2));
set(handles.INITE2, 'String',bodyinfo.P(3));
set(handles.INITE3, 'String',bodyinfo.P(4));

set(handles.INITZD, 'String',bodyinfo.Rd(3));

set(handles.INITWX, 'String',bodyinfo.w(1));
set(handles.INITWY, 'String',bodyinfo.w(2));
set(handles.INITWZ, 'String',bodyinfo.w(3));

set(handles.INITIXX, 'String',bodyinfo.I(1));
set(handles.INITIYY, 'String',bodyinfo.I(2));
set(handles.INITIZZ, 'String',bodyinfo.I(3));


set(handles.INITFZ, 'String',bodyinfo.Force(3));

set(handles.INITTX, 'String',bodyinfo.Torque(1));
set(handles.INITTY, 'String',bodyinfo.Torque(2));
set(handles.INITTZ, 'String',bodyinfo.Torque(3));
else
    set(handles.INITE3, 'String',bodyinfo.PHIZ);
    set(handles.INITWZ, 'String',bodyinfo.w);
    set(handles.INITIZZ, 'String',bodyinfo.I);
    set(handles.INITTZ, 'String',bodyinfo.Torque);
end







set(handles.INITMASS, 'String',bodyinfo.M);




%set(handles.BDYENABLED, 'Value',bodyinfo.enabled);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BDYLISTBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDYLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BDYNAME_Callback(hObject, eventdata, handles)
% hObject    handle to BDYNAME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BDYNAME as text
%        str2double(get(hObject,'String')) returns contents of BDYNAME as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).label = get(hObject,'String');
handles = refreshdata(handles);
updateparent(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BDYNAME_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDYNAME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BDYNUM_Callback(hObject, eventdata, handles)
% hObject    handle to BDYNUM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BDYNUM as text
%        str2double(get(hObject,'String')) returns contents of BDYNUM as a double


% --- Executes during object creation, after setting all properties.
function BDYNUM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDYNUM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BDYENABLED.
function BDYENABLED_Callback(hObject, eventdata, handles)
% hObject    handle to BDYENABLED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BDYENABLED



function INITMASS_Callback(hObject, eventdata, handles)
% hObject    handle to INITMASS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITMASS as text
%        str2double(get(hObject,'String')) returns contents of INITMASS as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).M = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITMASS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITMASS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITIXX_Callback(hObject, eventdata, handles)
% hObject    handle to INITIXX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITIXX as text
%        str2double(get(hObject,'String')) returns contents of INITIXX as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).I(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITIXX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITIXX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITIYY_Callback(hObject, eventdata, handles)
% hObject    handle to INITIYY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITIYY as text
%        str2double(get(hObject,'String')) returns contents of INITIYY as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).I(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITIYY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITIYY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITIZZ_Callback(hObject, eventdata, handles)
% hObject    handle to INITIZZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITIZZ as text
%        str2double(get(hObject,'String')) returns contents of INITIZZ as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).I(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITIZZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITIZZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function INITX_Callback(hObject, eventdata, handles)
% hObject    handle to INITX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITX as text
%        str2double(get(hObject,'String')) returns contents of INITX as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).R(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITY_Callback(hObject, eventdata, handles)
% hObject    handle to INITY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITY as text
%        str2double(get(hObject,'String')) returns contents of INITY as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).R(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITZ_Callback(hObject, eventdata, handles)
% hObject    handle to INITZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITZ as text
%        str2double(get(hObject,'String')) returns contents of INITZ as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).R(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITE1_Callback(hObject, eventdata, handles)
% hObject    handle to INITE1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITE1 as text
%        str2double(get(hObject,'String')) returns contents of INITE1 as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).P(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITE1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITE1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITE2_Callback(hObject, eventdata, handles)
% hObject    handle to INITE2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITE2 as text
%        str2double(get(hObject,'String')) returns contents of INITE2 as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).P(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITE2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITE2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITE3_Callback(hObject, eventdata, handles)
% hObject    handle to INITE3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITE3 as text
%        str2double(get(hObject,'String')) returns contents of INITE3 as a double
num = handles.currentbodynum;
if handles.sysmodel.info.spatial
handles.sysmodel.body(num).P(4) = str2double(get(hObject,'String'));
else
    handles.sysmodel.body(num).PHIZ = str2double(get(hObject,'String'));
end

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITE3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITE3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITXD_Callback(hObject, eventdata, handles)
% hObject    handle to INITXD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITXD as text
%        str2double(get(hObject,'String')) returns contents of INITXD as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).Rd(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITXD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITXD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITYD_Callback(hObject, eventdata, handles)
% hObject    handle to INITYD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITYD as text
%        str2double(get(hObject,'String')) returns contents of INITYD as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).Rd(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITYD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITYD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITZD_Callback(hObject, eventdata, handles)
% hObject    handle to INITZD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITZD as text
%        str2double(get(hObject,'String')) returns contents of INITZD as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).Rd(3) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITZD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITZD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITWX_Callback(hObject, eventdata, handles)
% hObject    handle to INITWX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITWX as text
%        str2double(get(hObject,'String')) returns contents of INITWX as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).w(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITWX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITWX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITWY_Callback(hObject, eventdata, handles)
% hObject    handle to INITWY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITWY as text
%        str2double(get(hObject,'String')) returns contents of INITWY as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).w(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITWY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITWY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITWZ_Callback(hObject, eventdata, handles)
% hObject    handle to INITWZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITWZ as text
%        str2double(get(hObject,'String')) returns contents of INITWZ as a double
num = handles.currentbodynum;
if handles.sysmodel.info.spatial
handles.sysmodel.body(num).w(3) = str2double(get(hObject,'String'));
else
 handles.sysmodel.body(num).w = str2double(get(hObject,'String'));   
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITWZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITWZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



function INITFX_Callback(hObject, eventdata, handles)
% hObject    handle to INITFX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITFX as text
%        str2double(get(hObject,'String')) returns contents of INITFX as a double
num = handles.currentbodynum;

if ~get(handles.FXGRAV,'Value')
    set(handles.FXFIN, 'String', get(hObject,'String'));
else
    mass = str2double(get(handles.INITMASS,'String'));
    set(handles.FXFIN, 'String', ...
        str2double(get(hObject,'String'))+mass*handles.sysmodel.info.units.G);
end
handles.sysmodel.body(num).Force(1) = str2double(get(handles.FXFIN,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITFX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITFX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITFY_Callback(hObject, eventdata, handles)
% hObject    handle to INITFY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITFY as text
%        str2double(get(hObject,'String')) returns contents of INITFY as a double
num = handles.currentbodynum;

if ~get(handles.FYGRAV,'Value')
    set(handles.FYFIN, 'String', get(handles.INITFY,'String'));
else
    mass = str2double(get(handles.INITMASS,'String'));
    set(handles.FYFIN, 'String', ...
        str2double(get(handles.INITFY,'String'))+mass*handles.sysmodel.info.units.G);
end
handles.sysmodel.body(num).Force(2) = str2double(get(handles.FYFIN,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITFY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITFY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITFZ_Callback(hObject, eventdata, handles)
% hObject    handle to INITFZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITFZ as text
%        str2double(get(hObject,'String')) returns contents of INITFZ as a double
num = handles.currentbodynum;

if ~get(handles.FZGRAV,'Value')
    set(handles.FZFIN, 'String', get(handles.INITFZ,'String'));
else
    mass = str2double(get(handles.INITMASS,'String'));
    set(handles.FZFIN, 'String', ...
        str2double(get(handles.INITFZ,'String'))+mass*handles.sysmodel.info.units.G);
end
handles.sysmodel.body(num).Force(3) = str2double(get(handles.FZFIN,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITFZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITFZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITTX_Callback(hObject, eventdata, handles)
% hObject    handle to INITTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITTX as text
%        str2double(get(hObject,'String')) returns contents of INITTX as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).Torque(1) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITTX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITTY_Callback(hObject, eventdata, handles)
% hObject    handle to INITTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITTY as text
%        str2double(get(hObject,'String')) returns contents of INITTY as a double
num = handles.currentbodynum;
handles.sysmodel.body(num).Torque(2) = str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITTY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITTZ_Callback(hObject, eventdata, handles)
% hObject    handle to INITTZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITTZ as text
%        str2double(get(hObject,'String')) returns contents of INITTZ as a double
num = handles.currentbodynum;
if handles.sysmodel.info.spatial
handles.sysmodel.body(num).Torque(3) = str2double(get(hObject,'String'));
else
   handles.sysmodel.body(num).Torque = str2double(get(hObject,'String')); 
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITTZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITTZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FXFIN_Callback(hObject, eventdata, handles)
% hObject    handle to FXFIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FXFIN as text
%        str2double(get(hObject,'String')) returns contents of FXFIN as a double


% --- Executes during object creation, after setting all properties.
function FXFIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FXFIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FYFIN_Callback(hObject, eventdata, handles)
% hObject    handle to FYFIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FYFIN as text
%        str2double(get(hObject,'String')) returns contents of FYFIN as a double


% --- Executes during object creation, after setting all properties.
function FYFIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FYFIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FZFIN_Callback(hObject, eventdata, handles)
% hObject    handle to FZFIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FZFIN as text
%        str2double(get(hObject,'String')) returns contents of FZFIN as a double


% --- Executes during object creation, after setting all properties.
function FZFIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FZFIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FXGRAV.
function FXGRAV_Callback(hObject, eventdata, handles)
% hObject    handle to FXGRAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FXGRAV
num = handles.currentbodynum;

if ~get(handles.FXGRAV,'Value')
    set(handles.FXFIN, 'String', get(handles.INITFX,'String'));
else
    mass = str2double(get(handles.INITMASS,'String'));
    set(handles.FXFIN, 'String', ...
        str2double(get(handles.INITFX,'String'))+mass*handles.sysmodel.info.units.G);
end
handles.sysmodel.body(num).Force(1) = str2double(get(handles.FXFIN,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes on button press in FYGRAV.
function FYGRAV_Callback(hObject, eventdata, handles)
% hObject    handle to FYGRAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FYGRAV
num = handles.currentbodynum;

if ~get(handles.FYGRAV,'Value')
    set(handles.FYFIN, 'String', get(handles.INITFY,'String'));
else
    mass = str2double(get(handles.INITMASS,'String'));
    set(handles.FYFIN, 'String', ...
        str2double(get(handles.INITFY,'String'))+mass*handles.sysmodel.info.units.G);
end
handles.sysmodel.body(num).Force(2) = str2double(get(handles.FYFIN,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes on button press in FZGRAV.
function FZGRAV_Callback(hObject, eventdata, handles)
% hObject    handle to FZGRAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FZGRAV
num = handles.currentbodynum;

if ~get(handles.FZGRAV,'Value')
    set(handles.FZFIN, 'String', get(handles.INITFZ,'String'));
else
    mass = str2double(get(handles.INITMASS,'String'));
    set(handles.FZFIN, 'String', ...
        str2double(get(handles.INITFZ,'String'))+mass*handles.sysmodel.info.units.G);
end
handles.sysmodel.body(num).Force(3) = str2double(get(handles.FZFIN,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes on button press in EXITBTN.
function EXITBTN_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes when selected object is changed in BDYTYPEPANEL.
function BDYTYPEPANEL_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in BDYTYPEPANEL 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
%if get(handles.BDYTYPE3D, 'Value')
%    handles.sysmodel.info.spatial = 1;
%else
%    handles.sysmodel.info.spatial = 0;
%end
%handles = refreshdata(handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
varargout{1} = handles.sysmodel;
delete(hObject);


% --- Executes on button press in MOVEUP.
function MOVEUP_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEUP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bodynum = get(handles.BDYLISTBOX,'Value');
if bodynum == 1 || bodynum == 2
    return
end
index = 1;
for x = 1:handles.sysmodel.info.bodies
    if x == bodynum - 1 
        tempbodies(index) = handles.sysmodel.body(x+1);
        tempbodies(index).num = index-1;
        index = index+1;
        
        tempbodies(index) = handles.sysmodel.body(x);
        tempbodies(index).num = index-1;
        index = index+1;
    
    elseif x ~= bodynum-1 && x ~= bodynum
        tempbodies(index) = handles.sysmodel.body(x);
        tempbodies(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.body= tempbodies;

handles.currentbodynum = bodynum-1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in MOVEDOWN.
function MOVEDOWN_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEDOWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bodynum = get(handles.BDYLISTBOX,'Value');
if bodynum == 1 || bodynum == handles.sysmodel.info.bodies
    return
end
index = 1;
for x = 1:handles.sysmodel.info.bodies
    if x == bodynum 
        tempbodies(index) = handles.sysmodel.body(x+1);
        tempbodies(index).num = index-1;
        index = index+1;
        
        tempbodies(index) = handles.sysmodel.body(x);
        tempbodies(index).num = index-1;
        index = index+1;
    
    elseif x ~= bodynum+1 && x ~= bodynum
        tempbodies(index) = handles.sysmodel.body(x);
        tempbodies(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.body= tempbodies;

handles.currentbodynum = bodynum+1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);
