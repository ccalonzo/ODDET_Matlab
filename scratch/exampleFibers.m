% Example using draw3dCylinder to draw multiple fibers in a volume.
% 2014-08-20 CAlonzo
% Requires draw3DCylinder.m, drawEllipse.m, and stack2tif.m

Slate = zeros(256,256,256);

Sketch = draw3dCylinder(1,1,1,8,45,45,Slate);
Sketch = draw3dCylinder(1,128,64,16,90,0,Sketch);
Sketch = draw3dCylinder(200,20,1,16,60,120,Sketch);
Sketch = draw3dCylinder(225,225,1,32,0,0,Sketch);
Sketch = draw3dCylinder(1,200,1,4,30,-30,Sketch);

implay(Sketch);

stack2tif(flipdim(Sketch,1),'fibers');


