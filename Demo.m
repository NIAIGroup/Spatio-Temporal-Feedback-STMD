%% Function Description
% Top Function

clear all; close all; clc;

%% Set Path for Reading Image Sequences
% Path to Read in Image Sequence
Parameter_File.folder0 = 'Input-Video';

% Start and end frame of input image sequence
Parameter_File.StartFrame = 1;
Parameter_File.StartRecordFrame = 200;      
Parameter_File.EndFrame = 1300;

% Read in First Image
Parameter_Fun.file = [Parameter_File.folder0,'/',sprintf('%s%04d.tif','Frame',Parameter_File.StartFrame)];
I = rgb2gray(imread(Parameter_Fun.file));
[Parameter_Fun.M,Parameter_Fun.N] = size(I);

% Make directory for saving data
Parameter_File.folder_Global = 'Neural-Outputs\';

if ~exist(Parameter_File.folder_Global,'dir')
    mkdir(Parameter_File.folder_Global)
end

%% Setting Parameters

ParameterSetting

%% Calculating Consuming Time £¨Start Point£©
tic;
timedLog('Start Small Target Motion Perception...')

%% Use Main Function to Process Input Image Sequence

Main

%% Calculating Consuming Time £¨End Point£©
timeTrain = toc/60; % min
if timeTrain<60
    timedLog(['Motion Perception finished, time taken: ',num2str(timeTrain),' min'])
else
    timedLog(['Motion Perception finished, time taken: ',num2str(timeTrain/60), ' hrs'])
end
