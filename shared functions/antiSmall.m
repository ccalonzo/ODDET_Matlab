function NewMask = antiSmall(Mask,minDiameter,connectivity)
% Remove small object
% original code by Kyle P Quinn
% 03Apr2013 CAlonzo
% Replace bwlabel() with bwconncomp() for more efficient memory handling.
% 07Aug2013 CAlonzo
% Use regionprops to calculate areas
%
% 12Jun2014 CAlonzo
% default to 4 neareast neighbors, but allow user to specify otherwise

if nargin < 3
    connectivity = 4;
end

%%
CC = bwconncomp(Mask,connectivity); %Identify individual objects
Stats = regionprops(CC,'EquivDiameter'); %Calculate equivalent diameter of each object
Keep = find([Stats.EquivDiameter] > minDiameter); %Find objects smaller than minDiameter
NewMask = ismember(labelmatrix(CC), Keep);

return

% %% KPQ's original code
% [L,NUM] = bwlabel(Mask,4); %Identify individual objects
% val=histc(reshape(L,1,[]),1:NUM); %Calculate sizes of each object
% ind=find(val<(pi*(minDiameter/2)^2)); %Find objects smaller than minDiameter
% for ii=ind  %
%     L=L.*(1-(L==ii));
% end
% 
% NewMask=(L>0);