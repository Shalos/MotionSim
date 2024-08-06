function [ Qd ] = BuildQd2D( system )
%Construct the Qd matrix, that will be the vector of forces to solve for
%constraint equations

%preallocated Qd matrix, make sure long enough for addition with Ctt
Qd = zeros(system.info.cdof,1);

index = 4;
for x = 1:system.info.joints
    [ i,j,Ai,Aj,Ri,Rj,si,sj,sqi,Si,Sj,Sqi,...
        phii,phij,Rdj,Rdi,wi,wj,Aphii,Aphij] = system.joint(x).solverinfo{:};
    
    if system.joint(x).Type == 1   %Rev Joint
        %Calculate the Qd for rev joint.
        Qd(index:index+1,1) = Ai*si*wi^2 - Aj*sj*wj^2;
        index = index +2;
    elseif system.joint(x).Type == 2   %trans Joint
        
        %compute normal vector of sqi
        ni = sqi - si;
        ni = [cos(90*pi/180), -sin(90*pi/180); sin(90*pi/180), cos(90*pi/180)]*ni;
        %compute differences for calculations
        hi = (ni);
        Hi = Ai*hi;
        
        Rij = Ri + Si-Rj -Sj;
        %compute the Qd terms for the RHS of the constraints
        Qd(index,1) = -2*wi*(Aphii*hi)'*(Rdi-Rdj)...
            -wi^2*(si'*hi-Rij'*Hi)...
            + 2*wi*wj*(Aphii*hi)'*Aphij*sj...
            -wj^2*Hi'*Sj;
        Qd(index+1) = 0;
        index = index +2;
    end
end
end

