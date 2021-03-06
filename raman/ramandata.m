sname = 'wtsub-1';
NormIsolatedSpectra = zeros(1340,4);
NormTissueSpectra = zeros(1340,4);
NormLipidSpectra = zeros(1340,4);
NormNotLipidSpectra = zeros(1340,4);

for k = 1:4

fname = [sname,num2str(k),'.dat'];
RawData = load(fname,'ascii');
Axis = (RawData(1,:))';
RamanImages = reshape(RawData(2:end,:),sqrt(size(RawData,1)-1),sqrt(size(RawData,1)-1),size(Axis,1));
TissueSpectrum = squeeze(mean(mean(RamanImages,1),2));

%%
slice = 1000;
CurrentImage = RamanImages(:,:,slice);
PrettyImage = prettyGray(CurrentImage);
% figure('Name',fname);
% subplot(1,3,1);
% image(PrettyImage*64); axis image off;
imwrite(PrettyImage,[fname,'_1000.tif']);

%%
Mask = CurrentImage > 1.0*adaptiveThreshold(CurrentImage);
% subplot(1,3,2);
% image(PrettyImage.*Mask*64); axis image off;
imwrite(PrettyImage.*Mask,[fname,'_1000_Lipids.tif']);
Mask3d = logical(repmat(Mask,[1 1 size(Axis)]));
LipidSpectrum = squeeze(sum(sum(RamanImages.*Mask3d,1),2))/sum(Mask(:));

%%
Mask = ~(CurrentImage > 0.9*adaptiveThreshold(CurrentImage));
% subplot(1,3,3);
% image(PrettyImage.*Mask*64); axis image off;
imwrite(PrettyImage.*Mask,[fname,'_1000_NotLipids.tif']);
Mask3d = logical(repmat(Mask,[1 1 size(Axis)]));
NotLipidSpectrum = squeeze(sum(sum(RamanImages.*Mask3d,1),2))/sum(Mask(:));

%%
% figure('Name',fname);
NormTissueSpectrum = (TissueSpectrum-mean(TissueSpectrum(1:80)))/(TissueSpectrum(1236)-mean(TissueSpectrum(1:80)));
NormLipidSpectrum = (LipidSpectrum-mean(LipidSpectrum(1:80)))/(LipidSpectrum(1236)-mean(LipidSpectrum(1:80)));
NormNotLipidSpectrum = (NotLipidSpectrum-mean(NotLipidSpectrum(1:80)))/(NotLipidSpectrum(1236)-mean(NotLipidSpectrum(1:80)));
% plot(Axis,NormTissueSpectrum,'r', Axis,NormLipidSpectrum,'g', Axis,NormNotLipidSpectrum,'b');

IsolatedSpectrum = NormLipidSpectrum - NormNotLipidSpectrum;
NormIsolatedSpectra(:,k) = IsolatedSpectrum/IsolatedSpectrum(1000);
NormLipidSpectra(:,k) = NormLipidSpectrum;
NormNotLipidSpectra(:,k) = NormNotLipidSpectrum;
NormTissueSpectra(:,k) = NormTissueSpectrum;

end

figure('Name',[sname,':Raman spectrum']);
plot(Axis,mean(NormIsolatedSpectra,2));

figure('Name',[sname,':Tissue spectra']);
plot(Axis,mean(NormTissueSpectra,2),'r',Axis,mean(NormLipidSpectra,2),'g',...
    Axis,mean(NormNotLipidSpectra,2),'b');

