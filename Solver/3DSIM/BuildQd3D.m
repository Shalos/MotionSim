function [ Qd ] = BuildQd3D( system,t )
%Build the Qd matrix for the 3D Dynamic simulation

%preallocated Qd matrix
Qd =zeros(system.info.cdof,1);

%fill out Qd matrix
index = 7;
for x = 1:system.info.joints
    %%% Load common variables between joints into simple variables for
    %%% calculation
    [ i,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,...
        Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj,SkewWi,SkewWj ] = system.joint(x).solverinfo{:};
    
    m = 1+(x-1)*3;
    n = 3 + (x-1)*3;
    if system.joint(x).Type == 1  %for joint type of spherical

        Qd(index:index+2,1) =  -Ai * SkewWi *SkewWi *(pi) +  Aj * SkewWj *SkewWj* (pj);
        index = index +3;
    elseif system.joint(x).Type == 2  %for joint type of rev
        %Compute extra vectors and simplify
        Sj = Aj*(pj - qj);

        sj = (pj-qj);
        
        Sdj = Aj*SkewWj*sj;
        si = (pi - qi);
        [ w_vect, v_vect ] = twoperpvect3D( si );

        W_vect=Ai*w_vect;
        V_vect = Ai*v_vect;
        Wd_vect = Ai*SkewWi*w_vect;
        Vd_vect = Ai*SkewWi*v_vect;
        

        
        %fill in Qd matrix
        Qd(index:index+2,1) =-Ai * SkewWi *SkewWi *(pi) +  Aj * SkewWj *SkewWj* (pj);
        Qd(index+3,1) = -2*Wd_vect'*Sdj - W_vect'*Aj*SkewWj*SkewWj*sj - Sj'*Ai*SkewWi*SkewWi*w_vect; %wi
        Qd(index+4,1) = -2*Vd_vect'*Sdj - V_vect'*Aj*SkewWj*SkewWj*sj - Sj'*Ai*SkewWi*SkewWi*v_vect;%vi
    

        

%     sj = (pj - qj);
%     si = (pi - qi);
%     
%     [ w_vect, v_vect ] = twoperpvect3D( si );
%     
%     sdj = SkewWj*sj;
%     wd_vect = SkewWi*w_vect;
%     vd_vect = SkewWi*v_vect;
% 
%         Qd(index:index+2,1) = -Ai * SkewWi *(pdi) +  Aj * SkewWj * (pdj);
%         
%         Qd(index+3,1) = -2*(Ai*wd_vect)'*(Aj*sdj) +(Ai*wd_vect)'*Ai*SkewWi*Aj*sj + (Aj*sdj)'*Aj*SkewWj*Ai*w_vect;
%         Qd(index+4,1) = -2*(Ai*vd_vect)'*(Aj*sdj) +(Ai*vd_vect)'*Ai*SkewWi*Aj*sj + (Aj*sdj)'*Aj*SkewWj*Ai*v_vect;
         index = index +5;
    elseif system.joint(x).Type == 3
        %compute extra variables for Qd matrix
        Sj = Aj*(pj - qj);
        Sdj = Aj*(pdj - qdj);
        si = (pi - qi);
        Pij = Rj + Aj*pj -Ri-Ai*pi;
        Pdij = Rdj + Aj*SkewWj*pj -Rdi-Ai*SkewWi*pi;
        [ w_vect, v_vect ] = twoperpvect3D( si );
        W_vect=Ai* w_vect;
        V_vect = Ai*v_vect;
        wd_vect = SkewWi*w_vect;
        vd_vect = SkewWi*v_vect;
        Wd_vect = Ai*wd_vect;
        Vd_vect = Ai*vd_vect;
        
        %fill in Qd matrix
        %Type 2 perp
        Qd(index,1) = -2*Pdij'*Wd_vect - Pij'*Ai*SkewWi*wd_vect + W_vect'*(Ai*SkewWi*pdi - Aj*SkewWj*pdj); %wi
        Qd(index+1,1) = -2*Pdij'*Vd_vect - Pij'*Ai*SkewWi*vd_vect + V_vect'*(Ai*SkewWi*pdi - Aj*SkewWj*pdj);
        %Type one perp
        Qd(index+2,1) = -2*Wd_vect'*Sdj + Wd_vect'*Ai*SkewWi*Ai'*Sj+Sdj'*Aj*SkewWj*Aj'*W_vect;
        Qd(index+3,1) = -2*Vd_vect'*Sdj + Vd_vect'*Ai*SkewWi*Ai'*Sj+Sdj'*Aj*SkewWj*Aj'*V_vect;
        
        index = index +4;  
    elseif system.joint(x).Type == 5
        %calculate the extra vectors
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
        
        %fill in Qd matrix
        %Type 2 perp
        Qd(index,1) = -2*Pdij'*Wd_vect - Pij'*Ai*SkewWi*wd_vect + W_vect'*(Ai*SkewWi*pdi - Aj*SkewWj*pdj); %wi
        Qd(index+1,1) = -2*Pdij'*Vd_vect - Pij'*Ai*SkewWi*vd_vect + V_vect'*(Ai*SkewWi*pdi - Aj*SkewWj*pdj);
        %Type one perp
        Qd(index+2,1) = -2*Wd_vect'*Sdj + Wd_vect'*Ai*SkewWi*Ai'*Sj+Sdj'*Aj*SkewWj*Aj'*W_vect;
        Qd(index+3,1) = -2*Vd_vect'*Sdj + Vd_vect'*Ai*SkewWi*Ai'*Sj+Sdj'*Aj*SkewWj*Aj'*V_vect;
        Qd(index+4,1) = -2*Vd_vect'*Wdj_vect + Vd_vect'*Ai*SkewWi*Ai'*Wj_vect+Wdj_vect'*Aj*SkewWj*Aj'*V_vect;
        index = index +5;
    elseif system.joint(x).Type == 4  %for joint type of S-S
        %calculate the D vector and derivative
        d = Rj+ Pj-Ri - Pi;
        dd = Rdj + Pdj  - Rdi - Pdi ;
        %fill in Qd matrix
        Qd(index,1) = -2*dd'*dd+2*d'*(Ai*SkewWi*pdi- Aj*SkewWj*pdj);
        index = index +1;
    elseif system.joint(x).Type == 6

        Qd(index:index+2,1) =  -Ai * SkewWi *SkewWi *(pi) +  Aj * SkewWj *SkewWj* (pj);
        index = index +3;
        
        
    end
end

