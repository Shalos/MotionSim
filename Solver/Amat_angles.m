function [ Amat ] = Amat_angles(x,y,z)
%find the transformation matrix from a series of angles about the x,y,z
    a = [1 0 0;               %calculate the X rotation
         0 cos(x) -sin(x);
         0 sin(x) cos(x)];
     
    b = [cos(y) 0 sin(y);     %calculate the Y rotation
         0 1 0;
         -sin(y) 0 cos(y)];    %calculate the Z rotation
     
    c = [cos(z)  -sin(z) 0;
         sin(z) cos(z) 0;
         0 0 1];
   Amat = a*b*c;       %multiply together for trans matrix
end

