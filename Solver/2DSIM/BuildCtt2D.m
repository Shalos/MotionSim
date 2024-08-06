function [ Ctt ] = BuildCtt2D( system,t )
%construct the matrix Ctt for second derivitive of t
Ctt = zeros(system.info.cdof,1);

index = system.info.cdof-system.info.drivers+1;
for x = 1:system.info.drivers
    [ body,R,X,Y,coord,ft,fdt,fddt ] = DecompDriver2D( system, x );    
    
    if coord == 'X'
        Ctt(index,1) =eval(fddt);
    elseif coord == 'Y'
        Ctt(index,1) = eval(fddt);
    elseif coord == 'PHI'
        Ctt(index,1) = eval(fddt);
    end       
    
    index = index +1 ;
end
end

