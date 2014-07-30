function PhasorMap = phasorMap(GImage,SImage,mapResolution)
% Constructs phasor disttribution map given the calculated phasor values,
% GImage and SImage, e.g. using FlimPhasorImages.m
%
% 20140730 CAlonzo

% Default mapResolution = 256
if nargin < 3, mapResolution = 256; end 

PhasorMap = hist3([SImage(:),GImage(:)],'Edges',...
    {1/mapResolution:1/mapResolution:1,1/mapResolution:1/mapResolution:1});

return