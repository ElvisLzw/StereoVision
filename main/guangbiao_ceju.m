%% 十字光标选点测距
%1.选点得出结果
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%导入标定文件
%% Read in the stereo pair of images.
I1 = imread('left3.bmp');
I2 = imread('right3.bmp');%导入左右摄像头拍摄照片
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%校正图片
%% Display the images after rectification.
imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%形成3D视图
%% Compute the disparity.
% left2
%disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'Method','BlockMatching',...
            %'BlockSize',65,'UniquenessThreshold',60,'DisparityRange',[48,80]);

% left3
 disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,80]);
%默认参数提取视差在[48,80]范围的视差图
%% 十字光标选点
imshow(J1)
hold on
[meanx,meany] = ginput(1); %%  十字光标选点
%% 输出距离
pointCloud3D = reconstructScene(disparityMap, stereoParams);%从视差图重建对应于每个像素点的三维世界坐标。
X = pointCloud3D(:, :, 1);%存储X轴信息
Y = pointCloud3D(:, :, 2);%存储Y轴信息
Z = pointCloud3D(:, :, 3);%存储Z轴信息

dx = X(fix(meany),fix(meanx));%输出X轴信息
dy = Y(fix(meany),fix(meanx));%输出Y轴信息
dz = Z(fix(meany),fix(meanx))%输出Z轴信息
dists = sqrt(dx^2+dy^2+dz^2)