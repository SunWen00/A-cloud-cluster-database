
clc
clear
close all



filepath = 'D:\ql2222\0603-2129quan\hongwai-kebosike0527\TL-HLBE_QL2_002129_000000000_0_I_20230603222747_100001_dataFiled_8\解帧后\去背景后filter\ProcessedImages\';

filelist = dir(strcat(filepath,'*.png'));
for i = 1:length(filelist)
    database(:,:,i) = double(imread([filepath,filelist(i).name]));
end

k=1;

for t=1:size(database,3)
    t
    grayImage = database(:,:,t);
    bwImage = grayImage;

    bwImage = imfill(bwImage,"hole");

    SE = strel('disk',1);

    bwImage = imclose(bwImage,SE);
    bwImage = imopen(bwImage,SE);

    bwImage = imerode(bwImage,SE);

    [L,num] = bwlabel(bwImage);
    areas=regionprops(L,'BoundingBox');
    status=regionprops(L,'BoundingBox');
    centroid = regionprops(L,'Centroid');
    figure(1)
    imshow(grayImage);hold on;
    for i=1:num
        rectangle('position',status(i).BoundingBox,'edgecolor','r');
        text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r')
    end
    hold off;
    drawnow;

    for i = 1:num
        [L,~] = bwlabel(bwImage);
        L(L~=i) = 0;
        figure(2)
        imshow(L,[])
        drawnow

        [raw,col] = find(L==i);

        if length(raw)<=2
            i=i+1;
        else
            rect = [min(col) min(raw) (max(col)-min(col)) (max(raw)-min(raw))];
            [I,rectout]= imcrop(bwImage,rect);
            [Y,rectoutY]= imcrop(grayImage,rect);
            figure(3)
            imshow(I,[])
            drawnow
            cloud{k,1}=I;                                  %% 腐蚀膨胀后的矩阵
            cloud{k,2}=length((find(I~=0)));               %% 非0的个数
            cloud{k,3}=length((find(I~=0)))/numel(I);      %  切割矩阵云的覆盖率
            cloud{k,4}=rectout;                            %% 切割的区域
            cloud{k,5}=[t,i,num];                          %% 第t张图像，第i个切割区域，一共切割了num个区域
            cloud{k,6}=imresize(I,1/50*19,'nearest');      %% 提升分辨率为50m

            cloud{k,7}=Y;                                  %%原始矩阵
            cloud{k,8}=length((find(Y~=0)));
            cloud{k,9}=length((find(Y~=0)))/numel(Y);
            cloud{k,10}=rectoutY;
            cloud{k,11}=[t,i,num];
            cloud{k,12}=imresize(Y,1/50*19,'nearest');
            k=k+1;
            % save([num2str(i),'.mat'],'I',"-mat")
            % roi_img_filename = 'extracted_roi.jpg';
            % imwrite(I, roi_img_filename);
            % disp(['ROI 保存为 ', roi_img_filename]);
        end
    end
end
disp(num);
areas=regionprops(L,'BoundingBox');
status=regionprops(L,'BoundingBox');
centroid = regionprops(L,'Centroid');
imshow(grayImage);hold on;
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r')
end
