% RunList = { ...
%  'macro', 1, 1, 1, 75.0, 59.3, 88.4;...
% };
% dataGroup = 'singletry';

RunList = { ...
 'mono', 1, 6, 3, 76.6, 58.1, 88.6;...
 'mono', 1, 5, 10, 76.6, 58.1, 88.6;...
 'macro', 1, 8, 1, 75.0, 59.3, 88.4;...
 'macro', 2, 10, 1, 75.0, 59.3, 88.4;...
};
dataGroup = 'monocytes3';

%% Execution switches
saveImages = 0;
displayImages = 0;
saveData = 1;
loadExistingMasks = 1;

%% Initialize data file with header
if saveData
    Header = {'cell','slide','field','Redox','Confluence','Threshold'};
    fid = fopen(['redox_',dataGroup,'.tsv'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n',Header{:});
end %if saveData

%%
for m = 1:size(RunList,1)
    
%% Breakout RunList and set some constants
cellType = RunList{m,1};
slide = RunList{m,2};
fields = RunList{m,3};
firstField = RunList{m,4};
seriesPrefix = cellType;
pwr755 = RunList{m,5};
pwr860 = RunList{m,6};
pwr800 = RunList{m,7};
gainCh1 = 860;
gainCh2 = 800;
gainCh3 = 800;

threshold = 0.04;
adaptive = true;
tweak = 1.0;

MeanRedox = zeros(fields,1);
Confluence = zeros(fields,1);
Threshold = ones(fields,1)*threshold;
CellLabel = cell(fields,1);

%% Loop through a series (all fields on 1 sample slide)
    for k = 1:fields
        CellLabel{k} = cellType;
        field = k-1+firstField;
        fname = [seriesPrefix,'-',num2str(slide),num2str(field)];
        ImageParams = {fname,pwr755,pwr860,gainCh2,gainCh3};
        [NADH,FAD,SaturatedPts] = loadRedoxImages(ImageParams);
        
    %%Calculate redox
        % Smoothen images for redox calc
        h = fspecial('average');
        FADsmooth = imfilter(medfilt2(single(FAD)),h,'replicate');
        NADHsmooth = imfilter(medfilt2(single(NADH)),h,'replicate');
        % Calculate redox
        TotInt = NADHsmooth+FADsmooth;
        redox = FADsmooth./(TotInt);
        redox(isnan(redox)) = 0;  % set divide-by-zero to zero
        redox(isinf(redox)) = 0;  % set divide-by-zero to zero

    %% Create intensity threshold mask
        % disp('Thresholding');
        if loadExistingMasks
            Mask = imread(['mask_',fname,'.tif']);
            CellMask = (Mask(:,:,1) > 128);
        else
            if adaptive
                Threshold(k) = adaptiveThreshold(TotInt)*tweak;
            end
            Mask = TotInt > Threshold(k);
            %Mask = Mask & ~SaturatedPts;
            Mask = medfilt2(Mask);
        
            %Remove small objects
            [L,NUM] = bwlabel(Mask,4);
            val=histc(reshape(L,1,[]),1:NUM);
            ind=find((val<(pi*(20/2)^2)));%|(val>10000));
            for ii=ind
            L=L.*(1-(L==ii));
            end
            CellMask=(L>0);
        end

   
    %% Calculate mean redox
        MeanRedox(k) = sum(sum(CellMask.*redox)) ./ sum(sum(CellMask));
        Confluence(k) = sum(sum(CellMask)) / (size(NADH,1)*size(NADH,2));
    
        %% Pretty Images
        if (saveImages || displayImages)
            RGB2 = prettyRGB(medfilt2(FAD),medfilt2(NADH),zeros(size(NADH,1)),.3,0.999); % scale brightness from 20% to 99.9%
            [redox2,PrettyIntensity] = prettyRedox(redox,NADHsmooth,'none',jet(64),1,0);
      %      redox2 = rgb2grayback(redox2,PrettyIntensity,CellMask);
        end % if (saveImage | displayImages)
    
    %% Display Images
        if displayImages
            figure('Name',fname);
            subplot(2,2,1);image(RGB2); axis image; axis off; title('FAD,NADH,SHG');
            subplot(2,2,2);image(redox2); axis image; axis off; title('Redox');
            colormap(hot);
            subplot(2,2,3);imagesc(PrettyIntensity); axis image; axis off; title('NADH');
            subplot(2,2,4);imagesc(CellMask); axis image; axis off; title('Segmentation');
%         subplot(2,2,4);image(ind2rgb(Mask,gray(2)));axis image; axis off; title('Mask');
%         subplot(1,2,2);imagesc(Mask);axis image; axis off; title(['Mask ',fname]);
        end %if displayImages

    %% Save Images
        if saveImages
            imwrite(RGB2,['rgb_',fname,'.tif']);  disp(['rgb_',fname,'.tif']);
            imwrite(redox2,['redox_',fname,'.tif']);  disp(['redox_',fname,'.tif']);
            imwrite(single(CellMask),['mask_',fname,'.tif']);  disp(['mask_',fname,'.tif']);
        end %if saveImages
    
    end %for k = 1:seriesLength

    if saveData
        %Header = {'cell','slide','field','Redox','Confluence','Threshold'};
        DataPack = horzcat(slide*ones(fields,1),(firstField:firstField-1+fields)',MeanRedox,Confluence,Threshold);
        DataPack = horzcat(CellLabel,num2cell(DataPack));
        %save(['FLIM_',cellType,'-',num2str(slide),'.tsv'],'DataPack','-ASCII','-tabs');
        for k = 1:fields
            fprintf(fid,'%s\t%d\t%d\t%g\t%g\t%g\n',...
                DataPack{k,:});
        end %for k = 1:fields    
%         disp([cellType,'-',num2str(slide),' mean values saved to ', 'redox_',dataGroup,'.tsv']);
        disp([cellType,'-',num2str(slide),' mean redox ',num2str(mean(MeanRedox))]);
    end %if saveData

end %for m = 1:length(RunList)
fclose('all');
disp('DONE!');



