function [RadialSpectra,Fourier] = radialPSD(SourceImage,bins,suppressDC)
% Assumes square images, but of arbitrary size
% Radial PSD is calculated only up to the last complete circle in Fourier
% space.
% Set suppressDC = true to block DC component, suppressDC = false to keep DC,
% unspecified defaults to suppress = false;
%
% CAlonzo 20Nov2012

%% Create coordinate axes centered at (imageSize/2 + 1)
imageSize = size(SourceImage,1);
origin = imageSize/2 + 1;
[X,Y] = meshgrid(1:imageSize);
X = X - origin;
Y = Y - origin;
R = sqrt(X.*X + Y.*Y);
clear X Y;

%% 2D-FFT of SourceImage
if nargin < 3
    suppressDC = false;
end %if nargin < 3

Fourier = fft2(SourceImage);
Fourier = Fourier.*conj(Fourier);
Fourier = fftshift(Fourier);
if suppressDC
    Fourier(origin,origin) = 0;
end %if suppressDC

%% Radial averaging
RadialSpectra = zeros(bins,2);
binStep = R(origin,imageSize) / bins;
binStart = -binStep;
for k = 1:bins
    binStart = binStart + binStep;  %first binStart = 0
    Mask = R >= binStart & R < binStart+binStep;
    RadialSpectra(k,1) = binStart;
    RadialSpectra(k,2) = sum(sum(Fourier.*Mask)) / sum(sum(Mask));
end %for k = 1:bins

return

