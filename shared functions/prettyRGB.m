function RGB = prettyRGB(RedStack,GreenStack,BlueStack,dark,bright)
% prettyRGB combines 3 grey-scale image stacks into an RGB 4-D array.
% Specify dark and bright saturation points as percentiles from 0 to 1,
% i.e. 99 percentile = 0.99.
%
% This function does NOT perform co-registration.
% CAlonzo 12Jul2012

%12Jun2014 CAlonzo 
%Default bright and dark values (0.99 and 0.01, respectively).

if nargin < 5, bright = 0.99; end;
if nargin < 4, dark = 0.01; end;

%% Correct reversed scales
if bright < dark
    temp = dark;
    dark = bright;
    bright = temp;
end

%% Convert to single precision
RedStack = single(RedStack);
GreenStack = single(GreenStack);
BlueStack = single(BlueStack);

%% Combine stacks into 4-D array
RGB = cat(4,RedStack,GreenStack,BlueStack); % Contatenate stacks to 4-D.
RGB = permute(RGB,[1 2 4 3]); % Swap 3rd and 4th dimensions

%% Normalize and saturate stacks
ImR=sort(reshape(nonzeros(RGB),1,[]),'descend');  %arrange intensity values in descending order
maxInt=ImR(max(round((1-bright)*length(ImR)),1)); % pick up bright saturation point
minInt=ImR(round((1-dark)*length(ImR))); % and dark saturation point
RGB = (RGB-minInt)/(maxInt-minInt); % offset and normalize
RGB = RGB.*(RGB<1) + (RGB>=1); %saturate top
RGB = RGB.*(RGB>=0); %saturate bottom

return