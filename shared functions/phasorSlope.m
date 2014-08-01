function [g,s,x1,y1,x2,y2,a,b] = phasorSlope(Gmap,Smap)
% phasorSlope finds the best fit line (ax + b) to a scatter plot of
% (Gmap,Smap) and also gives the intersections (x1 and x2) of that line to
% the Universal Circle (sqrt(0.25 - (x-0.5)^2)).
% CAlonzo 28Nov2012
%
% 20140801 CAlonzo
% Re-order output variables, calculate y-coordinates of intersections.
% Calculate mean phasor values.

%% Mean values
g = mean(Gmap(:));
s = mean(Smap(:));

%% Apply linear fitting (ax + b) to (Gmap,Smap) scatter plot.
Coeffs = fit(reshape(Gmap,[],1),reshape(Smap,[],1),'poly1');
a = Coeffs.p1;
b = Coeffs.p2;

%% Find intersection with Universal Circle, sqrt(0.25 - (x-0.5)^2)
x1 = (-2*a*b + 1 + sqrt((2*a*b-1)^2 - 4*(a*a+1)*(b*b)))/(2*(a*a+1));
x2 = (-2*a*b + 1 - sqrt((2*a*b-1)^2 - 4*(a*a+1)*(b*b)))/(2*(a*a+1));

% extrapolate intersections
y1 = a*x1 + b;
y2 = a*x2 + b;

return
