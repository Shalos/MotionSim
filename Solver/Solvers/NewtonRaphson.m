function [ tspan, Y ] = NewtonRaphson( odefun,tspan,y0,varargin )
%NEWTONRAPHSON Summary of this function goes here
%   Detailed explanation goes here
varargin = varargin(2:3);  %for variable step compatibility

if ~isnumeric(tspan)
  error('TSPAN should be a vector of integration steps.');
end

if ~isnumeric(y0)
  error('Y0 should be a vector of initial conditions.');
end

h = diff(tspan);
if any(sign(h(1))*h <= 0)
  error('Entries of TSPAN are not in order.') 
end  

try
  f0 = feval(odefun,tspan(1),y0,varargin{:});
catch
  msg = ['Unable to evaluate the ODEFUN at t0,y0. ',lasterr];
  error(msg);  
end  

y0 = y0(:);   % Make a column vector.
if ~isequal(size(y0),size(f0))
  error('Inconsistent sizes of Y0 and f(t0,y0).');
end  

neq = length(y0);
N = length(tspan);
Y = zeros(neq,N);


Y(:,1) = y0;
for i = 2:N
  ti = tspan(i-1);
  yi = Y(:,i-1);

  Y(:,i) =  feval(odefun,ti,yi,varargin{:});
end
Y = Y.';
end

