prefix = 'hfk_low-';
timeRes = 256;
imageRes = 128;
phasorRes = 256;
% well = 2;

GImage = zeros(imageRes,imageRes,5,3);
SImage = zeros(imageRes,imageRes,5,3);
PhasorMap = zeros(phasorRes,phasorRes,5,3);

for field = 1:5
    for well = 1:3
    fname = [prefix,num2str(well),num2str(field),'_ex755.asc'];
    [DecayMatrix,timeInterval] = loadFlimRawData(fname,timeRes,imageRes);
    Intensity = sum(DecayMatrix,3);
    threshold = adaptiveThreshold(Intensity);
    Mask = Intensity > threshold;
    [GImage(:,:,field,well),SImage(:,:,field,well)] = phasorImages(DecayMatrix);
    PhasorMap(:,:,field,well) = phasorMap(GImage(:,:,field,well),SImage(:,:,field,well),phasorRes);
    end
end

%%
CumulPhasorMap = sum(sum(PhasorMap,4),3);
plotPhasorMap(CumulPhasorMap,10);

    

