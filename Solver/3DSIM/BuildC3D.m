function [ C ] = BuildC3D( system,t )
%construct the constraint matrix for the 3D dynamic analysis

%preallocate constraint matrix
C = zeros(system.info.cdof,1);
C(1:6,1) = [system.body(1).R; system.body(1).P(2:4)];

%fill in constraint matrix
index = 7;
for x = 1:system.info.joints
    [ i,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,...
        Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj ] = system.joint(x).solverinfo{:};
    if system.joint(x).Type == 1   %spherical
        C(index:index+2, 1) = Ri + Pi - Rj-Pj;
        index = index +3;
    elseif system.joint(x).Type ==2 %rev
        
        %calculate the perpindicular vectors
        si = (pi - qi);
        Sj = Aj*(pj - qj);
        
        [ w_vect, v_vect ] = twoperpvect3D( si );
                W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        %fill in constraints
        C(index:index+2, 1) = Ri + Pi - Rj-Pj;
        C(index+3,1)        = W_vect'*Sj;
        C(index+4,1)        = V_vect'*Sj;
        
        index = index +5;
    elseif system.joint(x).Type ==3 %cyl
        %calculate the vectors and perpindicular vectors, and the loop
      %  Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
        si = (pi - qi);
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        
        [ w_vect, v_vect ] = twoperpvect3D( si );
        
         W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        
        C(index,1)        = W_vect'*Pij;
        C(index+1,1)        = V_vect'*Pij;
        
        C(index+2,1)        = W_vect'*Sj;
        C(index+3,1)        = V_vect'*Sj;
        index = index +4;
    elseif system.joint(x).Type ==4 %Spherical-Spherical
        %calculate the distance vector
        d = Rj+ Pj-Ri - Pi;
        %dd = Rdj + Pdj  - Rdi - Pdi ;
        L = system.joint(x).L;
        C(index,1)        = d'*d-L^2;
        index = index +1;
    elseif system.joint(x).Type ==5 %prismatic
        %calculate needed vectors
        Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
        Si = (pi - qi);
        sj = (pj - qj);
        
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        
        [ w_vect, v_vect ] = twoperpvect3D( si );
         W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        
        [ wj_vect, vj_vect ] = twoperpvect3D( sj );
        Wj_vect = Aj*wj_vect;
        Vj_vect = Aj*vj_vect;
       
        %perp type 2
        C(index,1)        = W_vect'*Pij;
        C(index+1,1)        = V_vect'*Pij;
        %perp type 1
        C(index+2,1)        = W_vect'*Sj;
        C(index+3,1)        = V_vect'*Sj;
        C(index+4,1)        = V_vect'*Wj_vect;
        index = index +5;
    elseif system.joint(x).Type ==6 % U joint
        
        
        
        C(index:index+2, 1) = Ri + Pi - Rj-Pj;
        index = index +3;    
    end
    
end

%Now append driving constraints

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
     elseif coord == 'e1'
%         

         C(index,1) =  e1 - eval(ft);
     elseif coord == 'e2'
%         
         C(index,1) =  e2 - eval(ft);
     elseif coord == 'e3'
%         
         C(index,1) =  e3 - eval(ft);
    end 
    index = index +1;
end
end

