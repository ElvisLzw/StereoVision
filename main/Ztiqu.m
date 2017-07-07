%% Z轴提取
%1.大致确定Z轴范围，在3D云图上提取并显示
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%导入标定文件
% load('webcamsSceneReconstruction.mat');
%% Read in the stereo pair of images.
% I1 = imread('sceneReconstructionLeft.jpg');
% I2 = imread('sceneReconstructionRight.jpg');
I1 = imread('left3.bmp');
I2 = imread('right3.bmp');%导入左右摄像头拍摄照片
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%校正图片
%% Display the images after rectification.
figure; imshow(cat(3, J1(:,:,1), J2(:,:,2:3)));%形成3D视图
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,80]);%视差计算，控制显示视差在0-80之间
figure; imshow(disparityMap, [0,80]); 
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
mask = repmat(Z >310 & Z <355, [1, 1, 3]);%确定Z周范围
J1(~mask) = 0;%J1中超过范围的区域为黑色
imshow(J1);