fname = 'White 1 5.0W 0.6V 0.6V 0.1s_rm1001.dat';
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
% figure;
% plot(Axis,squeeze(RamanImages(7,5,:)));
%%
figure('Name',fname);
plot(Axis,squeeze(mean(mean(RamanImages,1),2)));
