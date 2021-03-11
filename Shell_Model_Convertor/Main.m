%% Shell model convertor ver.2021.03.11a by AstreTunes from SEA group

% !!!!!! Matlab version r2016b or later is required (mandatory) !!!!!!

% How to use:
% - put your mods in Process/
% - run this script

% This program requires:
% - byte2Uint32LE.m
% - float162Byte2LE.m
% - float322Byte4LE.m
% - normal82Byte1.m
% - NormalConvertor_Mk2.m
% - ShellModelConvertor_Mk1.m
% - uint162Byte2LE.m
% - uint322Byte4LE.m
% - Frames/CPA001_Shell_AP.geometry
% - Frames/CPA002_Shell_HE.geometry
% - Frames/CPA003_Shell_CS.geometry

clc
clear
fclose all;
tic

%% Generate file list

APList = dir('**/CPA001_Shell_AP.primitives');
HEList = dir('**/CPA002_Shell_HE.primitives');
SAPList = dir('**/CPA003_Shell_CS.primitives');

%% Convert AP models

if isempty(APList)
    
    disp('No AP model file found.');
    
else
    
    for indPrim = 1: length(APList)
        ShellModelConvertor_Mk1(APList(indPrim).folder, 1);
    end
    
end

%% Convert HE models

if isempty(HEList)
    
    disp('No HE model file found.');
    
else
    
    for indPrim = 1: length(HEList)
        ShellModelConvertor_Mk1(HEList(indPrim).folder, 2);
    end
    
end

%% Convert SAP models

if isempty(SAPList)
    
    disp('No SAP model file found.');
    
else
    
    for indPrim = 1: length(SAPList)
        ShellModelConvertor_Mk1(SAPList(indPrim).folder, 3);
    end
    
end

%% End

disp('routine finished.');
toc
