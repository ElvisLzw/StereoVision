%% Z����ȡ
%1.����ȷ��Z�᷶Χ����3D��ͼ����ȡ����ʾ
%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.
% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');%����궨�ļ�
% load('webcamsSceneReconstruction.mat');
%% Read in the stereo pair of images.
% I1 = imread('sceneReconstructionLeft.jpg');
% I2 = imread('sceneReconstructionRight.jpg');
I1 = imread('left3.bmp');
I2 = imread('right3.bmp');%������������ͷ������Ƭ
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%У��ͼƬ
%% Display the images after rectification.
figure; imshow(cat(3, J1(:,:,1), J2(:,:,2:3)));%�γ�3D��ͼ
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,80]);%�Ӳ���㣬������ʾ�Ӳ���0-80֮��
figure; imshow(disparityMap, [0,80]); 
%% Reconstruct the 3-D world coordinates of points corresponding to each pixel from the disparity map.
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
view(player3D, ptCloud);


%% Segment out a person located between 310mm and 355mm away from the camera.
Z = pointCloud3D(:, :, 3);%�洢Z����Ϣ
mask = repmat(Z >310 & Z <355, [1, 1, 3]);%ȷ��Z�ܷ�Χ
J1(~mask) = 0;%J1�г�����Χ������Ϊ��ɫ
imshow(J1);