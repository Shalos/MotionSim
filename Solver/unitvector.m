function [ magnitude, uvector] = unitvector( vect )
%Finds the unit vector of the input vector and magnitude, outputs it for
%use

magnitude = norm(vect);

uvector = vect/magnitude;

if magnitude == 0
    if length(vect) == 3
        uvector = [0;0;0];
    else
        uvector = [0;0];
    end
end

end

