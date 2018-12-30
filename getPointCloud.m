function ptCloud = getPointCloud(frame, base_dir)
%This function extracts the point cloud from the desired bin file

fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame-1),'rb');
velo = fread(fid,[4 inf],'single')';
velo = velo(1:5:end,:); % remove every 5th point for display speed
fclose(fid);
ptCloud = pointCloud(velo(:,1:3),'Intensity',velo(:,4));

end

