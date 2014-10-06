%% Load results from summary data file
[~,~,Results] = xlsread('RedoxFLIM_20140926_Adipo_t3.xlsx');
Header = Results(1,:);
ResultsData = Results(2:end,:);
clear Results;

% Extract group label
% 1 = cell, 2 = time, 3 = well, 4 = field
countDataEntries = size(ResultsData,1);
Groups = cell(countDataEntries,1);
for k = 1:countDataEntries;
    Groups{k} = [ResultsData{k,1},'_wk',num2str(ResultsData{k,2})];
end 

% Calc stats on unfiltered dataset
% 5 = redox, 6 = TauM, 7 = A1, 8 = Tau1, 9 = A2, 10 = Tau2, 18 = Chi
colOfInterest = 18;
QtyOfInterest = cell2mat(ResultsData(:,colOfInterest));
[means,sd,se,grp] = grpstats(QtyOfInterest,Groups,{'mean','std','sem','gname'});
[p_anova,~,stats] = anova1(QtyOfInterest,Groups,'off');
figure('Name',Header{colOfInterest});multcompare(stats,'alpha',0.05);
set(gcf,'Name',Header{colOfInterest});
display([Header{colOfInterest},' ANOVA p-value is ', num2str(p_anova)]);

figure; barWithErrors(means,sd);
set(gca,'XTickLabel',grp);
set(gca,'FontSize',12);

ylabel(Header{colOfInterest}); 
% figure; barWithErrors(reshape(means,7,2),reshape(sd,7,2),[0:6]');
% ylabel(Header{colOfInterest}); 
% xlabel('time (weeks)');

%% Plot bar graphs
GroupsCellTime = {ResultsData(:,1),cell2mat(ResultsData(:,2))};
[means,sd,se,grp] = grpstats(QtyOfInterest,GroupsCellTime,{'mean','std','sem','gname'});

%% Compare FCCP treatment using anova1
% 5 = redox, 6 = TauM, 7 = A1, 8 = Tau1, 9 = A2, 10 = Tau2 
% colOfInterest = 5;
% QtyOfInterest = cell2mat(ResultsData(:,colOfInterest));
% Select FCCP vs adipo treatments
% SelectSubset = strcmp('fccp50t3',Groups)|strcmp('adipot3',Groups);
% GroupsSubset = Groups(SelectSubset);
% QtyOfInterestSubset = QtyOfInterest(SelectSubset);
% 
% [means,sd,se,grp] = grpstats(QtyOfInterestSubset,GroupsSubset,{'mean','std','sem','gname'});
% [p_anova,~,stats] = anova1(QtyOfInterestSubset,GroupsSubset,'off');
% figure('Name',Header{colOfInterest});multcompare(stats);
% set(gcf,'Name',Header{colOfInterest});
% display(['ANOVA p-value is ', num2str(p_anova)]);

% %% Create subset for stat analysis
% % 5 = redox, 6 = TauM, 7 = A1, 8 = Tau1, 9 = A2, 10 = Tau2 
% colOfInterest = 5;
% QtyOfInterest = cell2mat(ResultsData(:,colOfInterest));
% % Exclude FCCP treatments
% SelectSubset = ~(strcmp('fccp5t2',Groups)|strcmp('fccp50t3',Groups)|...
%     strcmp('fccp100t3',Groups)|strcmp('adipot3',Groups));
% GroupsSubset = Groups(SelectSubset);
% QtyOfInterestSubset = QtyOfInterest(SelectSubset);
% [means,sd,se,grp] = grpstats(QtyOfInterestSubset,GroupsSubset,{'mean','std','sem','gname'});
% [p_anova,~,stats] = anova1(QtyOfInterestSubset,GroupsSubset,'off');
% figure('Name',Header{colOfInterest});multcompare(stats);
% set(gcf,'Name',Header{colOfInterest});
% display(['ANOVA p-value is ', num2str(p_anova)]);

%% Compare FCCP treatment using ttest
% 5 = redox, 6 = TauM, 7 = A1, 8 = Tau1, 9 = A2, 10 = Tau2 
colOfInterest = 6;
QtyOfInterest = cell2mat(ResultsData(:,colOfInterest));
% Select FCCP vs adipo treatments
SelectSubset1 = strcmp('fccp50t3',Groups);
SelectSubset2 = strcmp('adipot3',Groups);
QtyOfInterestSubset1 = QtyOfInterest(SelectSubset1);
QtyOfInterestSubset2 = QtyOfInterest(SelectSubset2);
[h,p] = ttest(QtyOfInterestSubset1,QtyOfInterestSubset2);
display(['t-test p-value is ', num2str(p)]);

