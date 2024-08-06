function [ ] = KinematicSim2D( system )
%2D kinematic solver.

%initialize variables that will be used to save data
coord = struct('q', [], 'qd', [], 'qdd', []);
error = struct('Cerror',[],'Cvelerror',[]);
data = struct('coord', coord, 'error', error, 'T', [], 'points', []);

%begin simulation
disp(['Begining 2D Kinematic simulation: ', system.info.name])


disp(' ')
%run DOF analysis, check for proper system definition
system  = CalcDof( system, 3 );
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
q = [];
qd = [];
for x = 1:system.info.bodies
    q = [q; system.body(x).R; system.body(x).PHIZ];
    qd = [qd; system.body(x).Rd; system.body(x).w];
end

%START SIMULATION
index = 0;
for t = 0:system.info.timestep:system.info.time
    index = index+1;
    %Begin newton raphson iterations. while iterating through time, index holds
    %the current iteration number that is an integer.
    delta = 5;
    count = 0;
    while delta > system.info.accuracy
        
        %reload the system information for current iteration
        for x = 1:system.info.bodies
            m = 1 + (x-1)*3 ;
            system.body(x).R = q(m:m+1);
            system.body(x).PHIZ = q(m+2);
            system.body(x).Rd = qd(m:m+1);
            system.body(x).w = qd(m+2);
            phi = q(m+2);
            system.body(x).A = [cos(phi), -sin(phi); sin(phi), cos(phi)];
        end
        
        %%%%%%%%% precompute joint data to reduce calculations %%%%%%%%%%%%%
        for x = 1:system.info.joints
            system.joint(x).solverinfo = DecompJointSys2D( system, x, 1);
        end
        %if t == 0 store the initial configuration used in some calculations
        %and constraints
        if t == 0
            system.initial = q;
        end
        
        %build the constraint and its jacobian matrices for calculation
        C = BuildC2D(system,t);
        Cq = BuildCq2D(system);
        
        %solve for q and find current accuracy by obtaining the delta, take
        %max absolute value of delta to make sure all constraints meet the
        %desired level of accuracy
        temp = q;
        q = Cq\(-C)+q;
        deltaq = temp-q;
        delta = max(abs(deltaq));
        
        %check to insue the NR iterations have not exceeded a set maximum,
        %if they have then abort the iteration, something may be wrong.
        %count is the variable keeping count of the iterations
        if count > system.info.NRiter
            disp('WARNING MAXIMUM NR ITERATIONS REACHED');
            break
        else
            count = count+1;
        end
        
    end
    %After the NR iterations the positions and information of the system is
    %set, a last update of the matrices allows for calculations of the
    %velocity and accelerations
    
    %Make sure jacobian has update to latest iteration Make sure everything
    %is current so nothing has changed
    C = BuildC2D(system,t);
    Cq = BuildCq2D(system);
    Qd = BuildQd2D(system);
    Ct = BuildCt2D(system,t);
    
    %Capture the intial updated configuration of the system
    if t == 0
        system.initial = q;
    end
    
    %VELOCITY ANALYSIS- With the Position analysis done, using the
    %information found, calculated the velocities is straight forward.
    qd =Cq\(-Ct);
    
    %Acceleration Analsysis
    qdd = Cq\Qd;
        
    %save data for output     
    data.coord.q(index,:) =  q;    
    data.coord.qd(index,:) =  qd;    
    data.coord.qdd(index,:) =  qdd;
    
    data.error.Cerror(index,:) = C;
    data.error.Cvelerror(index,:) = Cq*qd-Ct;
    
    data.points(index,:) = evalpoints2D( system, qdd );
    
    data.T(index) = t;
end

%Save data to NAMERES.mat
save(strcat('Results\',system.info.name,'RES.mat'),'system', 'data');

calctime = toc;
disp(['Calculation Complete  -  Time: ', num2str(calctime), 's']);
end

