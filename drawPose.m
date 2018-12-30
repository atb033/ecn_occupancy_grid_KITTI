function drawPose(frame,pose)
% Draws the path of the vehicle till current frame and the vehicle

path = zeros(frame,7);
    for i = 1:frame
        path(i,:) = getSensorPose(i,pose);
    end
    % Plot the path till the current frame
    plot3(path(:,1),path(:,2),path(:,3),'LineWidth',1)

    % Plot the vehicle
    l = 4;
    w = 1.5;
    h = 1.5;

    % set bounding box corners
    scale = 1;
    corners_x = scale*[l/2, l/2, -l/2, -l/2, l/2, l/2, -l/2, -l/2]; % front/back
    corners_y = scale*[w/2, -w/2, -w/2, w/2, w/2, -w/2, -w/2, w/2]; % left/right
    corners_z = scale*[0,0,0,0,h,h,h,h];
    
    corners = [corners_x; corners_y; corners_z];
    corners = [corners; ones(1,size(corners,2))];
    
    corners = pose{frame}*corners;
    corners = corners(1:3,:);
    
    % Top face
    plot3([corners(1,1:4),corners(1,1)],...
        [corners(2,1:4),corners(2,1)],...
        [corners(3,1:4),corners(3,1)],'b','LineWidth',1.5);
    % Bottom face
    plot3([corners(1,5:8),corners(1,5)],...
        [corners(2,5:8),corners(2,5)],...
        [corners(3,5:8),corners(3,5)],'b','LineWidth',1.5);
    % Other edges
    plot3([corners(1,1),corners(1,5)],...
        [corners(2,1),corners(2,5)],...
        [corners(3,1),corners(3,5)],'b','LineWidth',1.5);
    plot3([corners(1,2),corners(1,6)],...
        [corners(2,2),corners(2,6)],...
        [corners(3,2),corners(3,6)],'b','LineWidth',1.5);
    plot3([corners(1,3),corners(1,7)],...
        [corners(2,3),corners(2,7)],...
        [corners(3,3),corners(3,7)],'b','LineWidth',1.5);
    plot3([corners(1,4),corners(1,8)],...
        [corners(2,4),corners(2,8)],...
        [corners(3,4),corners(3,8)],'b','LineWidth',1.5);     
    
    
end

