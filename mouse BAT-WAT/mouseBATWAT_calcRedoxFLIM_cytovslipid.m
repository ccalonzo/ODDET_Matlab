%% Load metadata
[~,~,RunList] = xlsread('sevi_mouse_BAT-WAT.xlsx');
InputHeader = RunList(1,:);
RunList = RunList(2:end,:);
dataGroup = '20140611_mousebatwat-all';

%% Execution switches
saveImages = true;
displayImages = false;
saveData = false;

%% Assign some constants for image rendering
flimScaleMin = 1000;
flimScaleMax = 2500;
flimScaleMin_F = 1000;
flimScaleMax_F = 2500;
bright = 0.90;
dark = 0.05;
bright_F = 0.95;
dark_F = 0.05;
redoxBright = 0.95;
redoxDark = 0.05;
redoxRed = 0.8;
redoxBlue = 0.0;

%% Intialize array containers for output
listLength = size(RunList,1);

NADHThreshold = zeros(listLength,1);
FADThreshold = zeros(listLength,1);
SHGThreshold = zeros(listLength,1);
MeanRedox = zeros(listLength,1);
MeanTauM = zeros(listLength,1);
MeanA1 = zeros(listLength,1);
MeanTau1 = zeros(listLength,1);
MeanA2 = zeros(listLength,1);
MeanTau2 = zeros(listLength,1);
MeanA1overA2 = zeros(listLength,1);
MeanTau2overTau1 = zeros(listLength,1);

% MeanTauM_F = zeros(listLength,1);
% MeanA1_F = zeros(listLength,1);
% MeanTau1_F = zeros(listLength,1);
% MeanA2_F = zeros(listLength,1);
% MeanTau2_F = zeros(listLength,1);
% MeanA1overA2_F = zeros(listLength,1);
% MeanTau2overTau1_F = zeros(listLength,1);
% 
% MeanTauM_L = zeros(listLength,1);
% MeanA1_L = zeros(listLength,1);
% MeanTau1_L = zeros(listLength,1);
% MeanA2_L = zeros(listLength,1);
% MeanTau2_L = zeros(listLength,1);
% MeanA1overA2_L = zeros(listLength,1);
% MeanTau2overTau1_L = zeros(listLength,1);


% wtbat-31 m = 13;
% wtepi-31 m = 21;
% wtsub-31 m = 34;
% kosub-31 m = 42;

%%Iterate through RunList
for m = 1:listLength
% Extract labels from RunList
    tissueType = RunList{m,1};
    treatment = RunList{m,2};
    slide = RunList{m,3};
    field = RunList{m,4};
    power755 = RunList{m,5};
    power860 = RunList{m,6};
    power900 = RunList{m,7};
    
    %% Load image files
    fname = [tissueType,treatment,'-',num2str(slide),num2str(field)];
    [Int755,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults([fname,'_ex755']);
    [Int860,TauM_F,A1_F,A2_F,Tau1_F,Tau2_F] = loadFlimFitResults([fname,'_ex860']);
    Int900 = loadFlimFitResults([fname,'_ex900']);

%     %% Coregister
%     [Int860] = CoRegisterNormxcorr2(Int755,Int860);
%     [Int900] = CoRegisterNormxcorr2(Int860,Int900);

    %% Create intensity threshold mask
    tweak = 1.0; %tweak threshold to be more(>1) or less(<1) agressive
    NADHThreshold(m) = adaptiveThreshold(Int755);
    NADHMask = (Int755) > NADHThreshold(m);
    FADThreshold(m) = adaptiveThreshold(Int860);
    FADMask = (Int860) > FADThreshold(m);
    SHGThreshold(m) = adaptiveThreshold(Int900);
    SHGMask = (Int900) > SHGThreshold(m);

    CellMask = antiSmall(NADHMask & FADMask, 10);
    LipidMask = NADHMask & ~FADMask;

    %% Normalize by laser power
    Int755 = Int755/power755^2;
    Int860 = Int860/power860^2;    
    Int900 = Int900/power900^2;    
    
    %% Redox ratio
    Redox = Int860 ./ (Int755 + Int860);
    Redox(isnan(Redox)) = 0; % set divide-by-zero to zero

    %% Fast to slow ratio
    A1overA2 = A1./A2;
    A1overA2(isnan(A1overA2)) = 0;  % set divide-by-zero to zero
    A1overA2(isinf(A1overA2)) = 0;  % set divide-by-zero to zero
    
    Tau2overTau1 = Tau2./Tau1;
    Tau2overTau1(isnan(Tau2overTau1)) = 0;  % set divide-by-zero to zero
    Tau2overTau1(isinf(Tau2overTau1)) = 0;  % set divide-by-zero to zero
    
    %% Pretty images
    if displayImages||saveImages
        Flimage755 = prettyFlim(TauM,Int755,'none',flipud(jet(64)),...
            flimScaleMax,flimScaleMin,bright,dark);
        Flimage860 = prettyFlim(TauM_F,Int860,'none',flipud(jet(64)),...
            flimScaleMax_F,flimScaleMin_F,bright_F,dark_F);
        % These maps are drawn with a reversed jet colormap to match the
        % SPCImage software
        Redox2 = prettyRedox(Redox,Int860+Int755,'none',jet(64),...
            redoxRed,redoxBlue,redoxBright,redoxDark);
        Pretty755 = prettyGray(Int755,bright,dark);
        Pretty860 = prettyGray(Int860,bright,dark);
        Pretty900 = prettyGray(Int900,bright,dark);
%         PrettyA1overA2 = prettyFlim(A1overA2,Intensity,'none',flipud(jet(64)),4,1); %scale A1/A2 ration from 1 to 4.
%         PrettyA1 = prettyFlim(A1,Intensity,'none',flipud(jet(64)),1,0); %scale from 0 to 1.
    % Segmented image
%         Flimage2 = prettyFlim(TauM,Intensity.*CellMask,'none',flipud(jet(64)),FlimScaleMax,FlimScaleMin);
        Segments = (2*uint8(LipidMask) + uint8(CellMask));
        cmp = [0 0 0; 0.8 0.8 0; 0 0.2 1; 0.8 0.8 0.8];
    % Resize images for better viewing 
        Flimage755 = imresize(Flimage755,2,'bilinear');
        Flimage860 = imresize(Flimage860,2,'bilinear');
        Redox2 = imresize(Redox2,2,'bilinear');
        Pretty755 = imresize(Pretty755,2,'bilinear');
        Pretty860 = imresize(Pretty860,2,'bilinear');
        Pretty900 = imresize(Pretty900,2,'bilinear');
        Overlay = cat(3,Pretty860,Pretty755,Pretty900);      
%         Segments = imresize(Segments,2,'nearest');
     % Collage
        PrettyCollage = collage2x2(Overlay,Redox2,Flimage755,Flimage860,2);
        GrayCollage = collage1x3(Pretty755,Pretty860,Pretty900,2);
    end %if displayImages||saveImages
    
    %% Display Images
    if displayImages
        %figure('Name',fname,'Position',[2400,200,600,600]);
        figure('Name',fname);%,'Position',[2000,50,600,600]);
        image(PrettyCollage); axis image off;
        figure('Name',fname);
        subplot(1,2,1); image(GrayCollage); axis image off;        
        subplot(1,2,2); image(ind2rgb(Segments,cmp));axis image off; 
%         subplot(2,2,1);image(Flimage755); axis image off; title('NADH \tau _m');
%         subplot(2,2,2);image(Flimage860); axis image off; title('FAD \tau _m');
%         subplot(2,2,3);image(Redox2); axis image off; title('Redox');
%         subplot(2,2,4);image(Overlay); axis image off; title('TPEF+SHG'); 
%         subplot(2,2,3);imagesc(Pretty860); axis image off; title('FAD Intensity'); colormap(gray);
%         subplot(2,2,4);imagesc(Pretty900); axis image off; title('SHG Intensity'); colormap(gray);
%         subplot(2,2,4);image(ind2rgb(Segments,cmp));axis image; axis off; title('Segments');        
    end %if displayImages

    %% Save Images
    if saveImages
        fname = [tissueType,treatment,'-',num2str(slide),num2str(field)];
        imwrite(PrettyCollage,['colors_',fname,'.tif']);
        imwrite(GrayCollage,['grays_',fname,'.tif']); 
        disp([fname,' images saved.']);
%         imwrite(Flimage755,['flim755_',fname,'_',num2str(FlimScaleMin),'-',num2str(FlimScaleMax),'.tif']);  
%             disp(['flim_',fname,'.tif',' saved.']);
%         imwrite(Flimage860,['flim860_',fname,'_',num2str(FlimScaleMin_F),'-',num2str(FlimScaleMax_F),'.tif']);  
%             disp(['flim_',fname,'.tif',' saved.']);
%         imwrite(redox2,['redox_',fname,'.tif']);  disp(['redox_',fname,'.tif',' saved.']);
        imwrite(Segments,cmp,['segments_',fname,'.tif']);
%         imwrite(real(CellMask),['mask_',fname,'_',num2str(tweak),'.tif']); disp(['mask_',fname,'.tif',' saved.']);
    end %if saveImages
    
    %% Calculate mean values
    if saveData
        MeanTauM(m) = sum(sum(CellMask.*TauM)) ./ sum(sum(CellMask));
        MeanA1(m) = sum(sum(CellMask.*A1)) ./ sum(sum(CellMask));
        MeanTau1(m) = sum(sum(CellMask.*Tau1)) ./ sum(sum(CellMask));
        MeanA2(m) =  sum(sum(CellMask.*A2)) ./ sum(sum(CellMask));
        MeanTau2(m) = sum(sum(CellMask.*Tau2)) ./ sum(sum(CellMask));
        MeanA1overA2(m) = sum(sum(CellMask.*A1overA2)) ./ sum(sum(CellMask));
        MeanTau2overTau1(m) = sum(sum(CellMask.*Tau2overTau1)) ./ sum(sum(CellMask));

%     MeanTauM_L(m) = sum(sum(LipidMask.*TauM)) ./ sum(sum(LipidMask));
%     MeanA1_L(m) = sum(sum(LipidMask.*A1)) ./ sum(sum(LipidMask));
%     MeanTau1_L(m) = sum(sum(LipidMask.*Tau1)) ./ sum(sum(LipidMask));
%     MeanA2_L(m) =  sum(sum(LipidMask.*A2)) ./ sum(sum(LipidMask));
%     MeanTau2_L(m) = sum(sum(LipidMask.*Tau2)) ./ sum(sum(LipidMask));
%     MeanA1overA2_L(m) = sum(sum(LipidMask.*A1overA2)) ./ sum(sum(LipidMask));
%     MeanTau2overTau1_L(m) = sum(sum(LipidMask.*Tau2overTau1)) ./ sum(sum(LipidMask));

%     MeanTauM_F(m) = sum(sum(CellMask.*TauM)) ./ sum(sum(CellMask));
%     MeanA1_F(m) = sum(sum(CellMask.*A1)) ./ sum(sum(CellMask));
%     MeanTau1_F(m) = sum(sum(CellMask.*Tau1)) ./ sum(sum(CellMask));
%     MeanA2_F(m) =  sum(sum(CellMask.*A2)) ./ sum(sum(CellMask));
%     MeanTau2_F(m) = sum(sum(CellMask.*Tau2)) ./ sum(sum(CellMask));
%     MeanA1overA2_F(m) = sum(sum(CellMask.*A1overA2)) ./ sum(sum(CellMask));
%     MeanTau2overTau1_F(m) = sum(sum(CellMask.*Tau2overTau1)) ./ sum(sum(CellMask));    
     
    %% Calculate mean redox values
        MeanRedox(m) = sum(Int860(CellMask))./sum((Int860(CellMask)+Int755(CellMask)));
%     CellLabel{m} = cellType;
    end %if saveData
    
end %for  m = 1:listLength

% disp([cellType,'d',num2str(day),' MeanTauM ',num2str(mean(MeanTauM))]);
% disp([cellType,' MeanTau1 ',num2str(mean(MeanTau1))]);
% disp([cellType,' MeanTau2 ',num2str(mean(MeanTau2))]);

%% Writes to .xlsx file
if saveData
    % Initialize output data file with header
%     Header = {'cell','treatment','slide','field', ...
%         'Redox','NADH Threshold','FAD Threshold',...
%         'TauM','A1','Tau1','A2','Tau2','A1/A2','Tau2/Tau1', ...
%         'TauM lipid','A1 lipid','Tau1 lipid','A2 lipid','Tau2 lipid','A1/A2 lipid','Tau2/Tau1 lipid',...
%         'TauM FAD','A1 FAD','Tau1 FAD','A2 FAD','Tau2 FAD','A1/A2 FAD','Tau2/Tau1 FAD' ...
%         };
%     
%     % Concatenate data columns
%     DataPack = horzcat(MeanRedox,Threshold,Threshold_F, ...
%         MeanTauM,MeanA1,MeanTau1,MeanA2,MeanTau2,MeanA1overA2,MeanTau2overTau1, ...
%         MeanTauM_L,MeanA1_L,MeanTau1_L,MeanA2_L,MeanTau2_L,MeanA1overA2_L,MeanTau2overTau1_L, ...
%         MeanTauM_F,MeanA1_F,MeanTau1_F,MeanA2_F,MeanTau2_F,MeanA1overA2_F,MeanTau2overTau1_F); 
%     DataPack = horzcat(RunList(:,1:4),num2cell(DataPack));
    
    DataPack = vertcat(Header,DataPack);
    xlswrite(['redox-flim_',dataGroup,'.xlsx'],DataPack);
    disp(['Mean values saved to ', 'redox-flim_',dataGroup,'.xlsx']);
end %if saveData

fclose('all');
disp('DONE!');