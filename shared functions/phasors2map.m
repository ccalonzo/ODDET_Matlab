function GSmap = phasors2map(Gmap,Smap,mapResolution)

GSmap = zeros(mapResolution);

%% Bin g and s
GmapBin = Gmap.*(Gmap>0)+eps;   %brings negative values to just above zero
SmapBin = Smap.*(Smap>0)+eps;   %brings negative values to just above zero
GmapBin = ceil(GmapBin*mapResolution);
SmapBin = ceil(SmapBin*mapResolution);
GmapBin = min(GmapBin,mapResolution);
SmapBin = min(SmapBin,mapResolution);

%% Accumulate phasors 
for n = 1:numel(GmapBin)
    GSmap(SmapBin(n),GmapBin(n)) = GSmap(SmapBin(n),GmapBin(n)) + 1;
end

return