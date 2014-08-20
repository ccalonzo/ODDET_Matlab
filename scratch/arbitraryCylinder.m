% Draws an arbitrary cylinder in 3D space
% 2014-08-20 CAlonzo

Slate = zeros(256,256,256);
Sketch = zeros(256,256,256);

phiDegrees = 45;
thetaDegrees = 90;
radius = 16;
x1 = 128;
y1 = 1;

phi = degtorad(phiDegrees);
theta = degtorad(thetaDegrees);
majorAxis = radius/cos(phi);


for k = 1:size(Slate,3)
    xk = cos(theta)*(double(k)*tan(phi));
    yk = sin(theta)*(double(k)*tan(phi)) + 1;
    Sketch(:,:,k) = drawEllipse(x1+xk,y1+yk,majorAxis,radius,thetaDegrees,Slate(:,:,k));
end
%%

imagesc(squeeze(Sketch(:,:,1))); axis xy image off;
%%
implay(Sketch);


