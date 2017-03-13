tic
% load('ckdbframe6_300');
load('C:\Users\yjw\Desktop\ckdb_ROI');
load('C:\Users\yjw\Desktop\論文實驗數據\set_all32.mat');
%% 建立情緒標記圖片資料庫
for i=1:327

for j=1:20


     if(j+1<=20)
% Iref=  histeq(ckdb_ROI.data{i,j});
% 
%  Iinput = histeq(ckdb_ROI.data{i,j+1});
 Iref=  ckdb_ROI.data{i,j};

 Iinput =ckdb_ROI.data{i,j+1};

else
    break
    end
       
        if size(Iref, 3) == 3
            Irefg = rgb2gray(Iref);
            Iinputg = rgb2gray(Iinput);
        else
                Irefg = Iref;
                Iinputg = Iinput;
        end
        opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);

converter = vision.ImageDataTypeConverter;



opticalFlow.OutputValue = 'Horizontal and vertical components in complex form'; 

opticalFlow.ReferenceFrameSource = 'Input port'; 

if 1 

opticalFlow.Method = 'Lucas-Kanade';

opticalFlow.NoiseReductionThreshold = 0.001; 

else

opticalFlow.Method = 'Horn-Schunck';

opticalFlow.Smoothness = 0.05; 

end
     
     %  imadjust(temp_image,[ ],[ ],1.5);%明亮
        Iinputg_c = step(converter, Iinputg);
        Irefg_c = step(converter, Irefg);
        of = step(opticalFlow, Iinputg_c, Irefg_c);
% change{i,j}=mean(sum(abs(of))); %變化輛
%         ofH = real(of);
         ofV = abs(of);
%          imshow(ofV);

        ofV=abs(imresize(ofV,[96 96]));
%         imshow(ofV);
%         ofH=imresize(ofH,[32 32]);
%       %% b1  
%         Iinputg_b = step(converter, imadjust(Iinputg,[ ],[ ],0.5));
%         Irefg_b = step(converter, imadjust(Irefg,[ ],[ ],0.5));
%         of_b = step(opticalFlow, Iinputg_b, Irefg_b);     
%         ofV_b = abs(of_b);
%         ofV_b=imresize(ofV_b,[32 32]);
%         %% b2
%          Iinputg_b2 = step(converter, imadjust(Iinputg,[ ],[ ],0.8));
%         Irefg_b2 = step(converter, imadjust(Irefg,[ ],[ ],0.8));
%         of_b2 = step(opticalFlow, Iinputg_b2, Irefg_b2);     
%         ofV_b2 = abs(of_b2);
%         ofV_b2=imresize(ofV_b2,[32 32]);
%         %% b3
%          Iinputg_b3 = step(converter, imadjust(Iinputg,[ ],[ ],1.2));
%         Irefg_b3 = step(converter, imadjust(Irefg,[ ],[ ],1.2));
%         of_b3 = step(opticalFlow, Iinputg_b3, Irefg_b3);     
%         ofV_b3 = abs(of_b3);
%         ofV_b3=imresize(ofV_b3,[32 32]);
        %% 
%        optical_ROIb.data{i,j}=ofV_b;
%        optical_ROIb2.data{i,j}=ofV_b2;
%        optical_ROIb3.data{i,j}=ofV_b3;
       optical_ROIV.data{i,j}= ofV;
         end
      
      
       
        
 
       
       


end

for i=1:327
    for j=1:19
        set_optical.data{i,j}=optical_ROIV.data{set_all.id(i),j};
    end
end
set_optical.data=set_optical.data';
set_optical.data=reshape(set_optical.data,1,6213);
set_optical.data=cell2mat(set_optical.data);
set_optical.data=reshape(set_optical.data,96,96,19,327);
set_optical.id=set_all.id;
set_optical.label=set_all.label;
set_optical.meta=set_all.meta;
% for i=1:327
%     for j=1:19
%         optcial_mix.data{i,j}=optical_ROIV.data{i,j};
%     end
% end
% k=328;
% for i=1:327
%     for j=1:19
%         optcial_mix.data{k,j}=optical_ROIb.data{i,j};
%     end
%     k=k+1;
% end
% for i=1:327
%     for j=1:19
%         optcial_mix.data{k,j}=optical_ROIb2.data{i,j};
%     end
%     k=k+1;
% end
% for i=1:327
%     for j=1:19
%         optcial_mix.data{k,j}=optical_ROIb3.data{i,j};
%     end
%     k=k+1;
% end
%  load('ckdb64.mat') ;
%  
%    optical_ROI32.data=optical_ROI32.data';
% 
%   optical_ROI32.data=reshape(optical_ROI32.data,1,6213);
%   optical_ROI32.data=cell2mat(optical_ROI32.data);
%  optical_ROI32.data=reshape(optical_ROI32.data,32,32,19,327);
%  optical_ROI32.label=single(cell2mat(optical_ROI32.label));
%  optical_ROI32.meta=ckdb64.meta;
toc;