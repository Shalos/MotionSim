function [ i,j,Ai,Aj,Ri,Rj,pi,pj,qi,Pi,Pj,Qi,phii,phij,Rdj,Rdi,wi,wj,Aphii,Aphij] = DecompJointSys2D( system,x,pack )
%converts all constraint data into easy to read and use data in constraint
%files, Mirrors equations for ease of debug and addition

%start with body data and gen information
i = system.joint(x).Bodyi;
j = system.joint(x).Bodyj;

if sum(abs(system.joint(x).qi)) == 0 && sum(abs(system.joint(x).qj)) ~= sum(abs(system.joint(x).qi))
temp = i;
i = j;
j=temp;
qi = system.joint(x).qj;
else
    qi = system.joint(x).qi;
end
pi = system.joint(x).pi;
pj = system.joint(x).pj;




%calculate for body i and j, different conditions
phii = system.body(i).PHIZ;
Ai = [cos(phii), -sin(phii); sin(phii), cos(phii)];
Ri = system.body(i).R;
Rdi = system.body(i).Rd;
wi = system.body(i).w;

phij = system.body(j).PHIZ;
Aj = [cos(phij), -sin(phij); sin(phij), cos(phij)];
Rj = system.body(j).R;
Rdj = system.body(j).Rd;
wj = system.body(j).w;

%calculate extra information
Aphii = [-sin(phii), -cos(phii); cos(phii), -sin(phii)];
Aphij = [-sin(phij), -cos(phij); cos(phij), -sin(phij)];
Pi = Ai*pi;
Qi = Ai*qi;
Pj = Aj*pj;

%packs into single variable if requested for faster computation
if pack
    tempi = i;
    i = {tempi,j,Ai,Aj,Ri,Rj,pi,pj,qi,Pi,Pj,Qi,phii,phij,Rdj,Rdi,wi,wj,Aphii,Aphij};
end
end

