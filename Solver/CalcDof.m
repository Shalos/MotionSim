function [ sysmodel ] = CalcDof( sysmodel)
%calculates the degrees of freedom for different coordinates and updates
%the system variable. 

%begin processing DOF analysis
cdof = 0;
if ~sysmodel.info.spatial
    bdof = 3;  %number of dof per body
    cdof = 3;
    %calc DOF by constraints
    for x = 1:sysmodel.info.joints
        if sysmodel.joint(x).Type == 1
            cdof = cdof +2;
        elseif sysmodel.joint(x).Type ==2
            cdof = cdof +2;
        end
        
    end
    cdof = cdof + sysmodel.info.drivers;
elseif sysmodel.info.spatial && sysmodel.info.dynamic
    bdof = 6;%number of dof per body
    cdof = 6;
    %calc dof by constraints
    for x = 1:sysmodel.info.joints
        if sysmodel.joint(x).Type == 1
            cdof = cdof +3;
        elseif sysmodel.joint(x).Type ==2
            cdof = cdof +5;
        elseif sysmodel.joint(x).Type ==3
            cdof = cdof +4;
        elseif sysmodel.joint(x).Type ==4
            cdof = cdof +1;
        elseif sysmodel.joint(x).Type ==5
            cdof = cdof +5;
        end
        
    end
    cdof = cdof + sysmodel.info.drivers;
elseif sysmodel.info.spatial && ~sysmodel.info.dynamic
    bdof = 7;%number of dof per body
    cdof = 7;
    %calc dof by constraints
    for x = 1:sysmodel.info.joints
        if sysmodel.joint(x).Type == 1
            cdof = cdof +3;
        elseif sysmodel.joint(x).Type ==2
            cdof = cdof +5;
        elseif sysmodel.joint(x).Type ==3
            cdof = cdof +4;
        elseif sysmodel.joint(x).Type ==4
            cdof = cdof +1;
        elseif sysmodel.joint(x).Type ==5
            cdof = cdof +5;
        end
        
    end
    cdof = cdof + sysmodel.info.bodies-1;
    cdof = cdof + sysmodel.info.drivers;
end
totdof = sysmodel.info.bodies*bdof;

dof = totdof - cdof;
%store data back in system variable
sysmodel.info.dof = dof;
sysmodel.info.totdof = totdof;
sysmodel.info.cdof = cdof;

end

