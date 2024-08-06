function [ Ct ] = BuildCt2D( system,t )
%%%%%%%%%%%Construct Ct%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Since constraints dont rely on t, it will mostly be used for driver
%constraints

Ct = zeros(system.info.cdof,1);

index = system.info.cdof-system.info.drivers+1;
for x = 1:system.info.drivers
    [ body,R,X,Y,coord,ft,fdt,fddt ] = DecompDriver2D( system, x );
    
    if coord == 'X'
        Ct(index,1) =-eval(fdt);
    elseif coord == 'Y'
        Ct(index,1) = -eval(fdt);
    elseif coord == 'PHI'
        Ct(index,1) = -eval(fdt);
    end
    index = index +1 ;
end
end

