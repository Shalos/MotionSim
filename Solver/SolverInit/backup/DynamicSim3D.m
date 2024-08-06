function [ ] = DynamicSim3D( system, post, saveexcel )
%Dynamic 3D solver
fprintf('%s', strcat('Run Simulation...', system.info.name));

%Process the degrees of freedom
disp(' ')
system  = CalcDof( system, 6 );
disp(['Body Dof: ' num2str(system.info.totdof) ' - Constraint DOF: ' ...
    num2str(system.info.cdof) ' = SYSTEM DOF: ' num2str(system.info.dof)])

%setup intial condition and vectors for use in the solver
tic
massvect = [];
forcevect = [];
initpos = [];
initvel = [];
for x = 1:system.info.bodies
    initpos = [initpos;system.body(x).R; system.body(x).P];
    initvel = [initvel;system.body(x).Rd; system.body(x).w];
    massvect = [massvect; system.body(x).M*[1;1;1]; system.body(x).I];
    forcevect = [forcevect; system.body(x).Force; system.body(x).Torque];
end
system.forcevect = forcevect;
system.massvect = massvect;
system.initial = [initpos;initvel];
system.info.waitmsg = 'Running Simulation';
system.h = waitbar(0,system.info.waitmsg);

%SIMULATE using ODE45, use a different solver or ODESET to control ODE
%solver
[T,Y] = ode45(@RKCalcDyn3D, 0:system.info.timestep:system.info.time, system.initial, [],[], system);

%close(h);
system.info.waitmsg = 'Evaluating results';
%Process the results suchs as forces, errors etc


coord = struct('q', [], 'qd', [], 'qdd', []);
forces = struct('body', [], 'joint', [], 'Qd', []);
error = struct('Cerror',[],'Cvelerror',[]);
data = struct('coord', coord, 'forces', forces, 'error', error, 'T', T, 'points', []);

data.coord.q = Y(:,1:system.info.bodies*7);

data.coord.qd = Y(:,1+system.info.bodies*7:system.info.totdof+system.info.bodies*7);

%Evaluate extra data and store in data variables
system.eval = 1;
for x = 1:length(T)
    Yd(x) = RKCalcDyn3D(T(x), Y(x,:)', [], system);
    data.coord.qdd(x,:) =  Yd(x).output(1+system.info.bodies*7:system.info.totdof+system.info.bodies*7);
    
    data.forces.body(x,:) = Yd(x).Qe;
    data.forces.joint(x,:) = Yd(x).lamda;
    data.forces.Qd(x,:) = Yd(x).Qd;
    
    data.error.Cerror(x,:) = Yd(x).Cerror;
    data.error.Cvelerror(x,:) = Yd(x).Cvelerror;
    
    data.points(x,:) = Yd.points;
end

%save data and system information
save(strcat('Results\',system.info.name,'RES.mat'),'system', 'data');

disp(['  Complete - ', num2str(toc),'s']);
close(system.h);
end

