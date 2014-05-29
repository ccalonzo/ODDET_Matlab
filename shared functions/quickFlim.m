function [Flimage,TauM,Int755,A1,A2,Tau1,Tau2] = quickFlim(fieldCode,uplim,botlim)
% Quickly show FLIM results for a single image field using data
% exported from SPCImage.
% 20140529 CAlonzo
% No need to specify laser power. Optionally specify upper limit and bottom
% limit for TauM. Default LUT is reversed jet.
% Return Flimage.


%% If not specified, don't normalize intenisty by laser power
if nargin < 3, botlim = min(min(Flim)); end
if nargin < 2, uplim = max(max(Flim)); end

%% Load data from files
[Int755,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults([fieldCode,'_ex755']);

%% Create pretty images
Flimage = prettyFlim(TauM,Int755,'none',flipud(jet(64)),uplim,botlim);
figure('name',['FLIM: ',fieldCode]); image(Flimage); axis image off;

return

