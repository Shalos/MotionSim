function [ x,y,z ] = Amat_toAngles( Amat )
 vect1 = Amat(:,1);
vect2 = Amat(:,2);
 vect3 = Amat(:,3);
% 
mag1 = sqrt(vect1'*vect1);
mag2 = sqrt(vect2'*vect2);
mag3 = sqrt(vect3'*vect3);
% 
% x = acos(dot(vect1,[1;0;0])/(mag1*1));
% y = acos(dot(vect2,[0;1;0])/(mag2*1));
% z = acos(dot(vect3,[0;0;1])/(mag3*1));

% y = asin(Amat(1,3));
% z = asin(Amat(1,2)/(-cos(y)));
% x = acos(Amat(3,3)/(cos(y)));
% 
% x  = acos((vect1'*[1;0;0])/(mag1));
% y  = acos((vect2'*[0;1;0])/(mag2));
% z  = acos((vect3'*[0;0;1])/(mag3));
y = asin(Amat(1,3));
z = acos(Amat(1,1)/cos(y));
x = acos(Amat(3,3)/cos(y));
% z = atan2(-Amat(1,2),Amat(1,1));
% x = atan2(Amat(2,3),Amat(3,3));
% y = asin(-Amat(1,3));
end

