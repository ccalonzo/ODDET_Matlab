function stack2tif(Stack,filename)
% Saves an image stack as a multipage tiff.
% No normalization or rescaling is performed.  
% Stack should be either uint8 (8-bit tiff) or uint16 (16-bit tiff).
% Image compression is default, 'packbits'.
% If filename already exits, iteration number is appended.
% e.g. 'myimage' becomes 'myimage1'
% CAlonzo 21May2012


%% Iterate filename if file already exists
k = 0;
base = filename;
while exist([filename,'.tif'],'file') == 2
  k = k+1;
  filename = [base,num2str(k)];
end %exist([filename,'.tif']) == 2  

%% Save frames to tiff
for k = 1:size(Stack,3)
    imwrite(Stack(:,:,k),[filename,'.tif'],'WriteMode','append');
end % for k = 1:size(Stack)

return
