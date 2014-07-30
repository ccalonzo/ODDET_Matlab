function [Fluorescence,timeInterval]=loadFlimRawData(filename,timeRes,imageRes)
% FlimData extracts the fluorescence decay matrix from an SPCM .asc file.
%
% Input: 
% filename is the .asc file containing raw SPCM data.
%
% Output: 
% Fluorescence is the fluorescence decay matrix in a 3D matrix: (space, space, time).
% timeInterval is the uniform time interval between data points in the
% decay matrix.
% 
% CAlonzo 14Jun2012
%
% CAlonzo 22Oct2012
% Use permute(F,[3,2,1]) instead of shiftdim(F,1). Makes spatial axes consistent with
% direct image from frame grabbers.
%
%CAlonzo 13Dec2012
%Set a fixed time-interval in the algorithm; .asc file need not contain time data. 

timeInterval = 12.508416/timeRes;

rawData = importdata(char(filename), ' ',10);
Fluorescence = reshape(rawData.data(:,1),timeRes,imageRes,imageRes);
Fluorescence = permute(Fluorescence,[3,2,1]);




return