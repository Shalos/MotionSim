function [ eulerang ] = Amat_Euler ( Amat )
%Find the euler angles from the transformation matrix
    tracea = Amat(1,1) + Amat(2,2) + Amat(3,3);  %trace of A matrix
    e0 = sqrt((tracea + 1)/4);                   %calc e0
    e1 = (Amat(3,2) - Amat(2,3))/(4*e0);          %calc e1
    e2 = (Amat(1,3) - Amat(3,1))/(4*e0);          %calce e2
    e3 = (Amat(2,1) - Amat(1,2))/(4*e0);          %calce e3
    eulerang = [e0; e1; e2; e3];                 %assemble to vector
end

