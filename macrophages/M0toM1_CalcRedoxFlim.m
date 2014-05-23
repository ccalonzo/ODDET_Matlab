%% Load metadata
[~,~,RunList] = xlsread('20140508_M0toM1.xlsx');
InputHeader = RunList(1,:);
RunList = RunList(2:end,:);
dataGroup = '20140508_M0toM1';

%% Execution switches
saveImages = true;
displayImages = true;
saveData = true;

%% Assign some constants for image rendering
flimScaleMin = 1000;
flimScaleMax = 3000;
bright = 0.95;
dark = 0.05;
redoxBright = 0.95;
redoxDark = 0.05;
redoxRed = 0.5;
redoxBlue = 0.0;


%% Intialize array containers for output
listLength = size(RunList,1);

Threshold = zeros(listLength,1); %Intensity threshold for NADH channel
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
% NuclearTauM = zeros(listLength,1);

%%Iterate through RunList
for m = 1:listLength
    %% Extract metadata from RunList
    cellType = RunList{m,1};
    timept = RunList{m,2};
    well = RunList{m,3};
    field = RunList{m,4};
    power755 = RunList{m,5};
    power860 = RunList{m,6};

    %% Load image files
    fname = [cellType,num2str(timept),'-',num2str(well),num2str(field)];
    [Int755,TauM,A1,A2,Tau1,Tau2] = loadFlimFitResults([fname,'_ex755']);
    Int860 = loadFlimFitResults([fname,'_ex860']);
    
    %% Normalize by laser power
    Int755 = Int755/power755^2;
    Int860 = Int860/power860^2;
    
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
%     Flimage = prettyFlim(TauM,Intensity,'none',flipud(jet(64)),flimScaleMax,flimScaleMin);
%     PrettyA1overA2 = prettyFlim(A1overA2,Intensity,'none',flipud(jet(64)),4,1); %scale A1/A2 ration from 1 to 4.
%     PrettyA1 = prettyFlim(A1,Intensity,'none',flipud(jet(64)),1,0); %scale from 0 to 1.
    % These maps are drawn with a reversed jet colormap to match the
    % SPCImage software
    
    %% Create intensity threshold mask
%     Threshold(m) = 500;  %in photon counts per pixel
%     tweak = 1.0; %tweak threshold to be more(>1) or less(<1) agressive
    Threshold(m) = adaptiveThreshold(Int755);
    Mask = Int755 > Threshold(m);
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
   Flimage2 = prettyFlim(TauM,Int755.*CellMask,'none',flipud(jet(64)),flimScaleMax,flimScaleMin,bright,dark);
   Redox2 = prettyRedox(Redox,(Int755+Int860).*CellMask,'none',jet(64),redoxRed,redoxBlue,redoxBright,redoxDark);
   Segments = uint8(CellMask);
   cmp = [0 0 0; 1 0 0; 1 1 0];
    
    %% Calculate mean values
    CellArea(m) = sum(CellMask(:));
    Mean755(m) = sum(sum(Int755.*CellMask));
    Mean860(m) = sum(sum(Int860.*CellMask));
    MeanRedox(m) = Mean860(m)/(Mean755(m)+Mean860(m)) / CellArea(m);
    MeanTauM(m) = sum(sum(CellMask.*TauM)) / CellArea(m);
    MeanA1(m) = sum(sum(CellMask.*A1)) / CellArea(m);
    MeanTau1(m) = sum(sum(CellMask.*Tau1)) / CellArea(m);
    MeanA2(m) =  sum(sum(CellMask.*A2)) / CellArea(m);
    MeanTau2(m) = sum(sum(CellMask.*Tau2)) / CellArea(m);
    MeanA1overA2(m) = sum(sum(CellMask.*A1overA2)) / CellArea(m);
    MeanTau2overTau1(m) = sum(sum(CellMask.*Tau2overTau1)) / CellArea(m);
    
    %% Display Images
    if displayImages
        %figure('Name',fname,'Position',[2400,200,600,600]);
        figure('Name',fname);%,'Position',[2000,50,600,600]);
        subplot(2,2,1);image(Flimage2); axis image off; title('\tau _m ');
        subplot(2,2,2);image(Redox2); axis image off; title('Redox ');
        subplot(2,2,3);imagesc(Int755); axis image off; title('NADH Intensity');
        colormap(gray(1024));
        subplot(2,2,4);image(ind2rgb(Segments,cmp));axis image; axis off; title('Segments');
%          subplot(1,2,2);image(ind2rgb(CellMask,gray(2)));axis image; axis off; title(['CellMask ',fname]);
    end %if displayImages

    %% Save Images
    if saveImages
%         imwrite(Flimage,['flim_',fname,'_',num2str(flimScaleMin),'-',num2str(flimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Flimage2,['flim_',fname,'_',num2str(flimScaleMin),'-',num2str(flimScaleMax),'.tif']);  disp(['flim_',fname,'.tif',' saved.']);
        imwrite(Redox2,['redox_',fname,'_',num2str(redoxBlue),'-',num2str(redoxRed),'.tif']);  disp(['redox',fname,'.tif',' saved.']);
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
    Header = {'cell','time','well','field','Redox','TauM','A1','Tau1','A2','Tau2','A1/A2','Tau2/Tau1','Int755','Int860','Threshold'};
    DataPack = horzcat(MeanRedox,MeanTauM,MeanA1,MeanTau1,MeanA2,MeanTau2,MeanA1overA2,MeanTau2overTau1,Mean755,Mean860,Threshold');
    DataPack = horzcat(RunList(:,1:4),num2cell(DataPack));
    DataPack = vertcat(Header,DataPack);
    xlswrite(['RedoxFLIM_',dataGroup,'.xlsx'],DataPack);
    disp(['Mean values saved to ', 'RedoxFLIM_',dataGroup,'.xlsx']);
end %if saveData

fclose('all');
disp('DONE!');