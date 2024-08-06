function [ sysmodel ] = InitialCond( sysmodel )
%INITIALCONDITIONS Summary of this function goes here
%   Detailed explanation goes here
if sysmodel.info.spatial && sysmodel.info.dynamic
    massvect = [];
    forcevect = [];
    initpos = [];
    initvel = [];
    for x = 1:sysmodel.info.bodies
        initpos = [initpos;sysmodel.body(x).R; sysmodel.body(x).P];
        initvel = [initvel;sysmodel.body(x).Rd; sysmodel.body(x).w];
        massvect = [massvect; sysmodel.body(x).M*[1;1;1]; sysmodel.body(x).I];
        forcevect = [forcevect; sysmodel.body(x).Force; sysmodel.body(x).Torque];
    end
    sysmodel.forcevect = forcevect;
    sysmodel.massvect = massvect;
    sysmodel.initial = [initpos;initvel];
    sysmodel.info.bodydof = [7,6,6];
    
    sysmodel.bodyinit = sysmodel.body;

elseif ~sysmodel.info.spatial && sysmodel.info.dynamic
    massvect = [];
    forcevect = [];
    initpos = [];
    initvel = [];
    for x = 1:sysmodel.info.bodies
        initpos = [initpos;sysmodel.body(x).R; sysmodel.body(x).PHIZ];
        initvel = [initvel;sysmodel.body(x).Rd; sysmodel.body(x).w];
        massvect = [massvect; sysmodel.body(x).M*[1;1]; sysmodel.body(x).I];
        forcevect = [forcevect; sysmodel.body(x).Force; sysmodel.body(x).Torque];
    end
    sysmodel.forcevect = forcevect;
    sysmodel.massvect = massvect;
    sysmodel.initial = [initpos;initvel];
    sysmodel.info.bodydof = [3,3,3];
elseif sysmodel.info.spatial && ~sysmodel.info.dynamic   
    initpos = [];
    initvel = [];
    for x = 1:sysmodel.info.bodies
        initpos = [initpos;sysmodel.body(x).R; sysmodel.body(x).P];
        initvel = [initvel;sysmodel.body(x).Rd;.5*calcL(sysmodel.body(x).P)'*sysmodel.body(x).w];
    end
    sysmodel.initial = [initpos;initvel];
    sysmodel.info.bodydof = [7,7,7];    
    
elseif ~sysmodel.info.spatial && ~sysmodel.info.dynamic
    initpos = [];
    initvel = [];
    for x = 1:sysmodel.info.bodies
        initpos = [initpos;sysmodel.body(x).R; sysmodel.body(x).PHIZ];
        initvel = [initvel;sysmodel.body(x).Rd; sysmodel.body(x).w];
    end
    sysmodel.initial = [initpos;initvel];
    sysmodel.info.bodydof = [3,3,3];
end
