function [ i,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj,SkewWi,SkewWj ] = DecompJointSys( system, x, pack )
%simplifies and reduces code to decompose a joint into its basice elements
%for calculations in multiple functions.
i = system.joint(x).Bodyi;
j = system.joint(x).Bodyj;
pi = system.joint(x).pi;
pj = system.joint(x).pj;
qi = system.joint(x).qi;
qj = system.joint(x).qj;



wj = system.body(j).w;
wi = system.body(i).w;
Ai = system.body(i).A;
Aj = system.body(j).A;
Ri = system.body(i).R;
Rj = system.body(j).R;
Rdi = system.body(i).Rd;
Rdj = system.body(j).Rd;
SkewWi = system.body(i).SkewW;
SkewWj = system.body(j).SkewW;

pdi = SkewWi*pi;

pdj =SkewWj*pj;
qdi = SkewWi*qi;
qdj =SkewWj*qj;

Pdi = Ai*pdi;
Pdj =Aj*pdj;
Qdi = Ai*qdi;
Qdj =Aj*qdj;
Pi = Ai*pi;
Pj = Aj*pj;
Qi = Ai*qi;
Qj =Aj*qj;

%if request pack in single variable to later use
if pack
    tempi = i;
    i = {tempi,j, Ri, Rj, Rdi, Rdj, Ai,Aj, wi,wj, pi,pj,qi,qj,Pi,Pj,Qi,Qj,Pdi,Pdj,Qdi,Qdj,pdi,pdj,qdi,qdj,SkewWi,SkewWj};
end

end

