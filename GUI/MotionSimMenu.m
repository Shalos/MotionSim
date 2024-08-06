function varargout = MotionSimMenu(varargin)
% MOTIONSIMMENU MATLAB code for MotionSimMenu.fig
%      MOTIONSIMMENU, by itself, creates a new MOTIONSIMMENU or raises the existing
%      singleton*.
%
%      H = MOTIONSIMMENU returns the handle to a new MOTIONSIMMENU or the handle to
%      the existing singleton*.
%
%      MOTIONSIMMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTIONSIMMENU.M with the given input arguments.
%
%      MOTIONSIMMENU('Property','Value',...) creates a new MOTIONSIMMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotionSimMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotionSimMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotionSimMenu

% Last Modified by GUIDE v2.5 15-Sep-2012 19:20:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotionSimMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @MotionSimMenu_OutputFcn, ...
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


% --- Executes just before MotionSimMenu is made visible.
function MotionSimMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotionSimMenu (see VARARGIN)

% Choose default command line output for MotionSimMenu
handles.output = hObject;
handles = updatelistbox(handles);
handles.msg = [];
handles.newmodel = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotionSimMenu wait for user response (see UIRESUME)
% uiwait(handles.MotionSimMenu);
function handles = updatelistbox(handles)

if get(handles.XLSRADIO,'Value')
    filenames = dir('Models/*.xlsx');
elseif get(handles.MATRADIO,'Value')
    filenames = dir('Models/*.mat');
elseif get(handles.MDLRADIO,'Value')
    filenames = dir('Simulink/*.mdl');
end

handles.names = {};
for x = 1:length(filenames)
    handles.names = [handles.names, filenames(x,1).name];
end
set(handles.FILEBOX, 'Value', 1);
set(handles.FILEBOX,'string', handles.names);



% --- Outputs from this function are returned to the command line.
function varargout = MotionSimMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in FILEBOX.
function FILEBOX_Callback(hObject, eventdata, handles)
% hObject    handle to FILEBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FILEBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FILEBOX


% --- Executes during object creation, after setting all properties.
function FILEBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FILEBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SIMBTN.
function SIMBTN_Callback(hObject, eventdata, handles)
% hObject    handle to SIMBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sysmodel = handles.sysmodel;
save(strcat('Models\',sysmodel.info.name,'.mat'),'sysmodel');
handles.sysmodel = SolverSelect(handles.sysmodel);
enableanalysis(handles, handles.sysmodel.info.name);
handles.sysmodelres = handles.sysmodel;
guidata(hObject, handles);

function enableanalysis(handles, filename)
set(handles.text4,'String', ['Loaded: ' filename])
set(handles.SAVEASRES,'ENABLE','on');
set(handles.POINTSBTN,'ENABLE','on');
set(handles.PLOTBTN,'ENABLE','on');
set(handles.FREQBTN,'ENABLE','on');
set(handles.ANIMATEBTN,'ENABLE','on');

% --- Executes on button press in SYSPARAMBTN.
function SYSPARAMBTN_Callback(hObject, eventdata, handles)
% hObject    handle to SYSPARAMBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SysParam(hObject);
guidata(hObject, handles);

% --- Executes on button press in EXITBTN.
function EXITBTN_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.MotionSimMenu)

% --- Executes on button press in SIMULINKBTN.
function SIMULINKBTN_Callback(hObject, eventdata, handles)
% hObject    handle to SIMULINKBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sysmodel
contents = cellstr(get(handles.FILEBOX,'String')); 
filename = contents{get(handles.FILEBOX,'Value')}; 

if get(handles.XLSRADIO,'Value')
    exceldata = importdata(filename);
    %Run the selected preprocessor, using the function handle from excel sheet
    preprocessor = eval(strcat('@', cell2mat(exceldata.textdata.INFO(22,3))));
    sysmodel = preprocessor(exceldata, filename);
    sysmodel.directory = path;
    sysmodel.preprocessor = eval(strcat('@', cell2mat(exceldata.textdata.INFO(22,3))));
    %save to .mat
    sysmodel = conv2simulink(sysmodel);
    
    save(strcat('simulink\',sysmodel.info.name,'-SIMULINKPARAM.mat'),'sysmodel');
    set(handles.MSGTXT,'String',['Loaded: ', filename])
   % enablehandles(sysmodel, handles)
elseif get(handles.MATRADIO,'Value')
    load(strcat('Models\',filename(:,1:length(filename)-4), '.mat'),'sysmodel');
    set(handles.MSGTXT,'String',['Loaded: ', filename])
    sysmodel = conv2simulink(sysmodel);
   % enablehandles(sysmodel, handles);
    
    save(strcat('simulink\',sysmodel.info.name,'-SIMULINKPARAM.mat'),'sysmodel');
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in POSTPROCBTN.
function POSTPROCBTN_Callback(hObject, eventdata, handles)
% hObject    handle to POSTPROCBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PostProcess();

% --- Executes on button press in LOADBTN.
function LOADBTN_Callback(hObject, eventdata, handles)
% hObject    handle to LOADBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sysmodel
contents = cellstr(get(handles.FILEBOX,'String')); 
filename = contents{get(handles.FILEBOX,'Value')}; 

if get(handles.XLSRADIO,'Value')
    exceldata = importdata(filename);
    %Run the selected preprocessor, using the function handle from excel sheet
    preprocessor = eval(strcat('@', cell2mat(exceldata.textdata.INFO(22,3))));
    sysmodel = preprocessor(exceldata, filename);
    sysmodel.directory = path;
    sysmodel.preprocessor = eval(strcat('@', cell2mat(exceldata.textdata.INFO(22,3))));
    %save to .mat

    
    save(strcat('Models\',sysmodel.info.name), 'sysmodel', 'exceldata');
    set(handles.MSGTXT,'String',['Loaded: ', filename])
    handles.sysmodel = sysmodel;
    enablehandles(handles,hObject)
elseif get(handles.MATRADIO,'Value')
    load(strcat('Models\',filename),'sysmodel');
    set(handles.MSGTXT,'String',['Loaded: ', filename])
    handles.sysmodel = sysmodel;
    enablehandles(handles,hObject)
elseif get(handles.MDLRADIO,'Value')
    %not yet implimented

load(strcat('Models\',filename(:,1:length(filename)-4), '.mat'),'sysmodel');
sysmodel = conv2simulink(sysmodel);
sysmodel.info.simulink = 1;

    open(filename)
end


function enablehandles(handles,hObject)
set(handles.SAVEMODBTN, 'ENABLE', 'on');
set(handles.BODIESBTN, 'ENABLE', 'on');
set(handles.JOINTSBTN, 'ENABLE', 'on');
set(handles.DRIVERSBTN, 'ENABLE', 'on');
set(handles.SDABTN, 'ENABLE', 'on');
set(handles.SIMULINKBTN, 'ENABLE', 'on');
set(handles.SYSPARAMBTN, 'ENABLE', 'on');
set(handles.SOLVEROPTIONS, 'ENABLE', 'on');
set(handles.SIMBTN, 'ENABLE', 'on');
guidata(hObject, handles);



% --- Executes on button press in LOADEXTERNAL.
function LOADEXTERNAL_Callback(hObject, eventdata, handles)
% hObject    handle to LOADEXTERNAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filename = uigetfile('Models\*.xlsx');
guidata(hObject, handles);
% --- Executes on selection change in STATUSBOX.
function STATUSBOX_Callback(hObject, eventdata, handles)
% hObject    handle to STATUSBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns STATUSBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from STATUSBOX


% --- Executes during object creation, after setting all properties.
function STATUSBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STATUSBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles = updatelistbox(handles);
guidata(hObject, handles);

% --- Executes on button press in SOLVEROPTIONS.
function SOLVEROPTIONS_Callback(hObject, eventdata, handles)
% hObject    handle to SOLVEROPTIONS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SolverOpt(hObject);
guidata(hObject, handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load(strcat('Models\','TEMPLATE3D.mat'),'sysmodel');
handles.sysmodel = sysmodel;

handles.newmodel = 1;
guidata(hObject, handles);
SysParam(hObject);
uiwait(gcf);
parentdata = guidata(handles.MotionSimMenu);
handles.sysmodel = parentdata.sysmodel;
enablehandles(handles,hObject);
handles.newmodel = 0;
set(handles.MSGTXT,'String',['Loaded: ', handles.sysmodel.info.name, '.mat'])
guidata(hObject, handles);


% --- Executes on button press in BODIESBTN.
function BODIESBTN_Callback(hObject, eventdata, handles)
% hObject    handle to BODIESBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BodyInput(hObject);
guidata(hObject, handles);



% --- Executes on button press in JOINTSBTN.
function JOINTSBTN_Callback(hObject, eventdata, handles)
% hObject    handle to JOINTSBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
JointInput(hObject);
guidata(hObject, handles);

% --- Executes on button press in DRIVERSBTN.
function DRIVERSBTN_Callback(hObject, eventdata, handles)
% hObject    handle to DRIVERSBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DriverInput(hObject);
guidata(hObject, handles);

% --- Executes on button press in SDABTN.
function SDABTN_Callback(hObject, eventdata, handles)
% hObject    handle to SDABTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SDAinput(hObject);
guidata(hObject, handles);


% --- Executes on button press in PLOTBTN.
function PLOTBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLOTBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotData(hObject);

% --- Executes on button press in ANIMATEBTN.
function ANIMATEBTN_Callback(hObject, eventdata, handles)
% hObject    handle to ANIMATEBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AnimateData(hObject);

% --- Executes on button press in FREQBTN.
function FREQBTN_Callback(hObject, eventdata, handles)
% hObject    handle to FREQBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FreqAnalysis(hObject);
guidata(hObject, handles);
% --- Executes on selection change in RESULTSLISTBOX.
function RESULTSLISTBOX_Callback(hObject, eventdata, handles)
% hObject    handle to RESULTSLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RESULTSLISTBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RESULTSLISTBOX


% --- Executes during object creation, after setting all properties.
function RESULTSLISTBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RESULTSLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DELETRESULTSBTN.
function DELETRESULTSBTN_Callback(hObject, eventdata, handles)
% hObject    handle to DELETRESULTSBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SIMULINKBTN.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to SIMULINKBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in EXITBTN.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LOADRES.
function LOADRES_Callback(hObject, eventdata, handles)
% hObject    handle to LOADRES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.resfilename = uigetfile('Results\*.mat');

load(strcat('results\',handles.resfilename),'sysmodel');
handles.sysmodelres = sysmodel;
enableanalysis(handles, handles.sysmodelres.info.name);

guidata(hObject, handles);

% --- Executes on button press in SAVEASRES.
function SAVEASRES_Callback(hObject, eventdata, handles)
% hObject    handle to SAVEASRES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sysmodel = handles.sysmodelres;
uisave({'sysmodel'}, sysmodel.info.name);

% --- Executes on button press in POINTSBTN.
function POINTSBTN_Callback(hObject, eventdata, handles)
% hObject    handle to POINTSBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PointsInput(hObject);


% --- Executes on button press in SAVEMODBTN.
function SAVEMODBTN_Callback(hObject, eventdata, handles)
% hObject    handle to SAVEMODBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sysmodel = handles.sysmodel;
save(strcat('Models\',sysmodel.info.name,'.mat'),'sysmodel');
