function [ Ct ] = BuildCt( system,t )
%Build the Ct matrix for 3d Dynamic\kinematic simulations
Ct = zeros(system.info.cdof,1);

index = system.info.cdof-system.info.drivers+1;
for x = 1:system.info.drivers
    [coord,R, X,Y,Z,ft,fdt,fddt,body] = DecompDriver( system, x );

    Ct(index,1) =eval(fdt);
    index = index +1 ;
end
end

