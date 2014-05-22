function [Moveable,Shift,Q] = CoRegisterNormcorr2(Fixed,Moveable)
% Image registration using Matlab's native normxcorr2 function in the Image
% Processing Toolbox.
% Each frame in Moveable is shifted to match with corresponding frame in Fixed.
% Fixed and Moveable should have the same stack height, but can have 
% arbitrary image sizes, even rectangular. Moveable can be smaller than Fixed.
% Array of row and column shifts for each frame is optionally returned as
% Shift. Peak correlation coefficients for each frame are returned as Q.
% 
% Requires: normxcorr2.m(Image processing toolbox), max2
%
% To do: crop FFT to nearest power of 2, but apply translation to full
% image.
%
% CAlonzo 12 Mar 2014


%% Determine stack size and image size
imageHeight = size(Fixed,1);
imageWidth = size(Fixed,2);
stackSize = size(Fixed,3);
Shift = zeros(stackSize,2);
Q = zeros(stackSize,1);

%% Registration slice-by-slice
for k = 1:stackSize

    % Use normxcorr2 to find appropriate shift
    [Q(k) Shift(k,:)] = max2(normxcorr2(Moveable(:,:,k),Fixed(:,:,k)));
    Shift(k,1) = Shift(k,1) - (imageHeight);
    Shift(k,2) = Shift(k,2) - (imageWidth);
            
    % shift rows 
    temp = zeros(imageHeight,imageWidth);
    if Shift(k,1) >= 0
        temp(1+Shift(k,1):imageHeight,:) = Moveable(1:imageHeight-Shift(k,1),:,k);        
    else
        temp(1:imageHeight+Shift(k,1),:) = Moveable(1-Shift(k,1):imageHeight,:,k);
    end % if Shift(k,1) > 0
	    
	% shift columns
    Moveable(:,:,k) = zeros(imageHeight,imageWidth);
    if Shift(k,2) >= 0  
        Moveable(:,1+Shift(k,2):imageWidth,k) = temp(:,1:imageWidth-Shift(k,2));
    else
        Moveable(:,1:imageWidth+Shift(k,2),k) = temp(:,1-Shift(k,2):imageWidth);
    end % if Shift(k,2) > 0
    
end % for k = 1:stackSize

return

function [MaxVal,yx] = max2(A)
% max2(A) returns the maximum value in a 2D array.
% (As opposed to max(A) which returns the column-wise maxima.)
%
% [MaxVal,xy] = max2(A) also returns the location of MaxVal as a  
% row vector, yx. yx(1) is the row, yx(2) is the column.
%
% CAlonzo 21May2012

[MaxVal,y] = max(A);
[MaxVal,x] = max(MaxVal);
yx = [y(x),x];

return