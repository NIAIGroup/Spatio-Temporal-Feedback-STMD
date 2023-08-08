function [Y] = Half_Wave_Rectification(X)
% Function Description
% this function is used to implement half-wave rectification 

Y = (abs(X)+X)*0.5;

end