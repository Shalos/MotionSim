function [ i,j,pi,pj,initialL,K,c,Adj,Adi,Ai,Aj,Ri,Rj,Rdi,Rdj,f ] = DecompSpringSys2D( sysmodel, x )
%used in spring/damper systems in order to proved easy to use variables
i = sysmodel.SDA(x).Bodyi;
j = sysmodel.SDA(x).Bodyj;
pi = sysmodel.SDA(x).pi;
pj = sysmodel.SDA(x).pj;
initialL = sysmodel.SDA(x).initL;
K = sysmodel.SDA(x).k;
c = sysmodel.SDA(x).c;
f =  sysmodel.SDA(x).f;


Ai =sysmodel.body(i).A;
Aj =sysmodel.body(j).A;
Ri = sysmodel.body(i).R;
Rj = sysmodel.body(j).R;
Rdi = sysmodel.body(i).Rd;
Rdj = sysmodel.body(j).Rd;

phi = sysmodel.body(i).PHIZ;
Adi = [-sin(phi), -cos(phi); cos(phi), -sin(phi)];
phi = sysmodel.body(j).PHIZ;
Adj = [-sin(phi), -cos(phi); cos(phi), -sin(phi)];

end

