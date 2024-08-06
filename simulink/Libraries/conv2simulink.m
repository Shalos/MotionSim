function [ sysmodel ] = conv2simulink(sysmodel)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

sysmodel = InitialCond( sysmodel );
sysmodel = CalcDof( sysmodel);
for x= 1:length(sysmodel.body)
    sysmodel.body(x).label=0;
end

for x= 1:length(sysmodel.joint)
    sysmodel.joint(x).label=0;
end
sysmodel.preprocessor = 0;
sysmodel.solver.solver = 0;
sysmodel.solver.solverfunc = 0;
sysmodel.eval = 1;
sysmodel.info.simulink = 1;