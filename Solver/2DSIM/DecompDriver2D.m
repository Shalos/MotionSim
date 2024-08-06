function [ body,R,X,Y,coord,ft,fdt,fddt ] = DecompDriver2D( system, x )
%decompose driver information to easy to read and use variables for use in
%filling constraint matrices.

body = system.drivers(x).body;
R = system.body(body).R;
X = R(1);
Y = R(2);

coord = system.drivers(x).coord;

ft = system.drivers(x).ft;
fdt = system.drivers(x).fdt;
fddt = system.drivers(x).fddt;
end

