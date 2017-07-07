%% ʮ�ֹ��ѡ����
%1.ѡ��ó����
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%����궨�ļ�
%% Read in the stereo pair of images.
I1 = imread('left3.bmp');
I2 = imread('right3.bmp');%������������ͷ������Ƭ
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%У��ͼƬ
%% Display the images after rectification.
imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%�γ�3D��ͼ
%% Compute the disparity.
% left2
%disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'Method','BlockMatching',...
            %'BlockSize',65,'UniquenessThreshold',60,'DisparityRange',[48,80]);

% left3
 disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,80]);
%Ĭ�ϲ�����ȡ�Ӳ���[48,80]��Χ���Ӳ�ͼ
%% ʮ�ֹ��ѡ��
imshow(J1)
hold on
[meanx,meany] = ginput(1); %%  ʮ�ֹ��ѡ��
%% �������
pointCloud3D = reconstructScene(disparityMap, stereoParams);%���Ӳ�ͼ�ؽ���Ӧ��ÿ�����ص����ά�������ꡣ
X = pointCloud3D(:, :, 1);%�洢X����Ϣ
Y = pointCloud3D(:, :, 2);%�洢Y����Ϣ
Z = pointCloud3D(:, :, 3);%�洢Z����Ϣ

dx = X(fix(meany),fix(meanx));%���X����Ϣ
dy = Y(fix(meany),fix(meanx));%���Y����Ϣ
dz = Z(fix(meany),fix(meanx))%���Z����Ϣ
dists = sqrt(dx^2+dy^2+dz^2)