function  [threshold,Area] = findNuclei3(TargetImage,start,stop)
%start and stop are the minimum and maximum thresholds to examine

Threshold = (stop-start)*(0:0.01:1)' + start;
Area = zeros(101,1);

for k = 1:length(Threshold)
    Binary = TargetImage < Threshold(k);
    Area(k) = sum(sum(Binary));
end %for k=1:length(Threshold)

dArea = smooth(diff(Area),'rlowess');  % first-derivative
%Area = smooth(diff(Area),'rlowess'); % second-derivative
[~,m] = max(dArea);

LinearFitAtInflection = fit(Threshold(m-5:m+5),Area(m-5:m+5),'poly1');
% threshold = -LinearFitAtInflection.p2/LinearFitAtInflection.p1;

LinearFitAtBaseline = fit(Threshold(1:10),Area(1:10),'poly1');

threshold = (LinearFitAtBaseline.p2-LinearFitAtInflection.p2)...
        /(LinearFitAtInflection.p1-LinearFitAtBaseline.p1);


return