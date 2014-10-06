%% Load metadata
[~,~,RunList] = xlsread('Adipo_t3.xlsx');
InputHeader = RunList(1,:);
RunList = RunList(2:end,:);
dataGroup = '20141006_Adipo_t3';

%% Execution switches
saveImages = true;
displayImages = false;
saveData = true;

%% Assign some constants for image rendering
flimScaleMin = 500;
flimScaleMax = 2500;
bright = 0.95;
dark = 0.05;
redoxBright = 0.95;
redoxDark = 0.05;
redoxRed = 0.8;
redoxBlue = 0.0;

%% Intialize array containers for output
listLength = size(RunList,1);

NADHThreshold = zeros(listLength,1); %Intensity threshold for NADH channel
FADThreshold = zeros(listLength,1); %Intensity threshold for FAD channel
CellArea = zeros(listLength,1);
MeanRedox = zeros(listLength,1);
Mean755 = zeros(listLength,1);
Mean860 = zeros(listLength,1);
MeanTauM = zeros(listLength,1);
MeanA1 = zeros(listLength,1);
MeanTau1 = zeros(listLength,1);
MeanA2 = zeros(listLength,1);
MeanTau2 = zeros(listLength,1);
MeanA1overA2 = zeros(listLength,1);
MeanTau2overTau1 = zeros(listLength,1);
MeanChi = zeros(listLength,1);
% NuclearTauM = zeros(listLength,1);

%% Iterate through RunList
for m = 1:listLength
    %% Extract metadata from RunList
    cellType = RunList{m,1};
    timept = RunList{m,2};
    well = RunList{m,3};
    field = RunList{m,4};
    power755 = RunList{m,5};
    power860 = RunList{m,6};

    %% Load image files
    fname = [cellType,'_t',num2str(timept),'-',num2str(well),num2str(field)];
    [Int755,TauM,A1,A2,Tau1,Tau2,Chi,A3,Tau3] = loadFlimFitResults([fname,'_ex755']);
    Int860 = loadFlimFitResults([fname,'_ex860']);
    Int755(128,128) = 0;
    Int860(128,128) = 0;
        
    %% Coregister
    [Int860] = CoRegisterNormxcorr2(Int755,Int860);
    
    %% Create intensity threshold mask
%     Threshold(m) = 500;  %in photon counts per pixel
    tweak = 1.0; %tweak threshold to be more(>1) or less(<1) agressive
    FADThreshold(m) = adaptiveThreshold(Int860)*tweak;
    FADMask = (Int860) > 80;%FADThreshold(m);
    NADHThreshold(m) = adaptiveThreshold(Int755);
    NADHMask = (Int755) > 500;%NADHThreshold(m);
%     CellMask = antiSmall(NADHMask & FADMask, 10);
    CellMask = FADMask ;
    LipidMask = NADHMask & ~FADMask;
    
%     %% Label cells
%     CC = bwconncomp(CellMask);
%     CellLabels = labelmatrix(CC);
%     
    %% Normalize by laser power
    Int755 = Int755/power755^2;
    Int860 = Int860/power860^2;    
    
    %% Redox ratio
    Redox = Int860 ./ (Int755 + Int860);
    Redox(isnan(Redox)) = 0; % set divide-by-zero to zero

%     CellMask = Redox > 0.35);
    
    %% Fast to slow ratio
    A1overA2 = A1./A2;
    A1overA2(isnan(A1overA2)) = 0;  % set divide-by-zero to zero
    A1overA2(isinf(A1overA2)) = 0;  % set divide-by-zero to zero
    
    Tau2overTau1 = Tau2./Tau1;
    Tau2overTau1(isnan(Tau2overTau1)) = 0;  % set divide-by-zero to zero
    Tau2overTau1(isinf(Tau2overTau1)) = 0;  % set divide-by-zero to zero
        
    %% Pretty images
%     Flimage = prettyFlim(TauM,Intensity,'none',flipud(jet(64)),flimScaleMax,flimScaleMin);
%     PrettyA1overA2 = prettyFlim(A1overA2,Intensity,'none',flipud(jet(64)),4,1); %scale A1/A2 ration from 1 to 4.
%     PrettyA1 = prettyFlim(A1,Intensity,'none',flipud(jet(64)),1,0); %scale from 0 to 1.
    % These maps are drawn with a reversed jet colormap to match the
    % SPCImage software
    
    
    %% Pretty images
    if displayImages||saveImages
        Flimage2 = prettyFlim(TauM,Int755,'none',flipud(jet(64)),flimScaleMax,flimScaleMin,bright,dark);
        Redox2 = prettyRedox(Redox,(Int755+Int860),'none',jet(64),redoxRed,redoxBlue,redoxBright,redoxDark);
        PrettyChi = prettyRedox(Chi,Int755,'none',jet(64),2,0);
        Pretty755 = prettyGray(Int755);
        Pretty860 = prettyGray(Int860);        
        Segments = uint8(CellMask)+uint8(2*LipidMask);
%         Segments = uint8(CellMask);
        cmp = [0 0 0; 0.8 0.8 0; 0 0.2 1; 0.5 0.2 1];
    end %if displayImages||saveImages
        
    %% Display Images
    if displayImages
        %figure('Name',fname,'Position',[2400,200,600,600]);
        figure('Name',fname);
        subplot(2,3,1);image(Flimage2); axis image off; title('\tau _m');
        subplot(2,3,2);image(Redox2); axis image off; title('Redox');
        subplot(2,3,3);image(PrettyChi); axis image off; title('Chi-square');
        subplot(2,3,4);imagesc(Int860); axis image off; title('FAD Intensity');
        subplot(2,3,5);imagesc(Int755); axis image off; title('NADH Intensity');
%         subplot(3,2,4);imagesc(Int860); axis image off; title('FAD Intensity');
        colormap(hot);
        subplot(2,3,6);image(ind2rgb(Segments,cmp));axis image; axis off; title('Segments');
%         subplot(3,2,6);imagesc(CellLabels);axis image; axis off; title('Cells');
    end %if displayImages

    %% Save Images
    if saveImages
%         imwrite(Flimage,['flim_',fname,'_',num2str(flimScaleMin),'-',num2str(flimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Flimage2,['flim_',fname,'_',num2str(flimScaleMin),'-',num2str(flimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Redox2,['redox_',fname,'_',num2str(redoxBlue),'-',num2str(redoxRed),'.tif']);  disp(['redox_',fname,'.tif',' saved.']);
        imwrite(Segments,cmp,['segments_',fname,'.tif']);
        imwrite(Pretty755,['NADH_',fname,'.tif']);
        imwrite(Pretty860,['FAD_',fname,'.tif']);
        imwrite(PrettyChi,['Chi_',fname,'.tif']);
        %imwrite(PrettyA1overA2,[fname,'_a1_a2.tif']);  disp([fname,'_a1_a2.tif saved']);
        %imwrite(PrettyA1,['a1_',fname,'.tif']);  disp(['a1_',fname,'.tif saved']);
%         imwrite(real(CellMask),['mask_',fname,'_',num2str(tweak),'.tif']); disp(['mask_',fname,'.tif',' saved.']);
    end %if saveImages
    
    %% Calculate mean values
    if saveData    
        CellArea(m) = sum(CellMask(:));
        Mean755(m) = mean(Int755(CellMask)); %sum(sum(Int755.*CellMask)) / CellArea(m);
        Mean860(m) = mean(Int860(CellMask)); %sum(sum(Int860.*CellMask)) / CellArea(m);
        MeanRedox(m) = Mean860(m)/(Mean755(m)+Mean860(m));
        MeanTauM(m) = mean(TauM(CellMask)); %sum(sum(CellMask.*TauM)) / CellArea(m);
        MeanA1(m) = mean(A1(CellMask)); %sum(sum(CellMask.*A1)) / CellArea(m);
        MeanTau1(m) = mean(Tau1(CellMask)); %sum(sum(CellMask.*Tau1)) / CellArea(m);
        MeanA2(m) =  mean(A2(CellMask)); %sum(sum(CellMask.*A2)) / CellArea(m);
        MeanTau2(m) = mean(Tau2(CellMask)); %sum(sum(CellMask.*Tau2)) / CellArea(m);
        MeanA1overA2(m) = mean(A1overA2(CellMask)); %sum(sum(CellMask.*A1overA2)) / CellArea(m);
        MeanTau2overTau1(m) = mean(Tau2overTau1(CellMask)); %sum(sum(CellMask.*Tau2overTau1)) / CellArea(m);
        MeanChi(m) = mean(Chi(CellMask));
    end %if saveData
   
end %for  m = 1:listLength

%% Save summary of results
if saveData
    Header = {'cell','time','well','field','Redox','TauM','A1','Tau1','A2','Tau2','A1/A2','Tau2/Tau1','Int755','Int860','Cell Area','NADHThreshold','FADTHreshold','Chi-square'};
    DataPack = horzcat(MeanRedox,MeanTauM,MeanA1,MeanTau1,MeanA2,MeanTau2,MeanA1overA2,MeanTau2overTau1,Mean755,Mean860,CellArea,NADHThreshold,FADThreshold,MeanChi);
    DataPack = horzcat(RunList(:,1:4),num2cell(DataPack));
    DataPack = vertcat(Header,DataPack);
    xlswrite(['RedoxFLIM_',dataGroup,'.xlsx'],DataPack);
    disp(['Mean values saved to ', 'RedoxFLIM_',dataGroup,'.xlsx']);
end %if saveData

disp('DONE!');