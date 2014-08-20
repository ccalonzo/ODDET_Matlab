function Sketch = draw3dCylinder(x1,y1,radius,phiDegrees,thetaDegrees,PreviousSpace)
% Draws a 3D cylindrical volume in PreviousSpace. PreviousSpace may already
% contain other elements, but should have equal dimensions.
% Specify (x1,y1) as the intersection of the cylinder axis with the first
% plane of PreviousSpace; radius of the cylinder; zentih angle, phiDegrees; 
% and azimuth angle, thetaDegrees. Angles are measured from the positive z
% and x axes, respectively.
% This function requires drawEllipse.m
% 2014-08-20 CAlonzo

phi = degtorad(phiDegrees);
theta = degtorad(thetaDegrees);
majorAxis = radius/cos(phi);

Sketch = zeros(size(PreviousSpace));

for k = 1:size(PreviousSpace,3)
    xk = cos(theta)*(double(k)*tan(phi));
    yk = sin(theta)*(double(k)*tan(phi)) + 1;
    Sketch(:,:,k) = drawEllipse(x1+xk,y1+yk,majorAxis,radius,thetaDegrees,PreviousSpace(:,:,k));
end

return
