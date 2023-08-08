% Description:
% Setting Parameters

%% Retina -- Photoreceptors
Parameter_Fun.GaussianFilter = fspecial('gaussian',3,1);

%% Lamina -- LMC
% Band Pass Filter (Gamma function 1 - Gamma function 2)

% Parameters for Gamma Function 1
Parameter_Fun.GammaFun1_Order = 2;
Parameter_Fun.GammaFun1_Tau = 3;              % Mu = Order/Tau < 1
Parameter_Fun.GammaFun1_Output = zeros(Parameter_Fun.M,Parameter_Fun.N,Parameter_Fun.GammaFun1_Order+1);

% Parameters for Gamma Function 2
Parameter_Fun.GammaFun2_Order = 6;
Parameter_Fun.GammaFun2_Tau = 9;              % Mu = Order/Tau < 1
Parameter_Fun.GammaFun2_Output = zeros(Parameter_Fun.M,Parameter_Fun.N,Parameter_Fun.GammaFun2_Order+1);

%% Elementary Motion Detectors
% EMD Gamma Tau and Order
Parameter_Fun.EMD_GammaConv_Order = 25;      % EMD Channel -- Delay Order
Parameter_Fun.EMD_GammaConv_Tau = 30;       % EMD Channel -- Delay Constant   Mu = Order/Tau < 1
Parameter_Fun.EMD_GammaConv_Output_ON = zeros(Parameter_Fun.M,Parameter_Fun.N,Parameter_Fun.EMD_GammaConv_Order+1);  % EMD ON Channel -- Delay Output

% Multi EMD Correlation Distances and Directions
Parameter_Fun.EMD_Dist = [2 4 6 8 10 12 14 16 18];                      % EMD Channel Correlation Distance
Parameter_Fun.EMD_Directions = [8 8 12 12 16 16 24 24 28];                % EMD Channel Correlation Direction Number
Parameter_Fun.EMD_Num = length(Parameter_Fun.EMD_Dist);

%% ESTMD
Parameter_Fun.ESTMD_GammaConv_Order = 5;
Parameter_Fun.ESTMD_GammaConv_Tau = 25;                           % Mu = Order/Tau < 1
Parameter_Fun.ESTMD_GammaConv_Outputs_OFF = zeros(Parameter_Fun.M,Parameter_Fun.N,Parameter_Fun.ESTMD_GammaConv_Order+1);
% Feedback ESTMD OFF Channel -- Delay Output
Parameter_Fun.Feedback_ESTMD_GammaConv_Outputs_OFF = zeros(Parameter_Fun.M,Parameter_Fun.N,Parameter_Fun.ESTMD_GammaConv_Order+1);
% ESTMD Lateral Inhibition Kernel
Parameter_Fun.ESTMD_Lateral_Inhibition_Kernel = Generalize_ESTMD_Lateral_InhibitionKernel;

%% Spatio-Temporal Feedback STMD
Parameter_Fun.Spatio_Temporal_Feedback_Loop_GaussFilter = fspecial('gaussian',5,1.5);
Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Order = 4;     
Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Tau =  8;    
Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaSmaple_T =  0:1:25;    
Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat = zeros(Parameter_Fun.M,Parameter_Fun.N,length(Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaSmaple_T));
Spatio_Temporal_Feedback_Loop_GammaKernel = ((Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Order*Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaSmaple_T).^Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Order).*(exp(-Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Order*Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaSmaple_T/Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Tau)...
                                                                       /(factorial(Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Order-1)*Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Tau^(Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaConv_Order+1)));
                                                                   