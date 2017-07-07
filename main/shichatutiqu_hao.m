%% ���Ӳ�ͼ����ȡ
%3.�Ӳ�ͼ����ȡ
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
%Ĭ�ϲ�����ȡ�Ӳ���[48,80]��Χ���Ӳ�ͼ

% disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'Method','BlockMatching','BlockSize',25,...
%     'UniquenessThreshold',15,'DisparityRange',[0,80]);
d = disparityMap;
subplot(1,2,1);
imshow(d, [0,80],'InitialMagnification', 50);
title('�Ӳ�ͼ', 'FontWeight', 'Bold');

%% ��ȡĿ��
mask = repmat(d >48& d <80, [1, 1, 3]);%��ȡ�Ӳ���48-80��Χ������
J1(~mask) = 0;
subplot(1,2,2);
imshow(J1, 'InitialMagnification', 50);
title('��ȡĿ��', 'FontWeight', 'Bold');