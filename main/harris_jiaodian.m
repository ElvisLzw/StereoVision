%% 位姿Harris
%1.自动检测角点，选点导入数据
load('biaoding.mat ');
cameraParams=stereoParams.CameraParameters1;
I = imread('leftyp2.bmp');
figure; imshow(I);
title('Input Image');
%% 校正图像
im = undistortImage(I, cameraParams);%校正图像
figure; imshow(im);
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

%% 
% Compute new extrinsics.
[rotationMatrix, translationVector] = extrinsics(imagePoints, worldPoints, cameraParams)%计算位姿