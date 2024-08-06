function varargout = CarSimStart(varargin)
% CARSIMSTART MATLAB code for CarSimStart.fig
%      CARSIMSTART, by itself, creates a new CARSIMSTART or raises the existing
%      singleton*.
%
%      H = CARSIMSTART returns the handle to a new CARSIMSTART or the handle to
%      the existing singleton*.
%
%      CARSIMSTART('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CARSIMSTART.M with the given input arguments.
%
%      CARSIMSTART('Property','Value',...) creates a new CARSIMSTART or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CarSimStart_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CarSimStart_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CarSimStart

% Last Modified by GUIDE v2.5 03-Jan-2014 20:59:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CarSimStart_OpeningFcn, ...
                   'gui_OutputFcn',  @CarSimStart_OutputFcn, ...
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


% --- Executes just before CarSimStart is made visible.
function CarSimStart_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CarSimStart (see VARARGIN)

% Choose default command line output for CarSimStart
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CarSimStart wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CarSimStart_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadPrj.
function LoadPrj_Callback(hObject, eventdata, handles)
% hObject    handle to LoadPrj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SavePrj.
function SavePrj_Callback(hObject, eventdata, handles)
% hObject    handle to SavePrj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in NewPrj.
function NewPrj_Callback(hObject, eventdata, handles)
% hObject    handle to NewPrj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CFGCar.
function CFGCar_Callback(hObject, eventdata, handles)
% hObject    handle to CFGCar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CSConfigure

