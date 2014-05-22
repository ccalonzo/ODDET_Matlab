function [ImageList,Header] = readListFile(ImageListFile)
% Reads the imaging parameters listed in a tab delimited text file.
% ImageListFile is the complete filename, e.g. 'imageList_today.txt'
% ImageList is a cell array: 
%       column 1 = group label, text string
%       column 2 = time point, numeric
%       column 3 = slide, numeric
%       column 4 = field, numeric 
%       column 5 = z Position, numeric
%       column 6 = gainCh1, numeric
%       column 7 = gainCh2, numeric
%       column 8 = gainCh3, numeric
%       column 9 = laser power 755nm, numeric
%       column 10 = laser power 860nm, numeric
%       column 11 = laser power 800nm, numeric
%       column 12 = laser power FLIM, numeric

% 02Apr2013 CAlonzo
% 27Jun2013 CAlonzo
% modified for new list file format, generalized to arbitrary number of
% rows and columns.


%% Open list file and extract imaging paramaters
fid=fopen(ImageListFile);
ImageListStruct = importdata(ImageListFile,'\t'); %reads tsv datafile with 1 header line
Columns = size(ImageListStruct.textdata,2);
Rows = size(ImageListStruct.textdata,1)-1;
ImageList = cell(Rows,Columns); %mix of text and numbers placed in a cell array
% ImageList = cell(size(ImageListStruct.textdata,1)-1,size(ImageListStruct.textdata,2)); %mix of text and numbers placed in a cell array
% ImageList = cell(size(ImageListStruct.textdata,1)-1,12); %mix of text and numbers placed in a cell array
ImageList(:,1) = ImageListStruct.textdata(2:end,1); %read first text column as group labels
ImageList(:,2:end) = num2cell(ImageListStruct.data(:,1:Columns-1)); %read all data columns
Header = ImageListStruct.textdata(1,:);
fclose('all');
clear ImageListFile ImageListStruct fid ans;

return
