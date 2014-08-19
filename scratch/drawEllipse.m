function Drawing = drawEllipse(xc,yc,a,b,PreviousField)

[X,Y] = meshgrid(1:size(PreviousField,1));

Drawing = (((X-xc)/a).^2 + ((Y-yc)/b).^2) <= 1;
Drawing = Drawing + PreviousField;

return
