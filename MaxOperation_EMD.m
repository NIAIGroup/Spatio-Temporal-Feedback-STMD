function [MaxOperation_Output,MaxOperation_Map] = MaxOperation_EMD(Input,MaxRegionSize,M,N)

% �ú������ڶ����ͼ����ÿһС�����ڽ��� Max Operation

% Parameter Setting
% Input : ����ͼ�񣬴�СΪ M*N
% MaxRegionSize : ���� Max Operation �������С ��2*MaxRegionSize�� *
% ��2*MaxRegionSize��
% M,N : ͼ��ķֱ���


MaxOperation_Output = Input;
MaxOperation_Map = zeros(size(Input));


for rr = 1:M
    
    for cc = 1:N
        
        r1 = max(1,rr-MaxRegionSize);
        r2 = min(M,rr+MaxRegionSize);
        c1 = max(1,cc-MaxRegionSize);
        c2 = min(N,cc+MaxRegionSize);
        
        rr1 = max(1,rr-2);
        rr2 = min(M,rr+2);
        cc1 = max(1,cc-2);
        cc2 = min(N,cc+2);
        
        
        if Input(rr,cc) == 0  
            MaxOperation_Output(rr,cc) = 0;
        elseif Input(rr,cc)~=max(max(Input(r1:r2,c1:c2)))
            MaxOperation_Output(rr,cc) = 0;
        elseif Input(rr,cc)==max(max(Input(r1:r2,c1:c2)))
            MaxOperation_Map(rr1:rr2,cc1:cc2) = ones(length(rr1:rr2),length(cc1:cc2));
        end

    end
    
end