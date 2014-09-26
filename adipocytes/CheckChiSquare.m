    fname = ['adipo_t3-71_ex755_IRF13-shift-82'];
    [Int755,TauM,A1,A2,Tau1,Tau2,Chi] = loadFlimFitResults(fname);
    Mask = Int755 > 500;
    Mask2 = Mask & (Chi < 1.25);
    PrettyChi = prettyRedox(Chi,Int755,'none',jet(64),2,0);
    PrettyTauM = prettyFlim(TauM,Int755,'none',flipud(jet(64)),2500,500,0.95,0.05);

    meanTauM = mean(TauM(Mask2));
    meanChi = mean(Chi(Mask2));
    disp(['avg TauM = ',num2str(meanTauM)]);
    disp(['avg Chi-square = ',num2str(meanChi)]);
    
        figure('Name',fname); 
    subplot(2,2,1), image(PrettyTauM); axis image off; title(['\tau _m = ',num2str(meanTauM)]);
    subplot(2,2,2), image(PrettyChi); axis image off; title(['\chi ^2 = ',num2str(meanChi)]);
    subplot(2,2,3), imagesc(Mask); axis image off;
    subplot(2,2,4), imagesc(Mask2); axis image off;
    
%     imwrite(PrettyChi,['Chi_',fname,'.tif']);
%     imwrite(PrettyTauM,['flim_',fname,'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
 