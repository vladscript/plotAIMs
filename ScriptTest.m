%% Script to Watch Data Setup #############################################
close all;
% It requires previously loaded data at: \Data Demo\AIMs.mat
% Labels @AIMs.mat:
% DYSKA, DYSKC, AMAN, CLZ
load([pwd,'\Data Demo\AIMsData.mat']);
Labels={'DYSK_A','+Amantadine','DYSK_C','+Clozapine'};
% Run once and paste AIMs data from sheet
% DYSKA=[];
% AMAN=[];
% DYSKC=[];
% CLZ=[];

%  AIMs Score Options ##############################################
% See Description:
% >>help plot_aims
% /global/global-sum/,
% /basic/amplitude/,
% /ALO-sum/ALO-basic/
TypeDysk='global';
% TimeIntervals: indexes for Minute Intervals:
%   [20,40,60,80,100,120,140,160,180]
%   [ 1, 2, 3, 4,  5,  6,  7,  8,  9]
% Intervals=[2,3,4];
Intervals=1:9;

% plot_session(S_DYSKA,S_AMAN,S_DYSKC,S_CLZ,Labels);
%% TIME BOXPLOTS AIMs                                 [All Together]
% AIMs Time Boxplots Series in the same Figure
[~,AIMS_DYSKA]=plot_aims(DYSKA,TypeDysk,Intervals);
[~,AIMS_AMAN]=plot_aims(AMAN,TypeDysk,Intervals);
[~,AIMS_DYSKC]=plot_aims(DYSKC,TypeDysk,Intervals);
[~,AIMS_CLZ]=plot_aims(CLZ,TypeDysk,Intervals);
FigAimsCLZ=gcf;
FigAimsCLZ.Name=['All Boxplots '];

%% RAINCLOUD PLOTS                         [SESSION,TEMPORAL,DELTASESSION]          

% Setup:
% AIMs: {all, lo, li, Ax, Ol}
KindofAIMs='all';

% Get Data:
DYSKAaims=getfield(AIMS_DYSKA,KindofAIMs);
AMANaims=getfield(AIMS_AMAN,KindofAIMs);
DYSKCaims=getfield(AIMS_DYSKC,KindofAIMs);
CLZaims=getfield(AIMS_CLZ,KindofAIMs);

% Raincouds of AIMs Time & Raincloud+Boxplot of Session ******************
[ScoresAMAN,DeltaScoreAMAN,ColorsAMAN]=plot_aims_time(DYSKAaims,AMANaims,...
                    Labels(1:2),Intervals);
[ScoresCLZ,DeltaScoreCLZ,ColorsCLZ]=plot_aims_time(DYSKCaims,CLZaims,...
                    Labels(3:4),Intervals);
% Deltas Figure **********************************************************
% Simple Boxplot:
% columns2boxplot(100-DeltaScoreAMAN,100-DeltaScoreCLZ,{'+AMAN';'+CLZ'})
% DeltaFig=gca;
% DeltaFig.YLim=[0,100];
% DeltaFig.Title.String='% Total AIMs Reduction ';
% DeltaFig.Title.Interpreter='tex';

% Raincloud:
figure;
stepplot=0.10;
% FIRST:
ActualColor=double(imadd(uint8(255*ColorsAMAN(1,:)),uint8(255*ColorsAMAN(2,:)),'uint8'))/255;
DeltaPlotA=raincloud_plot(100-DeltaScoreAMAN,'color',ActualColor,'box_on',1,'alphaval',1,...
    'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', ...
    stepplot, 'box_col_match',0);
stepplot=stepplot+0.30;
% SECOND:
ActualColor=double(imadd(uint8(255*ColorsCLZ(1,:)),uint8(255*ColorsCLZ(2,:)),'uint8'))/255;
DeltaPlotC=raincloud_plot(100-DeltaScoreCLZ,'color',ActualColor,'box_on',1,'alphaval',1,...
    'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', ...
    stepplot, 'box_col_match',0);
stepplot=stepplot+0.30;
DeltaFig2=gca;
DeltaFig2.Title.String='% Total AIMs Reduction';
DeltaFig2.Title.Interpreter='tex';
legend([DeltaPlotA{1},DeltaPlotC{1}],'+Amantadine','+Clozapine')
grid on;

%% TIME BOXPLOTS AIMs 
% AIMs Time Boxplots Series in the seme Figure
plot_aims(DYSKA,TypeDysk,Intervals,ColorsAMAN);
plot_aims(AMAN,TypeDysk,Intervals,ColorsAMAN);
FigAimsAMAN=gcf;
FigAimsAMAN.Name=['Boxplots ',Labels{1},' & ',Labels{2}];
plot_aims(DYSKC,TypeDysk,Intervals,ColorsCLZ);
plot_aims(CLZ,TypeDysk,Intervals,ColorsCLZ);
FigAimsCLZ=gcf;
FigAimsCLZ.Name=['Boxplots ',Labels{3},' & ',Labels{4}];

%% Tests ##################################################################
% SESSION SCORES TESTS 
% t-TEST
[h,p]=ttest(ScoresAMAN(:,1),ScoresAMAN(:,2),'Tail','right')
[h,p]=ttest(ScoresCLZ(:,1),ScoresCLZ(:,2),'Tail','right')
% 
% [h,p]=vartest2(ScoresAMAN(:,1),ScoresAMAN(:,2))
% [h,p]=vartest2(ScoresCLZ(:,1),ScoresCLZ(:,2))
% 
[p,h]=signtest(ScoresAMAN(:,1),ScoresAMAN(:,2),'Tail','right')
[p,h]=signtest(ScoresCLZ(:,1),ScoresCLZ(:,2),'Tail','right')

% Wilcoxon rank sum test
[p,h]=ranksum(ScoresAMAN(:,1),ScoresAMAN(:,2),'Tail','right')
[p,h]=ranksum(ScoresCLZ(:,1),ScoresCLZ(:,2),'Tail','right')
% 
[p,h] = signrank(ScoresAMAN(:,1),ScoresAMAN(:,2),'Tail','right')
[p,h] = signrank(ScoresCLZ(:,1),ScoresCLZ(:,2),'Tail','right')
% 
% % Unpaired
% [h,p]=ttest2(ScoresAMAN(:,1),ScoresCLZ(:,1))
% [h,p]=ttest2(ScoresAMAN(:,2),ScoresCLZ(:,2))

%  tests for means, medians, tests for column effects ####################



% Kruskal-Wallis is basically a non-parametric version of ANOVA 
% [p,tbl,stats]=kruskalwallis(ScoresAMAN)
% c = multcompare(stats);
% There is also a non-parametric version of repeated-measure ANOVA, which is called Friedman test.
% [p,tbl,stats] = friedman(ScoresAMAN)
% c = multcompare(stats);
% 
% [p,tbl,stats]=kruskalwallis(ScoresCLZ)
% c = multcompare(stats);
% 
% [p,tbl,stats] = friedman(ScoresCLZ)
% c = multcompare(stats);

%% TIME EVALUATION COMPARATION
% AIMs: {all, lo, li, Ax, Ol}
KindofAIMs='all';
DYSKAaims=getfield(AIMS_DYSKA,KindofAIMs);
AMANaims=getfield(AIMS_AMAN,KindofAIMs);
DYSKCaims=getfield(AIMS_DYSKC,KindofAIMs);
CLZaims=getfield(AIMS_CLZ,KindofAIMs);

% Tests for all Time Sets of AIMs
for n=1:9
        
    %     AMANTADINE        # # #
    A=DYSKAaims(:,n);
    B=AMANaims(:,n);
    
    %     CLOZAPINE         # # #
    C=DYSKCaims(:,n);
    D=CLZaims(:,n);
    
    % Wilcoxon signed rank test
    % [PVALW_A(n),WILCTEST_A(n)] = signrank(A,B);
    % [PVALW_C(n),WILCTEST_C(n)] = signrank(C,D);

    % t.test
    [TTEST_A(n),PVAL_A(n)]=ttest(A,B,'Tail','right');
    [TTEST_C(n),PVAL_C(n)]=ttest(C,D,'Tail','right');


%     [SIGNTEST(n),PVALS(n)] = vartest2(A,B);
%     [PVALR(n),RANKTEST(n)] = ranksum(A,B);
%     
%     
%     
%     [PVALWC(n),WILCTESTC(n)] = signrank(C,D);
%     [SIGNTESTC(n),PVALSC(n)] = vartest2(C,D);
%     [PVALRC(n),RANKTESTC(n)] = ranksum(C,D);
    fprintf('*')
end
fprintf('\n')
%% PLOTS ****************************************************************
% % ERROR BARS
%     MeanAIMs=mean(DYSKAaims);
%     errAIMs=std(DYSKAaims);
%     figure
%     errorbar(MeanAIMs,errAIMs,'Color',ColorsAMAN(1,:),'LineWidth',3);
%     hold on
%     MeanAIMs=mean(AMANaims);
%     errAIMs=std(AMANaims);
%     errorbar(MeanAIMs,errAIMs,'Color',ColorsAMAN(2,:),'LineWidth',3);
%     legend({'+Vehicle','+ Amantadine'})
% % ERROR BARS
%     MeanAIMs=mean(DYSKCaims);
%     errAIMs=std(DYSKCaims);
%     figure
%     errorbar(MeanAIMs,errAIMs,'Color',ColorsCLZ(1,:),'LineWidth',3);
%     hold on
%     MeanAIMs=mean(CLZaims);
%     errAIMs=std(CLZaims);
%     errorbar(MeanAIMs,errAIMs,'Color',ColorsCLZ(2,:),'LineWidth',3);
%     legend({'+Vehicle','+ Clozapine'})
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 