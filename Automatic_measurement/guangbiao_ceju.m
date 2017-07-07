%% 十字光标选点测距
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%导入标定文件

%% 读取摄像头拍照
vid1 = videoinput('winvideo',2,'MJPG_640x480');%打开右摄像头
%preview(vid1);%预览右摄像头
set(vid1,'ReturnedColorSpace','rgb');%设置图像为彩色
frame_right = getsnapshot(vid1);%获取当前摄像机拍摄图像
figure;imshow(frame_right);%显示所拍摄图像

vid2 = videoinput('winvideo',3,'MJPG_640x480');%打开左摄像头
%preview(vid2);%预览左摄像头
set(vid2,'ReturnedColorSpace','rgb');%设置图像为彩色
frame_left = getsnapshot(vid2);%获取当前摄像机拍摄图像
figure;imshow(frame_left);%显示所拍摄图像

%% Read in the stereo pair of images.
I1 = frame_left;
I2 = frame_right;%导入左右摄像头拍摄照片

%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%校正图片

%% Display the images after rectification.
figure;imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%形成3D视图

%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,256]);
%计算视差，视差范围控制在0到256

%% 十字光标选点
imshow(J1)
hold on
[meanx,meany] = ginput(1); %%  十字光标选点
close;

%% 输出距离
pointCloud3D = reconstructScene(disparityMap, stereoParams);%从视差图重建对应于每个像素点的三维世界坐标。
X = pointCloud3D(:, :, 1);%存储X轴信息
Y = pointCloud3D(:, :, 2);%存储Y轴信息
Z = pointCloud3D(:, :, 3);%存储Z轴信息

dx = X(fix(meany),fix(meanx));%输出X轴信息
dy = Y(fix(meany),fix(meanx));%输出Y轴信息
dz = Z(fix(meany),fix(meanx))%输出Z轴信息，单位为毫米
dists = sqrt(dx^2+dy^2+dz^2)
Z = pointCloud3D(:, :, 3);%存储Z轴信息