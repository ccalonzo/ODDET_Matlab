%% Load metadata
[~,~,RunList] = xlsread('20130813_macro.xlsx');
InputHeader = RunList(1,:);
RunList = RunList(2:end,:);
dataGroup = '20130813_macro';

%% Execution switches
saveImages = true;
displayImages = false;
saveData = true;

%% Initialize output data file with header
if saveData
    Header = {'cell','hour','slide','field','TauM','A1','Tau1','A2','Tau2','A1/A2','Tau2/Tau1','Threshold'};
end %if saveData

%% Intialize array containers for output
listLength = size(RunList,1);

MeanTauM = zeros(listLength,1);
MeanA1 = zeros(listLength,1);
MeanTau1 = zeros(listLength,1);
MeanA2 = zeros(listLength,1);
MeanTau2 = zeros(listLength,1);
MeanA1overA2 = zeros(listLength,1);
MeanTau2overTau1 = zeros(listLength,1);
Threshold = zeros(listLength,1);
NuclearTauM = zeros(listLength,1);

%%Iterate through RunList
for m = 1:listLength
    %% Extract labels from RunList
    cellType = RunList{m,1};
    timept = RunList{m,2};
    slide = RunList{m,3};
    field = RunList{m,4};
    %% Assign some constants
    FlimScaleMin = 500;
    FlimScaleMax = 2500;

    %% Load image files
    fname = [cellType,'h',num2str(timept),'-',num2str(slide),num2str(field)];
%     fname = [cellType,'-',num2str(slide),num2str(field)];
    A1 = load([fname,'_a1','.asc'],'-ascii');
    A2 = load([fname,'_a2','.asc'],'-ascii');
    Tau1 = load([fname,'_t1','.asc'],'-ascii');
    Tau2 = load([fname,'_t2','.asc'],'-ascii');
    Intensity = load([fname,'_photons','.asc'],'-ascii');
    
    %% Fast to slow ratio
    A1overA2 = A1./A2;
    A1overA2(isnan(A1overA2)) = 0;  % set divide-by-zero to zero
    A1overA2(isinf(A1overA2)) = 0;  % set divide-by-zero to zero
    
    Tau2overTau1 = Tau2./Tau1;
    Tau2overTau1(isnan(Tau2overTau1)) = 0;  % set divide-by-zero to zero
    Tau2overTau1(isinf(Tau2overTau1)) = 0;  % set divide-by-zero to zero
    
    %% Normalize A1 and A2
    Temp = A1 + A2;
    A1 = A1./Temp;
    A1(isnan(A1)) = 0;
    A2 = A2./Temp;
    A2(isnan(A2)) = 0;
    clear Temp;
    
    %% Weighted mean lifetime
    TauM = A1.*Tau1 + A2.*Tau2;
    
    %% Pretty images
     Flimage = prettyFlim(TauM,Intensity,'none',flipud(jet(64)),FlimScaleMax,FlimScaleMin);
    % PrettyA1overA2 = prettyFlim(A1overA2,Intensity,'none',flipud(jet(64)),4,1); %scale A1/A2 ration from 1 to 4.
    % PrettyA1 = prettyFlim(A1,Intensity,'none',flipud(jet(64)),1,0); %scale from 0 to 1.
    % These maps are drawn with a reversed jet colormap to match the
    % SPCImage software
    
    %% Create intensity threshold mask
%     Threshold(m) = 500;  %in photon counts per pixel
    tweak = 1.0; %tweak threshold to be more(>1) or less(<1) agressive
    Threshold(m) = adaptiveThreshold(Intensity)*tweak;
    Mask = Intensity > Threshold(m);
%     CellMask = (Intensity.*Mask > Threshold(m)*4) | (TauM.*Mask > 1300) ;
      CellMask = medfilt2(Mask);
    
%     %% Remove nuclei by FLIM threshold
%     [NuclearTauM(m),Ranks] = findNuclei3(TauM+~Mask*3000,800,2400);
%     CellMask = Mask & (TauM > NuclearTauM(m));
    
%     %% Remove resdiual nuclei with a combined TauM and Intensity threshold
%     NuclearBits = (TauM < NuclearTauM(m)*1.2)&(Intensity < Threshold(m)*1.5);
%     CellMask = CellMask & ~NuclearBits;
%     CellMask = medfilt2(CellMask);
    
    %% Segmented image
    Flimage2 = prettyFlim(TauM,Intensity.*CellMask,'none',flipud(jet(64)),FlimScaleMax,FlimScaleMin);
    Segments = uint8(Mask) + uint8(CellMask);
    cmp = [0 0 0; 1 0 0; 1 1 0];
    
    %% Calculate mean values
    MeanTauM(m) = sum(sum(CellMask.*TauM)) ./ sum(sum(CellMask));
    MeanA1(m) = sum(sum(CellMask.*A1)) ./ sum(sum(CellMask));
    MeanTau1(m) = sum(sum(CellMask.*Tau1)) ./ sum(sum(CellMask));
    MeanA2(m) =  sum(sum(CellMask.*A2)) ./ sum(sum(CellMask));
    MeanTau2(m) = sum(sum(CellMask.*Tau2)) ./ sum(sum(CellMask));
    MeanA1overA2(m) = sum(sum(CellMask.*A1overA2)) ./ sum(sum(CellMask));
    MeanTau2overTau1(m) = sum(sum(CellMask.*Tau2overTau1)) ./ sum(sum(CellMask));
    
    %% Display Images
    if displayImages
        %figure('Name',fname,'Position',[2400,200,600,600]);
        figure('Name',fname);%,'Position',[2000,50,600,600]);
        subplot(1,2,1);image(Flimage); axis image; axis off; title(['\tau _m ',fname]);
%         subplot(2,2,2);imagesc(Intensity); axis image; axis off; title(['Intensity ',fname]);
%         subplot(2,2,3);image(Flimage2); axis image; axis off; title(['\tau _m ',fname]);
%         colormap(flipud(jet(64)));
        subplot(1,2,2);image(ind2rgb(Segments,cmp));axis image; axis off; title(['Segments ',fname]);
%          subplot(1,2,2);image(ind2rgb(CellMask,gray(2)));axis image; axis off; title(['CellMask ',fname]);
    end %if displayImages

    %% Save Images
    if saveImages
%         imwrite(Flimage,['flim_',fname,'_',num2str(FlimScaleMin),'-',num2str(FlimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Flimage2,['flim_',fname,'_',num2str(FlimScaleMin),'-',num2str(FlimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Segments,cmp,['segments_',fname,'.tif']);
        %imwrite(PrettyA1overA2,[fname,'_a1_a2.tif']);  disp([fname,'_a1_a2.tif saved']);
        %imwrite(PrettyA1,['a1_',fname,'.tif']);  disp(['a1_',fname,'.tif saved']);
%         imwrite(real(CellMask),['mask_',fname,'_',num2str(tweak),'.tif']); disp(['mask_',fname,'.tif',' saved.']);
    end %if saveImages
    
	fclose('all');
end %for  m = 1:listLength

% disp([cellType,'d',num2str(day),' MeanTauM ',num2str(mean(MeanTauM))]);
% disp([cellType,' MeanTau1 ',num2str(mean(MeanTau1))]);
% disp([cellType,' MeanTau2 ',num2str(mean(MeanTau2))]);

if saveData
    DataPack = horzcat(MeanTauM,MeanA1,MeanTau1,MeanA2,MeanTau2,MeanA1overA2,...
        MeanTau2overTau1,Threshold);
    DataPack = horzcat(RunList(:,1:4),num2cell(DataPack));
    DataPack = vertcat(Header,DataPack);
    xlswrite(['FLIM_',dataGroup,'.xlsx'],DataPack);
    disp(['Mean values saved to ', 'FLIM_',dataGroup,'.tsv']);
end %if saveData

fclose('all');
disp('DONE!');