function [redox2,avgi2] = prettyRedox(redox,avgi,filename,lut,uplim,botlim,bright,dark)
% Creates pretty redox images by modulating with total fluorescence. 
% Algorithm is based on Kyle Quinn's pretty redox code.  Top and Bottom 1%
% of pixels are saturated for a prettier image.  OUTPUT IS NOT INTENDED FOR 
% QUANTITATIVE USE. 
% 
% Output:
% redox2 = modulated redox map 
% avgi2 = top+bottom saturated intensity image.
% Redox images are also saved as a 24-bit RGB (multi-page) tiff.  If
% 'filename.tif' already exists, filename is iterated, i.e. 'filename1'.
% If filename is specified as 'none', image is not saved.
% 
% Input:
% redox = redox map 
% avgi = modulating mask for redox, i.e. total fluorescence intensity image
% Last three inputs are optional:
% lut is the color-map/look-up-table for converting redox ratio to color,
% while uplim and botlim are the upper and bottom limits of the redox index
% for plotting.  Default values are lut = jet(64); uplim = 1; botlim = 0;
%
% CAlonzo 29May2012
%
% modified 28Jun2012
% - Renamed variables and some operational corrections
% modified 12Jun2012
% - If filename = 'none', image is not saved.
% - Output prettified fluorescence intensity image too.
% - Input total intensity image (avgi) rather than 2 separate channels
%
% 17Oct2012 CAlonzo
% Improved stack handling. redox2 is now a 4-D array (R,G,B,slice); but at
% the cost of much larger memory footprint.  Consider creating a 
% save-to-file-only version of prettyRedox.
%
% 20140523 CAlonzo
% Default is to not save image to file.
% Automatically switch if specified scale limits are reversed

%% Set default color map and corresponding normalization and offset
if nargin < 8, bright = 0.99; end
if nargin < 7, dark = 0.01; end
if nargin < 6, botlim=min(redox(:)); end
if nargin < 5, uplim=max(redox(:)); end
if nargin < 4, lut = jet(64); end
if nargin < 3, filename = 'none'; end
bitScale = size(lut,1)-1;

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

%% Take total intensity and rescale across 1st to 99th percentile.
ImR=sort(reshape(nonzeros(avgi),1,[]),'descend'); 
maxFlr=ImR(round((1-bright)*length(ImR))); %pick up 99th and first percentile 
minFlr=ImR(round((1-dark)*length(ImR))); % lowest values
avgi2=single((avgi-minFlr)/(maxFlr-minFlr)); %setting 1% to 0 and 99% to 1
avgi2=avgi2.*(avgi2<1) + (avgi2>=1); %saturate top 1%
avgi2=avgi2.*(avgi2>=0); %saturate bottom 1%

%% Rescale redox map to bit scale
redox=(redox-botlim)/(uplim-botlim);
redox=redox.*(redox<1) + (redox>=1);
redox=round(bitScale*(redox.*(redox>=0)))+1;
    
%% Apply color map, convert to RGB, and modulate by total intensity
imageSize=size(avgi,1);
stackSize=size(avgi,3);
redox2 = single(ones(imageSize,imageSize,3,stackSize));
for istack=1:stackSize    
    redox2(:,:,:,istack) = ind2rgb(redox(:,:,istack),lut);
    for k = 1:3
        redox2(:,:,k,istack) = redox2(:,:,k,istack).*avgi2(:,:,istack);
    end %for k = 1:3
    
    % Save redox stack as multipage tiff
    if ~strcmpi(filename,'none')
        imwrite(redox2(:,:,:,istack),[filename,'.tif'],'Compression','none','WriteMode','append');
    end %if ~strcmpi(filename,'none')
  
end %for istack=1:stack

    if ~strcmpi(filename,'none')
        disp([filename,'.tif saved.']); 
    end %if ~strcmpi(filename,'none')

return