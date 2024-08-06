function [ Cq ] = BuildCq3D( system,t )
%Build the jacobian matrix for 3D Dynamic Solver

%preallocated jacobian matrix and body info
Cq = zeros(system.info.cdof - system.info.drivers, system.info.bodies*6);
Cq(1:6,1:6) = eye(6,6);

%build the rest of the matrix
index = 7;
for x = 1:system.info.joints
    %%% Load common variables between joints into simple variables for
    %%% calculation
    [ i,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,...
        Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj ] = system.joint(x).solverinfo{:};
    
    if system.joint(x).Type == 1   %for joint type of spherical
    
        ni = 1+(i-1)*6;
        nj = 1+(j-1)*6;
        %for body i
        Cq(index:index+2,ni:ni+5) = [eye(3,3), -Skew(Pi)*Ai];
        %for body j
        Cq(index:index+2,nj:nj+5) = [-eye(3,3), Skew(Pj)*Aj];
        
        index = index+3;
    elseif system.joint(x).Type == 2 %rev
        ni = 1+(i-1)*6;
        nj = 1+(j-1)*6;
        
        si = (pi - qi);
        Sj = Aj*(pj - qj);
        [ w_vect, v_vect ] = twoperpvect3D( si );
        
         W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        
        %for body i
        Cq(index:index+2,ni:ni+5) = [eye(3,3), -Skew(Pi)*Ai]; %spherical portion
%         Cq(index+3,ni:ni+5) = [0,0,0,-Sj'*Skew(W_vect)*Ai]; %perp type 1
%         Cq(index+4,ni:ni+5) = [0,0,0,-Sj'*Skew(V_vect)*Ai]; %perp type 1
        Cq(index+3,ni:ni+5) = [0,0,0,-Sj'*Skew(W_vect)*Ai]; %perp type 1
        Cq(index+4,ni:ni+5) = [0,0,0,-Sj'*Skew(V_vect)*Ai]; %perp type 1
        %for body j
        Cq(index:index+2,nj:nj+5) = [-eye(3,3),Skew(Pj)*Aj]; %spherical portion
%         Cq(index+3,nj:nj+5) = [0,0,0,-W_vect'*Skew(Sj)*Aj];
%         Cq(index+4,nj:nj+5) = [0,0,0,-V_vect'*Skew(Sj)*Aj];
        Cq(index+3,nj:nj+5) = [0,0,0,-W_vect'*Skew(Sj)*Aj];
        Cq(index+4,nj:nj+5) = [0,0,0,-V_vect'*Skew(Sj)*Aj];
        
        
        index = index + 5;
    elseif system.joint(x).Type == 3 %cylindrical
        ni = 1+(i-1)*6;
        nj = 1+(j-1)*6;
        
       % Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
        
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        
        si = (pi - qi);
        [ w_vect, v_vect ] = twoperpvect3D( si );
        
         W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        
        %for body i
        %Perp Type two
        Cq(index,ni:ni+5) = [-W_vect',-(Pij + Pi)'*Skew(W_vect)*Ai];
        Cq(index+1,ni:ni+5) = [-V_vect',-(Pij + Pi)'*Skew(V_vect)*Ai];
        %Perp Type one
        Cq(index+2,ni:ni+5) = [0,0,0,-Sj'*Skew(W_vect)*Ai];
        Cq(index+3,ni:ni+5) = [0,0,0,-Sj'*Skew(V_vect)*Ai];
        
        %for body j
        %Perp Type two
        Cq(index,nj:nj+5) = [W_vect', - W_vect'*Skew(Pj)*Aj];
        Cq(index+1,nj:nj+5) = [V_vect', -V_vect'*Skew(Pj)*Aj];
        %Perp Type one
        Cq(index+2,nj:nj+5) = [0,0,0,-W_vect'*Skew(Sj)*Aj];
        Cq(index+3,nj:nj+5) = [0,0,0,-V_vect'*Skew(Sj)*Aj];
        
        index = index + 4;
    elseif system.joint(x).Type == 4 %for joint type of S-S
        ni = 1+(i-1)*6;
        nj = 1+(j-1)*6;
        
        d = Rj+ Pj-Ri - Pi;
        %dd = Rdj + Pdj  - Rdi - Pdi ;
        
        %for body i
        Cq(index,ni:ni+5) = [-2*d', 2*d'*Ai*Skew(pi)];
        %for body j
        Cq(index,nj:nj+5) = [2*d',  -2*d'*Aj*Skew(pj)];
        
        index = index +1;
    elseif system.joint(x).Type == 5 %prismatic
        ni = 1+(i-1)*6;
        nj = 1+(j-1)*6;
        
      %  Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
       % si = Ai*(pi - qi);
        sj = Aj*(pj - qj);
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        
        
         si = (pi - qi);
        [ w_vect, v_vect ] = twoperpvect3D( si );
        
         W_vect = Ai*w_vect;
         V_vect = Ai*v_vect;
        
                
        [ wj_vect, vj_vect ] = twoperpvect3D( sj );
        
         Wj_vect = Aj*wj_vect;
     %    Vj_vect = Aj*vj_vect;
        
        %for body i
        %Perp Type two
        Cq(index,ni:ni+5) = [-W_vect',-(Pij + Pi)'*Skew(W_vect)*Ai];
        Cq(index+1,ni:ni+5) = [-V_vect',-(Pij + Pi)'*Skew(V_vect)*Ai];
        %Perp Type one
        Cq(index+2,ni:ni+5) = [0,0,0,-Sj'*Skew(W_vect)*Ai];
        Cq(index+3,ni:ni+5) = [0,0,0,-Sj'*Skew(V_vect)*Ai];
        Cq(index+4,ni:ni+5) = [0,0,0,-Wj_vect'*Skew(V_vect)*Ai];
        
        %for body j
        %Perp Type two
        Cq(index,nj:nj+5) = [W_vect', - W_vect'*Skew(Pj)*Aj];
        Cq(index+1,nj:nj+5) = [V_vect', -V_vect'*Skew(Pj)*Aj];
        %Perp Type one
        Cq(index+2,nj:nj+5) = [0,0,0,-W_vect'*Skew(Sj)*Aj];
        Cq(index+3,nj:nj+5) = [0,0,0,-V_vect'*Skew(Sj)*Aj];
        Cq(index+4,nj:nj+5) = [0,0,0,-V_vect'*Skew(Wj_vect)*Aj];
        
        index = index + 5;  
    elseif system.joint(x).Type == 6
            
        ni = 1+(i-1)*6;
        nj = 1+(j-1)*6;
        %for body i
        Cq(index:index+2,ni:ni+5) = [eye(3,3), -Skew(Pi)*Ai];
        %for body j
        Cq(index:index+2,nj:nj+5) = [-eye(3,3), Skew(Pj)*Aj];
        
        index = index+3;
    end
end

%driving constraints for Cq to be added in.
for x = 1:system.info.drivers
    [coord,R, X,Y,Z,ft,fdt,fddt,body] = DecompDriver( system, x );
    
    m = 1+(body-1)*6;
    
    if coord == 'X'
        Cq(index,m) =1;
    elseif coord == 'Y'
        Cq(index,m+1) = 1;
    elseif coord == 'Z'
        Cq(index,m+2) = 1;
    elseif strcmp(coord, 'e1')
        Cq(index,m+3) = 1;
    elseif strcmp(coord, 'e2')
        Cq(index,m+4) = 1;
    elseif strcmp(coord, 'e3')
        Cq(index,m+5) = 1;
    end

    index = index +1 ;
end
end

