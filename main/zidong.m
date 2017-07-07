%% 自动测距
%2.根据确定质心，点运行出结果
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');
%% Read in the stereo pair of images.
I1 = imread('left2.bmp');
I2 = imread('right2.bmp');
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
%% Display the images after rectification.
subplot(2,2,1);
imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'Method','BlockMatching',...
            'BlockSize',65,'UniquenessThreshold',60,'DisparityRange',[48,80]);
%默认参数提取视差在[48,80]范围的视差图
d = disparityMap;
subplot(2,2,2);
imshow(d,[48,80], 'InitialMagnification', 50);
%% 求最小外接矩形
bw=im2bw(d);%视差图二值化
imshow(bw, 'InitialMagnification', 50);
[r, c]=find(bw==1);  
% 'a'是按面积算的最小矩形，如果按边长用'p'  
[rectx,recty,perimeter] = minboundrect(c,r,'p');   
imshow(bw);hold on  
line(rectx,recty);
%% 计算质心
I = double(bw);
[rows,cols] = size(I); 
x = ones(rows,1)*[1:cols];
y = [1:rows]'*ones(1,cols);   
area = sum(sum(I)); 
meanx = sum(sum(I.*x))/area; 
meany = sum(sum(I.*y))/area;
subplot(2,2,3);
imshow(I)
hold on
plot(meanx,meany,'r+'); %在视差图上用十字标出重心位置

subplot(2,2,4);
imshow(J1)
hold on
plot(meanx,meany,'r+'); %在J1上十字标出重心位置

%% 输出距离
pointCloud3D = reconstructScene(disparityMap, stereoParams);%从视差图重建对应于每个像素点的三维世界坐标。
X = pointCloud3D(:, :, 1);%存储X轴信息
Y = pointCloud3D(:, :, 2);%存储Y轴信息
Z = pointCloud3D(:, :, 3);%存储Z轴信息

dx = X(fix(meany),fix(meanx));%输出X轴信息
dy = Y(fix(meany),fix(meanx));%输出Y轴信息
dz = Z(fix(meany),fix(meanx))%输出Z轴信息
dists = sqrt(dx^2+dy^2+dz^2)
