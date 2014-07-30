prefix = 'hfk_g1-';
timeRes = 256;
imageRes = 128;
phasorRes = 256;
well = 2;

GImage = zeros(imageRes,imageRes,5);
SImage = zeros(imageRes,imageRes,5);
PhasorMap = zeros(phasorRes,phasorRes,5);

for field = 1:5
    fname = [prefix,num2str(well),num2str(field),'_ex755.asc'];
    [DecayMatrix,timeInterval] = loadFlimRawData(fname,timeRes,imageRes);
    Intensity = sum(DecayMatrix,3);
    threshold = adaptiveThreshold(Intensity);
    Mask = Intensity > threshold;
    [GImage(:,:,field),SImage(:,:,field)] = phasorImages(DecayMatrix);
    PhasorMap(:,:,field) = phasorMap(GImage(:,:,field),SImage(:,:,field),phasorRes);
end

CumulPhasorMap = sum(PhasorMap,3);
plotPhasorMap(CumulPhasorMap,10);

    

