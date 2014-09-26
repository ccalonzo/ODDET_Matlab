function [Redox,TauM,Int755,Int860,A1,A2,Tau1,Tau2] = quickRedoxFlim(fieldCode,power755,power860,displayImages)
% [Redox,TauM,Int755,Int860,A1,A2,Tau1,Tau2] = quickRedoxFlim(fieldCode,power755,power860)
%
% Quickly show FLIM and redox results for a single image field using data
% exported from SPCImage.
% 20140523 CAlonzo

%% If not specified, don't normalize intenisty by laser power
if nargin < 4
    displayImages = true;
end

if nargin < 3
    power860 = 1;
    power755 = 1;
end

%% Load data from files
[Int755,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults([fieldCode,'_ex755']);
Int860 = load([fieldCode,'_ex860_photons.asc']);
Int860 = CoRegisterNormxcorr2(Int755,Int860);
Redox = (Int860/power860^2) ./ (Int755/power755^2 + Int860/power860^2);


%% Create pretty images
if displayImages
    Flimage = prettyFlim(TauM,Int755,'none',flipud(jet(64)),2500,1000);
    Redox2 = prettyRedox(Redox,Int755+Int860,'none',jet(64),0.8,0.0);
    figure('name',['FLIM: ',fieldCode]); image(Flimage); axis image off;
    figure('name',['Redox: ',fieldCode]); image(Redox2); axis image off;
end

return

