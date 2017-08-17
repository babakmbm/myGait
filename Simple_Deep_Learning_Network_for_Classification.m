websave('\networks\imagenet-caffe-alex.mat','http://www.vlfeat.org/matconvnet/models/beta16/imagenet-caffe-alex.mat');
% Load MatConvNet network into a SeriesNetwork
convnet = helperImportMatConvNet(cnnFullMatFile);

% View the CNN architecture
convnet.Layers

% Set up image data
dataFolder = ' \data\PetImages';
categories = {'Cat', 'Dog'};
imds = imageDatastore(fullfile(dataFolder, categories), 'LabelSource', 'foldernames');
