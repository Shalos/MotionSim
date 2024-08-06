function [ i,j,pi,pj,initialL,K,c,wj,wi,Ai,Aj,Ri,Rj,Rdi,Rdj,f ] = DecompSpringSys( sysmodel, x )
%simplify spring data, to be easily extracted when needed
i = sysmodel.SDA(x).Bodyi;
j = sysmodel.SDA(x).Bodyj;
pi = sysmodel.SDA(x).pi;
pj = sysmodel.SDA(x).pj;
initialL = sysmodel.SDA(x).initL;
K = sysmodel.SDA(x).k;
c = sysmodel.SDA(x).c;
f =  sysmodel.SDA(x).f;

wj = sysmodel.body(j).w;
wi = sysmodel.body(i).w;
Ai =sysmodel.body(i).A;
Aj =sysmodel.body(j).A;
Ri = sysmodel.body(i).R;
Rj = sysmodel.body(j).R;
Rdi = sysmodel.body(i).Rd;
Rdj = sysmodel.body(j).Rd;

end

