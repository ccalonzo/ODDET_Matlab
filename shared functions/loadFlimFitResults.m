function [Intensity,TauM,A1,A2,Tau1,Tau2,Chi,A3,Tau3] = loadFlimFitResults(fname)
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
% 2014-09-18 CAlonzo
% Optionally load chi-square results
% 2014-10-06 CAlonzo
% Modified to accept tri-exponential results

%% Load data from files
Intensity = load([fname,'_photons','.asc'],'-ascii');
A1 = load([fname,'_a1','.asc'],'-ascii');
Tau1 = load([fname,'_t1','.asc'],'-ascii');
A2 = load([fname,'_a2','.asc'],'-ascii');
Tau2 = load([fname,'_t2','.asc'],'-ascii');

if exist([fname,'_chi','.asc'],'file') == 2
    Chi = load([fname,'_chi','.asc'],'-ascii');
end 

if exist([fname,'_a3','.asc'],'file') == 2
    A3 = load([fname,'_a3','.asc'],'-ascii');
    Tau3 = load([fname,'_t3','.asc'],'-ascii');
    components = 3;
else
    components = 2;
end
    
%% Normalize A1 and A2
if components == 3
    Temp = A1 + A2 + A3;
    A1 = A1./Temp;
    A1(isnan(A1)) = 0;
    A2 = A2./Temp;
    A2(isnan(A2)) = 0;
    A3 = A3./Temp;
    A3(isnan(A3)) = 0;

    TauM = A1.*Tau1 + A2.*Tau2 + A3.*Tau3;

else
    Temp = A1 + A2;
    A1 = A1./Temp;
    A1(isnan(A1)) = 0;
    A2 = A2./Temp;
    A2(isnan(A2)) = 0;

    TauM = A1.*Tau1 + A2.*Tau2;
end

return