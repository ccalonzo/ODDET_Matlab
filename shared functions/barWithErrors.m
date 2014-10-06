function barWithErrors(BarData,BarErrors,XLabels)

if nargin < 3
    hb = bar(BarData);
else
    hb = bar(XLabels,BarData);
end 

hold on
% For each set of bars, find the centers of the bars, and write error bars
for ib = 1:numel(hb)
      % Find the centers of the bars
      xData = get(get(hb(ib),'Children'),'XData');
      barCenters = mean(unique(xData,'rows'));
      errorbar(barCenters',BarData(:,ib),BarErrors(:,ib),'k.');
end