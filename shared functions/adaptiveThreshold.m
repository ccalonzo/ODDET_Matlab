function  [threshold,PeakPSD] = adaptiveThreshold(TargetImage)
% Find an intensity threshold by maximizing non-DC peak of radial PSD.
% Based algorithm described by Kyle P Quinn.
% requires: radialPSD.m 
% 20Nov2012 CAlonzo

%Test a range of thresholds, from 50% to 100% of mean pixel value.
Threshold = mean(TargetImage(:))*(0.5:.025:1.0)';
PeakPSD = zeros(length(Threshold),1);

for k = 1:length(Threshold)
    Binary = TargetImage > Threshold(k);
    Spectra = radialPSD(Binary,32,true);
    PeakPSD(k) = max(Spectra(:,2));
end

[~,m] = max(PeakPSD);
threshold = Threshold(m);

return