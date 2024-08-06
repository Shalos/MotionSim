function [ matrix ] = Skew( v )
%calculate the 3D skew of the vector v.
matrix = [0 -v(3) v(2);      %calculates the skew matrix
            v(3) 0 -v(1);      %from an inputed vector
            -v(2) v(1) 0];

end

