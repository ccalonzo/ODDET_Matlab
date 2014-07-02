function Collage = collage2x2(stack1,stack2,stack3,stack4,border)
% Combine 4 images or stacks of the same size and same colordepth 
% into a 2x2 collage.
% 2013Jul31 CAlonzo
% 2014-06-19 CAlonzo
% Monochrome images rendered in gray scale.
%
% TO DO: Accept mixed sizes (and colordepths?)
% rows = max(size(stack1,1),size(stack2,1),size(stack2,1),size(stack4,1));
% cols = max(size(stack1,2),size(stack2,2),size(stack2,2),size(stack4,2));
% colordepth = max(size(stack1,3),size(stack2,3),size(stack2,3),size(stack4,3));

if nargin < 5, border = 0; end;

%% For simplicity, let's assume images are all the same size
rows =size(stack1,1);
cols = size(stack1,2);

colordepth1 = size(stack1,3);
colordepth2 = size(stack2,3);
colordepth3 = size(stack3,3);
colordepth4 = size(stack4,3);

if colordepth1 == 3
    stackheight = size(stack1,4);
else
    stackheight = colordepth1;
    colordepth1 = 1;
end

Filler = zeros(rows,cols,stackheight);
Collage = 255*uint8(ones(2*rows+3*border,2*cols+3*border,3,stackheight));

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
    Collage(2*border+rows+1:2*border+2*rows,border+1:border+cols,:,:) = stack3*255;
else
    Collage(2*border+rows+1:2*border+2*rows,border+1:border+cols,:,:) = permute(cat(4,stack3*255,stack3*255,stack3*255),[ 1 2 4 3]);
end

%%
if colordepth4 == 3
    Collage(2*border+rows+1:2*border+2*rows,2*border+cols+1:2*border+2*cols,:,:) = stack4*255;
else
    Collage(2*border+rows+1:2*border+2*rows,2*border+cols+1:2*border+2*cols,:,:) = permute(cat(4,stack4*255,stack4*255,stack4*255),[1 2 4 3]);
end

return
