function SimulinkCalcDyn3D(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.
%
%   It should be noted that the MATLAB S-function is very similar
%   to Level-2 C-Mex S-functions. You should be able to get more
%   information for each of the block methods by referring to the
%   documentation for C-Mex S-functions.
%
%   Copyright 2003-2010 The MathWorks, Inc.

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 3;
block.NumOutputPorts = 4;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;



% % Override input port properties
block.InputPort(1).Dimensions        = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(1);
%block.InputPort(1).DimensionsMode    = 'Variable';
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

% % Override input port properties
block.InputPort(2).Dimensions        = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(2);
%block.InputPort(1).DimensionsMode    = 'Variable';
block.InputPort(2).DatatypeID  = 0;  % double
block.InputPort(2).Complexity  = 'Real';
block.InputPort(2).DirectFeedthrough = true;

block.InputPort(3).Dimensions        =  block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(2);
%block.InputPort(1).DimensionsMode    = 'Variable';
block.InputPort(3).DatatypeID  = 0;  % double
block.InputPort(3).Complexity  = 'Real';
block.InputPort(3).DirectFeedthrough = true;

% block.InputPort(3).Dimensions        = 12;
% %block.InputPort(1).DimensionsMode    = 'Variable';
% block.InputPort(3).DatatypeID  = 0;  % double
% block.InputPort(3).Complexity  = 'Real';
% block.InputPort(3).DirectFeedthrough = true;

% Override output port properties
block.OutputPort(1).Dimensions       = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(1);
%block.OutputPort(1).DimensionsMode    = 'Variable';
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';

block.OutputPort(2).Dimensions       = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(2);
%block.OutputPort(1).DimensionsMode    = 'Variable';
block.OutputPort(2).DatatypeID  = 0; % double
block.OutputPort(2).Complexity  = 'Real';

block.OutputPort(3).Dimensions       = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(2);
%block.OutputPort(1).DimensionsMode    = 'Variable';
block.OutputPort(3).DatatypeID  = 0; % double
block.OutputPort(3).Complexity  = 'Real';

block.OutputPort(4).Dimensions       = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(2);
%block.OutputPort(1).DimensionsMode    = 'Variable';
block.OutputPort(4).DatatypeID  = 0; % double
block.OutputPort(4).Complexity  = 'Real';
% block.OutputPort(3).Dimensions       = 12;
% %block.OutputPort(1).DimensionsMode    = 'Variable';
% block.OutputPort(3).DatatypeID  = 0; % double
% block.OutputPort(3).Complexity  = 'Real';
% Register parameters
block.NumDialogPrms     = 1;
 
 

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0 0];

% block.NumContStates = 1;

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------
block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup



function SetInputPortSamplingMode(block, idx, fd)
 block.InputPort(idx).SamplingMode = fd;



block.OutputPort(1).SamplingMode = fd;
block.OutputPort(2).SamplingMode = fd;
block.OutputPort(3).SamplingMode = fd;
block.OutputPort(4).SamplingMode = fd;

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C-Mex counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
block.NumDworks = 1;
  
  block.Dwork(1).Name            = 'Initial';
  block.Dwork(1).Dimensions      = 52;
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;

  

  
%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C-MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)
%block.ContStates.Dimensions      = 52;
%block.ContStates.Data = [ block.InputPort(1).Data; block.InputPort(2).Data];
%block.ContStates.Data = block.InputPort(1).data;
%end InitializeConditions
%block.ContStates.Data = 1;

%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)
%block.Dwork(1).Data = block.InputPort(1).Data;%block.DialogPrm(1).Data.forcevect;
%block.ContStates.Data = [ block.InputPort(1).Data; block.InputPort(2).Data];
%endfunction

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)
qdof = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(1);
qddof = block.DialogPrm(1).Data.info.bodies*block.DialogPrm(1).Data.info.bodydof(2);

system = block.DialogPrm(1).Data;
system.forcevect =  block.InputPort(3).Data;


%block.OutputPort(1).Data =block.Dwork(1).Data;%block.Dwork(1).Data ;%block.ContStates.Data;%block.Dwork(1).Data + simtest(block.InputPort(1).Data)*0+block.DialogPrm(1).Data.info.joints;
temp = CalcDyn3D(block.CurrentTime,  [ block.InputPort(1).Data; block.InputPort(2).Data],[], system);
block.OutputPort(1).Data = temp.output(1:qdof);%temp(1:qdof); 

block.OutputPort(2).Data = temp.output(1+qdof:qdof+qddof);%temp(qdof+1:qdof + qddof);

block.OutputPort(3).Data = temp.Qe;

block.OutputPort(4).Data = temp.Qe;
%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlUpdate
%%
function Update(block)
%block.Dwork(1).Data = CalcDyn3D(block.CurrentTime, block.DialogPrm(1).Data.initial,[], block.DialogPrm(1).Data);
%block.Dwork(1).Data = block.InputPort(1).Data;

%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlDerivatives
%%
function Derivatives(block)
%block.Derivatives.Data = CalcDyn3D(block.CurrentTime, block.DialogPrm(1).Data.initial,[], block.DialogPrm(1).Data);
%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate


