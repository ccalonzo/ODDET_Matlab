function imagesq(array,figname)

if nargin > 1
    figure('Name',figname);
else
    figure
end

imagesc(array);
axis image off;

return