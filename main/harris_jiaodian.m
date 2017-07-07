%% λ��Harris
%1.�Զ����ǵ㣬ѡ�㵼������
load('biaoding.mat ');
cameraParams=stereoParams.CameraParameters1;
I = imread('leftyp2.bmp');
figure; imshow(I);
title('Input Image');
%% У��ͼ��
im = undistortImage(I, cameraParams);%У��ͼ��
figure; imshow(im);
%% �ǵ���
I1 = rgb2gray(im);%ͼƬ�ҶȻ�
corners = detectHarrisFeatures(I1);%Harris�ǵ���
imshow(I1);
hold on;
plot(corners.selectStrongest(500));%�������Ľǵ�
hold on
[x,y] = ginput(4);%ʮ�ֹ��ѡ��

X = corners.Location(:,1);%��ȡHarris��⵽�Ľǵ��X����  
Y = corners.Location(:,2) ;%��ȡHarris��⵽�Ľǵ��Y����

x_min=[];
y_min=[];
j=[];
d_min=[];
%% ѡ����ÿ��ѡ������ĵ�
for i=1:4
d = sqrt((X-x(i)).^2 + (Y-y(i)).^2);
[d_min(i) j(i)] = min(d);%����ĵ�Ϊ��j���㣬�������Ϊd_min
x_min = [x_min;X( j(i) )];
y_min = [y_min;Y( j(i) )];%x_min,y_minΪҪ�ҵĵ�,
end
imagePoints = [x_min y_min;];
imagePoints = double(imagePoints);%ת����������
% Load image at new location.
worldPoints=[0,0;22,0;22,22;0,22];%���� ���� ���� ����

%% 
% Compute new extrinsics.
[rotationMatrix, translationVector] = extrinsics(imagePoints, worldPoints, cameraParams)%����λ��