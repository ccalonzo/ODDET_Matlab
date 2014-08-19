fname = 'hfk_low-11';

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

T1 = 1/angFreq * sqrt(1/x1 - 1);
T2 = 1/angFreq * sqrt(1/x2 - 1);
text(x1*phasorRes,y1*phasorRes+10,['\color{red}',num2str(T1)]);
text(x2*phasorRes-10,y2*phasorRes+10,['\color{red}',num2str(T2)]);

x3 = 1/(1 + angFreq^2*avgTau1^2);
y3 = angFreq*avgTau1/(1 + angFreq^2*avgTau1^2);
x4 = 1/(1 + angFreq^2*avgTau2^2);
y4 = angFreq*avgTau2/(1 + angFreq^2*avgTau2^2);

plot(phasorRes*x3,phasorRes*y3,'bs');
plot(phasorRes*x4,phasorRes*y4,'bs');

text(x3*phasorRes-10,y3*phasorRes-10,['\color{blue}',num2str(avgTau1)]);
text(x4*phasorRes,y4*phasorRes-10,['\color{blue}',num2str(avgTau2)]);

