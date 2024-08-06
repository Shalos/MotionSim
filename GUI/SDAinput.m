function varargout = SDAinput(varargin)
% SDAINPUT MATLAB code for SDAinput.fig
%      SDAINPUT, by itself, creates a new SDAINPUT or raises the existing
%      singleton*.
%
%      H = SDAINPUT returns the handle to a new SDAINPUT or the handle to
%      the existing singleton*.
%
%      SDAINPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SDAINPUT.M with the given input arguments.
%
%      SDAINPUT('Property','Value',...) creates a new SDAINPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SDAinput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SDAinput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SDAinput

% Last Modified by GUIDE v2.5 08-Aug-2012 17:32:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SDAinput_OpeningFcn, ...
                   'gui_OutputFcn',  @SDAinput_OutputFcn, ...
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


% --- Executes just before SDAinput is made visible.
function SDAinput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SDAinput (see VARARGIN)

% Choose default command line output for SDAinput
 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.sysmodel = parentdata.sysmodel;
 handles.bodyi = 1;
 handles.bodyj = 1;
handles.output = hObject;
handles.currentSDAnum = 1;



if ~handles.sysmodel.info.spatial
   set(handles.PZi, 'ENABLE','off');
   set(handles.PZj, 'ENABLE','off');

end
handles = refreshdata(handles);
SDALIST_Callback(handles.SDALIST, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SDAinput wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function handles = refreshdata(handles)
sysmodel = handles.sysmodel;
SDAlistboxval = {'none'};
%enumerate list box of bodies
for x = 1:sysmodel.info.numSDA
    
   SDAlistboxval{x} = [num2str(sysmodel.SDA(x).num), '-', sysmodel.SDA(x).label];
  
end
set(handles.SDALIST,'String', SDAlistboxval);
set(handles.SDALIST, 'Value', handles.currentSDAnum );

if sysmodel.info.numSDA == 0
    SetAllEnable(handles,'off');
else
    SetAllEnable(handles,'on');
end

%enumerate bodies
handles.bodylist = {'none'};
%enumerate list box of bodies
for x = 1:sysmodel.info.bodies
    
   handles.bodylist{x} = [num2str(sysmodel.body(x).num), '-', sysmodel.body(x).label];
  
end
set(handles.Bodyi,'String', handles.bodylist);
set(handles.Bodyj,'String', handles.bodylist);
set(handles.Bodyi,'Value', handles.bodyi);
set(handles.Bodyj,'Value', handles.bodyj);




%pass data back to figure and parent figure
handles.sysmodel = sysmodel;
updateparent(handles);

function SetAllEnable(handles,arg)
set(handles.l, 'ENABLE',arg);
set(handles.k, 'ENABLE',arg);
set(handles.c, 'ENABLE',arg);
set(handles.f, 'ENABLE',arg);
set(handles.SDALabel, 'ENABLE',arg);

set(handles.Bodyj, 'ENABLE',arg);
set(handles.Bodyi, 'ENABLE',arg);
set(handles.PXj, 'ENABLE',arg);
set(handles.PXi, 'ENABLE',arg);
set(handles.PYj, 'ENABLE',arg);
set(handles.PYi, 'ENABLE',arg);
if handles.sysmodel.info.spatial
    set(handles.PZj, 'ENABLE',arg);
    set(handles.PZi, 'ENABLE',arg);
end
function updateparent(handles)
z = guidata(handles.parent);
z.sysmodel = handles.sysmodel;
guidata(handles.parent, z);

% --- Outputs from this function are returned to the command line.
function varargout = SDAinput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function k_Callback(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k as text
%        str2double(get(hObject,'String')) returns contents of k as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).k =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function l_Callback(hObject, eventdata, handles)
% hObject    handle to l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l as text
%        str2double(get(hObject,'String')) returns contents of l as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).initL =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function l_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_Callback(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c as text
%        str2double(get(hObject,'String')) returns contents of c as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).c =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).f =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enable.
function enable_Callback(hObject, eventdata, handles)
% hObject    handle to enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).enable = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);


function SDALabel_Callback(hObject, eventdata, handles)
% hObject    handle to SDALabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SDALabel as text
%        str2double(get(hObject,'String')) returns contents of SDALabel as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).label =get(hObject,'String');
handles = refreshdata(handles);
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SDALabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SDALabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PZj_Callback(hObject, eventdata, handles)
% hObject    handle to PZj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PZj as text
%        str2double(get(hObject,'String')) returns contents of PZj as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).pj(3) =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PZj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PZj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PYj_Callback(hObject, eventdata, handles)
% hObject    handle to PYj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PYj as text
%        str2double(get(hObject,'String')) returns contents of PYj as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).pj(2) =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PYj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PYj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PXj_Callback(hObject, eventdata, handles)
% hObject    handle to PXj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PXj as text
%        str2double(get(hObject,'String')) returns contents of PXj as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).pj(1) =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PXj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PXj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Bodyj.
function Bodyj_Callback(hObject, eventdata, handles)
% hObject    handle to Bodyj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Bodyj contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Bodyj
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).Bodyj = get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Bodyj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bodyj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PXi_Callback(hObject, eventdata, handles)
% hObject    handle to PXi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PXi as text
%        str2double(get(hObject,'String')) returns contents of PXi as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).pi(1) =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PXi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PXi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PYi_Callback(hObject, eventdata, handles)
% hObject    handle to PYi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PYi as text
%        str2double(get(hObject,'String')) returns contents of PYi as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).pi(2) =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PYi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PYi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PZi_Callback(hObject, eventdata, handles)
% hObject    handle to PZi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PZi as text
%        str2double(get(hObject,'String')) returns contents of PZi as a double
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).pi(3) =str2double(get(hObject,'String'));

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PZi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PZi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Bodyi.
function Bodyi_Callback(hObject, eventdata, handles)
% hObject    handle to Bodyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Bodyi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Bodyi
num = handles.currentSDAnum;
handles.sysmodel.SDA(num).Bodyi =get(hObject,'Value');

updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Bodyi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bodyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ADDSDA.
function ADDSDA_Callback(hObject, eventdata, handles)
% hObject    handle to ADDSDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sdanum = length(handles.sysmodel.SDA)+1;

if isempty(handles.sysmodel.SDA)
    handles.sysmodel.SDA= handles.sysmodel.info.templates.SDA;
else
    handles.sysmodel.SDA(sdanum)= handles.sysmodel.info.templates.SDA;
end
handles.sysmodel.info.numSDA = handles.sysmodel.info.numSDA+1;
handles.sysmodel.SDA(sdanum).num = sdanum-1;
handles.sysmodel.SDA(sdanum).label = 'SDA';
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);


% --- Executes on button press in DELETESDA.
function DELETESDA_Callback(hObject, eventdata, handles)
% hObject    handle to DELETESDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sdanum = get(handles.SDALIST,'Value');

if handles.sysmodel.info.numSDA == 0
    return
end

index = 1;
for x = 1:handles.sysmodel.info.numSDA
    if x ~= sdanum
        tempSDA(index) = handles.sysmodel.SDA(x);
        tempSDA(index).num = index-1;
        index = index+1;
    end
end
if handles.sysmodel.info.numSDA == 1
    handles.sysmodel.SDA= [];
else
handles.sysmodel.SDA= tempSDA;   
end

handles.sysmodel.info.numSDA = handles.sysmodel.info.numSDA-1;
handles.currentSDAnum = 1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on selection change in SDALIST.
function SDALIST_Callback(hObject, eventdata, handles)
% hObject    handle to SDALIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SDALIST contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SDALIST
SDAnum = get(hObject,'Value');
handles.currentSDAnum = SDAnum;
if isempty(handles.sysmodel.SDA)
    return
end
SDAinfo = handles.sysmodel.SDA(SDAnum);

set(handles.l, 'String', SDAinfo.initL);
set(handles.c, 'String', SDAinfo.c);
set(handles.k, 'String', SDAinfo.k);
set(handles.f, 'String', SDAinfo.f);

set(handles.PXi, 'String', SDAinfo.pi(1));
set(handles.PYi, 'String', SDAinfo.pi(2));


set(handles.PXj, 'String', SDAinfo.pj(1));
set(handles.PYj, 'String', SDAinfo.pj(2));

if handles.sysmodel.info.spatial
    set(handles.PZi, 'String', SDAinfo.pi(3));
    set(handles.PZj, 'String', SDAinfo.pj(3));
end

set(handles.Bodyi, 'Value', SDAinfo.Bodyi);

set(handles.Bodyj, 'Value', SDAinfo.Bodyj);

set(handles.SDALabel, 'String', SDAinfo.label);
set(handles.enable, 'Value', SDAinfo.enable);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SDALIST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SDALIST (see GCBO)
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
close(gcf)


% --- Executes on button press in MOVEUP.
function MOVEUP_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEUP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sdanum = get(handles.SDALIST,'Value');
if sdanum == 1 
    return
end
index = 1;
for x = 1:handles.sysmodel.info.numSDA
    if x == sdanum - 1 
        tempSDA(index) = handles.sysmodel.SDA(x+1);
        tempSDA(index).num = index-1;
        index = index+1;
        
        tempSDA(index) = handles.sysmodel.SDA(x);
        tempSDA(index).num = index-1;
        index = index+1;
    
    elseif x ~= sdanum-1 && x ~= sdanum
        tempSDA(index) = handles.sysmodel.SDA(x);
        tempSDA(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.SDA= tempSDA;

handles.currentSDAnum = sdanum-1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);

% --- Executes on button press in MOVEDOWN.
function MOVEDOWN_Callback(hObject, eventdata, handles)
% hObject    handle to MOVEDOWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sdanum = get(handles.SDALIST,'Value');
if sdanum == length(handles.sysmodel.SDA)
    return
end
index = 1;
for x = 1:handles.sysmodel.info.numSDA
    if x == sdanum 
        tempSDA(index) = handles.sysmodel.SDA(x+1);
        tempSDA(index).num = index-1;
        index = index+1;
        
        tempSDA(index) = handles.sysmodel.SDA(x);
        tempSDA(index).num = index-1;
        index = index+1;
    
    elseif x ~= sdanum+1 && x ~= sdanum
        tempSDA(index) = handles.sysmodel.SDA(x);
        tempSDA(index).num = index-1;
        index = index+1;
    end
end

handles.sysmodel.SDA= tempSDA;

handles.currentSDAnum = sdanum+1;
handles = refreshdata(handles);

updateparent(handles);

guidata(hObject, handles);
