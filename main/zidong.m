%% �Զ����
%2.����ȷ�����ģ������г����
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
%Ĭ�ϲ�����ȡ�Ӳ���[48,80]��Χ���Ӳ�ͼ
d = disparityMap;
subplot(2,2,2);
imshow(d,[48,80], 'InitialMagnification', 50);
%% ����С��Ӿ���
bw=im2bw(d);%�Ӳ�ͼ��ֵ��
imshow(bw, 'InitialMagnification', 50);
[r, c]=find(bw==1);  
% 'a'�ǰ���������С���Σ�������߳���'p'  
[rectx,recty,perimeter] = minboundrect(c,r,'p');   
imshow(bw);hold on  
line(rectx,recty);
%% ��������
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
plot(meanx,meany,'r+'); %���Ӳ�ͼ����ʮ�ֱ������λ��

subplot(2,2,4);
imshow(J1)
hold on
plot(meanx,meany,'r+'); %��J1��ʮ�ֱ������λ��

%% �������
pointCloud3D = reconstructScene(disparityMap, stereoParams);%���Ӳ�ͼ�ؽ���Ӧ��ÿ�����ص����ά�������ꡣ
X = pointCloud3D(:, :, 1);%�洢X����Ϣ
Y = pointCloud3D(:, :, 2);%�洢Y����Ϣ
Z = pointCloud3D(:, :, 3);%�洢Z����Ϣ

dx = X(fix(meany),fix(meanx));%���X����Ϣ
dy = Y(fix(meany),fix(meanx));%���Y����Ϣ
dz = Z(fix(meany),fix(meanx))%���Z����Ϣ
dists = sqrt(dx^2+dy^2+dz^2)
