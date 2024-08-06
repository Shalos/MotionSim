function [ results ] = ProcessResults( sysmodel )
%RESULTSAVE Summary of this function goes here
%   Detailed explanation goes here
Y = sysmodel.results.Y;
T = sysmodel.results.T;

%% setup data structure
coord = struct('q', [], 'qd', [], 'qdd', []);
forces = struct('body', [], 'joint', [], 'Qd', []);
error = struct('Cerror',[],'Cvelerror',[]);

data = struct('coord', coord, 'forces', forces, 'error', error, 'T', T,'Y',Y, 'points', coord);

%% arrange and find properties
bodyposdof = sysmodel.info.bodydof(1);
bodyveldof = sysmodel.info.bodydof(2);
bodyaccdof = sysmodel.info.bodydof(3);
data.coord.q = Y(:,1:sysmodel.info.bodies*bodyposdof);

data.coord.qd = Y(:,1+sysmodel.info.bodies*bodyposdof:sysmodel.info.totdof+sysmodel.info.bodies*bodyposdof);

%Evaluate extra data and store in data variables
sysmodel.eval = 1;
for x = 1:length(T)
    Yd(x) = sysmodel.solver.solverfunc(T(x), Y(x,:)', [], sysmodel);
    %if T(x) > 10
    data.coord.qdd(x,:) =  Yd(x).output(1+sysmodel.info.bodies*bodyposdof:sysmodel.info.totdof+sysmodel.info.bodies*bodyposdof);
    
    data.forces.body(x,:) = Yd(x).Qe;
    data.forces.bdyjoint(x,:) = Yd(x).CForces;
    data.forces.Qd(x,:) = Yd(x).Qd;
    
    data.joints.lambda(x,:) = Yd(x).lambda';
    
    data.joints.Cerror(x,:) = Yd(x).Cerror;
    data.joints.Cvelerror(x,:) = Yd(x).Cvelerror;
    if sysmodel.info.numpts > 0
        data.points.q(x,:) = Yd(x).points.q;
        data.points.qd(x,:) = Yd(x).points.qd;
        data.points.qdd(x,:) = Yd(x).points.qdd;
    end
   % end
end

%% save results into the sysmodel and output
results = data;

end

