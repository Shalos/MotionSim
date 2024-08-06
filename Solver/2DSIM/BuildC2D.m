function [ C ] = BuildC2D( system, t )
%%%%%%%%%%%%%%%%%Construct C, contraint matrix%%%%%%%%%%%%%%%%%%%%%%%%
%Construct the constraint matrix of the system

%preallocate matrix, and setup ground body since it is hardcoded
C = zeros(system.info.cdof,1);
C(1:3,1) = [system.body(1).R; system.body(1).PHIZ];

%begin filling out constraint matrix
index = 4;
for x = 1:system.info.joints
    %unpack constraint information
    [ i,j,Ai,Aj,Ri,Rj,si,sj,sqi,Si,Sj,Sqi,...
        phii,phij,Rdj,Rdi,wi,wj,Aphii,Aphij] = system.joint(x).solverinfo{:};
    
    if system.joint(x).Type == 1   %Rev Joint
        C(index:index+1, 1) = Ri + Ai*si - Rj-Aj*sj;
        index = index +2;
    elseif system.joint(x).Type == 2   %trans Joint
        %locate initial angles for use
        theti =system.initial((i*3));
        thetj =system.initial((j*3));
        
        %Convert sq into a perp vector
        ni = sqi - si;
        ni = [cos(90*pi/180), -sin(90*pi/180); sin(90*pi/180), cos(90*pi/180)]*ni;
        
        %calc some differences to make solving easier
        Rij = Ri + Sqi-Rj -Sj;
        Hi = Ai*(ni);
        %fill in constraint matrix
        C(index, 1) = Hi'*Rij;
        C(index+1, 1) = phii- phij - (theti-thetj);
        index = index +2;
    end
end

%fill in driver data for the constraint matrix
for x = 1:system.info.drivers
[ body,R,X,Y,coord,ft,fdt,fddt ] = DecompDriver2D( system, x );
    if coord == 'X'
        C(index,1) = X  - eval(ft);
    elseif coord == 'Y'
        C(index,1) = Y - eval(ft);
    elseif coord == 'PHI'
        C(index,1) =system.body(body).PHIZ-eval(ft);
    end    
   index = index +1;
end
end

