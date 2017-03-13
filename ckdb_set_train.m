function ckdb_set_train(varargin)
% EXERCISE4   Part 4 of the VGG CNN practical

setup ;

% Load  dataset

 load('C:\Users\yjw\Desktop\論文實驗數據\set_all32.mat');
% load('data\ckdb_327.mat') ;

% H = fspecial('unsharp');
 
% for i=1:327
%     for j=1:20
% % %         set_all.data(:,:,j,i)=imfilter(set_all.data(:,:,j,i),H);
% %         %set_all.data(:,:,j,i)=histeq(set_all.data(:,:,j,i));
% %          set_all.data(:,:,j,i)= imcomplement(set_all.data(:,:,j,i));
%     set_all.data(:,:,j,i)=imresize(set_all.data(:,:,j,i),[32 32]);
%     end
% end
%% set train


 imdb.images.id=1:327;

 imdb.images.data=im2single(set_all.data);

 imdb.images.label=set_all.label;

 imdb.images.set(1:109)=1;         %2=test,1=train 
 imdb.images.set(110:218)=1;      
 imdb.images.set(219:327)=2;
 imdb.meta=set_all.meta;
 
 imdb.meta.fonts=1:7;
% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------

net = initializesetCNN() ;

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 50;
trainOpts.numEpochs = 40;
trainOpts.continue = true ;
trainOpts.useGpu = false ;
trainOpts.learningRate = 0.001 ;
trainOpts.expDir = 'data/set_3_result' ; 
trainOpts = vl_argparse(trainOpts, varargin);


imageMean = mean(imdb.images.data(:)) ;
imdb.images.data = imdb.images.data - imageMean ;


tic
% Call training function in MatConvNet
[net,info] = cnn_train(net, imdb, @getBatch, trainOpts) ;

% Move the CNN back to the CPU if it was trained on the GPU
if trainOpts.useGpu
  net = vl_simplenn_move(net, 'cpu') ;
end
toc
% Save the result for later use
net.layers(end) = [] ;
net.imageMean = imageMean ;
save('data/set_3_result/ckdb_3_result.mat', '-struct', 'net') ;

toc;


% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;

im = 256 * reshape(im, 32,32, 20, []) ; %input size

labels = imdb.images.label(1,batch) ;





