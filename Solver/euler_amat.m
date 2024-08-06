function [ Amat ] = euler_amat( euler )
    temp = Skew(euler(2:4));              %grab the skew matrix of euler parameter e1 through e3
    Amat = (2*euler(1)^2-1)*eye([3 3]) + 2*euler(2:4)*euler(2:4)' + 2*euler(1)*temp; %calculate the A matrix
end

