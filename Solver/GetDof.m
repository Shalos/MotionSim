function [  tags ] = GetDof( spatial, jointnum )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if spatial
   if jointnum == 1 %spherical
       dof = 3;
       tags = {'X','Y','Z'};
   elseif jointnum == 2 %revolute
       dof = 5;
       tags = {'X','Y','Z','P1','P2'};  
   elseif jointnum == 3 %cylindrical
       dof = 4;
       tags = {'X','Y','Z','P1'};  
   elseif jointnum == 4 %SS
       dof = 1;
       tags = {'SS1'}; 
   elseif jointnum == 5 %prismatic
       dof = 5;
       tags = {'X','Y','Z','P1','P2'}; 
   end
else
    if jointnum == 1 %rev
       dof = 2;
       tags = {'X','Y'};
   elseif jointnum == 2 %trans
       dof = 2;
       tags = {'X','P1'};  
    end 
end

end

