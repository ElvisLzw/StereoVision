%% 颜色色域空间检测HSV
%2.颜色色域空间检测提取
load('biaoding.mat');
%% 提取颜色
I=imread('left1.bmp');
I = undistortImage(I, stereoParams.CameraParameters1);%根据相机标定校正图像
subplot(1,2,1);
imshow(I); title('校正图像', 'FontWeight', 'Bold');
%% LAB
% cform = makecform('srgb2lab');%将rgb转换为lab
% lab = applycform(I,cform);%应用lab
% a=lab(:,:,2);%选择lab中的a，即洋红色至绿色的范围
% bw=im2bw(a,0.7);%将图像二值化
%% HSV
I1 = rgb2hsv(I); % RGB转换到HSV空间
h = I1(:, :, 2); % H层
bw = im2bw(h, 0.97);
bw = imfill(bw,'holes');%图像填充

imLabel = bwlabel(bw);%对各连通域进行标记
stats = regionprops(imLabel,'Area');%求各连通域的大小
area = cat(1,stats.Area);
index = find(area == max(area));%求最大连通域的索引
img = ismember(imLabel,index);%获取最大连通域图像
%% 图像处理
% Zhongzhi=medfilt2(img);%中值滤波处理图像
% subplot(1,3,2);
% imshow(Zhongzhi); title('中值滤波处理图像', 'FontWeight', 'Bold');
%% 分割图像
I2 = I .* uint8(img); % 点乘
subplot(1,2,2);
imshow(I2); title('分割图像', 'FontWeight', 'Bold');