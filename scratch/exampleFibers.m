% Example using draw3dCylinder to draw multiple fibers in a volume.
% 2014-08-20 CAlonzo
% Requires draw3DCylinder.m, drawEllipse.m, and stack2tif.m

Slate = zeros(256,256,256);

Sketch = draw3dCylinder(1,1,1,8,45,45,Slate);
Sketch = draw3dCylinder(128,128,128,16,90,0,Sketch);
Sketch = draw3dCylinder(200,20,1,16,60,120,Sketch);
Sketch = draw3dCylinder(225,225,1,32,0,0,Sketch);
Sketch = draw3dCylinder(1,200,1,4,30,-30,Sketch);

implay(flipdim(Sketch,1));

stack2tif(flipdim(Sketch,1),'fibers');

%%
% Draw random fibers

OldSketch = zeros(256,256,256);
PhiMatrix = zeros(256,256,256);
ThetaMatrix = zeros(256,256,256);

for k = 1:10
    tryAgain = true;
    while tryAgain
        x = rand(1)*256;
        y = rand(1)*256;
        z = rand(1)*256;
        r = rand(1)*16 + 4;
        phi = rand(1)*90;
        theta = rand(1)*360;
        NewSketch = draw3dCylinder(x,y,z,r,phi,theta,OldSketch);
        if max(NewSketch) <= 1
            OldSketch = NewSketch;
            PhiMatrix = draw3dCylinder(x,y,z,r,phi,theta,PhiMatrix,phi);
            ThetaMatrix = draw3dCylinder(x,y,z,r,phi,theta,ThetaMatrix,theta);
            tryAgain = false;
        else
            tryAgain = true;
        end
    end
end

implay(flipdim(OldSketch,1));
stack2tif(flipdim(OldSketch,1),'randomfibers');
stack2tif(flipdim(PhiMatrix,1),'randomfibers-theta');

        