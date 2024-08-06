function [ Lmat ] = calcL( e )
%calculate L matrix from Euler parameters
    temp2 = Skew(e(2:4));             %calculate the skew of e1, e2, e3
    temp = -temp2 + e(1)*eye([3 3]); %calculate the 2nd half of L
    Lmat = [-e(2:4), temp];          %put together the L matrix
end

