function [GImage,SImage] = FlimPhasorImages(DecayMatrix,timeInterval,angularFreq)

% default to laser rep rate in GHz
if nargin < 3, angularFreq = 2*pi*80e-3; end

% extract imageRes from DecayMatrix
imageRes = size(DecayMatrix,1);

% Convert DecayMatrix into a cell array of column vectors
DecayMatrixCell = num2cell(shiftdim(DecayMatrix,2),1);
DecayMatrixCell = shiftdim(DecayMatrixCell,1);

% Construct cell arrays for timeInterval and angularFreq
timeStepCell = num2cell(ones(imageRes)*timeInterval);
angularFreqCell = num2cell(ones(imageRes)*angularFreq);

% Calculate phasor images
[GImage,SImage] = cellfun(@FlimPhasors,DecayMatrixCell,timeStepCell,angularFreqCell);

return