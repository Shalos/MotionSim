function [ Qd ] = BuildQd3DKin( system,t )
%Construct the Qd matrix for Kinematic 3D simulation using Euler parameters

%preallocate Qd matrix
Qd =zeros(system.info.cdof,1);
index = 7;
for x = 1:system.info.joints
    %%% Load common variables between joints into simple variables for
    %%% calculation
    [ i,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,...
        Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj,SkewWi,SkewWj ] = system.joint(x).solverinfo{:};
    
    %Begine Qd calculations
    m = 1+(x-1)*3;
    n = 3 + (x-1)*3;
    if system.joint(x).Type == 1  %for joint type of spherical
        
        %calculate the G and L matrices
        Gid = calcG(system.body(i).Pd);
        Lid = calcL(system.body(i).Pd);
        
        Gjd = calcG(system.body(j).Pd);
        Ljd = calcL(system.body(j).Pd);
        
        %solve for Qd portion
        Hip = -2*Gid*Lid'*pi;
        Hjp = -2*Gjd*Ljd'*pj;
        Qd(index:index+2,1) =  Hip-Hjp;

        index = index +3;
    elseif system.joint(x).Type == 2  %for joint type of rev
        %calculate extra vectors
        Sj = Aj*(pj - qj);
        Sdj = Aj*(pdj - qdj);
        
        si = (pi - qi);
        sj = (pj - qj);

        [ w_vect, v_vect ] = twoperpvect3D( si );
        W_vect=Ai* w_vect;
        V_vect = Ai*v_vect;
        Wd_vect = Ai*Skew(wi)*w_vect;
        Vd_vect = Ai*Skew(wi)*v_vect;

        Gid = calcG(system.body(i).Pd);
        Lid = calcL(system.body(i).Pd);
        
        Gjd = calcG(system.body(j).Pd);
        Ljd = calcL(system.body(j).Pd);
        
        %fill in spherical portion
        Hip = -2*Gid*Lid'*pi;
        Hjp = -2*Gjd*Ljd'*pj;
        Qd(index:index+2,1) =  Hip-Hjp;
        
        %2 perp vectors
        Hi = -2*Gid*Lid'*w_vect;
        Hj = -2*Gjd*Ljd'*sj;
        Qd(index+3,1) = -2*Wd_vect'*Sdj + W_vect'*Hj + Sj'*Hi; %wi
        Hi = -2*Gid*Lid'*v_vect;
        Hj = -2*Gjd*Ljd'*sj;
        Qd(index+4,1) = -2*Vd_vect'*Sdj  + V_vect'*Hj + Sj'*Hi;%vi
        index = index +5;
    elseif system.joint(x).Type == 3
        %calculate vectors
        Sj = Aj*(pj - qj);
        Sdj = Aj*(pdj - qdj);
        
        si = (pi - qi);
        sj = (pj - qj);
        
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        Pdij = Rdj + Aj*SkewWj*pj -Rdi-Ai*SkewWi*pi;
        [ w_vect, v_vect ] = twoperpvect3D( si );
        W_vect=Ai* w_vect;
        V_vect = Ai*v_vect;
        wd_vect = SkewWi*w_vect;
        vd_vect = SkewWi*v_vect;
        Wd_vect = Ai*wd_vect;
        Vd_vect = Ai*vd_vect;
        
        Gid = calcG(system.body(i).Pd);
        Lid = calcL(system.body(i).Pd);
        
        Gjd = calcG(system.body(j).Pd);
        Ljd = calcL(system.body(j).Pd);
        
        
        %Type 2 perp
        Hi = -2*Gid*Lid'*w_vect;
        Hib = -2*Gid*Lid'*pdi;
        Hjb = -2*Gid*Lid'*pdj;
        Qd(index,1) = -2*Pdij'*Wd_vect + Pij'*Hi + W_vect'*(Hjb-Hib); %wi
        Hi = -2*Gid*Lid'*v_vect;
        Qd(index+1,1) = -2*Pdij'*Vd_vect + Pij'*Hi + V_vect'*(Hjb-Hib);
        
        %Type one perp
        Hi = -2*Gid*Lid'*w_vect;
        Hj = -2*Gjd*Ljd'*sj;
        Qd(index+2,1) = -2*Wd_vect'*Sdj + W_vect'*Hj + Sj'*Hi;
        
        Hi = -2*Gid*Lid'*v_vect;
        Hj = -2*Gjd*Ljd'*sj;
        Qd(index+3,1) = -2*Vd_vect'*Sdj + V_vect'*Hj + Sj'*Hi;
        
        index = index +4;
    elseif system.joint(x).Type == 5
        %Calc extra vectors
        Sj = Aj*(pj - qj);
        Sdj = Aj*(pdj - qdj);
     
        si = (pi - qi);
        sj = (pj - qj);
        
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        Pdij = Rdj + Aj*SkewWj*pj -Rdi-Ai*SkewWi*pi;
        [ w_vect, v_vect ] = twoperpvect3D( si );
        [ wj_vect, vj_vect ] = twoperpvect3D( sj );
        W_vect=Ai* w_vect;
        V_vect = Ai*v_vect;
        wd_vect = SkewWi*w_vect;
        vd_vect = SkewWi*v_vect;
        Wd_vect = Ai*wd_vect;
        Vd_vect = Ai*vd_vect;
        
        wdj_vect = SkewWj*wj_vect;
        Wdj_vect = Aj*wdj_vect;
        Wj_vect = Aj*wj_vect;
               
        Gid = calcG(system.body(i).Pd);
        Lid = calcL(system.body(i).Pd);
        
        Gjd = calcG(system.body(j).Pd);
        Ljd = calcL(system.body(j).Pd);
        
        %Type 2 perp
        Hi = -2*Gid*Lid'*w_vect;
        Hib = -2*Gid*Lid'*pdi;
        Hjb = -2*Gid*Lid'*pdj;
        Qd(index,1) = -2*Pdij'*Wd_vect + Pij'*Hi + W_vect'*(Hjb-Hib); %wi
        Hi = -2*Gid*Lid'*v_vect;
        Qd(index+1,1) = -2*Pdij'*Vd_vect + Pij'*Hi + V_vect'*(Hjb-Hib);
        
        %Type one perp
        Hi = -2*Gid*Lid'*w_vect;
        Hj = -2*Gjd*Ljd'*sj;
        Qd(index+2,1) = -2*Wd_vect'*Sdj + W_vect'*Hj + Sj'*Hi;
        Hi = -2*Gid*Lid'*v_vect;
        Hj = -2*Gjd*Ljd'*sj;
        Qd(index+3,1) = -2*Vd_vect'*Sdj + V_vect'*Hj + Sj'*Hi;
        Hi = -2*Gid*Lid'*v_vect;
        Hj = -2*Gjd*Ljd'*wj_vect;
        Qd(index+4,1) = -2*Vd_vect'*Wdj_vect + V_vect'*Hj + Wj_vect'*Hi;
        index = index +5;
    elseif system.joint(x).Type == 4  %for joint type of S-S       
        %calculate needed vector loops and G/L matrices
        d = Rj+ Pj-Ri - Pi;
        dd = Rdj + Pdj  - Rdi - Pdi ;
        
        Gid = calcG(system.body(i).Pd);
        Lid = calcL(system.body(i).Pd);
        
        Gjd = calcG(system.body(j).Pd);
        Ljd = calcL(system.body(j).Pd);
        
        Hi = -2*Gid*Lid'*pi;
        Hj = -2*Gjd*Ljd'*pj;
        Qd(index,1) = -2*dd'*dd+2*d'*(Hj-Hi);
        index = index +1;
    end
    
end

for x = 1:system.info.bodies
    Qd(index) = -system.body(x).Pd'*system.body(x).Pd;
    index = index+1 ;
end
%Lengthen Qd to take in account Driver constraints.
for x = 1:system.info.drivers
    Qd(index) = 0;
    index = index+1 ;
end
end

