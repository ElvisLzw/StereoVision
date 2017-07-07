%% ��ɫɫ��ռ���HSV
%2.��ɫɫ��ռ�����ȡ
load('biaoding.mat');
%% ��ȡ��ɫ
I=imread('left1.bmp');
I = undistortImage(I, stereoParams.CameraParameters1);%��������궨У��ͼ��
subplot(1,2,1);
imshow(I); title('У��ͼ��', 'FontWeight', 'Bold');
%% LAB
% cform = makecform('srgb2lab');%��rgbת��Ϊlab
% lab = applycform(I,cform);%Ӧ��lab
% a=lab(:,:,2);%ѡ��lab�е�a�������ɫ����ɫ�ķ�Χ
% bw=im2bw(a,0.7);%��ͼ���ֵ��
%% HSV
I1 = rgb2hsv(I); % RGBת����HSV�ռ�
h = I1(:, :, 2); % H��
bw = im2bw(h, 0.97);
bw = imfill(bw,'holes');%ͼ�����

imLabel = bwlabel(bw);%�Ը���ͨ����б��
stats = regionprops(imLabel,'Area');%�����ͨ��Ĵ�С
area = cat(1,stats.Area);
index = find(area == max(area));%�������ͨ�������
img = ismember(imLabel,index);%��ȡ�����ͨ��ͼ��
%% ͼ����
% Zhongzhi=medfilt2(img);%��ֵ�˲�����ͼ��
% subplot(1,3,2);
% imshow(Zhongzhi); title('��ֵ�˲�����ͼ��', 'FontWeight', 'Bold');
%% �ָ�ͼ��
I2 = I .* uint8(img); % ���
subplot(1,2,2);
imshow(I2); title('�ָ�ͼ��', 'FontWeight', 'Bold');