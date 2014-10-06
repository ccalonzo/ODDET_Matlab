function barWithErrors(BarData,BarErrors,XLabels)
% barWithErrors(BarData,BarErrors,XLabels)
%
% Plot data in a bar chart with error bars
% Just like bar(), barWithErrors() expects data to be arranged in columns,
% each column corresponding to a separate category.


if nargin < 3
    Chart = bar(BarData);
else
    Chart = bar(XLabels,BarData);
end 

hold on
% For each set of bars, find the centers of the bars, and write error bars
for k = 1:numel(Chart)
      % Find the centers of the bars
      xData = get(get(Chart(k),'Children'),'XData');
      barCenters = mean(unique(xData,'rows'));
      errorbar(barCenters',BarData(:,k),BarErrors(:,k),'k.');
end