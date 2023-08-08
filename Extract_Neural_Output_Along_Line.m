function [NueralOutput] = Extract_Neural_Output_Along_Line(I,StartPoint,EndPoint,IsPlot)

%% Function Description
% this function is used to display neural output along a line
% For Example£º
% start point £¨X_s,Y_s£©,end point £¨X_e,Y_e£©and  X_s = X_e or Y_s = Y_e
% Data = I(X_s,Y_s:Y:e) or Data = I(X_s:X_e,Y_s)
% StartPoint = [X_s,Y_s]   
% EndPoint = [X_e,Y_e]     
% I    input signal                   

%% Main Function

if StartPoint(1) == EndPoint(1)
    
    NueralOutput = I(StartPoint(1),StartPoint(2):EndPoint(2));
    
    if IsPlot == 1
        figure
        plot(StartPoint(2):EndPoint(2),NueralOutput)
        title(strcat('Y = ',num2str(StartPoint(1)),'  X = ',num2str(StartPoint(2)),'-',num2str(EndPoint(2))))
        grid on
    end
    
elseif StartPoint(2) == EndPoint(2)
    
    NueralOutput = I(StartPoint(1):EndPoint(1),StartPoint(2));
    
    if IsPlot == 1
        figure
        plot(StartPoint(2):EndPoint(2),NueralOutput)
        title(strcat('Y = ',num2str(StartPoint(1)),'-',num2str(EndPoint(1)),'   X = ',num2str(StartPoint(2))))
        grid on
    end

end

end

