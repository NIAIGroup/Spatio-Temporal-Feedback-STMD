%% Function Description
% this function is used to display neural output along a line
% For Example£º
% start point £¨X_s,Y_s£©,end point £¨X_e,Y_e£©and  X_s = X_e or Y_s = Y_e
% Data = I(X_s,Y_s:Y:e) or Data = I(X_s:X_e,Y_s)

%% Main Function
close all;
%===================== ÑØ×Å X ÖáÕ¹Ê¾ ==========================%
% Determine the start point and end point of the line
X_Line = 128;

StartPoint = [X_Line, 1];
EndPoint = [X_Line, 500];

FloderSaveFig = [Parameter_File.folder_Global,'\','Neural Outputs of Each Layer'];
if ~exist(FloderSaveFig,'dir')
    mkdir(FloderSaveFig)
end

%%  Retina & Lamina
% Input signal
[Original_Image_XLine] = Extract_Neural_Output_Along_Line(Original_Image,StartPoint,EndPoint,0);
% Ommatidium Output
[Ommatidium_Outptut_XLine] = Extract_Neural_Output_Along_Line(Photoreceptors_Outptut,StartPoint,EndPoint,0);
% LMC Output
[LMCs_Band_Pass_Output_XLine] = Extract_Neural_Output_Along_Line(LMCs_Band_Pass_Output,StartPoint,EndPoint,0);

% Plot figure -- Input signal
figure
plot(StartPoint(2):EndPoint(2),Original_Image_XLine,'color','b','linewidth',2.0)
set(gca,'Position',[0.125 0.5 0.8 0.15]);
title('Input signal, $I(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','Input-Signal.fig'))

% Plot figure -- Ommatidium Output
figure
plot(StartPoint(2):EndPoint(2),Ommatidium_Outptut_XLine,'color','m','linewidth',2.0)
set(gca,'Position',[0.125 0.5 0.8 0.15]);
title('Ommatidium output, $P(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','Ommatidium-Output.fig'))

% Plot figure -- LMC Output
figure
plot(StartPoint(2):EndPoint(2),LMCs_Band_Pass_Output_XLine,'color','r','linewidth',2.0)
set(gca,'Position',[0.125 0.5 0.8 0.15]);
title('LMC output, $L(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','LMC-Output.fig'))

%% Medulla Layer

% ON & OFF Channel
ON_Channel_XLine = Extract_Neural_Output_Along_Line(ON_Channel,StartPoint,EndPoint,0);
ESTMD_Delayed_OFF_Channel_Xline = Extract_Neural_Output_Along_Line(ESTMD_Delayed_OFF_Channel,StartPoint,EndPoint,0);

figure
plot(StartPoint(2):EndPoint(2),ON_Channel_XLine,'color','b','linewidth',2.0)
set(gca,'Position',[0.125 0.5 0.8 0.15]);
title('Tm3 output, $S^{Tm3}(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','ESTMD-ON-Channel.fig'))

figure
plot(StartPoint(2):EndPoint(2),ESTMD_Delayed_OFF_Channel_Xline,'color','m','linewidth',2.0)
set(gca,'Position',[0.125 0.5 0.8 0.15]);
title('Tm1 output, $S^{Tm1}(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','ESTMD-OFF-Channel.fig'))

% Spatio-Temporal Feedback -- ON and OFF Channel
Spatio_Temporal_Feedback_ON_Channel_XLine = Extract_Neural_Output_Along_Line(Spatio_Temporal_Feedback_ON_Channel,StartPoint,EndPoint,0);
Spatio_Temporal_Feedback_OFF_Channel_Xline = Extract_Neural_Output_Along_Line(Spatio_Temporal_Feedback_OFF_Channel,StartPoint,EndPoint,0);

figure
plot(StartPoint(2):EndPoint(2),Spatio_Temporal_Feedback_ON_Channel_XLine,'color','b','linewidth',2.0)
set(gca,'Position',[0.125 0.5 0.8 0.15]);
title('Tm3 output, $S^{Tm3}(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','Spatio-Temporal-Feedback-ON-Channel.fig'))

figure
plot(StartPoint(2):EndPoint(2),Spatio_Temporal_Feedback_OFF_Channel_Xline,'color','m','linewidth',2.0)
set(gca,'Position',[0.125 0.5 0.8 0.15]);
title('Tm1 output, $S^{Tm1}(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','Spatio-Temporal-Feedback-ON-Channel.fig'))

%% Lobula
% ESTMD
ESTMD_Model_Outputs_Xline = Extract_Neural_Output_Along_Line(ESTMD_Model_Outputs,StartPoint,EndPoint,0);
% Spatio-Temporal Feedback STMD
Spatio_Temporal_Feedback_STMD_Model_Outputs_Xline = Extract_Neural_Output_Along_Line(Spatio_Temporal_Feedback_STMD_Model_Outputs,StartPoint,EndPoint,0);

figure
plot(StartPoint(2):EndPoint(2),ESTMD_Model_Outputs_Xline,'color','r','linewidth',2.0)
set(gca,'Position',[0.125 0.3 0.8 0.3]);
title('STMD output, $Q(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','STMD-Model-Outputs.fig'))

figure
plot(StartPoint(2):EndPoint(2),Spatio_Temporal_Feedback_STMD_Model_Outputs_Xline,'color','r','linewidth',2.0)
set(gca,'Position',[0.125 0.3 0.8 0.3]);
title('Spatio-Temporal Feedback STMD output, $Q(x,y_0,t_0)$','Interpreter','latex')
xlabel('$x$ (pixel)','Interpreter','latex')
ylabel('Outputs')
set(gca,'FontName','Times New Roman','FontSize',12);
saveas(gcf,strcat(FloderSaveFig,'\','Spatio-Temporal-Feedback-STMD-Model-Outputs.fig'))
