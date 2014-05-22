function  [threshold,PeakPSD] = adaptiveThreshold8bit(SourceImage)
% Find an intensity threshold by maximizing non-DC peak of radial PSD.
% Based algorithm described by Kyle P Quinn.
% 20Nov2012 CAlonzo
% 08Aug2013 CAlonzo
% Modified for direct application to 8-bit images.

%Test a range of thresholds, from 50% to 100% of mean pixel value.
Threshold = (-10:-1)';
PeakPSD = zeros(length(Threshold),1);

%% Generate radial bins
imageSize = size(SourceImage,1);
origin = imageSize/2 + 1;
bins=32;
[X,Y] = meshgrid(1:imageSize);
X = X - origin;
Y = Y - origin;
binSize = imageSize/2/bins;
RadialBins = ceil(sqrt(X.*X + Y.*Y)/binSize);
clear X Y;

m = 10;
%% Repeat if highest threshold tested has the highest PSD peak
while (m>9)
    %% Test different thresholds
    Threshold = Threshold+10;
    for k = 1:length(Threshold)
        Binary = SourceImage > Threshold(k);
        Spectra = radialPSD(Binary,16,true,RadialBins);
        PeakPSD(k) = max(Spectra(:,2));
    end %for k
    
    %% Find threshold that maximizes low-freq peak of PSD
    [~,m] = max(PeakPSD);
end %while (m==10)

threshold = Threshold(m);

return