setup ;
clear all;

    net = load('C:\Users\yjw\Downloads\practical-cnn-2015a\practical-cnn-2015a\data\setall_adjust_2_result\adjust_2_result.mat') ;
%  load('data\ckdb_327.mat') ;
load('C:\Users\yjw\Desktop\論文實驗數據\set_all32.mat') ;
load('C:\Users\yjw\Desktop\論文實驗數據\setall.mat') ;
% for i=1:327
%     for j=1:20
%         
%         set_all.data(:,:,j,i)=histeq(set_all.data(:,:,j,i));
%  
%     end
% end
imdb.images.id=1:327;
 imdb.images.label=set_all.label;

imdb.images.data=im2single(set_all.data);
imdb.meta.classes=set_all.meta.classes;

a=0;
e=0;

% set(1:257)=1;
% set(258:297)=2;
% set(298:327)=1;
l=0;
% set(1:109)=1;
% set(110:218)=2;
% set(219:327)=1;
for j=110:218

 
     
im=imdb.images.data(:,:,:,j);

im = 256 * (im - net.imageMean) ;


res = vl_simplenn(net, im) ;
% if set(j)==1
%   optical_exp_set3_train_score(:,j)=squeeze(res(end).x);
%  optical_exp_set3_test_score(:,j)=squeeze(res(end).x);
%  optica1_set1_train_score(:,j)=squeeze(res(8).x);
% end
  
for i=1:size(res(end).x,2)

  [score(i),pred(i)] = max(squeeze(res(end).x(1,i,:))) ;
  
end


if pred(i) == imdb.images.label(j)
    a=a+1;
else
    e=e+1;
%     s=fprintf('測試資料id: %d  label為:  %d  辨識結果: %s\n ', set_all.id(j), imdb.images.label(j),imdb.meta.classes(pred));
    str=sprintf('test data id: %d  label:  %d  reslut: %s\n ', set_all.id(j), imdb.images.label(j),imdb.meta.classes(pred));
%    figure('name',str);
%     imshow(setall.data{j,20});
   title(str);
   error_im{e}=setall.data{j,20}; 
   error_str{e}=str;

end
%fprintf(' label為:  %d  辨識結果: %s\n ', imdb.images.label(j),imdb.meta.classes(pred));
%  fprintf('測試資料id: %d  label為:  %d  辨識結果: %s\n ', set_all.id(j), imdb.images.label(j),imdb.meta.classes(pred));
% fprintf(' result: %s\n',imdb.meta.classes(pred)) ;
 g1(j)=set_all.label(j);
 g2(j)=pred;
end 
% suma=a-1;
% sume=e-1;
 
 g1(find(g1==0))=[];
g2(find(g2==0))=[];
[C,order] = confusionmat(g1,single(g2'));
%  for i=1:15
% subplot(5,3,i)
% imshow(error_im{i});
% title(error_str{i});
% end
% optical_set3_train_score=optical_set3_score(:,1:218);
% optical_set3_test_score=optical_set3_score(:,219:327);
% save('C:\Users\yjw\Desktop\論文實驗數據\ckdb_set_score\ckdb_set2_train_score.mat') ;
%  ckdb_exp_set3_train_score=ckdb_exp_set3_train_score(:,110:end);