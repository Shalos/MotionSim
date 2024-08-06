function [ sysmodel ] = SolverSelect( sysmodel )
%SOLVERSELECT Solves for results from system model
%   processes initial and final results while calling the solver inbetween
clc
fprintf('%s', strcat('Run Simulation...', sysmodel.info.name));
disp(' ')
sysmodel.info.waitmsg = 'Running Simulation';
sysmodel.info.waith = waitbar(0,sysmodel.info.waitmsg);
%% run some pre calculations for initial conditions and DOF check
sysmodel  = CalcDof( sysmodel);
sysmodel = InitialCond(sysmodel);
disp(['Body Dof: ' num2str(sysmodel.info.totdof) ' - Constraint DOF: ' ...
    num2str(sysmodel.info.cdof) ' = SYSTEM DOF: ' num2str(sysmodel.info.dof)])

%% Run simulation from solver parameters
solver = sysmodel.solver.solver;
solverfunc = sysmodel.solver.solverfunc;
if strcmp(sysmodel.solver.step,'auto')
    sysmodel.results.T = [sysmodel.solver.starttime,sysmodel.solver.endtime];
else
sysmodel.results.T = sysmodel.solver.starttime:sysmodel.solver.step:sysmodel.solver.endtime;
end
disp(' ')
disp('SOLVER STATS')
%options = odeset(
%    'Stats','on','InitialStep',sysmodel.solver.initstep,'MaxStep',sysmodel.solver.maxstep);
  
    options = odeset('Stats','on', 'AbsTol',sysmodel.solver.abstol,'RelTol', sysmodel.solver.reltol);
    
    if sysmodel.solver.initstep ~= -1
        options.InitialStep = sysmodel.solver.initstep;
    end
        
    if sysmodel.solver.maxstep ~= -1
         options.MaxStep = sysmodel.solver.maxstep;
    end
    tic
    %figure
[sysmodel.results.Tsim,sysmodel.results.Y] = solver(solverfunc, sysmodel.results.T, sysmodel.initial, options,[], sysmodel);
disp(' ')
toc
%% Finish up simulation and save results
disp(['Evaluating Results']);
sysmodel.info.waitmsg = 'Evaluating results';
sysmodel.results = ProcessResults(sysmodel);
close(sysmodel.info.waith);
save(strcat('Results\',sysmodel.info.name,'.mat'),'sysmodel');
disp(['Simulation Complete']);
