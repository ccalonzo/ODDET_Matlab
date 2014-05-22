function [ImageStack,stackSize] = loadStack(series,subdirectory)
% Load a series of images as a single stack given a full series name,
% i.e. up to the point that the name is unique to the stack series.
% 31July2013 CAlonzo
% optional input = subdirectory
% 04Sep2013 CAlonzo
% optional output = stackSize

if nargin < 2
    subdirectory = '.';
end
    
FileList = dir([subdirectory,'/',series,'*']);
ImageStack = imread([subdirectory,'/',FileList(1).name]);

stackSize = size(FileList,1);
imageSize = size(ImageStack,1);

ImageStack = cat(3,ImageStack,zeros(imageSize,imageSize,stackSize-1));

for m = 2:stackSize
    ImageStack(:,:,m) = imread([subdirectory,'/',FileList(m).name]);
end

return

    
