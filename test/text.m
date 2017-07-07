%% Reconstruct 3-D Scene from Disparity Map
%% Load the stereo parameters.

% Copyright 2015 The MathWorks, Inc.
load('biaoding.mat');
%% Read in the stereo pair of images.
%left3
I1 = imread('wleft30.bmp');
I2 = imread('wright30.bmp');
%% Rectify the images.
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);%У��ͼ��
%% Display the images after rectification.
figure; imshow(cat(3, J1(:,:,1), J2(:,:,2:3)));%˫Ŀ�Ӿ�ͼ��
%% Compute the disparity.
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2),'DisparityRange',[0,256]);%�����Ӳ�
figure; imshow(disparityMap, [0,256]); %��ʾ�Ӳ���0��80֮����Ӳ�


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
%% ȷ��Z�ܷ�Χ
mask = repmat(Z >250 & Z <350, [1, 1, 3]);%wleft30
%mask = repmat(Z >350 & Z <450, [1, 1, 3]);%wleft40
%mask = repmat(Z >450 & Z <500, [1, 1, 3]);%wleft50
%mask = repmat(Z >550 & Z <650, [1, 1, 3]);%wleft60
%mask = repmat(Z >650 & Z <700, [1, 1, 3]);%wleft70
%mask = repmat(Z >740 & Z <780, [1, 1, 3]);%wleft70
J1(~mask) = 0;%J1�г�����Χ������Ϊ��ɫ
imshow(J1);