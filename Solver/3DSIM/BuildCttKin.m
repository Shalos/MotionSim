function [ Ctt ] = BuildCttKin( system,t )
%build Ctt matrix for 3d Kinematic Simulation

Ctt = zeros(system.info.cdof,1);
index = system.info.cdof-system.info.drivers+1;

for x = 1:system.info.drivers
    [coord,R, X,Y,Z,ft,fdt,fddt,body] = DecompDriver( system, x );
   
    Ctt(index,1) = eval(fddt);
    index = index +1 ;
end
end

