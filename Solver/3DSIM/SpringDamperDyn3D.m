function [ springforces ] = SpringDamperDyn3D( sysmodel,t )

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
springforces = zeros(sysmodel.info.bodies*6,1);
%Begin the loop between different springs
for x = 1:sysmodel.info.numSDA
    %Calculated and insert all the body information into easy to read/use
    %variables
    
    [ i,j,pi,pj,initialL,K,c,wj,wi,Ai,Aj,...
        Ri,Rj,Rdi,Rdj,factuator ] = DecompSpringSys( sysmodel, x );
    %calculate the spring position vector, and velocity vector
    springvect = Rj + Aj*pj- Ri - Ai*pi;
    springvectd = Rdj + Aj*Skew(wj)*pj  - Rdi - Ai*Skew(wi)*pi;
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
    momenti = cross(pi,-spforcevect);
    %calculate forces on body j, ensuring the proper direction
    forcesj = spforcevect;
    momentj = cross(pj,spforcevect);
    
fx = 0;
SA = 5;
P = 14;
IA = 1;  
flag = 0;
    if j==1
       late = sysmodel.bodyinit(i).R(2)-sysmodel.body(i).R(2);
        if t<5
            control = 5000;
        else
            
            if sysmodel.body(2).R(1) < 10
                flag = 1;
            end
             
            if flag == 1
               control = 10*(sysmodel.body(2).R(1)); 
            else
            control = 100*(sysmodel.body(2).Rdd(1)-100);%-sysmodel.body(2).Rd(1)*100;
            end
        end
        if sysmodel.body(2).Rd(1) < .1
           control = 0; 
        end
        %sysmodel.body(2).Rd(1)
       forcesi = [control late*500 forcesi(3)]';
       momenti = [0 0 0]';
       
    end
    %Fill in the springforces matrix with their respective bodies, and then
    %output from function for later use. With careful attention to the
    %ground
    
    m = 1+(i-1)*6;
    n = 6+(i-1)*6;
    springforces(m:n) = springforces(m:n)+ [forcesi; momenti];
    
    m = 1+(j-1)*6;
    n = 6+(j-1)*6;
    springforces(m:n) = springforces(m:n)+ [forcesj; momentj];
    






    if i == 5 || i == 13
        m = 2+(i-1)*6;
       % sysmodel.ANN([fx;SA;P;IA;abs(spforcesp)]);
      %  springforces(m) = springforces(m) + sysmodel.ANN([fx;SA;P;IA;abs(spforcesp)]);
        %sysmodel.ANN([fx;SA;P;IA;abs(spforcesp)]);
    end
    
    if i == 9 || i == 17 
    m = 2+(i-1)*6;
    %springforces(m) = springforces(m) + sysmodel.ANN([fx;SA;P;IA;abs(spforcesp)]); %inputs = [FX,SA,P,IA,FZ];
    end
    
end

end

