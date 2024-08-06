classdef CarModel < handle
    %CARMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
         info;
        Arms;
        Chassis;
        joint;
        SDA;
        eval;
        drivers;
        solver;
        post;
        points;
        directory;
        preprocessor;
        forcevect;
        massvect;
        initial;
        results;
    end
    
    methods
         function obj =  CarModel()
            obj.solver = struct(...
        'type', [],...
        'solver', [],...
        'solverfunc', [],...
        'endtime', [],...
        'starttime', [],...
        'step', [],...
        'NRiter', [],...
        'reltol', [],...
        'abstol', [],...
        'maxstep', [],...
        'minstep', [],...
        'MAT', [],...
        'initstep', []);
        end
    end
    
end

