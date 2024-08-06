function [ out ] = Skew4( a )
%Calculate the 4D Skew of vector A
out = [0, -a';
       a, -Skew(a)];

end

