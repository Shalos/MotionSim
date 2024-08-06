function [ yd ] = CalcDyn2D( t, y,flag, sysmodel )
%Main function to return accelerations for current timestep in ODE
%algorithm. Variables are passed [q,qd] and returned as [qd,qdd]. The
%velcoities are passed through, while accelerations neeed to be calculated.
if ~sysmodel.info.simulink
waitbar(t/sysmodel.solver.endtime,sysmodel.info.waith,sprintf([sysmodel.info.waitmsg ': Sim Time - %12.3f'], t));
end

%Initilize and setup values to be used in the algorithm.
qd = y(1+3*sysmodel.info.bodies:3*sysmodel.info.bodies+3*sysmodel.info.bodies);%y(sysmodel.info.totdof+1:2*sysmodel.info.totdof);
for x = 1:sysmodel.info.bodies
    
    %iterate through the different bodies and update each body information
    %to current step
    m = 1 + (x-1)*3;
    sysmodel.body(x).R = y(m:m+1,1); 
    sysmodel.body(x).PHIZ = y(m+2,1); 
    m = m + sysmodel.info.totdof;
    sysmodel.body(x).Rd = y(m:m+1,1);   
    sysmodel.body(x).w = y(m+2,1);    
    %calculate the transformation matrices for each body
    phi = sysmodel.body(x).PHIZ;
    sysmodel.body(x).A = [cos(phi), -sin(phi); sin(phi), cos(phi)];
end

%%%%%%%%% precompute joint data to reduce calculations %%%%%%%%%%%%%
for x = 1:sysmodel.info.joints
   sysmodel.joint(x).solverinfo = DecompJointSys2D( sysmodel, x, 1);
end


%%%%%%%%%%%%CONSTRAINTS AND GAMMA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the constraint matrices and their derivitive matrices, assemble
%Qd for the RHS of constraint forces
C = BuildC2D(sysmodel,t);
Cq = BuildCq2D(sysmodel);
Qd = BuildQd2D(sysmodel);
Ct = BuildCt2D(sysmodel,t);
Ctt = BuildCtt2D(sysmodel,t);
if ~isempty(Qd)
    Qd = Qd + Ctt;
end

%Constraint Stabilization implimentation
alpha = sysmodel.info.alpha;
beta = sysmodel.info.beta;
Cvelerror = (Cq*qd - Ct);
Cerror = C;
if ~isempty(Qd) && sysmodel.info.stabilize
    Qd = Qd - 2*alpha*Cvelerror - beta^2*C; %stabilization equation.
end

%%%%%%%%%%%%%%%%%%%%%Assembling augmented matrix%%%%%%%%%%%%%%%%%
%assemble augemented form of the matrix, with the constraint and mass
%matrices into one large matrix

i =size(Cq,1);
MATRIX = [diag(sysmodel.massvect),               Cq';
          Cq,                           zeros(i,i)];

%fill out bodie forces and moments, inject any elements such as spring
%dampers etc.
Qe = sysmodel.forcevect + SpringDamperDyn2D(sysmodel);

%append constraint RHS (Qd) to force vector (Qe) to form RHS of Augmented 
%matrixequation
RHS = [Qe; Qd];

%Solve system of equations, find accelerations and constraint lamda's
ANS = MATRIX\RHS;

%%%%%%%%%%%%%%%%%%%%%%%%%%ASSEMBLE OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%construct the output to be used in the ODE45 Algorithm, follows form of
%[qd; qdd]

OUTPUT = [qd;ANS(1:sysmodel.info.totdof)];
    
%is system is in ODE45 algorithm simply pass velocities, if data is being
%process send out solver data.
if sysmodel.eval
    points = evalpoints2D( sysmodel, ANS );
    yd = struct('points',points,'output', OUTPUT,  'Cerror', Cerror,...
                'Cvelerror', Cvelerror,'Qe', Qe', 'Qd', Qd,...
                'lambda',  ANS(sysmodel.info.bodies*3+1:length(ANS)),'CForces', Cq'*ANS(sysmodel.info.bodies*3+1:length(ANS)));
else
    yd = OUTPUT;
end
end

