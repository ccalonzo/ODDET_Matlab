function Drawing = drawEllipse(xc,yc,a,b,phiDegrees,PreviousField)

phi = degtorad(phiDegrees);
[X,Y] = meshgrid(1:size(PreviousField,1));
Xrot = cos(phi)*(X-xc) - sin(phi)*(Y-yc);
Yrot = sin(phi)*(X-xc) + cos(phi)*(Y-yc);

Drawing = (((Xrot)/a).^2 + ((Yrot)/b).^2) <= 1;
Drawing = Drawing + PreviousField;

return
