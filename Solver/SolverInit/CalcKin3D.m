function [ Y ] = CalcKin3D( t, y,flag, sysmodel )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
waitbar(t/sysmodel.solver.endtime,sysmodel.info.waith,sprintf([sysmodel.info.waitmsg ': Sim Time - %12.3f'], t));


    q = y(1:sysmodel.info.totdof);
    qd = y(sysmodel.info.totdof+1:size(y,1));
    
    delta = 5;
    count = 0;
    while delta > sysmodel.solver.reltol
        
        for x = 1:sysmodel.info.bodies
            m = 1 + (x-1)*7 ;
            n = 1 + (x-1)*6 ;
            sysmodel.body(x).R = q(m:m+2);
            sysmodel.body(x).P = q(m+3:m+6);
            sysmodel.body(x).Rd = qd(m:m+2);
            sysmodel.body(x).Pd =  qd(m+3:m+6);
            sysmodel.body(x).w = 2*calcL(sysmodel.body(x).P)*sysmodel.body(x).Pd;
            sysmodel.body(x).A = euler_amat(sysmodel.body(x).P);
            sysmodel.body(x).SkewW = Skew(sysmodel.body(x).w);
        end
        for x = 1:sysmodel.info.joints
            sysmodel.joint(x).solverinfo = DecompJointSys( sysmodel, x, 1 );
        end
        
        
        %if t == 0 store the initial configuration used in some calculations
        %and constraints
        if t == 0
            sysmodel.initial = q;
        end
        
        %build the constraint and its jacobian matrices for calculation
        Ckin = BuildC3DKin(sysmodel,t);
        Cqkin = BuildCq3DKin(sysmodel);
        
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
        if count > sysmodel.solver.NRiter
            disp(['WARNING MAXIMUM NR ITERATIONS REACHED: Time: ' num2str(t)]);
            disp(num2str( sysmodel.body(1).P'*sysmodel.body(1).P))
            break
        else
            count = count+1;
        end
    end
    
     C = BuildC3DKin(sysmodel,t);
     Cq = BuildCq3DKin(sysmodel);
     Ct = -1*BuildCt(sysmodel,t);
     Qd = BuildQd3DKin(sysmodel);
     Ctt = -1*BuildCttKin(sysmodel,t);
     
         %VELOCITY ANALYSIS- With the Position analysis done, using the
    %information found, calculated the velocities is straight forward.
     qd =Cqkin\(-Ct);
     

     
    %Solve for Accelerations
    qdd = Cq\(Qd-Ctt);
    
    
    OUTPUT = [q;qd];
if sysmodel.eval
    OUTPUT = [qd;qdd];
    points = evalpoints( sysmodel, OUTPUT );    
    Cvelerror = (Cq*qd - Ct);

    Y = struct('points',points,'output', OUTPUT,  'Cerror', C,...
                'Cvelerror', Cvelerror,'Qe', 0, 'Qd', Qd,...
                'lambda',  0,'CForces',0);
else
    Y = OUTPUT;
end
    

end

