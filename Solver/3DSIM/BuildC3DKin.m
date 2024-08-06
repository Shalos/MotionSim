function [ C ] = BuildC3DKin( system,t )
%Constraint matrix for 3d Kinematic simulations using Euler parameters

%preallocate constraint matrix
C = zeros(system.info.cdof,1);
C(1:6,1) = [system.body(1).R; system.body(1).P(2:4)];

%Fill constraint matrix
index = 7;
for x = 1:system.info.joints
    [ i,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,...
        Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj ] = system.joint(x).solverinfo{:};
    
    if system.joint(x).Type == 1   %spherical
        C(index:index+2, 1) = Ri + Pi - Rj-Pj;
        index = index +3;
    elseif system.joint(x).Type ==2 %rev
        %calculate vectors
        Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);

        [ W_vect, V_vect ] = twoperpvect3D( Si );
        
        %fill constraint portion
        C(index:index+2, 1) = Ri + Pi - Rj-Pj;
        C(index+3,1)        = W_vect'*Sj;
        C(index+4,1)        = V_vect'*Sj;
        index = index +5;
    elseif system.joint(x).Type ==3 %cyl
        %calculate extra variables
        Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
       
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        [ W_vect, V_vect ] = twoperpvect3D( Si );
        
        %fill in matrix
        C(index,1)        = W_vect'*Pij;
        C(index+1,1)        = V_vect'*Pij;
        C(index+2,1)        = W_vect'*Sj;
        C(index+3,1)        = V_vect'*Sj;
        
        index = index +4;
    elseif system.joint(x).Type ==4 %ss
        %calculate the vectors
        d = Rj+ Pj-Ri - Pi;
        %dd = Rdj + Pdj  - Rdi - Pdi ;
        L = system.joint(x).L;
        %fill in constraint matrix
        C(index,1)        = d'*d-L^2;
        index = index +1;
     elseif system.joint(x).Type ==5 %prismatic
        %calculate extra vectors
        Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
       
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        [ W_vect, V_vect ] = twoperpvect3D( Si );
        [ Wj_vect, Vj_vect ] = twoperpvect3D( Sj );
        
        %fill in constraint matrix
        %perp type 2
        C(index,1)        = W_vect'*Pij;
        C(index+1,1)        = V_vect'*Pij;
        %perp type 1
        C(index+2,1)        = W_vect'*Sj;
        C(index+3,1)        = V_vect'*Sj;
        C(index+4,1)        = V_vect'*Wj_vect;
        index = index +5;
    end 
end

%Fill in the final constraint, for the jacobian that is the euler
%parameters constraints to make bodies form a 7x7 matrix for fully
%constrainted
for x = 1:system.info.bodies
     C(index,1) = system.body(x).P'*system.body(x).P - 1;
    index = index + 1; 
end

%Now fill in driving constraints
for x = 1:system.info.drivers
[coord,R, X,Y,Z,ft,fdt,fddt,body] = DecompDriver( system, x );

        e1 = system.body(body).P(2);
        e2 = system.body(body).P(3);
        e3 = system.body(body).P(4);

    if coord == 'X'
        C(index,1) = X  - eval(ft);
    elseif coord == 'Y'
        C(index,1) = Y  - eval(ft);
    elseif coord == 'Z'
        C(index,1) = Z  - eval(ft);
    elseif strcmp(coord, 'e1')
        C(index,1) =  e1 - eval(ft);
    elseif strcmp(coord, 'e2')

        C(index,1) =  e2 - eval(ft);
    elseif strcmp(coord, 'e3')

        C(index,1) =  e3 - eval(ft);
    end 
    
   index = index +1;
end
end

