function [ N1, N2 ] = twoperpvect3D( S )

%calculate the orthoganal triad to vector S

%from dot s'*d = 0, there are infinite posibilities, 1,1 is used for y
%and z to calculate a perpendicular vector.

% N1 = [0;0;0];
% N2 = [0;0;0];
% 
% if S(1) > 0 || S(1) < 0
%     Nx = (+S(2)+S(3))/S(1);
%     %construct N1 and normalize
%     N1 = [Nx; -1; -1];
%     %find the second unit vector 90 normal to both.
%     N2 = Skew(N1)*S;%cross(N1,S);
% elseif S(2) > 0 || S(2) < 0
%     Ny = (+S(3)+S(1))/S(2);
%     %construct N1 and normalize
%     N1 = [-1; Ny; -1];
%     %find the second unit vector 90 normal to both.
%     N2 = Skew(N1)*S;%cross(N1,S);
% elseif S(3) > 0 || S(3) < 0;op[[p[[
%     Nz = (+S(1)+S(2))/S(3);
%     %construct N1 and normalize
%     N1 = [-1; -1; Nz];
%     %find the second unit vector 90 normal to both.
%     N2 = Skew(N1)*S;%cross(N1,S);
% end


%use the previous function to find the unit quickly.
  
N1 = Skew(Amat_angles(90,90,0)*S)*S;
N2 = Skew(N1)*S;


[mag, N1] = unitvector(N1);
[mag, N2] = unitvector(N2);

end

