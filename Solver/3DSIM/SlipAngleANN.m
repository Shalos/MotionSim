function [ Lateralforces ] = SlipAngleANN( sysmodel )

%This function handles the spring/dampers that can be placed between 2
%points on 2 different bodies. The vector loop is calculated from a point
%on body i to a point on body j, the magnitude and unit vector is
%calculated. Using hooks law the force is calculated, multiplied by unit
%vector and applied to the points. If the point is a given distance from Cg
%the torque is also applied by the cross of the force vector and point
%vector.

%Damping is done a simular way, but using the velocity loop instead to
%obtain the unit vector and velocity. A damping coeficiant of c is used to
%control the gain of damping.

%Once everything is calculated, the extra forces etc generated and a matrix
%constructed to the same specifications as the right hand side matrix in
%order to add easily.

%create a matric with same dimensions as RHS for easy addition


%Neural network inputs
fx = 0;
SA = 10;
P = 15;
IA = 1;

%pre allocate array
Lateralforces = zeros(sysmodel.info.bodies*6,1);
i = 5;
j = 9;


m = 2+(i-1)*6;
Lateralforces(m) = sysmodel.ANN([fx;SA;P;IA;abs(sysmodel.body(i).Force(3))]);
    
m = 2+(j-1)*6;
Lateralforces(m) = sysmodel.ANN([fx;SA;P;IA;abs(sysmodel.body(j).Force(3))]); %inputs = [FX,SA,P,IA,FZ];
    

end

