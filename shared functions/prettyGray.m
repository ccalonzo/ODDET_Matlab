function Gray = prettyGray(Intensity,dark,bright)
% prettyGray rescales and saturates a singe image channel.
% Specify dark and bright saturation points as percentiles from 0 to 1,
% i.e. 99 percentile = 0.99.
%
% This function does NOT perform co-registration.
% based on PrettyRGB by CAlonzo 12Jul2012
% based on original algorithm by KQuinn
% CAlonzo 30Jul2013

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

%% Convert to double precision
Gray = double(Intensity);

%% Normalize and saturate stacks
ImR=sort(reshape(nonzeros(Gray),1,[]),'descend');  %arrange intensity values in descending order
maxInt=ImR(max(round((1-bright)*length(ImR)),1)); % pick up bright saturation point
minInt=ImR(round((1-dark)*length(ImR))); % and dark saturation point
Gray = (Gray-minInt)/(maxInt-minInt); % offset and normalize
Gray = Gray.*(Gray<1) + (Gray>=1); %saturate top
Gray = Gray.*(Gray>=0); %saturate bottom

return