function varargout = PlanarHalfCar(varargin)
% PLANARHALFCAR MATLAB code for PlanarHalfCar.fig
%      PLANARHALFCAR, by itself, creates a new PLANARHALFCAR or raises the existing
%      singleton*.
%
%      H = PLANARHALFCAR returns the handle to a new PLANARHALFCAR or the handle to
%      the existing singleton*.
%
%      PLANARHALFCAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLANARHALFCAR.M with the given input arguments.
%
%      PLANARHALFCAR('Property','Value',...) creates a new PLANARHALFCAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlanarHalfCar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlanarHalfCar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlanarHalfCar

% Last Modified by GUIDE v2.5 18-Dec-2013 20:09:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlanarHalfCar_OpeningFcn, ...
                   'gui_OutputFcn',  @PlanarHalfCar_OutputFcn, ...
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


% --- Executes just before PlanarHalfCar is made visible.
function PlanarHalfCar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlanarHalfCar (see VARARGIN)

% Choose default command line output for PlanarHalfCar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlanarHalfCar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlanarHalfCar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
hold on
axis off


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
