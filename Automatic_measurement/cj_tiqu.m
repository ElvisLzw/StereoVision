%% 十字光标选点测距,提取
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%导入标定文件

%% 读取摄像头拍照
vid_right = videoinput('winvideo',2,'MJPG_640x480');%打开右摄像头
%preview(vid_right);%预览右摄像头
set(vid_right,'ReturnedColorSpace','rgb');%设置图像为彩色


vid_left = videoinput('winvideo',3,'MJPG_640x480');%打开左摄像头
%preview(vid_left);%预览左摄像头
set(vid_left,'ReturnedColorSpace','rgb');%设置图像为彩色 

frame_right = getsnapshot(vid_right);%获取右摄像机拍摄图像
frame_left = getsnapshot(vid_left);%获取左摄像机拍摄图像
%figure;imshow(frame_right);%显示所拍摄图像
%figure;imshow(frame_left);%显示所拍摄图像

%% Read in the stereo pair of images.
I1 = frame_left;
I2 = frame_right;%导入左右摄像头拍摄照片

%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%根据摄像头标定结果校正图片

%% Display the images after rectification.
figure(1);imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%形成3D视图
title('3D视图');
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,256]);
figure(2); imshow(disparityMap, [0,256]);
title('视差图');
%计算视差，视差范围控制在0到256

%% 十字光标选点
figure(3);imshow(J1)
title('选择测量点');
hold on
[meanx,meany] = ginput(1); %%  十字光标选点
% close;

%% 输出距离
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
view(player3D, ptCloud);%3D云图效果

%% Segment out a person located between 310mm and 355mm away from the camera.
pointCloud3D = reconstructScene(disparityMap, stereoParams);%从视差图重建对应于每个像素点的三维世界坐标。
X = pointCloud3D(:, :, 1);%存储X轴信息
Y = pointCloud3D(:, :, 2);%存储Y轴信息
Z = pointCloud3D(:, :, 3);%存储Z轴信息

dx = X(fix(meany),fix(meanx));%输出X轴信息
dy = Y(fix(meany),fix(meanx));%输出Y轴信息
dz = Z(fix(meany),fix(meanx))%输出Z轴信息
dists = sqrt(dx^2+dy^2+dz^2)

mask = repmat(Z >(dz-50) & Z <(dz+50), [1, 1, 3]);%确定Z周范围，误差设定为上下50毫米
J1(~mask) = 0;%J1中超过范围的区域为黑色
figure(4);imshow(J1);
title('提取目标');