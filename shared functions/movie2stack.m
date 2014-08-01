function ImageStack = movie2stack(Movie,fname)

ImageStack = frame2im(Movie(1));
imwrite(ImageStack,[fname,'1.tif']);

for f = 2:size(Movie,2)
    ImageStack = cat(3,ImageStack,frame2im(Movie(f)));
    imwrite(frame2im(Movie(f)),[fname,num2str(f),'.tif']);
end

return