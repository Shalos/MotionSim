function [ points ] = evalpoints2D( system,ANS )
%Compute the points of interest in the, use calculated data to find the
%position, velocity and accelerations.

q = [];
qd = [];
qdd = [];
%iterate through points of interest
for x = 1:system.info.numpts
    body = system.points(x).body;
    vect = system.points(x).vect;
    
    m = 1+(body-1)*3;    
    q = [q,system.body(body).R + system.body(body).A*vect];
    qd = [qd,system.body(body).Rd + system.body(body).w*system.body(body).A*vect];
    qdd = [qdd,ANS(m:m+1) - system.body(body).w^2*system.body(body).A*vect ...
                          + ANS(m+2)*system.body(body).A*vect    ];
end
    %points = [q',qd',qdd'];
       points.q = q';
   points.qd = qd';
   points.qdd = qdd';
end

