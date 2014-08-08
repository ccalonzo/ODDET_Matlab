
%%
% figure('Position',[100 10 800 600]);
colorOrder = ['r','g','b','c','m'];

GImage = GImage_low;
SImage = SImage_low;

for timePt = 1:5
    lineColor = colorOrder(timePt);
    markColor = colorOrder(timePt);

% Draw universal circle
x = (0:0.01:1); 
y = sqrt(0.25 - (x-0.5).^2);
hold on; plot(x*phasorRes,y*phasorRes,'-k');

Gmap = GImage(:,:,timePt,1);
Smap = SImage(:,:,timePt,1);
for k = 2:3
    Gmap = vertcat(GImage(:,:,timePt,k),Gmap);
    Smap = vertcat(SImage(:,:,timePt,k),Smap);
end   

Gmap = Gmap(~isnan(Gmap));
Smap = Smap(~isnan(Smap));

[g,s,x1,y1,x2,y2,a,b] = phasorSlope(Gmap,Smap);
% Draw line through scatter plot
x = (0:0.01:1); 
plot(x*phasorRes,(a*x+b)*phasorRes,['-',lineColor],...
    x1*phasorRes,y1*phasorRes,['o',markColor],x2*phasorRes,y2*phasorRes,['o',markColor]);

% Plot center of phasor distribution
plot(g*phasorRes,s*phasorRes,['o',markColor],'MarkerFaceColor',markColor);
axis image xy;
M(timePt+5) = getframe(gcf);

end

%%
GImage = GImage_low;
SImage = SImage_low;
lineColor = 'b';
markColor = 'b';
    
Gmap = GImage(:,:,1,1);
Smap = SImage(:,:,1,1);
for k = 2:3
    Gmap = vertcat(GImage(:,:,1,k),Gmap);
    Smap = vertcat(SImage(:,:,1,k),Smap);
end   

for j = 2:5
    for k = 1:3
        Gmap = vertcat(GImage(:,:,j,k),Gmap);
        Smap = vertcat(SImage(:,:,j,k),Smap);
    end
end   

Gmap = Gmap(~isnan(Gmap));
Smap = Smap(~isnan(Smap));

GSmap = phasorMap(Gmap,Smap,256);

% Draw universal circle
x = (0:0.01:1); 
y = sqrt(0.25 - (x-0.5).^2);
hold on; plot(x*phasorRes,y*phasorRes,'-k');
[g,s,x1,y1,x2,y2,a,b] = phasorSlope(Gmap,Smap);
% Draw line through scatter plot
x = (0:0.01:1); 
plot(x*phasorRes,(a*x+b)*phasorRes,['-',lineColor],...
    x1*phasorRes,y1*phasorRes,['o',markColor],x2*phasorRes,y2*phasorRes,['o',markColor]);
% Plot center of phasor distribution
plot(g*phasorRes,s*phasorRes,['o',markColor],'MarkerFaceColor',markColor);
axis image xy;

prettyPhasor('',max(GSmap-10,0),Gmap,Smap);