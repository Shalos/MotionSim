function [ Cq ] = BuildCq2D( system )
%%%%%%%%%%%%Construct Cq, jacobian of the system%%%%%%%%%%%%%%%%%%%%%%%%
%construct the jacobian matrix of the system
Cq = zeros(system.info.cdof - system.info.drivers, system.info.bodies*3);
Cq(1:3,1:3) = eye(3,3);

%Reconstruct the constraint matrix with initial guesses
index = 4;
for x = 1:system.info.joints
    [ i,j,Ai,Aj,Ri,Rj,si,sj,sqi,Si,Sj,Sqi,...
        phii,phij,Rdj,Rdi,wi,wj,Aphii,Aphij] = system.joint(x).solverinfo{:};
    
    if system.joint(x).Type == 1   %Rev Joint
        ni = 1+(i-1)*3;
        nj = 1+(j-1)*3;
        %for the first body i
        Cq(index:index+1, ni:ni+2) = [eye(2,2), Aphii*si];
        Cq(index:index+1, nj:nj+2) = [-eye(2,2), -Aphij*sj] ;
        
        index = index +2;
    elseif system.joint(x).Type == 2   %trans Joint       
        ni = 1+(i-1)*3;
        nj = 1+(j-1)*3;
        
        %Transform sqi to a vector thats perpendicular to the axis
        normi = sqi - si;
        normi = [cos(90*pi/180), -sin(90*pi/180); sin(90*pi/180), cos(90*pi/180)]*normi;
        
        %process the normal vectors
        hi = (normi);   
        Hi = Ai*(normi); 
        
        %Computer the difference between body coordinates, find D
        Rij = Ri + Si-Rj -Sj;  
        
        %Fill in joint constraints for body i
        Cq(index, ni:ni+2) = [Hi', Rij'*Aphii*hi+Hi'*Aphii*si];
        Cq(index+1, ni:ni+2) =[ 0,0,1];
        
        %fill in joint constraints for body j
        Cq(index, nj:nj+2) = [-Hi', -Hi'*Aphij*sj];
        Cq(index+1, nj:nj+2) = [ 0,0,-1];
        
        index = index +2; %incriments joint location in Cq
    end
end

%Process driving constraints
for x = 1:system.info.drivers
    [ body,R,X,Y,coord,ft,fdt,fddt ] = DecompDriver2D( system, x );
    
    m = 1+(body-1)*3;
    if coord == 'X'
        Cq(index,m) =1;
    elseif coord == 'Y'
        Cq(index,m+1) = 1;
    elseif coord == 'PHI'
        Cq(index,m+2) = 1;
    end  
    index = index +1;
end
end

