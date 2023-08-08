% Function Description

%% Background Spatio-Temporal Dynamics Inferring
if (i >= (Parameter_File.StartRecordFrame-30))
    % Load Table of LPTC Response
    if (i ==  (Parameter_File.StartRecordFrame-30))
        
        % Mex Operation
        Is_Mex_Max = 1;
        MexOperation = 1;
        BackPatchSize = 200;
        BackPatchStep = 200;
        
        LPTC_Num = Parameter_Fun.EMD_Num;
        Spatio_Temporal_Dynamics_Map = zeros(Parameter_Fun.M,Parameter_Fun.N);
        M_Clustering = Parameter_Fun.M;
        N_Clustering = Parameter_Fun.N;
        
        % load table of responses of LPTCs£¬to obtain Ratio Response Velocity
        if ~exist('Ratio_Response_Velocity','var')
            file = ['Doc/','Table-Response-Velocity.mat'];
            load(file)
        end

        % Matrix for Updating
        % GammaSmaple_T in ParameterSetting -- the time sample of Gamma
        % Kernel
        Spatio_Temporal_Feedback_Loop_Gamma_Smaple_Length = length(Parameter_Fun.Spatio_Temporal_Feedback_Loop_GammaSmaple_T);
        Spatio_Temporal_Transform_Matrixs_Current_Frame = repmat(eye(3,3),[length(1:BackPatchStep:M_Clustering),length(1:BackPatchStep:N_Clustering)]);
        Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length = repmat(eye(3,3),[length(1:BackPatchStep:M_Clustering),length(1:BackPatchStep:N_Clustering),Spatio_Temporal_Feedback_Loop_Gamma_Smaple_Length]);
        
        % Feedback Constant
        Spatio_Temporal_Feedback_Constant = -0.1;
    end
    
    %% Mex
    if Is_Mex_Max == 1
        if MexOperation == 1
            timedLog('Building mex function: Spatio_Temporal_Background_Dynamics_Estimation_mex ...');
            % Compile MaxOperation_3D.m
            codegen Spatio_Temporal_Background_Dynamics_Estimation -args {Ratio_Response_Velocity,Spatio_Temporal_Dynamics_Map,Estimated_Background_Direction,Current_Spatio_Temporal_Feedback_Correlation_Outputs,Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat,ON_Channel,ESTMD_Delayed_OFF_Channel,Spatio_Temporal_Feedback_Constant,Spatio_Temporal_Transform_Matrixs_Current_Frame,Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length,MaxDir_EMDs_Outputs,LPTC_Num,BackPatchSize,BackPatchStep,M_Clustering,N_Clustering,Spatio_Temporal_Feedback_Loop_GammaKernel,Spatio_Temporal_Feedback_Loop_Gamma_Smaple_Length} -o  Spatio_Temporal_Background_Dynamics_Estimation_mex
            timedLog('Building mex function is completed.');
            MexOperation = 0;
            [Spatio_Temporal_Dynamics_Map,Spatio_Temporal_Feedback_ON_Channel,Spatio_Temporal_Feedback_OFF_Channel,Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length] = Spatio_Temporal_Background_Dynamics_Estimation_mex(Ratio_Response_Velocity,Spatio_Temporal_Dynamics_Map,Estimated_Background_Direction,Current_Spatio_Temporal_Feedback_Correlation_Outputs,Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat,...
                ON_Channel,ESTMD_Delayed_OFF_Channel,Spatio_Temporal_Feedback_Constant,Spatio_Temporal_Transform_Matrixs_Current_Frame,Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length,MaxDir_EMDs_Outputs,...
                LPTC_Num,BackPatchSize,BackPatchStep,M_Clustering,N_Clustering,Spatio_Temporal_Feedback_Loop_GammaKernel,Spatio_Temporal_Feedback_Loop_Gamma_Smaple_Length);
        else
            [Spatio_Temporal_Dynamics_Map,Spatio_Temporal_Feedback_ON_Channel,Spatio_Temporal_Feedback_OFF_Channel,Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length] = Spatio_Temporal_Background_Dynamics_Estimation_mex(Ratio_Response_Velocity,Spatio_Temporal_Dynamics_Map,Estimated_Background_Direction,Current_Spatio_Temporal_Feedback_Correlation_Outputs,Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat,...
                ON_Channel,ESTMD_Delayed_OFF_Channel,Spatio_Temporal_Feedback_Constant,Spatio_Temporal_Transform_Matrixs_Current_Frame,Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length,MaxDir_EMDs_Outputs,...
                LPTC_Num,BackPatchSize,BackPatchStep,M_Clustering,N_Clustering,Spatio_Temporal_Feedback_Loop_GammaKernel,Spatio_Temporal_Feedback_Loop_Gamma_Smaple_Length);
        end
    else
        [Spatio_Temporal_Dynamics_Map,Spatio_Temporal_Feedback_ON_Channel,Spatio_Temporal_Feedback_OFF_Channel,Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length] = Spatio_Temporal_Background_Dynamics_Estimation(Ratio_Response_Velocity,Spatio_Temporal_Dynamics_Map,Estimated_Background_Direction,Current_Spatio_Temporal_Feedback_Correlation_Outputs,Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat,...
            ON_Channel,ESTMD_Delayed_OFF_Channel,Spatio_Temporal_Feedback_Constant,Spatio_Temporal_Transform_Matrixs_Current_Frame,Spatio_Temporal_Transform_Matrixs_Gamma_Sample_Length,MaxDir_EMDs_Outputs,...
            LPTC_Num,BackPatchSize,BackPatchStep,M_Clustering,N_Clustering,Spatio_Temporal_Feedback_Loop_GammaKernel,Spatio_Temporal_Feedback_Loop_Gamma_Smaple_Length);
    end
    
end

