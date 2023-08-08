% Main Function to Implement Spatio-Temporal Feedback STMD

for i = Parameter_File.StartFrame:Parameter_File.EndFrame
    
    %======================== Retina Layer =============================%
    %% Read in Images
    file = [Parameter_File.folder0,'/',sprintf('%s%04d.tif','Frame',i)];
    I = imread(file);
    Original_Image = I;
    I = double(rgb2gray(I));
    
    %% Ommatidium
    Photoreceptors_Outptut = conv2(I,Parameter_Fun.GaussianFilter,'same');
    
    %========================  Lamina Layer ===========================%
    %% Large Monopolar Cells
    % Band-pass Filter (Gamma function 1 - Gamma function 2)
    [LMCs_Band_Pass_Output,Parameter_Fun.GammaFun1_Output,Parameter_Fun.GammaFun2_Output] = LMCs_BandPassFilter_GammaDiff(Photoreceptors_Outptut,Parameter_Fun.GammaFun1_Output,Parameter_Fun.GammaFun1_Tau,Parameter_Fun.GammaFun1_Order,...
        Parameter_Fun.GammaFun2_Output,Parameter_Fun.GammaFun2_Tau,Parameter_Fun.GammaFun2_Order);
    
    %========================== Medulla Layer ============================%
    %% Medulla Neurons
    % ON and OFF Channel Separation
    % Positive Part
    ON_Channel = Half_Wave_Rectification(LMCs_Band_Pass_Output);
    % Negative Part
    OFF_Channel = Half_Wave_Rectification(-LMCs_Band_Pass_Output);
    
    % Max Operation on ON and OFF Channels
    ON_Channel_Max = ON_Channel;
    Max_Operation_on_ON_OFF_Channels
    
    %====================== Lobula Layer ===============================%
    %% ESTMD
    [ESTMD_Model_Correlation_Outputs,Parameter_Fun.ESTMD_GammaConv_Outputs_OFF,ESTMD_Delayed_OFF_Channel] ...
        = Elementary_Small_Target_Motion_Detector(ON_Channel,OFF_Channel,...
        Parameter_Fun.ESTMD_GammaConv_Outputs_OFF,Parameter_Fun.ESTMD_GammaConv_Tau,Parameter_Fun.ESTMD_GammaConv_Order);
    
    % Lateral Inhibition
    ESTMD_Model_Outputs = Half_Wave_Rectification(conv2(ESTMD_Model_Correlation_Outputs,Parameter_Fun.ESTMD_Lateral_Inhibition_Kernel,'same'));
    
    %% Multi EMD Correlation
    [Multi_EMD_Outputs,MaxDir_EMDs_Outputs,Estimated_Background_Direction,Multi_EMD_Directions,Parameter_Fun.EMD_GammaConv_Output_ON,EMD_Delayed_ON_Cahnnel] = ...
        Multi_Elementary_Motion_Detectors(ON_Channel_Max,Parameter_Fun.EMD_GammaConv_Output_ON,Parameter_Fun.EMD_GammaConv_Order,Parameter_Fun.EMD_GammaConv_Tau,...
        Parameter_Fun.EMD_Dist,Parameter_Fun.EMD_Directions,Parameter_Fun.EMD_Num,Parameter_Fun.M,Parameter_Fun.N);
    
    
    %% Spatio-Temporal Feedback STMD
    % ensure the first feedback signal
    if i == (Parameter_File.StartRecordFrame-30)
        Spatio_Temporal_Feedback_STMD_Correlation_Outputs = zeros(Parameter_Fun.M,Parameter_Fun.N);
        Spatio_Temporal_Feedback_ON_Channel = zeros(Parameter_Fun.M,Parameter_Fun.N);
        Spatio_Temporal_Feedback_OFF_Channel = zeros(Parameter_Fun.M,Parameter_Fun.N);
    end
    
    if (i >= (Parameter_File.StartRecordFrame-30))
  
        Spatio_Temporal_Feedback_Correlation_Outputs  = Spatio_Temporal_Feedback_STMD_Correlation_Outputs + ESTMD_Model_Correlation_Outputs;
        Current_Spatio_Temporal_Feedback_Correlation_Outputs = conv2(Spatio_Temporal_Feedback_Correlation_Outputs,Parameter_Fun.Spatio_Temporal_Feedback_Loop_GaussFilter,'same');
        
        % Use LPTC subnetwork to infer background spatio-temporal dynamics
        Infer_Backgournd_Spatio_Temporal_Dynamics
        
        % Feedback ON and OFF Signal Correlation
        Spatio_Temporal_Feedback_STMD_Correlation_Outputs = Spatio_Temporal_Feedback_ON_Channel.*Spatio_Temporal_Feedback_OFF_Channel;
        
        % Lateral Inhibition
        Spatio_Temporal_Feedback_STMD_Model_Outputs = Half_Wave_Rectification(conv2(Spatio_Temporal_Feedback_STMD_Correlation_Outputs,Parameter_Fun.ESTMD_Lateral_Inhibition_Kernel,'same'));
        
        % Update (Feedback Signal Matrix)
        Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat(:,:,(2:end)) = Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat(:,:,(1:(end-1)));
        Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat(:,:,1) = Current_Spatio_Temporal_Feedback_Correlation_Outputs;
    end
    
    %% Plot Figure - Neural Output of Each Layer
    if (i==495)
        Display_Neural_Output_Along_Line
        break;
    end
    
    %% Display Frame Num
    disp(i);
    
end
