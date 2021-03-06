function [Flimage,TauM,Intensity,A1,A2,Tau1,Tau2] = quickFlim(fieldCode,exWave,uplim,botlim)
% Quickly show FLIM results for a single image field using data
% exported from SPCImage.
% 20140529 CAlonzo
% No need to specify laser power. Optionally specify upper limit and bottom
% limit for TauM. Default LUT is reversed jet.
% Return Flimage.
% 20140619 CAlonzo
% Option for specifying excitation wavelength, defaults to 755.

%% If not specified, don't normalize intenisty by laser power
if nargin < 2, exWave = 755; end

%% Load data from files
[Intensity,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults([fieldCode,'_ex',num2str(exWave)]);

%% Create pretty images
if nargin < 4, botlim = min(min(TauM)); end
if nargin < 3, uplim = max(max(TauM)); end
Flimage = prettyFlim(TauM,Intensity,'none',flipud(jet(64)),uplim,botlim);
figure('name',['FLIM: ',fieldCode]); image(Flimage); axis image off;

return

