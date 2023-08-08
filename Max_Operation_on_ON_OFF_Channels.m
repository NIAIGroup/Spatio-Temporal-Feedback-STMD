%% Function Description:
%% Max Operation on ON and OFF Channels

if (i >= (Parameter_File.StartRecordFrame-30)) 
    % Parameters for Max Operation
    MaxRegionSize = 7;
    Max_Threshold_ON_OFF = 0.1;
    M_Clustering = Parameter_Fun.M;
    N_Clustering = Parameter_Fun.N;
    
    %% Max Operation on ON Channels
    MaxOperation_Model_Input = ON_Channel;
    MaxOperation_Model_Input(MaxOperation_Model_Input<Max_Threshold_ON_OFF) = 0;
    
    %% Mex
    if (i == (Parameter_File.StartRecordFrame-30))
        Is_Mex_Max = 1;
        MexOperation = 1;
    end
    
    if Is_Mex_Max ==1
        if MexOperation == 1
            timedLog('Building mex function: MaxOperation_EMD_mex ...');
            % Compile MaxOperation_3D.m
            codegen MaxOperation_EMD -args {MaxOperation_Model_Input,MaxRegionSize,M_Clustering,N_Clustering} -o MaxOperation_EMD_mex
            timedLog('Building mex function is completed.');
            MexOperation = 0;
            [MaxOperation_ON_Output,MaxOperation_Map] = MaxOperation_EMD_mex(MaxOperation_Model_Input,MaxRegionSize,M_Clustering,N_Clustering);
            ON_Channel_Max = ON_Channel.*MaxOperation_Map;
        else
            [MaxOperation_ON_Output,MaxOperation_Map] = MaxOperation_EMD_mex(MaxOperation_Model_Input,MaxRegionSize,M_Clustering,N_Clustering);
            ON_Channel_Max = ON_Channel.*MaxOperation_Map;
        end
    else
        [MaxOperation_ON_Output,MaxOperation_Map] = MaxOperation_EMD(MaxOperation_Model_Input,MaxRegionSize,M_Clustering,N_Clustering);
        ON_Channel_Max = ON_Channel.*MaxOperation_Map;
    end
    
end
