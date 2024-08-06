function [ ] = DynamicSim2D( system )
%Prepares the 2d Dynamic simulation for calculation, invokes the
%ODE45 in solver

%Setup initial conditions for system
fprintf('%s', strcat('Run Simulation...', system.info.name));
disp(' ')
%run DOF analysis
system  = CalcDof( system, 3 );
disp(['Body Dof: ' num2str(system.info.totdof) ' - Constraint DOF: ' ...
    num2str(system.info.cdof) ' = SYSTEM DOF: ' num2str(system.info.dof)])

%Organize variables into initial conditions and vectors for quicker
%computations later.
tic
massvect = [];
forcevect = [];
initpos = [];
initvel = [];
for x = 1:system.info.bodies
    initpos = [initpos;system.body(x).R; system.body(x).PHIZ];
    initvel = [initvel;system.body(x).Rd; system.body(x).w];
    massvect = [massvect; system.body(x).M*[1;1]; system.body(x).I];
    forcevect = [forcevect; system.body(x).Force; system.body(x).Torque];
end
system.forcevect = forcevect;
system.massvect = massvect;
system.initial = [initpos;initvel];

%SIMULATE using either the ode45 subsitute for different algorithms or use
%ODESET to control error and solver.

[T,Y] = ode45(@RKCalcDyn2D, [0,system.info.time], system.initial, [],[], system);
ComputationDuration = toc;
disp(['  Complete:', num2str(ComputationDuration),'s']);

%Once data is complete begin processing and organize data to .mat file for
%later analysis. First step setup variables
tic
fprintf('%s', 'Evaluating Results:');
coord = struct('q', [], 'qd', [], 'qdd', []);
forces = struct('body', [], 'joint', [], 'Qd', []);
error = struct('Cerror',[],'Cvelerror',[]);
data = struct('coord', coord, 'forces', forces, 'error', error, 'T', T, 'points', []);

data.coord.q = Y(:,1:system.info.totdof);
data.coord.qd = Y(:,1+system.info.totdof:2*system.info.totdof);

%Evaluate system data, by re-running the RKCALCDYN Algorithm in order to
%pull out extra data.
system.eval = 1;
for x = 1:length(T)
    Yd(x) = RKCalcDyn2D(T(x), Y(x,:)', [], system);
    data.coord.qdd(x,:) =  Yd(x).output(system.info.totdof+1:2*system.info.totdof);
    
    data.forces.body(x,:) = Yd(x).Qe;
    data.forces.joint(x,:) = Yd(x).lamda;
    data.forces.Qd(x,:) = Yd(x).Qd;
    
    data.error.Cerror(x,:) = Yd(x).Cerror;
    data.error.Cvelerror(x,:) = Yd(x).Cvelerror;
    
    data.points(x,:) = Yd(x).points;
end

%save to RES.mat file
save(strcat('Results\',system.info.name,'RES.mat'),'system', 'data');
compduration = toc;

disp(['  Complete - ', num2str(compduration),'s']);
end

