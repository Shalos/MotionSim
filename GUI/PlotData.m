function varargout = PlotData(varargin)
% PLOTDATA MATLAB code for PlotData.fig
%      PLOTDATA, by itself, creates a new PLOTDATA or raises the existing
%      singleton*.
%
%      H = PLOTDATA returns the handle to a new PLOTDATA or the handle to
%      the existing singleton*.
%
%      PLOTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTDATA.M with the given input arguments.
%
%      PLOTDATA('Property','Value',...) creates a new PLOTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlotData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlotData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlotData

% Last Modified by GUIDE v2.5 29-Jul-2012 18:23:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlotData_OpeningFcn, ...
                   'gui_OutputFcn',  @PlotData_OutputFcn, ...
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


% --- Executes just before PlotData is made visible.
function PlotData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlotData (see VARARGIN)

% Choose default command line output for PlotData

 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.sysmodel = parentdata.sysmodelres;

handles.X1 = 0;
handles.X2 = 0;
handles.X3 = 0;


handles.bodies = length(handles.sysmodel.body);
handles.constraints = length(handles.sysmodel.joint);
handles.points = length(handles.sysmodel.points);

set(handles.COLORLISTBOX,'string', {'Blue', 'Yellow', 'Red','Green','Black'})

handles.pointopt = {'Gen','Pos', 'Vel', 'Acc'};


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
    
        handles.pntvar{1} = {'Time'};
    handles.pntvar{2} = {'X', 'Y','Z'};
    handles.pntvar{3} = {'Xd', 'Yd','Zd'};
    handles.pntvar{4} = {'Xdd', 'Ydd','Zdd'};
    
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
    handles.bodyvar{6} =  {'Fx', 'Fy', 'Tz'};
    
    handles.cnstvar{1} = {'Time'};
    handles.cnstvar{2} = {'C1','C2','C3'};
    handles.cnstvar{3} = {'C1','C2','C3'};
    
    handles.pntvar{1} = {'Time'};
    handles.pntvar{2} = {'X', 'Y'};
    handles.pntvar{3} = {'Xd', 'Yd'};
    handles.pntvar{4} = {'Xdd', 'Ydd'};
    
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
    
    handles.pntvar{1} = {'Time'};
    handles.pntvar{2} = {'X', 'Y'};
    handles.pntvar{3} = {'Xd', 'Yd'};
    handles.pntvar{4} = {'Xdd', 'Ydd'};
    
    handles.bodyopt = {'Gen','Pos', 'Vel', 'Acc'};
    handles.cnstopt = {'Gen','Error','Vel Error'};
end

YPROPERTY_Callback(handles.YPROPERTY, eventdata, handles);
YOBJECT_Callback(handles.YOBJECT, eventdata, handles);
XPROPERTY_Callback(handles.XPROPERTY, eventdata, handles);
XOBJECT_Callback(handles.YOBJECT, eventdata, handles);

handles.output = hObject;
handles = refreshmenu(handles);
handles.fig = figure;
set(handles.FIGMENU,'String', ['FIGURE' num2str(1)])
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
set(handles.XOBJECT,'string', OBJECTS)
set(handles.YOBJECT,'string', OBJECTS)


% --- Outputs from this function are returned to the command line.
function varargout = PlotData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in XOBJECT.
function XOBJECT_Callback(hObject, eventdata, handles)
% hObject    handle to XOBJECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns XOBJECT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from XOBJECT
selection = get(hObject,'Value');
ProccessMenuProperty(handles,selection,handles.XPROPERTY);


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
function XOBJECT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XOBJECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in XPROPERTY.
function XPROPERTY_Callback(hObject, eventdata, handles)
% hObject    handle to XPROPERTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns XPROPERTY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from XPROPERTY
selection = get(hObject,'Value');
objselection = get(handles.XOBJECT,'Value');
ProccessMenuVariable(handles,objselection, selection,handles.XVARIABLE);

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
    set(target,'String',handles.pntvar{selection});
end
% --- Executes during object creation, after setting all properties.
function XPROPERTY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XPROPERTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in XVARIABLE.
function XVARIABLE_Callback(hObject, eventdata, handles)
% hObject    handle to XVARIABLE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns XVARIABLE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from XVARIABLE
if get(handles.LIVEUPDATE,'Value')
PLOTBTN_Callback(handles.PLOTBTN, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function XVARIABLE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XVARIABLE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in YOBJECT.
function YOBJECT_Callback(hObject, eventdata, handles)
% hObject    handle to YOBJECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns YOBJECT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YOBJECT
selection = get(hObject,'Value');
ProccessMenuProperty(handles,selection,handles.YPROPERTY);
% --- Executes during object creation, after setting all properties.
function YOBJECT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YOBJECT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in YPROPERTY.
function YPROPERTY_Callback(hObject, eventdata, handles)
% hObject    handle to YPROPERTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns YPROPERTY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YPROPERTY
selection = get(hObject,'Value');
objselection = get(handles.YOBJECT,'Value');
ProccessMenuVariable(handles,objselection, selection,handles.YVARIABLE);

% --- Executes during object creation, after setting all properties.
function YPROPERTY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YPROPERTY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in YVARIABLE.
function YVARIABLE_Callback(hObject, eventdata, handles)
% hObject    handle to YVARIABLE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns YVARIABLE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YVARIABLE
if get(handles.LIVEUPDATE,'Value')
PLOTBTN_Callback(handles.PLOTBTN, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function YVARIABLE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YVARIABLE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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

% --- Executes on button press in PLOTBTN.
function PLOTBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLOTBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.XOBJECT,'Value');
prop = get(handles.XPROPERTY,'Value');
var = get(handles.XVARIABLE,'Value');
sigx = getsignal(handles,obj,prop,var);

obj = get(handles.YOBJECT,'Value');
prop = get(handles.YPROPERTY,'Value');
var = get(handles.YVARIABLE,'Value');
sigy = getsignal(handles,obj,prop,var);
figure(handles.currentfig)

if get(handles.REDRAW,'value');
   cla
end  
selcolor = get(handles.COLORLISTBOX,'value');
if selcolor == 1
    pcolor = 'b';
elseif selcolor ==2
    pcolor = 'y';
elseif selcolor == 3
    pcolor = 'r';
elseif selcolor == 4
    pcolor = 'g';
elseif selcolor == 5
    pcolor = 'k';
end

plot(sigx, sigy, pcolor)

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
        sig = results.joints.Cerror(:,spacing+var+sysmodel.info.bodydof(2));
    elseif prop == 3
        spacing = cnstloc(handles.sysmodel,obj-handles.sysmodel.info.bodies);
        sig = results.joints.Cvelerror(:,spacing+var+sysmodel.info.bodydof(2));
    elseif prop == 4
        spacing = cnstloc(handles.sysmodel,obj-handles.sysmodel.info.bodies);
        sig = results.joints.lambda(:,spacing+var+sysmodel.info.bodydof(2));
    end
elseif obj <= handles.bodies+handles.constraints+handles.points %point
     if prop == 2
         if sysmodel.info.spatial
             spacing = (obj-handles.bodies-handles.constraints-1)*(2);
         else
             spacing = (obj-handles.bodies-handles.constraints-1)*(2);
         end
        sig = results.points.q(:,spacing+var);
    elseif prop == 3
         if sysmodel.info.spatial
             spacing = (obj-handles.bodies-handles.constraints-1)*(2);
         else
             spacing = (obj-handles.bodies-handles.constraints-1)*(2);
         end
        sig = results.points.qd(:,spacing+var);

    elseif prop == 4
         if sysmodel.info.spatial
             spacing = (obj-handles.bodies-handles.constraints-1)*(2);
         else
             spacing = (obj-handles.bodies-handles.constraints-1)*(2);
         end
        sig = results.points.qdd(:,spacing+var);
    end
end
function accum = cnstloc(sysmodel, jointnum)
accum= 0;
for x = 1:jointnum-1
    temp = GetDof(sysmodel.info.spatial,sysmodel.joint(x).Type);
    accum = accum + length(temp);
end


% --- Executes on button press in XX1BTN.
function XX1BTN_Callback(hObject, eventdata, handles)
% hObject    handle to XX1BTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.XOBJECT,'Value');
prop = get(handles.XPROPERTY,'Value');
var = get(handles.XVARIABLE,'Value');
sigx = getsignal(handles,obj,prop,var);
handles.X1 = sigx;
% Hints: contents = cellstr(get(hObject,'String')) returns YPROPERTY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YPROPERTY
objcont = cellstr(get(handles.XOBJECT,'String'));
propcont = cellstr(get(handles.XPROPERTY,'String'));
varcont = cellstr(get(handles.XVARIABLE,'String'));
set(handles.X1TAG,'String',['X1 := '  objcont{obj}(1:4) '-' varcont{var}]);
guidata(hObject, handles);
% --- Executes on button press in XX2BTN.
function XX2BTN_Callback(hObject, eventdata, handles)
% hObject    handle to XX2BTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.XOBJECT,'Value');
prop = get(handles.XPROPERTY,'Value');
var = get(handles.XVARIABLE,'Value');
sigx = getsignal(handles,obj,prop,var);
handles.X2 = sigx;
objcont = cellstr(get(handles.XOBJECT,'String'));
propcont = cellstr(get(handles.XPROPERTY,'String'));
varcont = cellstr(get(handles.XVARIABLE,'String'));
set(handles.X2TAG,'String',['X2 := '  objcont{obj}(1:4) '-' varcont{var}]);
guidata(hObject, handles);

% --- Executes on button press in XX3BTN.
function XX3BTN_Callback(hObject, eventdata, handles)
% hObject    handle to XX3BTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.XOBJECT,'Value');
prop = get(handles.XPROPERTY,'Value');
var = get(handles.XVARIABLE,'Value');
sigx = getsignal(handles,obj,prop,var);
handles.X3 = sigx;
objcont = cellstr(get(handles.XOBJECT,'String'));
propcont = cellstr(get(handles.XPROPERTY,'String'));
varcont = cellstr(get(handles.XVARIABLE,'String'));
set(handles.X3TAG,'String',['X3 := '  objcont{obj}(1:4) '-' varcont{var}]);
guidata(hObject, handles);

% --- Executes on button press in YX1BTN.
function YX1BTN_Callback(hObject, eventdata, handles)
% hObject    handle to YX1BTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.YOBJECT,'Value');
prop = get(handles.YPROPERTY,'Value');
var = get(handles.YVARIABLE,'Value');
sigy = getsignal(handles,obj,prop,var);
handles.X1 = sigy;
objcont = cellstr(get(handles.YOBJECT,'String'));
propcont = cellstr(get(handles.YPROPERTY,'String'));
varcont = cellstr(get(handles.YVARIABLE,'String'));
set(handles.X1TAG,'String',['X1 := '  objcont{obj}(1:4) '-' varcont{var}]);
guidata(hObject, handles);

% --- Executes on button press in YX2BTN.
function YX2BTN_Callback(hObject, eventdata, handles)
% hObject    handle to YX2BTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.YOBJECT,'Value');
prop = get(handles.YPROPERTY,'Value');
var = get(handles.YVARIABLE,'Value');
sigy = getsignal(handles,obj,prop,var);
handles.X2 = sigy;
objcont = cellstr(get(handles.YOBJECT,'String'));
propcont = cellstr(get(handles.YPROPERTY,'String'));
varcont = cellstr(get(handles.YVARIABLE,'String'));
set(handles.X2TAG,'String',['X2 := '  objcont{obj}(1:4) '-' varcont{var}]);
guidata(hObject, handles);

% --- Executes on button press in YX3BTN.
function YX3BTN_Callback(hObject, eventdata, handles)
% hObject    handle to YX3BTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = get(handles.YOBJECT,'Value');
prop = get(handles.YPROPERTY,'Value');
var = get(handles.YVARIABLE,'Value');
sigy = getsignal(handles,obj,prop,var);
handles.X3 = sigy;
objcont = cellstr(get(handles.YOBJECT,'String'));
propcont = cellstr(get(handles.YPROPERTY,'String'));
varcont = cellstr(get(handles.YVARIABLE,'String'));
set(handles.X3TAG,'String',['X3 := '  objcont{obj}(1:4) '-' varcont{var}]);
guidata(hObject, handles);


function XFIELD_Callback(hObject, eventdata, handles)
% hObject    handle to XFIELD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XFIELD as text
%        str2double(get(hObject,'String')) returns contents of XFIELD as a double


% --- Executes during object creation, after setting all properties.
function XFIELD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XFIELD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YFIELD_Callback(hObject, eventdata, handles)
% hObject    handle to YFIELD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YFIELD as text
%        str2double(get(hObject,'String')) returns contents of YFIELD as a double


% --- Executes during object creation, after setting all properties.
function YFIELD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YFIELD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZFIELD_Callback(hObject, eventdata, handles)
% hObject    handle to ZFIELD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZFIELD as text
%        str2double(get(hObject,'String')) returns contents of ZFIELD as a double


% --- Executes during object creation, after setting all properties.
function ZFIELD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZFIELD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PLOTEQUBTN.
function PLOTEQUBTN_Callback(hObject, eventdata, handles)
% hObject    handle to PLOTEQUBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
X1 = handles.X1;
X2 = handles.X2;
X3 = handles.X3;
t = handles.sysmodel.results.T;

z = size(X3);
if z(1) > z(2)
    X3 = X3';
end

z = size(X2);
if z(1) > z(2)
    X2 = X2';
end

z = size(X1);
if z(1) > z(2)
    X1 = X1';
end

sigx = eval(get(handles.XFIELD,'String'));
sigy = eval(get(handles.YFIELD,'String'));

figure(handles.currentfig)
if get(handles.REDRAW,'value');
   cla
end  
selcolor=get(handles.COLORLISTBOX,'value');
if selcolor == 1
    pcolor = 'b';
elseif selcolor ==2
    pcolor = 'y';
elseif selcolor == 3
    pcolor = 'r';
elseif selcolor == 4
    pcolor = 'g';
elseif selcolor == 5
    pcolor = 'k';
end

plot(sigx, sigy, pcolor)

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in EXITBTN.
function EXITBTN_Callback(hObject, eventdata, handles)
% hObject    handle to EXITBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for x = 1:length(handles.fig)
    close(handles.fig(x))
end
close(handles.PlotData)


% --- Executes on button press in NEWFIGBTN.
function NEWFIGBTN_Callback(hObject, eventdata, handles)
% hObject    handle to NEWFIGBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fig(length(handles.fig)+1) = figure;
items = cellstr(get(handles.FIGMENU,'String'));
items(length(items)+1) = {['FIGURE ' num2str(length(items)+1)]};

 set(handles.FIGMENU,'String', items);
set(handles.FIGMENU, 'Value', length(items));
handles.currentfig = handles.fig(length(handles.fig));
guidata(hObject, handles);


% --- Executes on selection change in FIGMENU.
function FIGMENU_Callback(hObject, eventdata, handles)
% hObject    handle to FIGMENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FIGMENU contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FIGMENU
get(hObject,'Value')

% --- Executes during object creation, after setting all properties.
function FIGMENU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FIGMENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function PLOTBTN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PLOTBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in LIVEUPDATE.
function LIVEUPDATE_Callback(hObject, eventdata, handles)
% hObject    handle to LIVEUPDATE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LIVEUPDATE
