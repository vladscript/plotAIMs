%% Script to Watch Data Setup #############################################
close all;
% It requires previously loaded data at: \Data Demo\AIMs.mat
% Labels @AIMs.mat:
% DYSKA, DYSKC, AMAN, CLZ
load([pwd,'\Data Demo\AMANplusCLZ.mat']);
Labels={'LDOPA+veh','+AMAN','LDOPA+veh','+CLZ','LDOPA+veh','+AMAN+CLZ'};
% Run once and paste AIMs data from sheet
% DYSKVEH=[];
% AMANCLZ=[];

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
[~,AIMS_DYSKAC]=plot_aims(DYSKAC,TypeDysk,Intervals);
[~,AIMS_AMANCLZ]=plot_aims(AMANCLZ,TypeDysk,Intervals);
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
DYSKACaims=getfield(AIMS_DYSKAC,KindofAIMs);
AMANCLZaims=getfield(AIMS_AMANCLZ,KindofAIMs);

% Raincouds of AIMs Time & Raincloud+Boxplot of Session ******************
[~,~,ColorsALL]=plot_aims_time(DYSKAaims,...
                    AMANaims,DYSKCaims,CLZaims,DYSKACaims,AMANCLZaims,...
                    Labels,Intervals);
% By pairs:
[ScoresAMAN,DeltaAMAN,~]=plot_aims_time(DYSKAaims,AMANaims,...
                    Labels(1:2),Intervals);
[ScoresCLZ,DeltaCLZ,~]=plot_aims_time(DYSKCaims,CLZaims,...
                    Labels(3:4),Intervals);
[ScoresAMANCLZ,DeltaAMANCLZ,~]=plot_aims_time(DYSKACaims,AMANCLZaims,...
                    Labels(5:6),Intervals);
                
%% Deltas Figure **********************************************************

% Raincloud:
figure;
stepplot=0.10;
% FIRST:
ActualColor=double(imadd(uint8(255*ColorsALL(1,:)),uint8(255*ColorsALL(2,:)),'uint8'))/255;
DeltaPlotA=raincloud_plot(100-DeltaAMAN,'color',ActualColor,'box_on',1,'alphaval',1,...
    'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', ...
    stepplot, 'box_col_match',0);
stepplot=stepplot+0.30;

% SECOND:
ActualColor=double(imadd(uint8(255*ColorsALL(3,:)),uint8(255*ColorsALL(4,:)),'uint8'))/255;
DeltaPlotB=raincloud_plot(100-DeltaCLZ,'color',ActualColor,'box_on',1,'alphaval',1,...
    'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', ...
    stepplot, 'box_col_match',0);
stepplot=stepplot+0.30;

% THIRD:
ActualColor=double(imadd(uint8(255*ColorsALL(5,:)),uint8(255*ColorsALL(6,:)),'uint8'))/255;
DeltaPlotC=raincloud_plot(100-DeltaAMANCLZ,'color',ActualColor,'box_on',1,'alphaval',1,...
    'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', ...
    stepplot, 'box_col_match',0);
stepplot=stepplot+0.30;

DeltaFig2=gca;
DeltaFig2.Title.String='% Total AIMs Reduction';
DeltaFig2.Title.Interpreter='tex';
axis tight; grid on;
legend([DeltaPlotA{1},DeltaPlotB{1},DeltaPlotC{1}],{'+Amantadine','+Clozapine','+Amantadine+Clozapine'})


% %% TIME BOXPLOTS AIMs 
% % AIMs Time Boxplots Series in the seme Figure
% plot_aims(DYSKA,TypeDysk,Intervals,ColorsALL);
% plot_aims(AMAN,TypeDysk,Intervals,ColorsALL);
% plot_aims(DYSKC,TypeDysk,Intervals,ColorsALL);
% plot_aims(CLZ,TypeDysk,Intervals,ColorsALL);
% plot_aims(DYSKAC,TypeDysk,Intervals,ColorsALL);
% plot_aims(AMANCLZ,TypeDysk,Intervals,ColorsALL);
% FigAimsAMAN=gcf;
% FigAimsAMAN.Name=['Boxplots ',Labels{1},' & ',Labels{2}];

%% PLOTS ****************************************************************
% % STD BAR:
% plot_mean_std(ColorsALL,Labels,KindofAIMs,'STD',DYSKAaims,AMANaims,DYSKCaims,CLZaims,DYSKACaims,AMANCLZaims)
% % SEM bar
plot_mean_std(ColorsALL,Labels,KindofAIMs,'SEM',DYSKAaims,...
    AMANaims,DYSKCaims,CLZaims,DYSKACaims,AMANCLZaims);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%% Tests ##################################################################
% SESSION SCORES TESTS 
% t-TEST
[h,p]=ttest(ScoresAMANCLZ(:,1),ScoresAMANCLZ(:,2),'Tail','right')

% 
% [h,p]=vartest2(ScoresAMAN(:,1),ScoresAMAN(:,2))
% [h,p]=vartest2(ScoresCLZ(:,1),ScoresCLZ(:,2))
% 
[p,h]=signtest(ScoresAMANCLZ(:,1),ScoresAMANCLZ(:,2),'Tail','right')


% Wilcoxon rank sum test
[p,h]=ranksum(ScoresAMANCLZ(:,1),ScoresAMANCLZ(:,2),'Tail','right')

% 
[p,h] = signrank(ScoresAMANCLZ(:,1),ScoresAMANCLZ(:,2),'Tail','right')

% 
% % Unpaired
% [h,p]=ttest2(ScoresAMAN(:,1),ScoresCLZ(:,1))
% [h,p]=ttest2(ScoresAMAN(:,2),ScoresCLZ(:,2))

%  tests for means, medians, tests for column effects ####################



% Kruskal-Wallis is basically a non-parametric version of ANOVA 
% [p,tbl,stats]=kruskalwallis(ScoresAMAN)
% c = multcompare(stats);
% There is also a non-parametric version of repeated-measure ANOVA, which is called Friedman test.
[p,tbl,stats] = friedman(ScoresAMANCLZ)
c = multcompare(stats);
% 
% [p,tbl,stats]=kruskalwallis(ScoresCLZ)
% c = multcompare(stats);
% 
% [p,tbl,stats] = friedman(ScoresCLZ)
% c = multcompare(stats);

%% TIME EVALUATION COMPARATION
% AIMs: {all, lo, li, Ax, Ol}
KindofAIMs='all';
DYSKVEHaims=getfield(AIMS_DYSKA,KindofAIMs);
AMANCLZaims=getfield(AIMS_AMANCLZ,KindofAIMs);


% Tests for all Time Sets of AIMs
for n=1:9
        
    %     AMANTADINE  +CLOZAPINE      # # #
    A=DYSKVEHaims(:,n);
    B=AMANCLZaims(:,n);
    
    
    % Wilcoxon signed rank test
    % [PVALW_A(n),WILCTEST_A(n)] = signrank(A,B);
    % [PVALW_C(n),WILCTEST_C(n)] = signrank(C,D);

    % t.test
    [TTEST_A(n),PVAL_A(n)]=ttest(A,B,'Tail','right');
    


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
