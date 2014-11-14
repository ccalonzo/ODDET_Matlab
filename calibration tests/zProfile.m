
Intensity = zeros(128,128,10);
for k = 1:10
    wavelength(k) = 700+k*20;
    fname = ['umbel-hiconc-1_pmt3_',num2str(wavelength(k)),'mv_ex755'];
    Intensity(:,:,k) = load([fname,'_photons','.asc'],'-ascii');
end

Profile = squeeze(mean(mean(Intensity,1),2));
plot(wavelength,Profile);
