

clc
% clearvars -except cloud
close all
clear

load('cloud.mat')

base = zeros(800,800);
[w1,w2] = size(base);

cover_expected = 0.3;

cover_true = nnz(base)/w1/w2;


while cover_true <= cover_expected

    cloudNum = randi([1,size(cloud,1)]);
    cloudMat = cloud{cloudNum,7};

    cloudLoc = cloud{cloudNum,7};
    rectout = cloud{cloudNum,10};
    if (nnz(base(rectout(2):rectout(2)+rectout(4),rectout(1):rectout(1)+rectout(3)))==0)
        base(rectout(2):rectout(2)+rectout(4),rectout(1):rectout(1)+rectout(3)) = cloudMat;
    end

    cover_true = nnz(base)/w1/w2;

    figure(1)
    imshow(base,[])
    drawnow
end


% 将图像数据类型转换为 double 类型，以便进行计算
I_double = base;

% 获取图像数据的最大值和最小值
minI = min(I_double(:));
maxI = max(I_double(:));

% 进行归一化处理
I_normalized = (I_double - minI) / (maxI - minI);

% 显示原始图像和归一化后的图像
% subplot(1,2,1);
% imshow(I);
% title('原始图像');

% subplot(1,2,2);
imshow(I_normalized,[]);
title('归一化后的图像');


