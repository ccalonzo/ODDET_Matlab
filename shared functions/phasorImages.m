function [GImage,SImage] = phasorImages(DecayMatrix,timeInterval,angularFreq)
% requires calcPhasors.m
% Calculate phasor pairs (g,s) for entire image, given the raw decay matrix. 
% Unless otherwise specified, timeInterval and angularFreq are calculated 
% assuming a laser rep. rate of 80 MHz and pulse interval = 12.508416 ns.
% 20140730 CAlonzo

if nargin < 3, angularFreq = 2*pi*80e-3; end
if nargin < 2, timeInterval = 12.508416/size(DecayMatrix,3); end

% extract imageRes from DecayMatrix
imageRes = size(DecayMatrix,1);

% Convert DecayMatrix into a cell array of column vectors
DecayMatrixCell = num2cell(shiftdim(DecayMatrix,2),1);
DecayMatrixCell = shiftdim(DecayMatrixCell,1);

% Construct cell arrays for timeInterval and angularFreq
timeStepCell = num2cell(ones(imageRes)*timeInterval);
angularFreqCell = num2cell(ones(imageRes)*angularFreq);

% Calculate phasor images
[GImage,SImage] = cellfun(@calcPhasors,DecayMatrixCell,timeStepCell,angularFreqCell);

return