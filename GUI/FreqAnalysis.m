function varargout = FreqAnalysis(varargin)
% FREQANALYSIS MATLAB code for FreqAnalysis.fig
%      FREQANALYSIS, by itself, creates a new FREQANALYSIS or raises the existing
%      singleton*.
%
%      H = FREQANALYSIS returns the handle to a new FREQANALYSIS or the handle to
%      the existing singleton*.
%
%      FREQANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FREQANALYSIS.M with the given input arguments.
%
%      FREQANALYSIS('Property','Value',...) creates a new FREQANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FreqAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FreqAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FreqAnalysis

% Last Modified by GUIDE v2.5 22-Jul-2012 16:52:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FreqAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @FreqAnalysis_OutputFcn, ...
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


% --- Executes just before FreqAnalysis is made visible.
function FreqAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FreqAnalysis (see VARARGIN)

 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.sysmodel = parentdata.sysmodelres;




handles.bodies = length(handles.sysmodel.body);
handles.constraints = length(handles.sysmodel.joint);
handles.points = length(handles.sysmodel.points);

handles.pointopt = {'Gen','Pos', 'Vel', 'Acc'};

set(handles.COLORLISTBOX,'string', {'Blue', 'Yellow', 'Red','Green','Black'})

if handles.sysmodel.info.dynamic && handles.sysmodel.info.spatial  %dynamic-spatial
    handles.bodyvar{1} = {'Time'};
    handles.bodyvar{2} = {'X','Y','Z', 'e0','e1','e2','e3'};
    handles.bodyvar{3} = {'Xd','Yd','Zd', 'wx','wy','wz'};
    handles.bodyvar{4} = {'Xdd','Ydd','Zdd', 'wdx','wdy','wdz'};
    handles.bodyvar{5} = {'Fx', 'Fy', 'Fz','Tx','Ty','Tz'};
    handles.bodyvar{6} = {'Fx', 'Fy', 'Fz','Tx','Ty','Tz'};
    
    handles.cnstvar{1} = {'Time'};
    handles.cnstvar{2} = {'C1','C2','C3'};
    handles.cnstvar{3} = {'C1','C2','C3'};
    handles.cnstvar{4} = {'CForce1','CForce2','CForce3'};
    
    handles.bodyopt = {'Gen','Pos', 'Vel', 'Acc', 'BDYforces', 'CNSTforces'};
    handles.cnstopt = {'Gen','Error','Vel Error', 'Lambda'};
elseif ~handles.sysmodel.info.dynamic && handles.sysmodel.info.spatial %kinematic -spatial
    handles.bodyvar{1} = {'Time'};
    handles.bodyvar{2} = {'X','Y','Z', 'e0','e1','e2','e3'};
    handles.bodyvar{3} = {'Xd','Yd','Zd', 'ed0','ed1','ed2','ed3'};
    handles.bodyvar{4} = {'Xdd','Ydd','Zdd', 'edd0','edd1','edd2','edd3'};
    handles.bodyvar{5} = {'N/A'};
    
    handles.bodyopt = {'Gen','Pos', 'Vel', 'Acc'};
    handles.cnstopt = {'Gen','Error','Vel Error'};
elseif handles.sysmodel.info.dynamic && ~handles.sysmodel.info.spatial  %dynamic planar
    handles.bodyvar{1} = {'Time'};
    handles.bodyvar{2} = {'X','Y','PhiZ'};
    handles.bodyvar{3} =  {'Xd','Yd','wz'};
    handles.bodyvar{4} = {'Xdd','Ydd','wdz'};
    handles.bodyvar{5} =  {'Fx', 'Fy', 'Tz'};
    
    handles.cnstvar{1} = {'Time'};
    handles.cnstvar{2} = {'C1','C2','C3'};
    handles.cnstvar{3} = {'C1','C2','C3'};
    
    handles.bodyopt = {'Gen','Pos', 'Vel', 'Acc', 'BDYforces', 'CNSTforces'};
    handles.cnstopt = {'Gen','Error','Vel Error', 'Lambda'};
elseif ~handles.sysmodel.info.dynamic && ~handles.sysmodel.info.spatial %kin planar
    handles.bodyvar(1) = {'Time'};
    handles.bodyvar{2} = {'X','Y','PhiZ'};
    handles.bodyvar{3} =  {'Xd','Yd','wz'};
    handles.bodyvar{4} = {'Xdd','Ydd','wdz'};
    handles.bodyvar(5) = {'N/A'};
    
    handles.cnstvar{1} = {'Time'};
    handles.cnstvar{2} = {'C1','C2','C3'};
    handles.cnstvar{3} = {'C1','C2','C3'};
    
    handles.bodyopt = {'Gen','Pos', 'Vel', 'Acc'};
    handles.cnstopt = {'Gen','Error','Vel Error'};
end
PROPERTY_Callback(handles.PROPERTY, eventdata, handles);
OBJECT_Callback(handles.OBJECT, eventdata, handles);

handles.output = hObject;
handles = refreshmenu(handles);
handles.fig = figure;
handles.currentfig = handles.fig;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlotData wait for user response (see UIRESUME)
% uiwait(handles.PlotData);
function handles = refreshmenu(handles)
%handle points and bodies
BODY = {};
sysmodel = handles.sysmodel;
index = 1;
for x = 1:length(sysmodel.body)
    
   OBJECTS(index) = {['BDY' num2str(sysmodel.body(x).num) ' - ' sysmodel.body(x).label]}; 
   index = index+1;
end

for x = 1:length(sysmodel.joint)
   OBJECTS(index) = {['CNST' num2str(sysmodel.joint(x).num) ' - ' sysmodel.joint(x).label]}; 
   index = index +1;
end

for x = 1:length(sysmodel.points)
   OBJECTS(index) = {['PNT' num2str(sysmodel.points(x).num) ' - ' sysmodel.points(x).label]}; 
   index = index +1;
end


%init boxes
set(handles.OBJECT,'string', OBJECTS)


% --- Outputs from this function are returned to the command line.
function varargout = FreqAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in REDRAW.
function REDRAW_Callback(hObject, eventdata, handles)
% hObject    handle to REDRAW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of REDRAW
figure(handles.currentfig)
if get(hObject,'Value')
    hold off
else
   hold on
end

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

% --- Executes on selection change in COLORLISTBOX.
function COLORLISTBOX_Callback(hObject, eventdata, handles)
% hObject    handle to COLORLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns COLORLISTBOX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from COLORLISTBOX


% --- Executes during object creation, after setting all properties.
function COLORLISTBOX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to COLORLISTBOX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PLOTBTN.
function PLOTBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLOTBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.OBJECT,'Value');
prop = get(handles.PROPERTY,'Value');
var = get(handles.VARIABLE,'Value');
sig = getsignal(handles,obj,prop,var);


figure(handles.currentfig)
if get(handles.REDRAW,'value');
   cla
end  


plot(handles.sysmodel.results.T, sig)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in EXITBTN.
function EXITBTN_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes on selection change in OBJECT.
function OBJECT_Callback(hObject, eventdata, handles)
% hObject    handle to OBJECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OBJECT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OBJECT
selection = get(hObject,'Value');
ProccessMenuProperty(handles,selection,handles.PROPERTY);


function ProccessMenuProperty(handles, selection, target)
set(target,'Value',1);
if selection <= handles.bodies
    set(target,'String', handles.bodyopt);
elseif selection <= handles.bodies+handles.constraints
    set(target,'String', handles.cnstopt);
elseif selection <= handles.bodies+handles.constraints+handles.points
    set(target,'String', handles.pointopt);
end

% --- Executes during object creation, after setting all properties.
function OBJECT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OBJECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PROPERTY.
function PROPERTY_Callback(hObject, eventdata, handles)
% hObject    handle to PROPERTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PROPERTY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PROPERTY
selection = get(hObject,'Value');
objselection = get(handles.OBJECT,'Value');
ProccessMenuVariable(handles,objselection, selection,handles.VARIABLE);

function ProccessMenuVariable(handles, objselection, selection, target)
set(target,'Value',1);
if objselection <= handles.bodies
    set(target,'String',handles.bodyvar{selection});
elseif objselection <= handles.bodies+handles.constraints
    
    if selection == 1
        set(target,'String',handles.cnstvar{selection});
        return
    elseif selection == 4
        jointnum = objselection - handles.bodies;
       num = GetDof(handles.sysmodel.info.spatial,handles.sysmodel.joint(jointnum).Type);
       temp = {};
       for x = 1:length(num)
           temp{x} = ['L' num2str(x)];
       end
       handles.cnstvar{selection} = temp;
       set(target,'String',handles.cnstvar{selection});
    else
        jointnum = objselection - handles.bodies;
        handles.cnstvar{selection} = GetDof(handles.sysmodel.info.spatial,handles.sysmodel.joint(jointnum).Type);
        set(target,'String',handles.cnstvar{selection});
    end

elseif objselection <= handles.bodies+handles.constraints+handles.points
    
end

% --- Executes during object creation, after setting all properties.
function PROPERTY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PROPERTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in VARIABLE.
function VARIABLE_Callback(hObject, eventdata, handles)
% hObject    handle to VARIABLE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VARIABLE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VARIABLE


% --- Executes during object creation, after setting all properties.
function VARIABLE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VARIABLE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AMPBTN.
function AMPBTN_Callback(hObject, eventdata, handles)
% hObject    handle to AMPBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.OBJECT,'Value');
prop = get(handles.PROPERTY,'Value');
var = get(handles.VARIABLE,'Value');
sig = getsignal(handles,obj,prop,var);

figure(handles.currentfig)
if get(handles.REDRAW,'value');
   cla
end  

n = length(sig);
T = handles.sysmodel.results.T(n);
fs = n/T;
Ts = 1/fs;
Y = fft(sig,n);
Yplot = abs(Y)/n;
Yplot = fftshift(Y);

if mod(n,2)==0
    freqspan = -n/2:n/2-1;
else
    freqspan = -(n-1)/2:(n-1)/2;
end
freqaxis = freqspan/(n/fs);



plot(freqaxis, Yplot)
ytemp = Yplot(length(Yplot)/2:length(Yplot));
avgy = mean(imag(ytemp));
stdev = std(imag(ytemp));
axis([0 max(freqaxis) avgy-3*stdev avgy+3*stdev])

% --- Executes on button press in PHASEBTN.
function PHASEBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PHASEBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.OBJECT,'Value');
prop = get(handles.PROPERTY,'Value');
var = get(handles.VARIABLE,'Value');
sig = getsignal(handles,obj,prop,var);

figure(handles.currentfig)
if get(handles.REDRAW,'value');
   cla
end  
n = length(sig);
T = handles.sysmodel.results.T(n);
fs = n/T;
Ts = 1/fs;
Y = fft(sig,n);
phase = unwrap(angle(Y));
f = (0:length(Y)-1)'/length(Y)*100;

plot(f, phase)
axis([0 50 -180 180]);

% --- Executes on button press in PLOTEQUBTN.
function PLOTEQUBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLOTEQUBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function [sig] = getsignal(handles, obj, prop, var)
results = handles.sysmodel.results;
sysmodel = handles.sysmodel;
if prop == 1
       sig = results.T;
end

if obj <= handles.bodies %body
    
    if prop == 2
        spacing = (obj-1)*sysmodel.info.bodydof(1);
        sig = results.coord.q(:,spacing+var);
    elseif prop == 3
        spacing = (obj-1)*sysmodel.info.bodydof(2);
        sig = results.coord.qd(:,spacing+var);
    elseif prop == 4
        spacing = (obj-1)*sysmodel.info.bodydof(3);
        sig = results.coord.qdd(:,spacing+var);
    elseif prop == 5
        spacing = (obj-1)*sysmodel.info.bodydof(3);
        sig = results.forces.body(:,spacing+var);
    elseif prop == 6
        spacing = (obj-1)*sysmodel.info.bodydof(2);
        sig = results.forces.bdyjoint(:,spacing+var);
    end
elseif obj <= handles.bodies+handles.constraints %joint
     if prop == 2
        spacing = cnstloc(handles.sysmodel,obj-handles.sysmodel.info.bodies);
        sig = results.joints.Cerror(:,spacing+var+6);
    elseif prop == 3
        spacing = cnstloc(handles.sysmodel,obj-handles.sysmodel.info.bodies);
        sig = results.joints.Cvelerror(:,spacing+var+6);

    elseif prop == 4
        spacing = cnstloc(handles.sysmodel,obj-handles.sysmodel.info.bodies);
        sig = results.joints.lambda(:,spacing+var+6);
    end
elseif obj <= handles.bodies+handles.constraints+handles.points %point

end
function accum = cnstloc(sysmodel, jointnum)
accum= 0;
for x = 1:jointnum-1
    temp = GetDof(sysmodel.info.spatial,sysmodel.joint(x).Type);
    accum = accum + length(temp);
end


% --- Executes on button press in PHASEEQUBTN.
function PHASEEQUBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PHASEEQUBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in AMPEQUBTN.
function AMPEQUBTN_Callback(hObject, eventdata, handles)
% hObject    handle to AMPEQUBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PLOTALLBTN.
function PLOTALLBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLOTALLBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(handles.currentfig)
cla

obj = get(handles.OBJECT,'Value');
prop = get(handles.PROPERTY,'Value');
var = get(handles.VARIABLE,'Value');
sig = getsignal(handles,obj,prop,var);


n = length(sig);
T = handles.sysmodel.results.T(n);
fs = n/T;
Ts = 1/fs;
Y = fft(sig,n);
Yplot = abs(Y)/n;
Yplot = fftshift(Y);

if mod(n,2)==0
    freqspan = -n/2:n/2-1;
else
    freqspan = -(n-1)/2:(n-1)/2;
end
freqaxis = freqspan/(n/fs);


phase = unwrap(angle(Y));
f = (0:length(Y)-1)'/length(Y)*100;


subplot(3,1,1), plot(freqaxis,Yplot)

avgy = mean(imag(Yplot));
stdev = std(imag(Yplot));
axis([0 max(freqaxis) avgy-3*stdev avgy+3*stdev])
subplot(3,1,2), plot(f, phase)
axis([0 50 -90 90])
subplot(3,1,3), plot(handles.sysmodel.results.T, sig)
% --- Executes on button press in PLOTALLEQUBTN.
function PLOTALLEQUBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLOTALLEQUBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
