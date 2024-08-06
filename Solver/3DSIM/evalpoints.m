function [ points ] = evalpoints( system,ANS )
%compute points of interest, based of system data.

q = [];
qd = [];
qdd = [];
for x = 1:system.info.numpts
    body = system.points(x).body;
    vect = system.points(x).vect;
    
    m = 1+(body-1)*6;    
    q = [q,(system.body(body).R + system.body(body).A*vect)'];
    
    qd = [qd,(system.body(body).Rd + system.body(body).A*system.body(body).SkewW*vect)'];
    
    qdd = [qdd,(ANS(m:m+2) + system.body(body).A*system.body(body).SkewW*system.body(body).SkewW*vect ...
                          + system.body(body).A*Skew(ANS(m+3:m+5))*vect)'];

end
   % points = [q',qd',qdd'];
   points.q = q;
   points.qd = qd;
   points.qdd = qdd;
   
end


