tic
l=1;
p = genpath('E:\Emotion');  
%% 找情緒標記的txt檔的資料夾路徑
k=0;
length_p = size(p,2);   
path = {};    
temp = [];
index = 1;
for i = 1:length_p  
    if p(i) ~= ';'
        temp = [temp p(i)];
    else
        temp = [temp '\'];  
        path{index} = temp;
        index = index+1;
        temp = [];
    end
end 
%% 找有情緒標記的圖片路徑
file_num = length(path);      
for i = 1:file_num
    file_path =  path{i}; 
    txt_path_list = dir(strcat(file_path,'*.txt'));
    txt_num = length(txt_path_list); 
    if txt_num > 0
        k=k+1;
        for j = 1:txt_num
            txt_name = txt_path_list(j).name;    
            txt =  load(strcat(file_path,txt_name));
            txtpath{k}=strcat(file_path,txt_name);
            %fprintf('%d %d %s\n',i,j,strcat(file_path,txt_name));
            picpath{k}=strrep(file_path,'E:\Emotion','E:\cohn-kanade-images'); %字串替換
        end
        
    end
end
%% 建立情緒標記圖片資料庫
for i=1:length(picpath)
file_path = [picpath{i} '*.png'];
file_name = dir(file_path);
len=length(file_name); 
for j=1:len
    impath=strcat(picpath{i},file_name(j).name);
    temp_image2 = imread(impath);      %測試是否為彩色
    if numel(size(temp_image2))>2
        temp_image = rgb2gray(temp_image2);
    else
        temp_image=temp_image2;
    end
   %% 切臉部
% faceDetector = vision.CascadeObjectDetector;  % 人臉辨識器
%             fboxes = step(faceDetector, temp_image);  % 找出人臉
%             faceROI = insertObjectAnnotation(temp_image, 'rectangle', fboxes, 'Face');
%             [fboxesx, fboxesy] = size(fboxes);
%             farea = 0;
%             maxarea = 0;
%             if fboxesx == 0
%                 fprintf(fid,'%s\n',input_dir(n).name);
%                 continue;
%             elseif fboxesx == 1
%                 left = fboxes(1);  % 左上角的 x 座標
%                 top = fboxes(2) - 10;   % 左上角的 y 座標
%                 width = fboxes(3);  % 區域的寬
%                 height = fboxes(4) + 30;  % 區域的高 +30:怕切掉下嘴唇部分
%             else
%                 for l = fboxesx*2+1:fboxesx*3
%                     farea = fboxes(l)*fboxes(l + fboxesx);
%                     if farea > maxarea
%                         maxarea = farea;
%                         left = fboxes(l - 2*fboxesx);
%                         top = fboxes(l - fboxesx) - 10;
%                         width = fboxes(l);
%                         height = fboxes(l + fboxesx) + 30;
%                     end
%                 end
%             end
faceDetector = vision.CascadeObjectDetector;  % 人臉辨識器
            fboxes = step(faceDetector, temp_image);  % 找出人臉
            faceROI = insertObjectAnnotation(temp_image, 'rectangle', fboxes, 'Face');
            [fboxesx, fboxesy] = size(fboxes);
            farea = 0;
            maxarea = 0;
            a=load(txtpath{i});%找7的表情 範圍修正
            if fboxesx == 0
                fprintf(fid,'%s\n',input_dir(n).name);
                continue;
            elseif fboxesx == 1
                left = fboxes(1)+40;  % 左上角的 x 座標
%                 if a==7
                top = fboxes(2)+ 60;
%                 else
%                 top = fboxes(2)+ 80; 
%                 end% 左上角的 y 座標
                width = fboxes(3)-80;  % 區域的寬
                if a== 7
                    height = fboxes(4)-40;
                else
                height = fboxes(4) -90;  % 區域的高 +30:怕切掉下嘴唇部分
                end
            else
                for l = fboxesx*2+1:fboxesx*3
                    farea = fboxes(l)*fboxes(l + fboxesx);
                    if farea > maxarea
                        maxarea = farea;
                        left = fboxes(l - 2*fboxesx)+40;
                        top = fboxes(l - fboxesx) +60;
                        width = fboxes(l)-80;
                        if a== 7
                    height = fboxes(l + fboxesx)-40;
                       else
                height = fboxes(l + fboxesx) -90;  % 區域的高 +30:怕切掉下嘴唇部分
                       end
                        
                    end
                end
            end
           % opticFlow = opticalFlowLK('NoiseThreshold',0.009);
            temp_image = imcrop(temp_image, [left top width height]);
            figure;
            imshow(temp_image);
              figure;
            imshow(im2bw(temp_image));

             H = fspecial('gaussian',[3 3],0.5);
            I= imfilter(temp_image,H,'replicate');
            figure;
            imshow(I);
               figure;
            imshow(im2bw(I));
%            temp_image = edge(temp_image);
        
%             imshow(temp_image);
%            temp_image_r=imrotate(temp_image, 15);%旋轉
%             temp_image_r2=imrotate(temp_image, -15);%旋轉
%             temp_image_b1=imadjust(temp_image,[ ],[ ],0.5);
%             temp_image_b2=imadjust(temp_image,[ ],[ ],0.8);
%              temp_image_b3=imadjust(temp_image,[ ],[ ],1.5);%明亮
%            temp_image_f =flipdim(temp_image,2); %鏡像
%                figure;
%                imshow(temp_image);
%             temp_image=imresize(temp_image,[32 32]);
%             temp_image_r2=imresize(temp_image_r2,[32 32]);
%             temp_image_r=imresize(temp_image_r,[32 32]);
%             temp_image_b1=imresize(temp_image_b1,[32 32]);
%             temp_image_b2=imresize(temp_image_b2,[32 32]);
%            temp_image_b3=imresize(temp_image_b3,[32 32]);
%            temp_image_f=imresize(temp_image_f,[32 32]);
  %% 結構
   
   ckdb_ROI.data{i,j}=temp_image;
%     ckdb_ROI_r.data{i,j}=temp_image_r; 
%     ckdb_ROI_r2.data{i,j}=temp_image_r2; 
%      ckdb_ROI_b1.data{i,j}=temp_image_b2; 
%      ckdb_ROI_b2.data{i,j}=temp_image_b2; 
%      ckdb_ROI_b3.data{i,j}=temp_image_b3; 
%      ckdb_ROI_f.data{i,j}=temp_image_f; 
    ckdb_ROI.label{i}=load(txtpath{i});
 
  
  
end
end
% for i=1:327
%   for  j=1:20
%     ckdb_ROImix.data{i,j}=ckdb_ROI.data{i,j};
% end
% end
% k=328;
% for i=1:327
%   for  j=1:20
%     ckdb_ROImix.data{k,j}=ckdb_ROI_b1.data{i,j};
%   end
% k=k+1;
% end
% for i=1:327
%   for  j=1:20
%     ckdb_ROImix.data{k,j}=ckdb_ROI_b2.data{i,j};
%   end
% k=k+1;
% end
% for i=1:327
%   for  j=1:20
%     ckdb_ROImix.data{k,j}=ckdb_ROI_b3.data{i,j};
%   end
% k=k+1;
% end
% for i=1:327
%   for  j=1:20
%     ckdb_ROImix.data{k,j}=ckdb_ROI_r.data{i,j};
%   end
% k=k+1;
% end
% for i=1:327
%   for  j=1:20
%     ckdb_ROImix.data{k,j}=ckdb_ROI_r2.data{i,j};
%   end
% k=k+1;
% end
% for i=1:327
%   for  j=1:20
%     ckdb_ROImix.data{k,j}=ckdb_ROI_f.data{i,j};
%   end
% k=k+1;
% end


% 
%  imdb = load('charsdb.mat') ;
%  ckdb_ROImix.meta.classes='1234567';
%    ckdb_ROImix.data=ckdb_ROImix.data';
%   ckdb_ROImix.data=reshape(ckdb_ROImix.data,1,2289);
%   ckdb_ROImix.data=cell2mat(ckdb_ROImix.data);
%  ckdb_ROImix.data=reshape(ckdb_ROImix.data,32,32,20,2289);

toc