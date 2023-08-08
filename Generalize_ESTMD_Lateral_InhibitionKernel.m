function [InhibitionKernel] = Generalize_ESTMD_Lateral_InhibitionKernel(KernelSize,Sigma1,Sigma2,e,rho,A,B)

% Function Decription
% W(x,y) = A*[g_1(x,y)] - B[-g_1(x,y)]    % [x]   max(x,0)
% g_1 = G_1(x,y) - e*G_2(x,y) - rho

% KernelSize  Size of Inhibition Kernel
% Sigma1      Sigma of Gaussian Function 1
% Sigma2      Sigma of Gaussian Function 2
% e           Constant 

%% ----------------------------------------------%
if ~exist('KernelSize','var')
    KernelSize = 15;
end

if ~exist('Sigma1','var')
    Sigma1 = 1.5;
end

if ~exist('Sigma2','var')
   Sigma2 = 3.0;
end

if ~exist('e','var')
   e = 1.0;
end

if ~exist('rho','var')
   rho = 0;
end

if ~exist('A','var')
   A = 1.0;
end

if ~exist('B','var')
   B = 3.0;
end

Flag = mod(KernelSize,2);
if Flag == 0
    KernelSize = KernelSize +1;
end

CenX = round(KernelSize/2);
CenY = round(KernelSize/2);
[X,Y] = meshgrid(1:KernelSize,1:KernelSize);
ShiftX = X-CenX;
ShiftY = Y-CenY;

Gauss1 = (1/(2*pi*Sigma1^2))*exp(-(ShiftX.*ShiftX + ShiftY.*ShiftY)/(2*Sigma1^2));
Gauss2 = (1/(2*pi*Sigma2^2))*exp(-(ShiftX.*ShiftX + ShiftY.*ShiftY)/(2*Sigma2^2));

Filter = Gauss1 - e*Gauss2 - rho;

% max(x,0)
Positive_Component = (abs(Filter) + Filter)*0.5;
Negative_Component = (abs(Filter) - Filter)*0.5;

% Inhibition Kernel
InhibitionKernel = A*Positive_Component - B*Negative_Component;

end

