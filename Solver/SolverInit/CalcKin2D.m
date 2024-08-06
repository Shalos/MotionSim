function [ Y ] = CalcKin2D(  t, y,flag, sysmodel )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%place initial estimate into a form to be used by the matrix equations.
waitbar(t/sysmodel.solver.endtime,sysmodel.info.waith,sprintf([sysmodel.info.waitmsg ': Sim Time - %12.3f'], t));


    q = y(1:sysmodel.info.totdof);
    qd = y(sysmodel.info.totdof+1:2*sysmodel.info.totdof);
%START SIMULATION
    
    %Begin newton raphson iterations. while iterating through time, index holds
    %the current iteration number that is an integer.
    delta = 5;
    count = 0;
    while delta > sysmodel.solver.reltol
        
        %reload the system information for current iteration
        for x = 1:sysmodel.info.bodies
            m = 1 + (x-1)*3 ;
            sysmodel.body(x).R = q(m:m+1);
            sysmodel.body(x).PHIZ = q(m+2);
            sysmodel.body(x).Rd = qd(m:m+1);
            sysmodel.body(x).w = qd(m+2);
            phi = q(m+2);
            sysmodel.body(x).A = [cos(phi), -sin(phi); sin(phi), cos(phi)];
        end
        
        %%%%%%%%% precompute joint data to reduce calculations %%%%%%%%%%%%%
        for x = 1:sysmodel.info.joints
            sysmodel.joint(x).solverinfo = DecompJointSys2D( sysmodel, x, 1);
        end
        %if t == 0 store the initial configuration used in some calculations
        %and constraints
        if t == 0
            sysmodel.initial = q;
        end
        
        %build the constraint and its jacobian matrices for calculation
        C = BuildC2D(sysmodel,t);
        Cq = BuildCq2D(sysmodel);
        
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
        if count > sysmodel.solver.NRiter
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
    C = BuildC2D(sysmodel,t);
    Cq = BuildCq2D(sysmodel);
    Qd = BuildQd2D(sysmodel);
    Ct = BuildCt2D(sysmodel,t);
    

    %VELOCITY ANALYSIS- With the Position analysis done, using the
    %information found, calculated the velocities is straight forward.
    qd =Cq\(-Ct);
    
    %Acceleration Analsysis
    qdd = Cq\Qd;
        
    %save data for output     
    
OUTPUT = [q;qd];
if sysmodel.eval
    OUTPUT = [qd;qdd];
    points = evalpoints2D( sysmodel, OUTPUT );    
    Cvelerror = (Cq*qd - Ct);

    Y = struct('points',points,'output', OUTPUT,  'Cerror', C,...
                'Cvelerror', Cvelerror,'Qe', 0, 'Qd', Qd,...
                'lambda',  0,'CForces',0);
else
    Y = OUTPUT;
end


end

