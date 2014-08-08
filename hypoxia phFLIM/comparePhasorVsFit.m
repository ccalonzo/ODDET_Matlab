fname = 'hfk_g1-12';

[DecayMatrix,timeInterval] = loadFlimRawData([fname,'_ex755.asc'],256,128);
[Intensity,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults([fname,'_ex755']);

Mask = Intensity > adaptiveThreshold(Intensity);

[GMap,SMap] = phasorImages(DecayMatrix);
[GSMap,g,s,x1,y1,x2,y2,a,b] = phasorMap(GMap(Mask),SMap(Mask));
prettyPhasor(fname,GSMap,GMap(Mask),SMap(Mask),2);
%%
angFreq = 2*pi*80e-3;
phasorRes = 256;

avgTau1 = mean(Tau1(Mask))/1000;
avgTau2 = mean(Tau2(Mask))/1000;

plot(phasorRes*1/(1 + angFreq^2*avgTau1^2),phasorRes*angFreq*avgTau1/(1 + angFreq^2*avgTau1^2),'bs');
plot(phasorRes*1/(1 + angFreq^2*avgTau2^2),phasorRes*angFreq*avgTau2/(1 + angFreq^2*avgTau2^2),'bs');


