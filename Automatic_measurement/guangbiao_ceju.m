%% ʮ�ֹ��ѡ����
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%����궨�ļ�

%% ��ȡ����ͷ����
vid1 = videoinput('winvideo',2,'MJPG_640x480');%��������ͷ
%preview(vid1);%Ԥ��������ͷ
set(vid1,'ReturnedColorSpace','rgb');%����ͼ��Ϊ��ɫ
frame_right = getsnapshot(vid1);%��ȡ��ǰ���������ͼ��
figure;imshow(frame_right);%��ʾ������ͼ��

vid2 = videoinput('winvideo',3,'MJPG_640x480');%��������ͷ
%preview(vid2);%Ԥ��������ͷ
set(vid2,'ReturnedColorSpace','rgb');%����ͼ��Ϊ��ɫ
frame_left = getsnapshot(vid2);%��ȡ��ǰ���������ͼ��
figure;imshow(frame_left);%��ʾ������ͼ��

%% Read in the stereo pair of images.
I1 = frame_left;
I2 = frame_right;%������������ͷ������Ƭ

%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%У��ͼƬ

%% Display the images after rectification.
figure;imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%�γ�3D��ͼ

%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,256]);
%�����Ӳ�ӲΧ������0��256

%% ʮ�ֹ��ѡ��
imshow(J1)
hold on
[meanx,meany] = ginput(1); %%  ʮ�ֹ��ѡ��
close;

%% �������
pointCloud3D = reconstructScene(disparityMap, stereoParams);%���Ӳ�ͼ�ؽ���Ӧ��ÿ�����ص����ά�������ꡣ
X = pointCloud3D(:, :, 1);%�洢X����Ϣ
Y = pointCloud3D(:, :, 2);%�洢Y����Ϣ
Z = pointCloud3D(:, :, 3);%�洢Z����Ϣ

dx = X(fix(meany),fix(meanx));%���X����Ϣ
dy = Y(fix(meany),fix(meanx));%���Y����Ϣ
dz = Z(fix(meany),fix(meanx))%���Z����Ϣ����λΪ����
dists = sqrt(dx^2+dy^2+dz^2)
Z = pointCloud3D(:, :, 3);%�洢Z����Ϣ