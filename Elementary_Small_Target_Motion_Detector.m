function [ESTMD_Output,GammaConv_Output_OFF,DelayOFF_Channel] = Elementary_Small_Target_Motion_Detector(ON_Channel,OFF_Channel,...
                                                              GammaConv_Output_OFF,GammaFun_Tau,GammaFun_Order)
                                                          
% Function Description:
% Calculate the output of STMD subnetrwork

% Parameter Description
% ON_Channel : Signal of ON Channel at current time
% OFF_Channel £ºSignal of OFF Channel at current time
% GammaFun_Output_OFF :   Output of Gamma kernel in OFF Channel 

%% Main
% OFF Channel Delay
[GammaConv_Output_OFF] = GammaKernelConv(OFF_Channel,GammaConv_Output_OFF,GammaFun_Tau,GammaFun_Order);
DelayOFF_Channel = GammaConv_Output_OFF(:,:,GammaFun_Order+1);

% ESTMD Correlation Step
ESTMD_Output = ON_Channel.*DelayOFF_Channel;

end


