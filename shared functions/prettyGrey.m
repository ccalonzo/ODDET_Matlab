function Grey = prettyGrey(Intensity,dark,bright)
% prettyGrey rescales and saturates a singe image channel.
% Specify dark and bright saturation points as percentiles from 0 to 1,
% i.e. 99 percentile = 0.99.
%
% This function does NOT perform co-registration.
% based on PrettyRGB by CAlonzo 12Jul2012
% based on original algorithm by KQuinn
% CAlonzo 30Jul2013


%% Convert to single precision
Grey = single(Intensity);


%% Normalize and saturate stacks
ImR=sort(reshape(nonzeros(Grey),1,[]),'descend');  %arrange intensity values in descending order
maxInt=ImR(max(round((1-bright)*length(ImR)),1)); % pick up bright saturation point
minInt=ImR(round((1-dark)*length(ImR))); % and dark saturation point
Grey = (Grey-minInt)/(maxInt-minInt); % offset and normalize
Grey = Grey.*(Grey<1) + (Grey>=1); %saturate top
Grey = Grey.*(Grey>=0); %saturate bottom

return