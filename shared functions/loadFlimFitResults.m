function [Intensity,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults(fname)
% [Intensity,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults(fname)
%
% Load FLIM fit results exported from SPCImage. The working directory 
% should contain 5 files in ASCII format following the naming convention: 
% (e.g. fname = 'fname') fname_a1.asc, fname_a2.asc, fname_t1.asc, 
% fname_t2.asc, fname_photons.asc. These correspond, respectively to the 
% 4 fit constants, and intensity at each pixel.
% Data from each file is loaded to corresponding arrays. Additionally,
% Mean lifetime, TauM = A1*Tau1 + A2*Tau2 is calculated. Note that A1 and
% A2 have been normalized to ensure that A1 + A2 = 1
% 2014-05-22 CAlonzo

%% Load data from files
A1 = load([fname,'_a1','.asc'],'-ascii');
A2 = load([fname,'_a2','.asc'],'-ascii');
Tau1 = load([fname,'_t1','.asc'],'-ascii');
Tau2 = load([fname,'_t2','.asc'],'-ascii');
Intensity = load([fname,'_photons','.asc'],'-ascii');

%% Normalize A1 and A2
Temp = A1 + A2;
A1 = A1./Temp;
A1(isnan(A1)) = 0;
A2 = A2./Temp;
A2(isnan(A2)) = 0;

%% Calculate TauM
TauM = A1.*Tau1 + A2.*Tau2;


return