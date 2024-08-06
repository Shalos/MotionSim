function [ Cq ] = BuildCq3DKin( system,t )
%Calculate jacobian based on Euler parameters for 3d Kinematic solver

%preallocate matrix
Cq = zeros(system.info.cdof, system.info.bodies*7);
Cq(1:3,1:3) = eye(3,3);
Cq(4:6,5:7) = eye(3,3);

%fill in matrix
index = 7;
for x = 1:system.info.joints
    %%% Load common variables between joints into simple variables for
    %%% calculation
    [ i,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,...
        Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj ] = system.joint(x).solverinfo{:};
    
    %process constraints
    if system.joint(x).Type == 1   %for joint type of spherical
        ni = 1+(i-1)*7;
        nj = 1+(j-1)*7;
        
        ei = system.body(i).P;
        ej = system.body(j).P;
        
        %for body i
        Ci = 2*(calcG(ei)*skew4(pi) + pi*ei');
        Cq(index:index+2,ni:ni+6) = [eye(3,3), Ci]; %spherical portion
        
        %for body j
        Cj = 2*(calcG(ej)*skew4(pj) + pj*ej');
        Cq(index:index+2,nj:nj+6) = [-eye(3,3), -Cj]; %spherical portion
        
        index = index+3;
    elseif system.joint(x).Type == 2 %rev
        ni = 1+(i-1)*7;
        nj = 1+(j-1)*7;
        
        ei = system.body(i).P;
        ej = system.body(j).P;
        
        %load up variables needed for calcs
        si = (pi - qi);
        sj = (pj - qj);
        [ w_vect, v_vect ] = twoperpvect3D( si );
        Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
        W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        
        %for body i
        Ci = 2*(calcG(ei)*skew4(pi) + pi*ei');
        Cq(index:index+2,ni:ni+6) = [eye(3,3), Ci]; %spherical portion
        
        Ci = 2*(calcG(ei)*skew4(w_vect) + w_vect*ei');
        Cq(index+3,ni:ni+6) = [0,0,0,Sj'*Ci]; %perp type 1
        
        Ci = 2*(calcG(ei)*skew4(v_vect) + v_vect*ei');
        Cq(index+4,ni:ni+6) = [0,0,0,Sj'*Ci]; %perp type 1
        
        %for body j
        Cj = 2*(calcG(ej)*skew4(pj) + pj*ej');
        Cq(index:index+2,nj:nj+6) = [-eye(3,3), -Cj]; %spherical portion
        
        Cj = 2*(calcG(ej)*skew4(sj) + sj*ej');
        Cq(index+3,nj:nj+6) = [0,0,0,W_vect'*Cj];
        Cq(index+4,nj:nj+6) = [0,0,0,V_vect'*Cj];
        
        index = index + 5;
    elseif system.joint(x).Type == 3 %cylindrical
        ni = 1+(i-1)*7;
        nj = 1+(j-1)*7;
        
        ei = system.body(i).P;
        ej = system.body(j).P;
        
        %calculate needed vectors
        Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
        
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        si = (pi - qi);
        sj = (pj - qj);
        [ w_vect, v_vect ] = twoperpvect3D( si );
        W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        
        %for body i
        %Perp Type two
        Ci = 2*(calcG(ei)*skew4(w_vect) + w_vect*ei');
        Bi = 2*(calcG(ei)*skew4(pi) + pi*ei');
        Cq(index,ni:ni+6) = [-W_vect', -W_vect'*Bi + Pij'*Ci];
        Ci = 2*(calcG(ei)*skew4(v_vect) + v_vect*ei');
        Cq(index+1,ni:ni+6) = [-V_vect', -V_vect'*Bi + Pij'*Ci];
        
        %Perp Type one
        Ci = 2*(calcG(ei)*skew4(w_vect) + w_vect*ei');
        Cq(index+2,ni:ni+6) = [0,0,0,Sj'*Ci]; %perp type 1
        Ci = 2*(calcG(ei)*skew4(v_vect) + v_vect*ei');
        Cq(index+3,ni:ni+6) = [0,0,0,Sj'*Ci]; %perp type 1
        
        %for body j
        %Perp Type two
        Bj = 2*(calcG(ej)*skew4(pj) + pj*ej');
        Cq(index,nj:nj+6) = [W_vect',  W_vect'*Bj];
        Cq(index+1,nj:nj+6) = [V_vect',  V_vect'*Bj];
        
        %Perp Type one
        Cj = 2*(calcG(ej)*skew4(sj) + sj*ej');
        Cq(index+2,nj:nj+6) = [0,0,0,W_vect'*Cj];
        Cq(index+3,nj:nj+6) = [0,0,0,V_vect'*Cj];
        
        index = index + 4;
    elseif system.joint(x).Type == 4 %for joint type of S-S
        ni = 1+(i-1)*7;
        nj = 1+(j-1)*7;
        
        ei = system.body(i).P;
        ej = system.body(j).P;
        
        d = Rj+ Pj-Ri - Pi;
        %dd = Rdj + Pdj  - Rdi - Pdi ;
        
        %for body i
        Bi = 2*(calcG(ei)*skew4(pi) + pi*ei');
        Cq(index,ni:ni+6) = [-2*d', -2*d'*Bi];
        
        %for body j
        Bj = 2*(calcG(ej)*skew4(pj) + pj*ej');
        Cq(index,nj:nj+6) = [2*d',  2*d'*Bj];
        
        index = index +1;
    elseif system.joint(x).Type == 5 %prismatic
        ni = 1+(i-1)*7;
        nj = 1+(j-1)*7;
        
        ei = system.body(i).P;
        ej = system.body(j).P;
        
        %calculate extra variables for calc
        Si = Ai*(pi - qi);
        Sj = Aj*(pj - qj);
        
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        si = (pi - qi);
        sj = (pj - qj);
        [ w_vect, v_vect ] = twoperpvect3D( si );
        W_vect = Ai*w_vect;
        V_vect = Ai*v_vect;
        
        [ wj_vect, vj_vect ] = twoperpvect3D( sj );
        Wj_vect = Aj*wj_vect;
        Vj_vect = Aj*vj_vect;
        
        %for body i
        %Perp Type two
        Ci = 2*(calcG(ei)*skew4(w_vect) + w_vect*ei');
        Bi = 2*(calcG(ei)*skew4(pi) + pi*ei');
        Cq(index,ni:ni+6) = [-W_vect', -W_vect'*Bi + Pij'*Ci];
        
        Ci = 2*(calcG(ei)*skew4(v_vect) + v_vect*ei');
        Cq(index+1,ni:ni+6) = [-V_vect', -V_vect'*Bi + Pij'*Ci];
        
        %Perp Type one
        Ci = 2*(calcG(ei)*skew4(w_vect) + w_vect*ei');
        Cq(index+2,ni:ni+6) = [0,0,0,Sj'*Ci]; %perp type 1
        
        Ci = 2*(calcG(ei)*skew4(v_vect) + v_vect*ei');
        Cq(index+3,ni:ni+6) = [0,0,0,Sj'*Ci]; %perp type 1
        
        Ci = 2*(calcG(ei)*skew4(v_vect) + v_vect*ei');
        Cq(index+4,ni:ni+6) = [0,0,0,Wj_vect'*Ci];
        
        %for body j
        %Perp Type two
        Bj = 2*(calcG(ej)*skew4(pj) + pj*ej');
        Cq(index,nj:nj+6) = [W_vect',  W_vect'*Bj];
        Cq(index+1,nj:nj+6) = [V_vect',  V_vect'*Bj];
        %Perp Type one
        Cj = 2*(calcG(ej)*skew4(sj) + sj*ej');
        
        Cq(index+2,nj:nj+6) = [0,0,0,W_vect'*Cj];
        Cq(index+3,nj:nj+6) = [0,0,0,V_vect'*Cj];
        
        Cj = 2*(calcG(ej)*skew4(wj_vect) + wj_vect*ej');
        Cq(index+4,nj:nj+6) = [0,0,0,V_vect'*Cj];
        
        index = index + 5;
    end
    
end
%Fill in the final constraint, for the jacobian that is the euler
%parameters Cq to make bodies form a 7x7 matrix for fully
%constrainted

for x = 1:system.info.bodies
    ni = 1+(x-1)*7;
    
    Cq(index,ni:ni+6) = [0,0,0,2*system.body(x).P'];
    index = index + 1;
    
end

%driving Cq, append to current matrix, fill in proper spot of Cq
for x = 1:system.info.drivers
    [coord,R, X,Y,Z,ft,fdt,fddt,body] = DecompDriver( system, x );
    
    m = 1+(body-1)*7;
    
    if coord == 'X'
        Cq(index,m) = 1;
    elseif coord == 'Y'
        Cq(index,m+1) = 1;
    elseif coord == 'Z'
        Cq(index,m+2) = 1;
    elseif strcmp(coord, 'PHIZ')
        Cq(index,m+6) = 1;
    elseif strcmp(coord, 'PHIY')
        Cq(index,m+5) = 1;
    elseif strcmp(coord, 'PHIX')
        Cq(index,m+4) = 1;
    elseif strcmp(coord, 'e3')
        Cq(index,m+6) = 1;
    elseif strcmp(coord, 'e2')
        Cq(index,m+5) = 1;
    elseif strcmp(coord, 'e1')
        Cq(index,m+4) = 1;
        
    end
       
    index = index +1 ;
end
end

