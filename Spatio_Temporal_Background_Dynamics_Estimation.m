function [Velocity_Estimation_Map,Spatio_Temporal_Feedback_ON_Channel,Spatio_Temporal_Feedback_OFF_Channel,Update_Transform_Matrixs_Gamma_Sample_Length]...
                                  = Spatio_Temporal_Background_Dynamics_Estimation(Ratio_Response_Velocity,Velocity_Estimation_Map,...
                                                   Estimated_Background_Direction,Smoothed_Spatio_Temporal_Feedback_Correlation_Output,Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat,...
                                                       ON_Channel,Delay_OFF_Channel,Feedback_Constant,Transform_Matrixs_Current_Frame,Transform_Matrixs_Gamma_Sample_Length,MaxDir_EMDs_Outputs,...
                                                               LPTC_Num,PatchSize,PatchStep,M,N,GammaKernel_FeedbackDelay,Gamma_Smaple_Length)                                                                  
%%
Update_Transform_Matrixs_Gamma_Sample_Length = Transform_Matrixs_Gamma_Sample_Length;
Spatio_Temporal_Feedback_ON_Channel = ON_Channel;
Spatio_Temporal_Feedback_OFF_Channel = Delay_OFF_Channel;

for it = 1:PatchStep:M
    for jt = 1:PatchStep:N
        
        r1 = max(1,it-PatchSize);
        r2 = min(M,it+PatchSize);
        c1 = max(1,jt-PatchSize);
        c2 = min(N,jt+PatchSize);
        Single_Vote = zeros(1,LPTC_Num);
        
        for itt = r1:r2
            for jtt = c1:c2
                SinglePixel_EMDs = MaxDir_EMDs_Outputs(itt,jtt,:);
                SinglePixel_EMDs = reshape(SinglePixel_EMDs,[1,LPTC_Num]);
                Single_Vote = Single_Vote + SinglePixel_EMDs;
            end
        end
        
        Test_Ratio_Response_Velocity = Single_Vote/max(Single_Vote);
        [~,Smallest_Index] = pdist2(Ratio_Response_Velocity,Test_Ratio_Response_Velocity,'euclidean','Smallest',1);
        Video_Sample_Frequency = 1000;
        EstimatedVelocity = (Smallest_Index-1)/Video_Sample_Frequency;
        Velocity_Estimation_Map(it,jt) = EstimatedVelocity;
        
        
        % Update Spatio Temporal Dynamics - phi(t,s) and psi(t,s)
        SpatioTemporaTransform = [1 0 (EstimatedVelocity*cos(-Estimated_Background_Direction/360*2*pi)); 0 1 (EstimatedVelocity*sin(-Estimated_Background_Direction/360*2*pi)); 0 0 1];
        tm1 = round((it-1)/PatchStep)+1;
        tm2 = round((jt-1)/PatchStep)+1;
        tmc1 = 3*(tm1-1)+2;
        tmc2 = 3*(tm2-1)+2;
        Transform_Matrixs_Current_Frame((tmc1-1):(tmc1+1),(tmc2-1):(tmc2+1)) = SpatioTemporaTransform;
       
        % Spatio Temporal Feedback Signal
        Spatio_Temporal_Feedback_Signal= zeros(size(Smoothed_Spatio_Temporal_Feedback_Correlation_Output));
        
        for kt=1:Gamma_Smaple_Length
            
            SpatioTemporaTransformTransform_Past = Transform_Matrixs_Gamma_Sample_Length((tmc1-1):(tmc1+1),(tmc2-1):(tmc2+1),kt);
            tform = projective2d(SpatioTemporaTransformTransform_Past');
            Warp_Output = imwarp(Spatio_Temporal_Feedback_STMD_Outputs_GammaConv_Mat(:,:,kt),tform,'OutputView', imref2d(size(Smoothed_Spatio_Temporal_Feedback_Correlation_Output)));
            Spatio_Temporal_Feedback_Signal = Spatio_Temporal_Feedback_Signal + Warp_Output*GammaKernel_FeedbackDelay(kt);
            % Update
            Update_Transform_Matrixs_Gamma_Sample_Length((tmc1-1):(tmc1+1),(tmc2-1):(tmc2+1),kt) = SpatioTemporaTransformTransform_Past*SpatioTemporaTransform;

        end
        
        Spatio_Temporal_Feedback_ON_Channel(r1:r2,c1:c2) = ON_Channel(r1:r2,c1:c2)+(Feedback_Constant*Spatio_Temporal_Feedback_Signal(r1:r2,c1:c2));
        Spatio_Temporal_Feedback_OFF_Channel(r1:r2,c1:c2) = Delay_OFF_Channel(r1:r2,c1:c2)+(Feedback_Constant*Spatio_Temporal_Feedback_Signal(r1:r2,c1:c2));
        % Hal-Wave Rectification
        Spatio_Temporal_Feedback_ON_Channel(r1:r2,c1:c2) = (abs(Spatio_Temporal_Feedback_ON_Channel(r1:r2,c1:c2))+Spatio_Temporal_Feedback_ON_Channel(r1:r2,c1:c2))*0.5;
        Spatio_Temporal_Feedback_OFF_Channel(r1:r2,c1:c2) = (abs(Spatio_Temporal_Feedback_OFF_Channel(r1:r2,c1:c2))+Spatio_Temporal_Feedback_OFF_Channel(r1:r2,c1:c2))*0.5;
        

    end
end

Update_Transform_Matrixs_Gamma_Sample_Length(:,:,(2:end)) = Update_Transform_Matrixs_Gamma_Sample_Length(:,:,(1:(end-1)));
Update_Transform_Matrixs_Gamma_Sample_Length(:,:,1) = Transform_Matrixs_Current_Frame;

