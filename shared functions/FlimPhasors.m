function [g,s] = FlimPhasors(DecayTrace,timeInterval,angularFreq)
% Calculate the normalized discrete sine transform of DecayTrace
% s = sum(DecayTrace.*sin(angularFreq*TimeAxis)) / sum(DecayTrace);
% 
% DecayTrace is the intensity decay over uniform time intervals.
% timeInterval is the time step between samples of DecayTrace.
% angularFreq is 2*pi()*repetition rate of excitation laser
%
% CAlonzo 13Jun2012

%% Crop out left side of trace
[peak,p0] = max(DecayTrace);
DecayTrace=DecayTrace(p0:end);
peak;

%% Construct time axis
TimeAxis = (0:size(DecayTrace,1)-1)'*timeInterval;


%% Consine transform evaluated at angularFreq
g = sum(DecayTrace.*cos(angularFreq*TimeAxis)) / sum(DecayTrace);
s = sum(DecayTrace.*sin(angularFreq*TimeAxis)) / sum(DecayTrace);

return