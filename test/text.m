%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.

% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');
%% Read in the stereo pair of images.
%left3
I1 = imread('wleft30.bmp');
I2 = imread('wright30.bmp');
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%校正图像
%% Display the images after rectification.
figure; imshow(cat(3, J1(:,:,1), J2(:,:,2:3)));%双目视觉图像
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,256]);%计算视差
figure; imshow(disparityMap, [0,256]); %显示视差在0到80之间的视差


%% Reconstruct the 3-D world coordinates of points corresponding to each pixel from the disparity map.
pointCloud3D = reconstructScene(disparityMap, stereoParams);%从视差图重建对应于每个像素点的三维世界坐标。
%% Reconstruct the 3-D Scene
% Reconstruct the 3-D world coordinates of points corresponding to each
% pixel from the disparity map.
points3D = reconstructScene(disparityMap, stereoParams);%建立3D云图

% Convert to meters and create a pointCloud object
points3D = points3D ./ 1000;%单位变成米
ptCloud = pointCloud(points3D, 'Color', J1);

% Create a streaming point cloud viewer
player3D = pcplayer([-0.5, 0.5], [-0.5, 0.5], [0, 0.8], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down');%垂直轴为Y轴 方向向下
xlabel(player3D.Axes,'X (m)');
ylabel(player3D.Axes,'Y (m)');
zlabel(player3D.Axes,'Z (m)');
% Visualize the point cloud
view(player3D, ptCloud);


%% Segment out a person located between 310mm and 355mm away from the camera.
Z = pointCloud3D(:, :, 3);%存储Z轴信息
%% 确定Z周范围
mask = repmat(Z >250 & Z <350, [1, 1, 3]);%wleft30
%mask = repmat(Z >350 & Z <450, [1, 1, 3]);%wleft40
%mask = repmat(Z >450 & Z <500, [1, 1, 3]);%wleft50
%mask = repmat(Z >550 & Z <650, [1, 1, 3]);%wleft60
%mask = repmat(Z >650 & Z <700, [1, 1, 3]);%wleft70
%mask = repmat(Z >740 & Z <780, [1, 1, 3]);%wleft70
J1(~mask) = 0;%J1中超过范围的区域为黑色
imshow(J1);