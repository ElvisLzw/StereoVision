%% ʮ�ֹ��ѡ����,��ȡ
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%����궨�ļ�

%% ��ȡ����ͷ����
vid_right = videoinput('winvideo',2,'MJPG_640x480');%��������ͷ
%preview(vid_right);%Ԥ��������ͷ
set(vid_right,'ReturnedColorSpace','rgb');%����ͼ��Ϊ��ɫ


vid_left = videoinput('winvideo',3,'MJPG_640x480');%��������ͷ
%preview(vid_left);%Ԥ��������ͷ
set(vid_left,'ReturnedColorSpace','rgb');%����ͼ��Ϊ��ɫ 

frame_right = getsnapshot(vid_right);%��ȡ�����������ͼ��
frame_left = getsnapshot(vid_left);%��ȡ�����������ͼ��
%figure;imshow(frame_right);%��ʾ������ͼ��
%figure;imshow(frame_left);%��ʾ������ͼ��

%% Read in the stereo pair of images.
I1 = frame_left;
I2 = frame_right;%������������ͷ������Ƭ

%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%��������ͷ�궨���У��ͼƬ

%% Display the images after rectification.
figure(1);imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%�γ�3D��ͼ
title('3D��ͼ');
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,256]);
figure(2); imshow(disparityMap, [0,256]);
title('�Ӳ�ͼ');
%�����Ӳ�ӲΧ������0��256

%% ʮ�ֹ��ѡ��
figure(3);imshow(J1)
title('ѡ�������');
hold on
[meanx,meany] = ginput(1); %%  ʮ�ֹ��ѡ��
% close;

%% �������
pointCloud3D = reconstructScene(disparityMap, stereoParams);%���Ӳ�ͼ�ؽ���Ӧ��ÿ�����ص����ά�������ꡣ

%% Reconstruct the 3-D Scene
% Reconstruct the 3-D world coordinates of points corresponding to each
% pixel from the disparity map.
points3D = reconstructScene(disparityMap, stereoParams);%����3D��ͼ

% Convert to meters and create a pointCloud object
points3D = points3D ./ 1000;%��λ�����
ptCloud = pointCloud(points3D, 'Color', J1);

% Create a streaming point cloud viewer
player3D = pcplayer([-0.5, 0.5], [-0.5, 0.5], [0, 0.8], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down');%��ֱ��ΪY�� ��������
xlabel(player3D.Axes,'X (m)');
ylabel(player3D.Axes,'Y (m)');
zlabel(player3D.Axes,'Z (m)');
% Visualize the point cloud
view(player3D, ptCloud);%3D��ͼЧ��

%% Segment out a person located between 310mm and 355mm away from the camera.
pointCloud3D = reconstructScene(disparityMap, stereoParams);%���Ӳ�ͼ�ؽ���Ӧ��ÿ�����ص����ά�������ꡣ
X = pointCloud3D(:, :, 1);%�洢X����Ϣ
Y = pointCloud3D(:, :, 2);%�洢Y����Ϣ
Z = pointCloud3D(:, :, 3);%�洢Z����Ϣ

dx = X(fix(meany),fix(meanx));%���X����Ϣ
dy = Y(fix(meany),fix(meanx));%���Y����Ϣ
dz = Z(fix(meany),fix(meanx))%���Z����Ϣ
dists = sqrt(dx^2+dy^2+dz^2)

mask = repmat(Z >(dz-50) & Z <(dz+50), [1, 1, 3]);%ȷ��Z�ܷ�Χ������趨Ϊ����50����
J1(~mask) = 0;%J1�г�����Χ������Ϊ��ɫ
figure(4);imshow(J1);
title('��ȡĿ��');