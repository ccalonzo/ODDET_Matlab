function Collage = collage1x3(stack1,stack2,stack3,border)
% Combine 3 images or stacks of the same size and same colordepth 
% into a 1x3 collage.
% For RGB images: RGB is in dimension 3, stack is along dimension 4. 
% Monochrome images rendered in gray scale.
% Modified from collage2x2.m
%
% Expected bug: if stack is 3 slices deep, subroutine will mistake it for
% an RGB image.
%
% TO DO: Accept mixed sizes (and colordepths?)
% rows = max(size(stack1,1),size(stack2,1),size(stack2,1),size(stack4,1));
% cols = max(size(stack1,2),size(stack2,2),size(stack2,2),size(stack4,2));
% colordepth = max(size(stack1,3),size(stack2,3),size(stack2,3),size(stack4,3));
% 2014Jun16 CAlonzo

if nargin < 4, border = 0; end;

%% For simplicity, let's assume images are all the same size
rows =size(stack1,1);
cols = size(stack1,2);

colordepth1 = size(stack1,3);
colordepth2 = size(stack2,3);
colordepth3 = size(stack3,3);

if colordepth1 == 3
    stackheight = size(stack1,4);
else
    stackheight = colordepth1;
    colordepth1 = 1;
end

Filler = zeros(rows,cols,stackheight);
Collage = 255*uint8(ones(rows+2*border,3*cols+4*border,3,stackheight));

%%
if colordepth1 == 3
    Collage(border+1:border+rows,border+1:border+cols,:,:) = stack1*255;
else
    Collage(border+1:border+rows,border+1:border+cols,:,:) = permute(cat(4,stack1*255,stack1*255,stack1*255),[1 2 4 3]);
end
   
%%
if colordepth2 == 3
    Collage(border+1:border+rows,2*border+cols+1:2*border+2*cols,:,:) = stack2*255;
else
    Collage(border+1:border+rows,2*border+cols+1:2*border+2*cols,:,:) = permute(cat(4,stack2*255,stack2*255,stack2*255),[1 2 4 3]);
end

%%
if colordepth3 == 3
    Collage(border+1:border+rows,3*border+2*cols+1:3*border+3*cols,:,:) = stack3*255;
else
    Collage(border+1:border+rows,3*border+2*cols+1:3*border+3*cols,:,:) = permute(cat(4,stack3*255,stack3*255,stack3*255),[ 1 2 4 3]);
end

return
