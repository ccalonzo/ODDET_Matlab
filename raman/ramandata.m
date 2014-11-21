fname = 'Brown 5 3.5W 2.0V 2.0V 0.1s_rm1001.dat';
RawData = load(fname,'ascii');
Axis = (RawData(1,:))';
RamanImages = reshape(RawData(2:end,:),sqrt(size(RawData,1)-1),sqrt(size(RawData,1)-1),size(Axis,1));

%%
slice = 1000;
CurrentImage = RamanImages(:,:,slice);
PrettyImage = prettyGray(CurrentImage);
figure('Name',fname);
imagesc(PrettyImage); axis image off;
imwrite(PrettyImage,[fname,'_1000.tif']);

%%
Mask = CurrentImage > 0.75*adaptiveThreshold(CurrentImage);
Mask3d = logical(repmat(Mask,[1 1 size(Axis)]));

%%
figure('Name',fname);
TissueSpectrum = squeeze(mean(mean(RamanImages,1),2));
plot(Axis,TissueSpectrum);

figure('Name','Lipids');

plot(Axis,squeeze(mean(mean(RamanImages.*Mask3d,1),2)));
figure('Name','Not Lipids');
plot(Axis,squeeze(mean(mean(RamanImages.*~Mask3d,1),2)));
