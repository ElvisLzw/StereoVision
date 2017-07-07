%% 在视差图上提取
%3.视差图上提取
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');
%% Read in the stereo pair of images.
I1 = imread('left2.bmp');
I2 = imread('right2.bmp');
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
%% Display the images after rectification.
imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'Method','BlockMatching','BlockSize',65,...
    'UniquenessThreshold',60,'DisparityRange',[48,80]);
%默认参数提取视差在[48,80]范围的视差图

% disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'Method','BlockMatching','BlockSize',25,...
%     'UniquenessThreshold',15,'DisparityRange',[0,80]);
d = disparityMap;
subplot(1,2,1);
imshow(d, [0,80],'InitialMagnification', 50);
title('视差图', 'FontWeight', 'Bold');

%% 提取目标
mask = repmat(d >48& d <80, [1, 1, 3]);%提取视差在48-80范围的区域
J1(~mask) = 0;
subplot(1,2,2);
imshow(J1, 'InitialMagnification', 50);
title('提取目标', 'FontWeight', 'Bold');