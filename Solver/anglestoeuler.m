function [ e0,e1,e2,e3 ] = anglestoeuler( x,y,z )
%ANGLESTOEULER Summary of this function goes here
%   Detailed explanation goes here
x = x*pi/180;
y = y*pi/180;
z = z*pi/180;
[ Amat ] = Amat_angles(x,y,z);
[ eulerang ] = Amat_Euler ( Amat );
e0 = eulerang(1);
e1 = eulerang(2);
e2 = eulerang(3);
e3 = eulerang(4);

disp(['e0 ' num2str(e0) ' e1 ' num2str(e1) ' e2 ' num2str(e2) ' e3 ' num2str(e3)])
end

