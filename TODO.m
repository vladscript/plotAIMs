%% Ready 2 GITHUB
% FOR DYSKINESIA DATA run:
% >>ScriptTest
%% TO DO list
% 

%% Guide to plot AIMs Scores
% Main Function: plot_aims
% Options: 
% global/global-sum/basic
% /amplitude/...
% ALO-sum/ALO-basic

% TYPE: 
% >>help plot_aims

% >>CONDITION_A=[]
% % COPYDATA TO EMPTY MATRIX CONDITION_A
% >>[SessionScore_A,AIMs_D1]=plot_aims(CONDITION_A,'global');
% % To add plots at the same figure:
% >>CONDITION_B=[];
% % COPYDATA TO EMPTY MATRIX CONDITION_B
% >>[SessionScore_B,AIMs_B]=plot_aims(CONDITION_B,'global');

% PLOT Session Scores:
% >>Labels={'Condition A';'Condition B'};
% >>plot_session(SessionScore_A,SessionScore_B,Labels);

% Plot Rainclouds For AIMsData Output
% plot_aims_time(AIMs_D1.all,AIMs_D2.all,Labels);

% PLOT TOTAL Speceific AIMs
% >>plot_session(SessionScore_A,SessionScore_B,Labels);