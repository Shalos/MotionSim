function [coord,R, X,Y,Z,ft,fdt,fddt,body] = DecompDriver( system, x )
%simply driver constraints by inputting into easy to use variables
body = system.drivers(x).body;

R = system.body(body).R;
X = R(1);
Y = R(2);
Z = R(3);

coord = system.drivers(x).coord;


ft = system.drivers(x).ft;
fdt = system.drivers(x).fdt;
fddt = system.drivers(x).fddt;
end

