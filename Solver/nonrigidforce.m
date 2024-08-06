function [ force] = nonrigidforce( system )

A = .001;
E = 210*10^9;
L = .2;
I = .000001;

%  C1 = A*E/L;
%  C2 = E*I/L^3;


D = [];
for x = 1:20
D = [D;
    L*x*cos(system.body(1).PHIZ) - system.body(x).R(1);
    L*x*sin(system.body(1).PHIZ) - system.body(x).R(2);    
     system.body(1).PHIZ - system.body(x).PHIZ];
end
D = [D;0;0;0];
GLOBALK = zeros(3*21,3*21);
for x = 1:19
%build K
C = cos(system.initbody(1).PHIZ);%(system.body(2).R(1)- system.body(1).R(1))/L;
S = sin(system.initbody(1).PHIZ);%(system.body(2).R(2)- system.body(1).R(2))/L;
CC = C^2;
SS = S^2;
CS = C*S;

K = E/L * [ A*CC + 12*I*SS/L^2,  (A-12*I/L^2)*CS, -6*I*S/L, -(A*CC+12*I*SS/L^2), -(A-12*I/L^2)*CS, -6*I*S/L;
           (A-12*I/L^2)*CS, A*SS+12*I*CC/L^2, 6*I*C/L, -(A-12*I/L^2)*CS, -(A*SS+12*I*CC/L^2), 6*I*C/L;
           -6*I*S/L, 6*I*C/L, 4*I, 6*I*S/L, -6*I*C/L, 2*I;
           -(A*CC+12*I*SS/L^2), -(A-12*I/L^2)*CS, 6*I*S/L, A*CC+12*I*SS/L^2, (A-12*I/L^2)*CS, 6*I*S/L;
           -(A-12*I/L^2)*CS, -(A*SS+12*I*CC/L^2), -6*I*C/L, (A-12*I/L^2)*CS, A*SS+12*I*CC/L^2, -6*I*C/L;
           -6*I*S/L, 6*I*C/L, 2*I, 6*I*S/L, -6*I*C/L, 4*I];



% K = [C1, 0,        0,    -C1,   0,           0;
%      0, 12*C2, 6*C2*L^2,  0,   -12*C2,    6*C2*L;
%      0, 6*C2*L, 4*C2*L^2, 0, -6*C2*L^2, 2*C2*L^2;
%      -C1, 0,       0,     C1,    0,          0;
%      0, -12*C2, -6*C2*L,   0,    12*C2,   -6*C2*L;
%      0, 6*C2*L,  2*C2*L^2, 0,   -6*C2*L,   4*C2*L^2];  %BLAH LOCAL K

 m = 1+3*(x-1);
 n = 6+3*(x-1);
 GLOBALK(m:n, m:n)=GLOBALK(m:n, m:n)+K;

%  GLOBALK(1:6,1:6) = K;
%  GLOBALK(4:9, 4:9)=GLOBALK(4:9, 4:9)+K;
%  GLOBALK(7:12, 7:12)=GLOBALK(7:12, 7:12)+K;
end
 
 force = GLOBALK*D;

 %force(4) = -force(4);

end

