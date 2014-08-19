function Drawing = drawCircle(xc,yc,r,PreviousField)

[X,Y] = meshgrid(1:size(PreviousField,1));

Drawing = ((X-xc).^2 + (Y-yc).^2) <= r^2;

return