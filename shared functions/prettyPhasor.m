function [g,s,a,b,x1,x2,y1,y2] = prettyPhasor(figLabel,GSmap,Gmap,Smap,phasorRes)
% requires: phasorSlope.m

%% Linear fit to phasor scatter
[a b x1 x2] = phasorSlope(Gmap,Smap);
y1 = a*x1 + b;
y2 = a*x2 + b;

%% Mean values
g = mean(Gmap(:));
s = mean(Smap(:));

%% Plot phasor map
% Adjust jet colormap such that background is white
figure('Name',figLabel,'Color','w');
cmp = jet(64);
cmp(1,:) = 1;
colormap(cmp);

% Plot GSmap 
imagesc(GSmap); 
axis xy; axis image;

% Draw universal circle
x = (0:0.01:1); 
y = sqrt(0.25 - (x-0.5).^2);
hold on; plot(x*phasorRes,y*phasorRes,'-k');

% Draw line through scatter plot
plot(x*phasorRes,(a*x+b)*phasorRes,':b',...
    x1*phasorRes,y1*phasorRes,'or',x2*phasorRes,y2*phasorRes,'or');

% Plot center of phasor distribution
plot(g*phasorRes,s*phasorRes,'or','MarkerFaceColor','r');

% Adjust tick labels to (0:1)
set(gca,'XTick',0:phasorRes/4:phasorRes,'XTickLabel',0:.25:1);%,'FontSize',16);
set(gca,'YTick',0:phasorRes/4:phasorRes,'YTickLabel',0:.25:1);%,'FontSize',16);

return