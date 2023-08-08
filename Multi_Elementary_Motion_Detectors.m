function [Multi_EMD_Outputs,MaxDir_EMDs_Outputs,Estimated_Background_Direction,Multi_EMD_Directions,GammaConv_Output,Delay_Signal] = Multi_Elementary_Motion_Detectors(X0,GammaConv_Output,GammaFun_Order,GammaFun_Tau,Dist_Set,Directions_Set,EMD_Num,M,N)

% this function is used to calculate the outputs of multiple LPTCs
% Correlation Distance = 4, 8, 12, 16
% Correlation Directions = 8, 12, 16, 24

% Parameter Setting
% XO : input
% GammaFilter_Output : Output of Gamma Kernel
% Dist_Set : Distance Between Two Pixels
% Directions_Set£º  direction numbers
% Correlation_Output : correlation outputs of multiple LPTCs

%% Channel Delay
[GammaConv_Output] = GammaKernelConv(X0,GammaConv_Output,GammaFun_Tau,GammaFun_Order);
Delay_Signal = GammaConv_Output(:,:,GammaFun_Order+1);

% initilize output matrix
Multi_EMD_Outputs = cell(1,EMD_Num);
MaxDir_EMDs_Outputs = zeros(M,N,EMD_Num);
Multi_EMD_Directions =  zeros(1,EMD_Num);

%% Signal Correlation
for j=1:EMD_Num
    
    % Current Correlation Distance
    Dist = Dist_Set(j);
    % Current Correlation Direction Number
    Direction_Num = Directions_Set(j);
    
    Correlation_Output = zeros(M,N,Direction_Num);
    
    % Determine Correlation region
    CorrelationRegion_Row = (Dist+1):(M-Dist);
    CorrelationRegion_Col = (Dist+1):(N-Dist);
    
    Dir_Step = 2*pi/Direction_Num;
    Summation_Correlation_Output = zeros(1,Direction_Num);
    
    for k=1:Direction_Num
        
        X_Com = round(Dist*cos(Dir_Step*(k-1)+pi/2));
        Y_Com = round(Dist*sin(Dir_Step*(k-1)+pi/2));
        
        Correlation_Output(CorrelationRegion_Row,CorrelationRegion_Col,k) = X0(CorrelationRegion_Row,CorrelationRegion_Col).*Delay_Signal(CorrelationRegion_Row-X_Com,CorrelationRegion_Col-Y_Com);
        
        Summation_Correlation_Output(:,k) = sum(sum(Correlation_Output(CorrelationRegion_Row,CorrelationRegion_Col,k)));
    end
    % Determine the direction of maximal output
    [Index] = find(Summation_Correlation_Output == max(Summation_Correlation_Output),1);
    Multi_EMD_Directions(:,j) = (360/Direction_Num)*(Index-1);
    % record output
    Multi_EMD_Outputs{j} = Correlation_Output;
end

TabVel = tabulate(Multi_EMD_Directions);
Count_TabVel = TabVel(:,2);
TabVel_Index = find(Count_TabVel==max(Count_TabVel),1);
Estimated_Background_Direction = TabVel(TabVel_Index,1);

for j=1:EMD_Num
    
    Unit_Multi_EMD_Outputs = Multi_EMD_Outputs{j};
    Direction_Num = Directions_Set(j);
    Estimated_Background_Direction_Index = round(Estimated_Background_Direction*Direction_Num/360)+1;
    Estimated_Background_Direction_Index = min(Estimated_Background_Direction_Index,Direction_Num);
    MaxDir_EMDs_Outputs(:,:,j) = Unit_Multi_EMD_Outputs(:,:,Estimated_Background_Direction_Index);
end

end