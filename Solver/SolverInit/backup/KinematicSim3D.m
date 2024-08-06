function [ ] = KinematicSim3D( system )
%KinematicSim 3d Solver

%calculate degrees of freedom, and check for properly constraint system
disp(['Begining 3D Kinematic simulation: ' system.info.name])
disp(' ')
%run DOF analysis
system  = CalcDof( system, 7 );
disp(['Body Dof: ' num2str(system.info.totdof) ' - Constraint DOF: ' ...
    num2str(system.info.cdof) ' = SYSTEM DOF: ' num2str(system.info.dof)])

if system.info.dof ~= 0
    disp('WARNING SYSTEM DOF NOT PROPERLY CONSTRAINTED, SOLVER WILL FAIL')
    reply = input('Continue? y/n','s');
    if reply ~= 'y'
        return
    end
end


tic
%place initial estimate into a form to be used by the matrix equations.
coord = struct('q', [], 'qd', [], 'qdd', []);
error = struct('Cerror',[],'Cvelerror',[]);
data = struct('coord', coord, 'error', error, 'T', [], 'points', []);

q = [];
qd = [];
for x = 1:system.info.bodies
    q = [q; system.body(x).R; system.body(x).P];
    qd = [qd; system.body(x).Rd; .5*calcL(system.body(x).P)'*system.body(x).w];
end

%Begin Simulation
index = 0;
for t = 0:system.info.timestep:system.info.time
    index = index+1;
    %Using NR method, find the position at the current time step. delta is
    %the current accuracy, count is the number of iterations past
    delta = 5;
    count = 0;
    while delta > system.info.accuracy
        
        %reload the system information for current iteration
        for x = 1:system.info.bodies
            m = 1 + (x-1)*7 ;
            n = 1 + (x-1)*6 ;
            system.body(x).R = q(m:m+2);
            system.body(x).P = q(m+3:m+6);
            system.body(x).Rd = qd(m:m+2);
            system.body(x).Pd =  qd(m+3:m+6);
            system.body(x).w = 2*calcL(system.body(x).P)*system.body(x).Pd;
            system.body(x).A = euler_amat(system.body(x).P);
            system.body(x).SkewW = Skew(system.body(x).w);
        end
        for x = 1:system.info.joints
            system.joint(x).solverinfo = DecompJointSys( system, x, 1 );
        end

        %if t == 0 store the initial configuration used in some calculations
        %and constraints
        if t == 0
            system.initial = q;
        end
        
        %build the constraint and its jacobian matrices for calculation
        Ckin = BuildC3DKin(system,t);
        Cqkin = BuildCq3DKin(system);
        
        %solve for q and find current accuracy by obtaining the delta, take
        %max absolute value of delta to make sure all constraints meet the
        %desired level of accuracy
        temp = q;
        q = Cqkin\(-Ckin)+q;
        deltaq = temp-q;
        delta = max(abs(deltaq));
        
        %check to insue the NR iterations have not exceeded a set maximum,
        %if they have then abort the iteration, something may be wrong.
        %count is the variable keeping count of the iterations
        if count > system.info.NRiter
            disp(['WARNING MAXIMUM NR ITERATIONS REACHED: Time: ' num2str(t)]);
            disp(num2str( system.body(1).P'*system.body(1).P))
            break
        else
            count = count+1;
        end
        
    end
    %After the NR iterations the positions and information of the system is
    %set, a last update of the matrices allows for calculations of the
    %velocity and accelerations
    
    for x = 1:system.info.bodies
        m = 1 + (x-1)*7 ;
        n = 1 + (x-1)*6 ;
        system.body(x).R = q(m:m+2);
        system.body(x).P = q(m+3:m+6);
        system.body(x).Rd = qd(n:n+2);
        system.body(x).Pd =  qd(m+3:m+6);
        system.body(x).w = 2*calcL(system.body(x).P)*system.body(x).Pd;
        system.body(x).A = euler_amat(system.body(x).P);
        system.body(x).SkewW = Skew(system.body(x).w);
    end
    for x = 1:system.info.joints
        system.joint(x).solverinfo = DecompJointSys( system, x, 1 );
    end
    
    %Calculate Matrices to be used for analysis
     C = BuildC3DKin(system,t);
     Cq = BuildCq3DKin(system);
     Ct = -1*BuildCt(system,t);
     Qd = BuildQd3DKin(system);
     Ctt = -1*BuildCttKin(system,t);
     
    %Capture the intial updated configuration of the system
    if t == 0
        system.initial = q;
    end

    %VELOCITY ANALYSIS- With the Position analysis done, using the
    %information found, calculated the velocities is straight forward.
     qd =Cqkin\(-Ct);
     

     
    %Solve for Accelerations
    qdd = Cq\(Qd-Ctt);

    %Compile data into standard format, in the data variable, also with raw
    %data.   
    data.coord.q(index,:) =  q;    
    data.coord.qd(index,:) =  qd;    
    data.coord.qdd(index,:) =  qdd;
    
    data.error.Cerror(index,:) = C;
    data.error.Cvelerror(index,:) = Cq*qd-Ct;
    
    data.points(index,:) = evalpoints( system, [qd;qdd] );
    
    data.T(index) = t;
end

save(strcat('Results\',system.info.name,'RES.mat'),'system', 'data');

calctime = toc;
disp(['Calculation Complete  -  Time: ', num2str(calctime), 's']);
end

