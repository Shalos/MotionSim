function [ yd ] = CalcDyn3D(t, y,flag, sysmodel)
%3D Dynamic simulation solver, input data is the current time and system
%information [q,qd], this function outputs the derivative [qd,qdd] for the
%ODE45 algorithm. 


if ~sysmodel.info.simulink
waitbar(t/sysmodel.solver.endtime,sysmodel.info.waith,sprintf([sysmodel.info.waitmsg ': Sim Time - %12.3f'], t));
end


%%%%%%%%%%%%%INITIALIZE AND SETUP CURRENT ITERATION VALUES%%%%%%%%%%%%%
%fill out system info from previous RK update, the parameters needed
%for further calculation, as long as updating the system struct.




qd = y(1+7*sysmodel.info.bodies:7*sysmodel.info.bodies+6*sysmodel.info.bodies);
qdp = [];
for x = 1:sysmodel.info.bodies
    
    %iterate through the different bodies. m updates the corresponding
    %parameters in the y matrix to its particular body. where the
    % coordinates, euler paramters, velocites, and angular velocities
    %are stored for calculation
    m = 1 + (x-1)*7;
    sysmodel.body(x).R = y(m:m+2,1); %1:3
    sysmodel.body(x).P = y(m+3:m+6,1);  %4:7
    m = 1+7*sysmodel.info.bodies + (x-1)*6;
    sysmodel.body(x).Rd = y(m:m+2,1);   %8:10
    sysmodel.body(x).w = y(m+3:m+5,1);    %11:13
   
    
    %find the transformation matrix from helper functions
    sysmodel.body(x).A = euler_amat(sysmodel.body(x).P);

    %calculate the derivative of Euler parameters for output
    sysmodel.body(x).Pd = .5*calcL(sysmodel.body(x).P)'*sysmodel.body(x).w;  %calc p dot
    qdp = [qdp;y(m:m+2,1); .5*calcL(sysmodel.body(x).P)'*sysmodel.body(x).w];

    %precalculate the Skew of the angular velocity matrix to save
    %computations
     sysmodel.body(x).SkewW = Skew(sysmodel.body(x).w);
end

%pre compute joint information, to be used later in building matrices. Do
%this early, so not to repeat multiple times with other matrices saving
%time.
for x = 1:sysmodel.info.joints
   sysmodel.joint(x).solverinfo = DecompJointSys( sysmodel, x, 1 );
end



%%%%%%%%%%%%CONSTRAINTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the constraint matrices for the corresponding joints
%for the system. Seperated into a different fuction due to the number of
%constraints needed to be handeled
Cq = BuildCq3D( sysmodel, t);
Ctt = BuildCtt(sysmodel,t);
Qd = BuildQd3D(sysmodel,t);
C = BuildC3D(sysmodel,t);
Ct = BuildCt(sysmodel,t);

%%%%%%%%%% Qd Matrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate the Qd matrix for the RHS portion of the constraints, this is
%from the derivations of Cq*qdd=Qd, where Qd = -Ctt -d/dq(Cq*qd)Qd -
%2*Cqt*qd.. where all but the -d/dq(Cq*qd)Qd is zero.
if ~isempty(Qd)
    Qd = Qd + Ctt;
end

%%%%%%%%%%%%%%%%%%CONSTRAINT CORRECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %constraint stabilization, Using the constraint stabilization techniques
% the alpha and beta can be set for each joint, and then added to
% its corresponding gamma for correction. Alpha and Beta controlling the
% system response
alpha = sysmodel.info.alpha;
beta = sysmodel.info.beta;
Cerror = C;
Cvelerror = (Cq*qd - Ct);

if ~isempty(Qd) && sysmodel.info.stabilize
    Qd = Qd - 2*alpha*Cvelerror - beta^2*C; 
end

%%%%%%%%%%%%%%%%%%%%%Assembling augmented matrix%%%%%%%%%%%%%%%%%
%assemble augemented form of the matrix, with the constraint and mass
%matrices into one large matrix
i =size(Cq,1);
MATRIX = [diag(sysmodel.massvect), Cq';
          Cq, zeros(i,i)];

%%%%%%%%%%%%%%%% ASSEMBLING RIGHT HAND SIDE%%%%%%%%%%%%%%%%%%%%%%%%
%Build the right hand side of the equation, or force matrix
%fill out bodie forces and moments
Qe = sysmodel.forcevect;
for x = 2:sysmodel.info.bodies
    m = 1+(x-1)*6;
    n = 1;
   % Qe(m:m+2,n) = sysmodel.body(x).Force;
    Qe(m+3:m+5,n) = sysmodel.body(x).A*Qe(m+3:m+5,n) - sysmodel.body(x).SkewW*diag(sysmodel.body(x).I)*sysmodel.body(x).w;
end
Qe = Qe + SpringDamperDyn3D(sysmodel,t);

%combine forces with joint data.
RHS = [Qe; Qd];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%SOLVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%solve system of equations for rdd and wd, using the simple inverse method
%LU factorization or sparse matrices may later be used to expedite
%calculation
i =size(Cq,1);
MATRIX = [diag(sysmodel.massvect), Cq'       ;
                Cq,               zeros(i,i)];

ANS = MATRIX\RHS; 

%%%%%%%%%%%%%%%%%%%%%%%%%%ASSEMBLE OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%construct the output of the derivitives for continueing numerical
%approximation rd and wd calculated from the RK algorithm, while the new
%accelerations are placed into an OUTPUT variables.
OUTPUT = [qdp;ANS(1:sysmodel.info.bodies*6)];

%return to sender, OUTPUT is the variable given to yd to be sent out of the
%function, unless data is being extracted for analysis
if sysmodel.eval
    points = evalpoints( sysmodel, ANS );
    yd = struct('points',points, 'output', OUTPUT, 'Cerror', Cerror, 'Cvelerror', Cvelerror, 'Qe', Qe, 'Qd', Qd,'lambda',ANS(sysmodel.info.bodies*6+1:length(ANS)), 'CForces',  Cq'*ANS(sysmodel.info.bodies*6+1:length(ANS)));
else
    yd = [OUTPUT];
end

end

