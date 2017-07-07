%% 位姿求解
%% Load the stereo parameters.
load('biaoding.mat ');%导入标定文件
cameraParams=stereoParams.CameraParameters1;

%% 读取摄像头拍照
vid_right = videoinput('winvideo',2,'MJPG_640x480');%打开右摄像头
%preview(vid_right);%预览右摄像头
set(vid_right,'ReturnedColorSpace','rgb');%设置图像为彩色
frame_right = getsnapshot(vid_right);%获取右摄像机拍摄图像
I = frame_right;
figure(1); imshow(I);
title('摄像头输入图像');
%% 校正图像
im = undistortImage(I, cameraParams);%校正图像
figure(2); imshow(im);
title('校正后图像');
%% 角点检测
I1 = rgb2gray(im);%图片灰度化
corners = detectHarrisFeatures(I1);%Harris角点检测
imshow(I1);
hold on;
plot(corners.selectStrongest(500));%画出检测的角点
hold on
[x,y] = ginput(4);%十字光标选点

X = corners.Location(:,1);%提取Harris检测到的角点的X坐标  
Y = corners.Location(:,2) ;%提取Harris检测到的角点的Y坐标

x_min=[];
y_min=[];
j=[];
d_min=[];
%% 选出离每次选点最近的点
for i=1:4
d = sqrt((X-x(i)).^2 + (Y-y(i)).^2);
[d_min(i) j(i)] = min(d);%最近的点为第j个点，最近距离为d_min
x_min = [x_min;X( j(i) )];
y_min = [y_min;Y( j(i) )];%x_min,y_min为要找的点,
end
imagePoints = [x_min y_min;];
imagePoints = double(imagePoints);%转换数据类型
% Load image at new location.
worldPoints=[0,0;22,0;22,22;0,22];%左上 右上 右下 左下

%% Compute new extrinsics.
[rotationMatrix, translationVector] = extrinsics(imagePoints, worldPoints, cameraParams)%计算位姿