function pointSpectra(RamanImages,Axis)

PrettyImage = prettyGray(RamanImages(:,:,1000));
%%
F1 = figure;
subplot(1,2,1);
G1 = imagesc(PrettyImage*255); colormap(jet(256)); axis square off;
set(G1,'HandleVisibility','off');
G2 = gca;
set(gca,'nextplot','replacechildren');
%%
subplot(1,2,2);
S1 = plot(Axis,squeeze(RamanImages(1,1,:)));
L1 = line([1440 1440],[0 1500],'Color','r');
axis([0 1800 600 1500]);
G3 = gca;
set(gca,'nextplot','replacechildren');
%%
%% Assign GUI callback
set(G1,'ButtonDownFcn',{@selectPoint,G2,G3,S1});
set(G3,'ButtonDownFcn',{@selectWavelength,G1,G3,Axis,L1});

%% Define Callback Functions

function selectPoint(hObject,eventdata,imageAxes,spectrumAxes,spectrum)
    currPt = round(get(gca,'CurrentPoint'));
    axes(imageAxes); plot(currPt(1,1),currPt(1,2),'ws');
    axes(spectrumAxes);
    set(spectrum,'YData',squeeze(RamanImages(currPt(1,2),currPt(1,1),:)));
end

function selectWavelength(hObject,eventdata,imageHandle,spectrumAxes,Axis,lineHandle)
    getPt = get(gca,'CurrentPoint');
    currWv = find(Axis>getPt(1,1),1,'first');
    axes(spectrumAxes); set(lineHandle,'XData',[getPt(1,1) getPt(1,1)]);
    PrettyImage = prettyGray(RamanImages(:,:,currWv));
    set(imageHandle,'CData',PrettyImage*255); 
end

end


