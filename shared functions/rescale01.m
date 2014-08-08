function NewImage = rescale01(OldImage,offset)
% Rescale image from 0 to 1. If offset can be specified (e.g. 0), otherwise
% offset is equal to min(OldImage(:)).

if nargin < 2, offset = min(OldImage(:)); end

NewImage = (OldImage-offset)/(max(OldImage(:)-offset));

return