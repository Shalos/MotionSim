

function generateframe(tdex,hobj,handles)
    sysmodel = handles.sysmodel;
    results = sysmodel.results;
    x = hobj.sphx;
    y = hobj.sphy;
    z = hobj.sphz;
    h = hobj.h;
    bdyaxes = hobj.bodyaxes;
    scale = .5;
    bscal = 1;
    dex = 1;
    
    bodyposdof = sysmodel.info.bodydof(1);
    bodyveldof = sysmodel.info.bodydof(2);
    bodyaccdof = sysmodel.info.bodydof(3);
    for a = 1:sysmodel.info.joints
        
        %only process the joints that are spherical,revolute,S-S
        if sysmodel.info.spatial && (sysmodel.joint(a).Type == 1 || sysmodel.joint(a).Type == 2 || sysmodel.joint(a).Type == 4)
            %process the information of the bodies, their transformation
            %matrices, and their positions of the sperhical locations etc.
            %With taking care that if i or j is equal to zero, hardcode the
            %data as body zero is ground and doesnt move.
            j = sysmodel.joint(a).Bodyj;
            i = sysmodel.joint(a).Bodyi;
            
            %this check ensures the correct transformation matrix if
            %its for kinematic or dynamic, since dynamic utilizes euler
            %parameters.
                Amatj= euler_amat(results.coord.q(tdex, j*7-3:j*7)');
                Amati= euler_amat(results.coord.q(tdex, i*7-3:i*7)');
                newi = results.coord.q(tdex, i*7-6:i*7-4)' + Amati*sysmodel.joint(a).pi;
                newj = results.coord.q(tdex, j*7-6:j*7-4)' + Amatj*sysmodel.joint(a).pj;

            

            xi=results.coord.q(tdex, i*bodyposdof-bodyposdof+1);
            yi=results.coord.q(tdex, i*bodyposdof-bodyposdof+2);
           
            xj=results.coord.q(tdex, j*bodyposdof-bodyposdof+1);
            yj=results.coord.q(tdex, j*bodyposdof-bodyposdof+2);
            
            zi=results.coord.q(tdex, i*bodyposdof-bodyposdof+3);
            zj=results.coord.q(tdex, j*bodyposdof-bodyposdof+3);
            
            %plot the system, if S-S contraint then plot the inbetween
            %gap red.

                if sysmodel.joint(a).Type == 4
                    set(h(dex),'Xdata',scale*x+newj(1),'Ydata', scale*y + newj(2), 'Zdata', scale*z+ newj(3));
                    dex = dex+1;
                    set(h(dex),'Xdata',[newj(1,1),newi(1,1)],'Ydata', [newj(2,1),newi(2,1)], 'Zdata', [newj(3,1),newi(3,1)]);
                    dex = dex+1;
                    %  hj4(a) = surf(sjx+newj(1), sjy + newj(2), sjz+ newj(3));
                    %  hj2(a) = plot3([newj(1,1),newi(1,1)],[newj(2,1),newi(2,1)],[newj(3,1),newi(3,1)], 'r');
                end
                if j>1
                    set(h(dex),'Xdata',[xj,newj(1,1)],'Ydata', [yj,newj(2,1)], 'Zdata', [zj,newj(3,1)]);
                    dex = dex+1;
                    % hj1(a) = plot3([xj,newj(1,1)],[yj,newj(2,1)],[zj,newj(3,1)], 'b');
                end
                if i > 1
                    set(h(dex),'Xdata',[xi,newi(1,1)],'Ydata', [yi,newi(2,1)], 'Zdata', [zi,newi(3,1)]);
                    dex = dex+1;
                    %hj2(a) = plot3([xi,newi(1,1)],[yi,newi(2,1)],[zi,newi(3,1)], 'b');
                end
                set(h(dex),'Xdata',.3*scale*x+newi(1),'Ydata', .3*scale*y + newi(2), 'Zdata', .3*scale*z+ newi(3));
                dex = dex+1;
                %hj3(a) = surf(.3*sjx+newi(1), .3*sjy + newi(2), .3*sjz+ newi(3));

          
        elseif ~sysmodel.info.spatial && sysmodel.joint(a).Type == 1  % 2D Animation
            j = sysmodel.joint(a).Bodyj;
            i = sysmodel.joint(a).Bodyi;
            phiz = results.coord.q(tdex, i*3);
            Amati = [cos(phiz), -sin(phiz); sin(phiz), cos(phiz)];
            phiz = results.coord.q(tdex, j*3);
            Amatj = [cos(phiz), -sin(phiz); sin(phiz), cos(phiz)];
            newi = results.coord.q(tdex, i*3-2:i*3-1)' + Amati*sysmodel.joint(a).pi;
            newj = results.coord.q(tdex, j*3-2:j*3-1)' + Amatj*sysmodel.joint(a).pj;
            
            xi=results.coord.q(tdex, i*bodyposdof-bodyposdof+1);
            yi=results.coord.q(tdex, i*bodyposdof-bodyposdof+2);
           
            xj=results.coord.q(tdex, j*bodyposdof-bodyposdof+1);
            yj=results.coord.q(tdex, j*bodyposdof-bodyposdof+2);
                if j > 1
                    set(h(dex),'Xdata',[xj,newj(1,1)],'Ydata', [yj,newj(2,1)], 'Zdata', [0,0]);
                    dex = dex+1;
                    %  hj1(a) = plot3([xj,newj(1,1)],[yj,newj(2,1)],[0,0], 'b');
                end
                if i > 1
                    set(h(dex),'Xdata',[xi,newi(1,1)],'Ydata', [yi,newi(2,1)], 'Zdata', [0,0]);
                    dex = dex+1;
                    % hj2(a) = plot3([xi,newi(1,1)],[yi,newi(2,1)],[0,0], 'b');
                end
                set(h(dex),'Xdata',.3*scale*x+newi(1),'Ydata', .3*scale*y + newi(2), 'Zdata', .3*scale*z);
                dex = dex+1;
                % hj3(a) = surf(sjx+newi(1), sjy + newi(2), sjz);
            
        end
    end
    for i = 1:sysmodel.info.bodies
        %grab the current xyz coordinates of the bodies
        bx=results.coord.q(tdex, i*bodyposdof-bodyposdof+1);
        by=results.coord.q(tdex, i*bodyposdof-bodyposdof+2);
        
        %find Tmatrix for axis lines taking in account the different
        %ways of calculating the Tmatrix for euler or
        
        if sysmodel.info.spatial
            Amati= euler_amat(results.coord.q(tdex, i*7-3:i*7)');
            bz=results.coord.q(tdex, i*bodyposdof-bodyposdof+3);
        else
            phiz = results.coord.q(tdex,  i*3);
            Amati = [cos(phiz), -sin(phiz); sin(phiz), cos(phiz)];
            Amati = [Amati,[0;0];[0,0,0]];
            
            bz = 0;
        end
        
        %plot the body axis if checkbox enabled
        % if get(handles.BDYAXES,'Value')
        %eval(get(handles.editBASCALE,'String'));
        if bdyaxes
        coord = Amati*[bscal;0;0];
        set(h(dex),'Xdata',[bx bx+coord(1)],'Ydata', [by by+coord(2)], 'Zdata', [bz bz+coord(3)]);
        dex = dex+1;
        % plot3([bx bx+coord(1)],[by by+coord(2)],[bz bz+coord(3)],'r')
        coord = Amati*[0;bscal;0];
        set(h(dex),'Xdata',[bx bx+coord(1)],'Ydata',[by by+coord(2)], 'Zdata', [bz bz+coord(3)]);
        dex = dex+1;
        %plot3([bx bx+coord(1)],[by by+coord(2)],[bz bz+coord(3)],'g')
        coord = Amati*[0;0;bscal];
        set(h(dex),'Xdata',[bx bx+coord(1)],'Ydata',[by by+coord(2)], 'Zdata', [bz bz+coord(3)]);
        dex = dex+1;
        %plot3([bx bx+coord(1)],[by by+coord(2)],[bz bz+coord(3)],'k')
        else
            set(h(dex),'Xdata',0,'Ydata',0, 'Zdata', 0);
            set(h(dex+1),'Xdata',0,'Ydata',0, 'Zdata', 0);
            set(h(dex+2),'Xdata',0,'Ydata',0, 'Zdata', 0);
            dex = dex + 3;
         end
        
        %hb(i) = surf(.3*sbx+x, .3*sby + y, .3*sbz+ z);
        set(h(dex),'Xdata',.3*scale*x+bx,'Ydata',  .3*scale*y + by, 'Zdata', .3*scale*z+ bz);
        dex = dex+1;
    end
    for z = 1:sysmodel.info.numpts
        
        if sysmodel.info.spatial
        newp = results.points.q(tdex,(z-1)*3+1:z*3);
        set(h(dex),'Xdata',newp(1),'Ydata', newp(2), 'Zdata', newp(3));   
        else
        newp = results.points.q(tdex,(z-1)*2+1:z*2);
        set(h(dex),'Xdata',newp(1),'Ydata', newp(2), 'Zdata',0);   
        end

        dex = dex+1;
        %plot3(newp(1),newp(2),newp(3),'r*')
        
    end
   