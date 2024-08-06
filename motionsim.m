function [ ] = motionsim(varargin)
%This is the main program, it is designed as a function to be called easily
%and begin the process. Everything is handeled through the excel file,
%which this function imports, finds the pre/post and solver information
%from file, and then uses to run the simulation.
clear all
global ydata xdata
clc

addpath(genpath(pwd))


%import excel file, Filename should point to the file in the same folder.
%if option to load directly from .mat file is selected, will skip
if nargin == 0
    MotionSimMenu
elseif nargin == 1
    if varargin{1} == 'MBS'
        MotionSimMenu
    elseif varargin{1} == 'VEHICLE'
        CarSimStart
    end
elseif nargin == 2
    
end



%rmpath(genpath(pwd))