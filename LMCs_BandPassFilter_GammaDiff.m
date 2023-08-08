function [LMCs_BandPassFilter_Output,GammaFun1_Output,GammaFun2_Output] = LMCs_BandPassFilter_GammaDiff(X0,GammaFun1_Output,GammaFun1_Tau,GammaFun1_Order,GammaFun2_Output,GammaFun2_Tau,GammaFun2_Order)
% Funcion Description
% Band Pass Filter = Gamma Function 1 - Gamma Function 2
% Parameter Setting
% X0  Input Image
% GammaFun1_Tau  Gamma kernel 1 -- Time Constant
% GammaFun1_Order Gamma kernel 1 -- Order
% GammaFun1_Output  Gamma kernel 1 -- Output

GammaFun1_Output = GammaKernelConv(X0,GammaFun1_Output,GammaFun1_Tau,GammaFun1_Order);
GammaFun2_Output = GammaKernelConv(X0,GammaFun2_Output,GammaFun2_Tau,GammaFun2_Order);

LMCs_BandPassFilter_Output = GammaFun1_Output(:,:,GammaFun1_Order+1) - GammaFun2_Output(:,:,GammaFun2_Order+1);

end

