function sensor_pose = getSensorPose(frame, pose)
%Returns the desired sensor pose in the following format:
% [X, Y, Z, QW, QX, QY, QZ] from the homogeneous matrix

sensor_xyz = pose{frame}(1:3,4)';
sensor_quat = tform2quat(pose{frame});

sensor_pose = [sensor_xyz, sensor_quat];

end

