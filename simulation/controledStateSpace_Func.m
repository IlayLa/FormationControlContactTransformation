function controledStateSpaceDelta = controledStateSpace_Func(t,y,mu,J2,Req)
leader_indices = 1:6;
follower_indices = 7:12;

% leader_PositionPN = y(leader_indices)';
% desiredFollower_PositionPN = leader_PositionPN;
% desiredFollower_PositionPN(2) = desiredFollower_PositionPN(2)-pi/3;
% desiredFollower_PositionECI = PN2ECI(desiredFollower_PositionPN(:));
% [follower_PositionECI(1:6)] = PN2ECI(y(follower_indices));
% [leader_r, leader_v, leader_h] = getRelevantECIVectors(leader_PositionECI);
% [follower_r, follower_v, follower_h] = getRelevantECIVectors(follower_PositionECI);
% 
% 
% 
% 
% delta_v = zeros(1,3);
% delta_vr = dot(follower_r/norm(follower_r),delta_v);
% delta_vt = dot(cross(follower_h,follower_r)/(norm(follower_h)*norm(follower_r)),delta_v);
% % delta_vh = dot(follower_h/norm(follower_h),delta_v);
% delta_R = delta_vr;
% delta_Theta = norm(follower_r)*delta_vt;
% delta_h = cross(follower_r,delta_v);
% delta_Nu = delta_h(3);
% delta_v_polarNodals = [delta_R; delta_Theta; delta_Nu];








leader_OsculatingStateSpaceDelta = OsculatingStateSpace_Func(t,y(leader_indices),mu,J2,Req);
follower_OsculatingStateSpaceDelta = OsculatingStateSpace_Func(t,y(follower_indices),mu,J2,Req);




controledStateSpaceDelta = [...
    leader_OsculatingStateSpaceDelta;...
    follower_OsculatingStateSpaceDelta...%+[0;0;0;delta_v_polarNodals(:)]
    ];

end