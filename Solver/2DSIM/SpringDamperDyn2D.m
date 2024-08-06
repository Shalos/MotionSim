function [ springforces ] = SpringDamperDyn2D( system)

%This function handles the spring/dampers that can be placed between 2
%points on 2 different bodies. The vector loop is calculated from a point
%on body i to a point on body j, the magnitude and unit vector is
%calculated. Using hooks law the force is calculated, multiplied by unit
%vector and applied to the points. If the point is a given distance from Cg
%the torque is also applied by the cross of the force vector and point
%vector.

%Damping is done a simular way, but using the velocity loop instead to
%obtain the unit vector and velocity. A damping coeficiant of c is used to
%control the gain of damping.

%Once everything is calculated, the extra forces etc generated and a matrix
%constructed to the same specifications as the right hand side matrix in
%order to add easily.

%create a matric with same dimensions as RHS for easy addition
springforces = zeros(system.info.bodies*3,1);

%Begin the loop between different springs
for x = 1:system.info.numSDA
    %Calculated and insert all the body information into easy to read/use
    %variables
    
    [ i,j,pi,pj,initialL,K,c,Adj,Adi,Ai,Aj,...
        Ri,Rj,Rdi,Rdj,factuator ] = DecompSpringSys2D( system, x );
    %calculate the spring position vector, and velocity vector
    springvect = Rj + Aj*pj- Ri - Ai*pi;
    springvectd = Rdj + Adj*pj  - Rdi - Adi*pi;
    %Use the unitvector function that was created to find the magnitude and
    %unit vector of the position and velocity.
    [ springL,springuvect] = unitvector(springvect);
    
    [ springvel,springuvectd] = unitvector(springvectd);
    
    %Calculate the spring and damping forces from the magnitudes then
    %multiply them by their corresponding unit vectors. Then add the 2
    %vectors to a Force vector
    spforcesp = (initialL-springL)*K;
    spforcedamp = -c*springvel;
    spforcevect = spforcesp*springuvect + spforcedamp*springuvectd+factuator;
    
    %calculate forces/moments on body i, Ensuring the proper direction
    forcesi = -spforcevect;
    momenti = pi(1)*-spforcevect(2)-pi(2)*-spforcevect(1);
    %calculate forces on body j, ensuring the proper direction
    forcesj = spforcevect;
    momentj = pj(1)*spforcevect(2)-pj(2)*spforcevect(1);
    
    %Fill in the springforces matrix with their respective bodies, and then
    %output from function for later use. With careful attention to the
    %ground
    
    m = 1+(i-1)*3;
    n = 3+(i-1)*3;
    springforces(m:n) = springforces(m:n)+ [forcesi; momenti];
    
    m = 1+(j-1)*3;
    n = 3+(j-1)*3;
    springforces(m:n) = springforces(m:n)+ [forcesj; momentj];
    
end

end

