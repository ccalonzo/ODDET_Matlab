function Sketch = drawEllipse(xc,yc,a,b,thetaDegrees,PreviousField)
% Draws a 2D ellipse on PreviousField. PreviousField should be a square
% matrix, but may already contain other elements. The ellipse is centered 
% at (xc,yc), and described by (((Xrot)/a).^2 + ((Yrot)/b).^2) <= 1, 
% where Xrot and Yrot are axes rotated by thetaDegrees wuth respect to the 
% axes of PreviousField.
% To plot, use imagesc(Sketch); axis xy image; such that origin is on the
% lower left.
% 2014-08-20 CAlonzo

theta = degtorad(thetaDegrees);
[X,Y] = meshgrid(1:size(PreviousField,1),1:size(PreviousField,2));
Xrot = cos(theta)*(X-xc) + sin(theta)*(Y-yc);
Yrot = -sin(theta)*(X-xc) + cos(theta)*(Y-yc);

Sketch = (((Xrot)/a).^2 + ((Yrot)/b).^2) <= 1;
Sketch = Sketch + PreviousField;

return
