function drawTrackletBoxes(frame, tracklets, pose)
%
% Tracklet initialization loop
for it = 1:numel(tracklets)
  
  % shortcut for tracklet dimensions
  w = tracklets{it}.w;
  h = tracklets{it}.h;
  l = tracklets{it}.l;

  % set bounding box corners
  scale = 1;
  corners(it).x = scale*[l/2, l/2, -l/2, -l/2, l/2, l/2, -l/2, -l/2]; % front/back
  corners(it).y = scale*[w/2, -w/2, -w/2, w/2, w/2, -w/2, -w/2, w/2]; % left/right
  corners(it).z = scale*[0,0,0,0,h,h,h,h];
  
  % get translation and orientation
  t{it} = [tracklets{it}.poses(1,:); tracklets{it}.poses(2,:); tracklets{it}.poses(3,:)];
  rz{it} = wrapToPi(tracklets{it}.poses(6,:));
%   occlusion{it} = tracklets{it}.poses(8,:);
%   
%   
%   % 3D bounding box faces (indices for corners)
% face_idx = [ 1,2,6,5   % front face
%              2,3,7,6   % left face
%              3,4,8,7   % back face
%              4,1,5,8]; % right face

end

  % compute bounding boxes for visible tracklets
  for it = 1:numel(tracklets)
    
    % get relative tracklet frame index (starting at 0 with first appearance; 
    % xml data stores poses relative to the first frame where the tracklet appeared)
    pose_idx = frame-tracklets{it}.first_frame; % 0-based => 1-based MATLAB index

    % only draw tracklets that are visible in current frame
    if pose_idx<1 || pose_idx>(size(tracklets{it}.poses,2))
      continue;
    end
    
        % compute 3d object rotation in velodyne coordinates
    % VELODYNE COORDINATE SYSTEM:
    %   x -> facing forward
    %   y -> facing left
    %   z -> facing up
    R = [cos(rz{it}(pose_idx)), -sin(rz{it}(pose_idx)), 0;
         sin(rz{it}(pose_idx)),  cos(rz{it}(pose_idx)), 0;
                             0,                      0, 1];

    % rotate and translate 3D bounding box in velodyne coordinate system
    corners_3D      = R*[corners(it).x;corners(it).y;corners(it).z];
    corners_3D(1,:) = corners_3D(1,:) + t{it}(1,pose_idx);
    corners_3D(2,:) = corners_3D(2,:) + t{it}(2,pose_idx);
    corners_3D(3,:) = corners_3D(3,:) + t{it}(3,pose_idx);

%     % Convert to global coordinate system
    corners_3D_global = pose{frame}*[corners_3D;ones(1,size(corners_3D,2))];
    corners_3D_global = corners_3D_global(1:3,:);
%     corners_3D_global = corners_3D;

% Plotting the cube
    % Top face
    plot3([corners_3D_global(1,1:4),corners_3D_global(1,1)],...
        [corners_3D_global(2,1:4),corners_3D_global(2,1)],...
        [corners_3D_global(3,1:4),corners_3D_global(3,1)],'r','LineWidth',1.5);
    % Bottom face
    plot3([corners_3D_global(1,5:8),corners_3D_global(1,5)],...
        [corners_3D_global(2,5:8),corners_3D_global(2,5)],...
        [corners_3D_global(3,5:8),corners_3D_global(3,5)],'r','LineWidth',1.5);
    % Other edges
    plot3([corners_3D_global(1,1),corners_3D_global(1,5)],...
        [corners_3D_global(2,1),corners_3D_global(2,5)],...
        [corners_3D_global(3,1),corners_3D_global(3,5)],'r','LineWidth',1.5);
    plot3([corners_3D_global(1,2),corners_3D_global(1,6)],...
        [corners_3D_global(2,2),corners_3D_global(2,6)],...
        [corners_3D_global(3,2),corners_3D_global(3,6)],'r','LineWidth',1.5);
    plot3([corners_3D_global(1,3),corners_3D_global(1,7)],...
        [corners_3D_global(2,3),corners_3D_global(2,7)],...
        [corners_3D_global(3,3),corners_3D_global(3,7)],'r','LineWidth',1.5);
    plot3([corners_3D_global(1,4),corners_3D_global(1,8)],...
        [corners_3D_global(2,4),corners_3D_global(2,8)],...
        [corners_3D_global(3,4),corners_3D_global(3,8)],'r','LineWidth',1.5);    
    
end

