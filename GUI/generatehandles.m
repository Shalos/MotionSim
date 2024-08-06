   
function hout = generatehandles(sysmodel)
dex = 1;
for a = 1:sysmodel.info.joints
    j = sysmodel.joint(a).Bodyj;
    i = sysmodel.joint(a).Bodyi;
    %only process the joints that are spherical,revolute,S-S
        if  sysmodel.info.spatial && (sysmodel.joint(a).Type == 1 || sysmodel.joint(a).Type == 2 || sysmodel.joint(a).Type == 4)

           
            %this check ensures the correct transformation matrix if
            %its for kinematic or dynamic, since dynamic utilizes euler
            %parameters.
            
            %plot the system, if S-S contraint then plot the inbetween
            %gap red.
            
            if sysmodel.joint(a).Type == 4
                h(dex) = surf( zeros(3,3),  zeros(3,3),  zeros(3,3));
                dex = dex+1;
                h(dex) = plot3(0, 0, 0, 'r');
                dex = dex+1;
            end
            if j>1
                h(dex) = plot3(0, 0, 0, 'b');
                dex = dex+1;
            end
            if i > 1
                h(dex) = plot3(0, 0, 0, 'b');
                dex = dex+1;
            end
            h(dex) = surf( zeros(3,3),  zeros(3,3), zeros(3,3));
            dex = dex+1;
        elseif ~sysmodel.info.spatial && sysmodel.joint(a).Type == 1  % 2D Animation
            if j>1
                h(dex) = plot3(0, 0, 0, 'b');
                dex = dex+1;
            end
            if i > 1
                h(dex) = plot3(0, 0, 0, 'b');
                dex = dex+1;
            end
            h(dex) = surf( zeros(3,3),  zeros(3,3), zeros(3,3));
            dex = dex+1;
            
        end
    end

    for i = 1:sysmodel.info.bodies
        
        %grab the current xyz coordinates of the bodies
        %plot the body axis if checkbox enabled
        
        
        h(dex) = plot3(0, 0, 0,'r');
        dex = dex+1;
        h(dex) =  plot3(0, 0, 0,'g');
        dex = dex+1;
        h(dex) =  plot3(0, 0, 0,'k');
        dex = dex+1;
        
        
        h(dex) = surf( zeros(3,3),  zeros(3,3), zeros(3,3));
        dex = dex+1;
        
    end
    for z = 1:sysmodel.info.numpts
        
        h(dex) = plot3(0, 0, 0,'r*');
        dex = dex+1;
        
    end
    hout.h = h;
    [x,y,z] = sphere(20);
    hout.sphx = x;
    hout.sphy = y;
    hout.sphz = z;