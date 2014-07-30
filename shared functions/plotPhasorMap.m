function plotPhasorMap(PhasorMap,offset,drawCircle)
% Plot PhasorMap with jet colormap on a white background.
% offset specifies the minimum count to include in the plot, default = 0.
% Also optionally draws the universal circle, default is drawCircle = TRUE.
% 
% 20140730 CAlonzo

if nargin < 2, offset = 0; end
if nargin < 3, drawCircle = true; end

phasorRes = size(PhasorMap,1);

%% Plot phasor map
% Adjust jet colormap such that background is white
figure;
cmp = jet(256);
cmp(1,:) = 1;
colormap(cmp);
imagesc(max(PhasorMap-offset,0)); axis xy; axis image;% title(filename);
% Adjust tick labels to (0:1)
set(gca,'XTick',0:64:256,'XTickLabel',0:.25:1);%,'FontSize',16);
set(gca,'YTick',0:64:256,'YTickLabel',0:.25:1);%,'FontSize',16);

% Draw universal circle
if drawCircle 
    x = (0:0.01:1); 
    y = sqrt(0.25 - (x-0.5).^2);
    hold on; plot(x*phasorRes,y*phasorRes,'-k');
end

return
