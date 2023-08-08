function [XNow] = GammaKernelConv(X0,XPast,Tau,Order)
% References: 1. A Theory for Neural Networks with Time Delays
%  2. The Gamma Filter - A New Class of Adaptive IIR Filters With
%  Restricted Feedback

% this function is used to calculate the convolution with  Gamma kernel
% function input: image sequence I(x,y,n)

% Parameter Description
% Tau:   Gamma kernel - time constant
% Order:  Gamma  kernel - order
% X0: current input I(x,y,n)
% XPast: function output at last time X(n-1)
% XNow: function output at current time


Mu = Order/Tau;

Y1 = XPast(:,:,2:(Order+1));
Y2 = XPast(:,:,1:Order);
Y3 = (1-Mu)*Y1 + Mu*Y2;

XNow(:,:,1) = X0;
XNow(:,:,2:(Order+1)) = Y3;


end

