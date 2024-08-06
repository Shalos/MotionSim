function varargout = SolverOpt(varargin)
% SOLVEROPT MATLAB code for SolverOpt.fig
%      SOLVEROPT, by itself, creates a new SOLVEROPT or raises the existing
%      singleton*.
%
%      H = SOLVEROPT returns the handle to a new SOLVEROPT or the handle to
%      the existing singleton*.
%
%      SOLVEROPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLVEROPT.M with the given input arguments.
%
%      SOLVEROPT('Property','Value',...) creates a new SOLVEROPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SolverOpt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SolverOpt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SolverOpt

% Last Modified by GUIDE v2.5 26-Jun-2012 17:57:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SolverOpt_OpeningFcn, ...
                   'gui_OutputFcn',  @SolverOpt_OutputFcn, ...
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


% --- Executes just before SolverOpt is made visible.
function SolverOpt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SolverOpt (see VARARGIN)

% Choose default command line output for SolverOpt
 if ~isempty(varargin)
     handles.parent = varargin{1};
 end
parentdata = guidata(handles.parent);
handles.sysmodel = parentdata.sysmodel;

handles.output = hObject;

if handles.sysmodel.info.dynamic
    set(handles.ROOTTYPE,'ENABLE', 'off');
else
    set(handles.VARIABLESTEP,'ENABLE', 'off');
    set(handles.FIXEDSTEP,'ENABLE', 'off');
end


handles = refreshdata(handles);
handles = setoptions(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SolverOpt wait for user response (see UIRESUME)
% uiwait(handles.SOLVEROPT);
function handles = refreshdata(handles)
sysmodel = handles.sysmodel;

if strcmp(sysmodel.solver.type, 'variable')
    set(handles.VARIABLESTEP, 'Value', 1);
elseif strcmp(sysmodel.solver.type, 'fixed')
    set(handles.FIXEDSTEP, 'Value', 1);
else
    set(handles.ROOTTYPE, 'Value', 1);
end
set(handles.MAXITER, 'String', sysmodel.solver.NRiter);
set(handles.RELTOL, 'String', sysmodel.solver.reltol);
set(handles.ABSTOL, 'String', sysmodel.solver.abstol);
if sysmodel.solver.maxstep ~= -1
set(handles.MAXSTEPSIZE, 'String', sysmodel.solver.maxstep);
end
%set(handles.MINSTEPSIZE, 'String', sysmodel.solver.minstep);
if sysmodel.solver.initstep ~= -1
set(handles.INITSTEPSIZE, 'String', sysmodel.solver.initstep);
end

set(handles.STARTTIME, 'String', sysmodel.solver.starttime);
set(handles.STEP, 'String', sysmodel.solver.step);
set(handles.ENDTIME, 'String', sysmodel.solver.endtime);
%pass data back to figure and parent figure
handles.sysmodel = sysmodel;
updateparent(handles);

function updateparent(handles)
z = guidata(handles.parent);
z.sysmodel = handles.sysmodel;
guidata(handles.parent, z);

% --- Outputs from this function are returned to the command line.
function varargout = SolverOpt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in VARIABLESTEP.
function VARIABLESTEP_Callback(hObject, eventdata, handles)
% hObject    handle to VARIABLESTEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VARIABLESTEP


% --- Executes on button press in FIXEDSTEP.
function FIXEDSTEP_Callback(hObject, eventdata, handles)
% hObject    handle to FIXEDSTEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FIXEDSTEP



function STARTTIME_Callback(hObject, eventdata, handles)
% hObject    handle to STARTTIME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STARTTIME as text
%        str2double(get(hObject,'String')) returns contents of STARTTIME as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.starttime = get(hObject,'String');
else
     handles.sysmodel.solver.starttime = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function STARTTIME_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STARTTIME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ENDTIME_Callback(hObject, eventdata, handles)
% hObject    handle to ENDTIME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ENDTIME as text
%        str2double(get(hObject,'String')) returns contents of ENDTIME as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.endtime = get(hObject,'String');
else
     handles.sysmodel.solver.endtime = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ENDTIME_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ENDTIME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



    
function STEP_Callback(hObject, eventdata, handles)
% hObject    handle to STEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STEP as text
%        str2double(get(hObject,'String')) returns contents of STEP as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.step = get(hObject,'String');
else
     handles.sysmodel.solver.step = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function STEP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SOLVERMENU.
function SOLVERMENU_Callback(hObject, eventdata, handles)
% hObject    handle to SOLVERMENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SOLVERMENU contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SOLVERMENU

if strcmp(handles.sysmodel.solver.type, 'variable')
    solverfuncnames = {'ode45', 'ode23', 'ode113', 'ode15s', 'ode23s', 'ode23t','ode23tb'};
elseif strcmp(handles.sysmodel.solver.type, 'fixed')
    solverfuncnames = {'ode8', 'ode5', 'ode4', 'ode3', 'ode2', 'ode1'};
else
     solverfuncnames = {'NewtonRaphson'};
end
handles.sysmodel.solver.solver = eval(['@' solverfuncnames{1,get(hObject,'Value')}]);
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SOLVERMENU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SOLVERMENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when selected object is changed in SOLVERTYPE.
function SOLVERTYPE_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in SOLVERTYPE 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles = setoptions(handles);
updateparent(handles);
guidata(hObject, handles);

function [handles] = setoptions(handles)

set(handles.SOLVERMENU, 'Value', 1);
set(handles.RELTOL, 'ENABLE', 'off');
set(handles.MAXITER, 'ENABLE', 'off');
set(handles.ABSTOL, 'ENABLE', 'off');
set(handles.MAXSTEPSIZE, 'ENABLE', 'off');
%set(handles.MINSTEPSIZE, 'ENABLE', 'off');
set(handles.INITSTEPSIZE, 'ENABLE', 'off');
if get(handles.VARIABLESTEP, 'Value')
    handles.sysmodel.solver.type = 'variable';
    set(handles.SOLVERMENU, 'String', {'ode45 (Dormand-Prince)', 'ode23 (Bogacki-Shampine)', ...
    'ode113 (Adams-Bashforth-Moulton)', 'ode15s (stiff/NDF)', 'ode23s (Stiff-Rosenbrock)',...
    'ode23t (mod. Stiff/ Trap', 'ode23tb (stiff/TR-BDF2)'});

    set(handles.RELTOL, 'ENABLE', 'on');
    set(handles.ABSTOL, 'ENABLE', 'on');
set(handles.MAXSTEPSIZE, 'ENABLE', 'on');
%set(handles.MINSTEPSIZE, 'ENABLE', 'on');
set(handles.INITSTEPSIZE, 'ENABLE', 'on');
elseif get(handles.FIXEDSTEP, 'Value')
    handles.sysmodel.solver.type = 'fixed';
    set(handles.SOLVERMENU, 'String', {'ode8 (Dormand-Prince)', 'ode5 (Dormand-Prince)',...
        'ode4 (Runga-Kutta', 'ode3 (Bogacki-Shampine)', 'ode2 (Heun)',...
        'ode1 (Euler)'});
    set(handles.STEP, 'ENABLE', 'on');

else
    handles.sysmodel.solver.type = 'root';
    set(handles.SOLVERMENU, 'String', {'Newton Raphson'});
    set(handles.RELTOL, 'ENABLE', 'on');
    set(handles.MAXITER, 'ENABLE', 'on');
    set(handles.STEP, 'ENABLE', 'on');

end




function RELTOL_Callback(hObject, eventdata, handles)
% hObject    handle to RELTOL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RELTOL as text
%        str2double(get(hObject,'String')) returns contents of RELTOL as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.reltol = 1e-3;
else
     handles.sysmodel.solver.reltol = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function RELTOL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RELTOL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ABSTOL_Callback(hObject, eventdata, handles)
% hObject    handle to ABSTOL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ABSTOL as text
%        str2double(get(hObject,'String')) returns contents of ABSTOL as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.abstol = 1e-6;
else
     handles.sysmodel.solver.abstol = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ABSTOL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ABSTOL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MAXSTEPSIZE_Callback(hObject, eventdata, handles)
% hObject    handle to MAXSTEPSIZE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MAXSTEPSIZE as text
%        str2double(get(hObject,'String')) returns contents of MAXSTEPSIZE as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.maxstep = -1;
else
     handles.sysmodel.solver.maxstep = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function MAXSTEPSIZE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MAXSTEPSIZE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MINSTEPSIZE_Callback(hObject, eventdata, handles)
% hObject    handle to MINSTEPSIZE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MINSTEPSIZE as text
%        str2double(get(hObject,'String')) returns contents of MINSTEPSIZE as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.minstep = get(hObject,'String');
else
     handles.sysmodel.solver.minstep = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function MINSTEPSIZE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MINSTEPSIZE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITSTEPSIZE_Callback(hObject, eventdata, handles)
% hObject    handle to INITSTEPSIZE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITSTEPSIZE as text
%        str2double(get(hObject,'String')) returns contents of INITSTEPSIZE as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.initstep = -1;
else
     handles.sysmodel.solver.initstep = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function INITSTEPSIZE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITSTEPSIZE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MAXITER_Callback(hObject, eventdata, handles)
% hObject    handle to MAXITER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MAXITER as text
%        str2double(get(hObject,'String')) returns contents of MAXITER as a double
if strcmp(get(hObject,'String'), 'auto')
    handles.sysmodel.solver.NRiter = get(hObject,'String');
else
     handles.sysmodel.solver.NRiter = str2double(get(hObject,'String'));
end
updateparent(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function MAXITER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MAXITER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
