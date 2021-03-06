function [Flimage,Intensity2] = prettyFlim(Flim,Intensity,filename,lut,uplim,botlim,bright,dark)
% Creates pretty flim images by modulating with total fluorescence intensity.
% This is based on Kyle Quinn's pretty redox code.
%
% Flim is a stack of fluorescence lifetime maps.
% Intensity is the corresponding stack of total fluorescence intensity.
% filename species the filename to save the pretty image to.  If 
% 'filename.tif' already exists, filename is iterated, i.e. 'filename1'.
% Flim images are saved as a 24-bit RGB (multi-page) tiff.  
% 
% Last three inputs are optional:
% lut is the color-map/look-up-table for converting flim to color.
% If lut is not specified, default is lut = flipud(jet(64)).
% uplim and botlim specify the offset and normalization of the colorscale.
% Default values are the maximum and minimum values of Flim, respectively.
%
% CAlonzo 01June2012
%
% CAlonzo 26Nov2012
% additional options:   bright = bright saturation level (0-1),
%                       dark = dark saturation level (0-1)
%
%CAlonzo 12Sep2013
% FIXED: bright is upper brightness limit, e.g. upper 1% bright = 0.99;
%        dark is lower brightness limit, e.g. lower 1% dark = 0.01;
%
%20140523 CAlonzo
% New deafult LUT = flipud(jet(64));
% By default, image is not saved to file.

%% Set default color map, offset and normalization
if nargin < 8, bright = 0.99; end
if nargin < 7, dark = 0.01; end
if nargin < 6, botlim = min(min(Flim)); end
if nargin < 5, uplim = max(max(Flim)); end
if nargin < 4, lut = flipud(jet(64)); end
if nargin < 3, filename = 'none'; end

%% Correct reversed scales
if uplim < botlim
    temp = botlim;
    botlim = uplim;
    uplim = temp;
end

if bright < dark
    temp = dark;
    dark = bright;
    bright = temp;
end

%% Iterate filename if file already exists
k = 0;
base = filename;
while exist([filename,'.tif'],'file') == 2
  k = k+1;
  filename = [base,num2str(k)];
end %exist([filename,'.tif']) == 2  

%% Take total intensity and rescale across 2nd to 99th percentile.
ImR=sort(reshape(nonzeros(Intensity),1,[]),'descend');
maxFlr=ImR(round((1-bright)*length(ImR))); %pick up 99th and first percentile 
minFlr=ImR(round((1-dark)*length(ImR))); % lowest values
Intensity2=(Intensity-minFlr)/(maxFlr-minFlr); %setting bottom limit to zero and top limit to 1
Intensity2=Intensity2.*(Intensity2<1) + (Intensity2>=1); %saturate top 1%
Intensity2=Intensity2.*(Intensity2>=0); %saturate bottom 1%

%% Rescale flim map to bit-depth of lut
bitScale = size(lut,1)-1;
Flim=(Flim-botlim)/(uplim-botlim);
Flim=Flim.*(Flim<1) + (Flim>=1); %saturate pixels > uplim
Flim=round(bitScale*(Flim.*(Flim>=0)))+1; %remove negative values and convert to integer
    
%% Apply color map, convert to RGB, and modulate by total intensity
for istack=1:size(Flim,3)    
    Flimage = ind2rgb(Flim(:,:,istack),lut);
    for k = 1:3
        Flimage(:,:,k) = Flimage(:,:,k).*Intensity2(:,:,istack);
    end %for k = 1:3
    
    % Save redox stack as multipage tiff
    if ~strcmpi(filename,'none')
        imwrite(Flimage,[filename,'.tif'],'Compression','none','WriteMode','append');
    end %if ~strcmpi(filename,'none')
  
end %for istack=1:size(Flimage,3)  

if ~strcmpi(filename,'none')
   disp([filename,'.tif saved.']);
end %if ~strcmpi(filename,'none')
   

return