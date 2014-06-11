%% Load metadata
[~,~,RunList] = xlsread('sevi_mouse_BAT-WAT.xlsx');
InputHeader = RunList(1,:);
RunList = RunList(2:end,:);
dataGroup = '20140611_mousebatwat-all';

%% Execution switches
saveImages = true;
displayImages = true;
saveData = true;

%% Intialize array containers for output
listLength = size(RunList,1);

Threshold = zeros(listLength,1);
Threshold_F = zeros(listLength,1);
NuclearTauM = zeros(listLength,1);
MeanRedox = zeros(listLength,1);

MeanTauM = zeros(listLength,1);
MeanA1 = zeros(listLength,1);
MeanTau1 = zeros(listLength,1);
MeanA2 = zeros(listLength,1);
MeanTau2 = zeros(listLength,1);
MeanA1overA2 = zeros(listLength,1);
MeanTau2overTau1 = zeros(listLength,1);

MeanTauM_F = zeros(listLength,1);
MeanA1_F = zeros(listLength,1);
MeanTau1_F = zeros(listLength,1);
MeanA2_F = zeros(listLength,1);
MeanTau2_F = zeros(listLength,1);
MeanA1overA2_F = zeros(listLength,1);
MeanTau2overTau1_F = zeros(listLength,1);

MeanTauM_L = zeros(listLength,1);
MeanA1_L = zeros(listLength,1);
MeanTau1_L = zeros(listLength,1);
MeanA2_L = zeros(listLength,1);
MeanTau2_L = zeros(listLength,1);
MeanA1overA2_L = zeros(listLength,1);
MeanTau2overTau1_L = zeros(listLength,1);


% wtbat-31 m = 13;
% wtepi-31 m = 21;
% wtsub-31 m = 34;
% kosub-31 m = 42;

%%Iterate through RunList
for m = 1:listLength
    %% Assign some constants
    FlimScaleMin = 1000;
    FlimScaleMax = 5000;
    FlimScaleMin_F = 500;
    FlimScaleMax_F = 2000;
    bright = 0.95;
    dark = 0.05;
    redoxBright = 0.99;
    redoxDark = 0.2;
    redoxRed = 0.7;
    redoxBlue = 0.01;
    
%% LOAD IMAGE FILES

% Extract labels from RunList
    cellType = RunList{m,1};
    treatment = RunList{m,2};
    slide = RunList{m,3};
    field = RunList{m,4};

    %% Load image files
    fname = [cellType,treatment,'-',num2str(slide),num2str(field)];
    [Int755,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults([fname,'_ex755']);
    Int860 = loadFlimFitResults([fname,'_ex860']);
    Int900 = loadFlimFitResults([fname,'_ex900']);

    %% Coregister
    [Int860] = CoRegisterNormxcorr2(Int755,Int860);
    [Int900] = CoRegisterNormxcorr2(Int860,Int900);

    %% Create intensity threshold mask
    tweak = 1.0; %tweak threshold to be more(>1) or less(<1) agressive
    Threshold(m) = adaptiveThreshold(Int755+Int860*2);
    Mask = Int755 > Threshold(m);    

    %% Fast to slow ratio
    A1overA2 = A1./A2;
    A1overA2(isnan(A1overA2)) = 0;  % set divide-by-zero to zero
    A1overA2(isinf(A1overA2)) = 0;  % set divide-by-zero to zero
    
    Tau2overTau1 = Tau2./Tau1;
    Tau2overTau1(isnan(Tau2overTau1)) = 0;  % set divide-by-zero to zero
    Tau2overTau1(isinf(Tau2overTau1)) = 0;  % set divide-by-zero to zero
    

    %% Calculate mean values
    MeanTauM_F(m) = sum(sum(CellMask.*TauM)) ./ sum(sum(CellMask));
    MeanA1_F(m) = sum(sum(CellMask.*A1)) ./ sum(sum(CellMask));
    MeanTau1_F(m) = sum(sum(CellMask.*Tau1)) ./ sum(sum(CellMask));
    MeanA2_F(m) =  sum(sum(CellMask.*A2)) ./ sum(sum(CellMask));
    MeanTau2_F(m) = sum(sum(CellMask.*Tau2)) ./ sum(sum(CellMask));
    MeanA1overA2_F(m) = sum(sum(CellMask.*A1overA2)) ./ sum(sum(CellMask));
    MeanTau2overTau1_F(m) = sum(sum(CellMask.*Tau2overTau1)) ./ sum(sum(CellMask));    
     
%% Load 755 image files
    fname = [cellType,treatment,'-',num2str(slide),num2str(field),'_ex755em460'];
    fname1 = fname;
    %     fname = [cellType,'-',num2str(slide),num2str(field)];
    A1 = load([fname,'_a1','.asc'],'-ascii');
    A2 = load([fname,'_a2','.asc'],'-ascii');
    Tau1 = load([fname,'_t1','.asc'],'-ascii');
    Tau2 = load([fname,'_t2','.asc'],'-ascii');
    Intensity755 = load([fname,'_photons','.asc'],'-ascii');
    
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
     Flimage755 = prettyFlim(TauM,Intensity755,'none',flipud(jet(64)),FlimScaleMax,FlimScaleMin,bright,dark);
    % PrettyA1overA2 = prettyFlim(A1overA2,Intensity,'none',flipud(jet(64)),4,1); %scale A1/A2 ration from 1 to 4.
    % PrettyA1 = prettyFlim(A1,Intensity,'none',flipud(jet(64)),1,0); %scale from 0 to 1.
    % These maps are drawn with a reversed jet colormap to match the
    % SPCImage software
    
    %% Create intensity threshold mask
%     Threshold(m) = 20;  %in photon counts per pixel
%     tweak = 1.0; %tweak threshold to be more(>1) or less(<1) agressive
    Threshold(m) = adaptiveThreshold(Intensity755);
    Mask = Intensity755 > Threshold(m);
%     CellMask = (Intensity.*Mask > Threshold(m)*4) | (TauM.*Mask > 1300) ; %for lipids
      LipidMask = medfilt2(Mask) & ~(CellMask);
    
%     %% Remove nuclei by FLIM threshold
%     [NuclearTauM(m),Ranks] = findNuclei3(TauM+~Mask*3000,800,2400);
%     CellMask = Mask & (TauM > NuclearTauM(m));
    
%     %% Remove resdiual nuclei with a combined TauM and Intensity threshold
%     NuclearBits = (TauM < NuclearTauM(m)*1.2)&(Intensity755 < Threshold(m)*1.5);
%     CellMask = CellMask & ~NuclearBits;
%     CellMask = medfilt2(CellMask);
    
    %% Segmented image
%     Flimage2 = prettyFlim(TauM,Intensity.*CellMask,'none',flipud(jet(64)),FlimScaleMax,FlimScaleMin);
    Segments = 2*uint8(LipidMask) + uint8(CellMask);
    cmp = [0 0 0; 1 0 0; 1 1 0];
    
    %% Calculate mean values
    MeanTauM_L(m) = sum(sum(LipidMask.*TauM)) ./ sum(sum(LipidMask));
    MeanA1_L(m) = sum(sum(LipidMask.*A1)) ./ sum(sum(LipidMask));
    MeanTau1_L(m) = sum(sum(LipidMask.*Tau1)) ./ sum(sum(LipidMask));
    MeanA2_L(m) =  sum(sum(LipidMask.*A2)) ./ sum(sum(LipidMask));
    MeanTau2_L(m) = sum(sum(LipidMask.*Tau2)) ./ sum(sum(LipidMask));
    MeanA1overA2_L(m) = sum(sum(LipidMask.*A1overA2)) ./ sum(sum(LipidMask));
    MeanTau2overTau1_L(m) = sum(sum(LipidMask.*Tau2overTau1)) ./ sum(sum(LipidMask));
    
    %% Calculate mean values
    MeanTauM(m) = sum(sum(CellMask.*TauM)) ./ sum(sum(CellMask));
    MeanA1(m) = sum(sum(CellMask.*A1)) ./ sum(sum(CellMask));
    MeanTau1(m) = sum(sum(CellMask.*Tau1)) ./ sum(sum(CellMask));
    MeanA2(m) =  sum(sum(CellMask.*A2)) ./ sum(sum(CellMask));
    MeanTau2(m) = sum(sum(CellMask.*Tau2)) ./ sum(sum(CellMask));
    MeanA1overA2(m) = sum(sum(CellMask.*A1overA2)) ./ sum(sum(CellMask));
    MeanTau2overTau1(m) = sum(sum(CellMask.*Tau2overTau1)) ./ sum(sum(CellMask));

    %% Calculate Redox 
%     h = fspecial('gaussian');
%     FADsmooth = imfilter((single(Intensity860)),h,'replicate');
%     NADHsmooth = imfilter((single(Intensity755)),h,'replicate');
    redox = Intensity860./(Intensity860+Intensity755);
    redox(isnan(redox)) = 0;  % set divide-by-zero to zero
    redox(isinf(redox)) = 0;  % set divide-by-zero to zero
    redox2 = prettyRedox(redox,Intensity860+Intensity755,...
        'none',jet(64),redoxRed,redoxBlue,redoxBright,redoxDark);

    %% Calculate mean redox values
    MeanRedox(m) = sum(Intensity860(CellMask))./sum((Intensity860(CellMask)+Intensity755(CellMask)));
   
         %% Display Images
    if displayImages
        %figure('Name',fname,'Position',[2400,200,600,600]);
        figure('Name',fname);%,'Position',[2000,50,600,600]);
        subplot(2,3,2);image(Flimage755); axis image; axis off; title(['NADH \tau _m ']);
        subplot(2,3,5);imagesc(LipidMask); axis image; axis off; title(['Lipid Mask']);
        subplot(2,3,1);image(Flimage860); axis image; axis off; title(['FAD \tau _m ']);
        subplot(2,3,4);imagesc(CellMask); axis image; axis off; title(['Cell Mask']);
        subplot(2,3,3);image(redox2); axis image; axis off; title(['redox ']);
%         subplot(2,2,2);imagesc(Intensity); axis image; axis off; title(['Intensity ',fname]);
%         subplot(2,2,3);image(Flimage2); axis image; axis off; title(['\tau _m ',fname]);
%         colormap(flipud(jet(64)));
        subplot(2,3,6);image(ind2rgb(Segments,cmp));axis image; axis off; title(['Segments ']);
%          subplot(1,2,2);image(ind2rgb(CellMask,gray(2)));axis image; axis off; title(['CellMask ',fname]);
    end %if displayImages

    %% Save Images
    if saveImages
        fname = [cellType,treatment,'-',num2str(slide),num2str(field)];
%         imwrite(Flimage,['flim_',fname,'_',num2str(FlimScaleMin),'-',num2str(FlimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Flimage755,['flim755_',fname,'_',num2str(FlimScaleMin),'-',num2str(FlimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Flimage860,['flim860_',fname,'_',num2str(FlimScaleMin),'-',num2str(FlimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(redox2,['redox_',fname,'.tif']);  disp(['redox_',fname,'.tif',' saved.']);
        imwrite(Segments,cmp,['segments_',fname,'.tif']);
        %imwrite(PrettyA1overA2,[fname,'_a1_a2.tif']);  disp([fname,'_a1_a2.tif saved']);
        %imwrite(PrettyA1,['a1_',fname,'.tif']);  disp(['a1_',fname,'.tif saved']);
%         imwrite(real(CellMask),['mask_',fname,'_',num2str(tweak),'.tif']); disp(['mask_',fname,'.tif',' saved.']);
    end %if saveImages
    
%     CellLabel{m} = cellType;
end %for  m = 1:listLength

% disp([cellType,'d',num2str(day),' MeanTauM ',num2str(mean(MeanTauM))]);
% disp([cellType,' MeanTau1 ',num2str(mean(MeanTau1))]);
% disp([cellType,' MeanTau2 ',num2str(mean(MeanTau2))]);

%% Writes to .xlsx file
if saveData
    % Initialize output data file with header
    Header = {'cell','treatment','slide','field', ...
        'Redox','NADH Threshold','FAD Threshold',...
        'TauM','A1','Tau1','A2','Tau2','A1/A2','Tau2/Tau1', ...
        'TauM lipid','A1 lipid','Tau1 lipid','A2 lipid','Tau2 lipid','A1/A2 lipid','Tau2/Tau1 lipid',...
        'TauM FAD','A1 FAD','Tau1 FAD','A2 FAD','Tau2 FAD','A1/A2 FAD','Tau2/Tau1 FAD' ...
        };
    
    % Concatenate data columns
    DataPack = horzcat(MeanRedox,Threshold,Threshold_F, ...
        MeanTauM,MeanA1,MeanTau1,MeanA2,MeanTau2,MeanA1overA2,MeanTau2overTau1, ...
        MeanTauM_L,MeanA1_L,MeanTau1_L,MeanA2_L,MeanTau2_L,MeanA1overA2_L,MeanTau2overTau1_L, ...
        MeanTauM_F,MeanA1_F,MeanTau1_F,MeanA2_F,MeanTau2_F,MeanA1overA2_F,MeanTau2overTau1_F); 
    DataPack = horzcat(RunList(:,1:4),num2cell(DataPack));
    
    DataPack = vertcat(Header,DataPack);
    xlswrite(['redox-flim_',dataGroup,'.xlsx'],DataPack);
    disp(['Mean values saved to ', 'redox-flim_',dataGroup,'.xlsx']);
end %if saveData

fclose('all');
disp('DONE!');