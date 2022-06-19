% An experimental geometry model extractor, data acquiring script
% version -
% requirement:
% - 
% -

% function sectionInfo = GeometryReader_Mk1(fileName)

    %% debug params
    clc
    clear
    fileName = 'Queue/CPA001_Shell_AP_0.11.5.geometry';
    
    %% load raw data
    
    geomFile = fopen(fileName, 'r');
    geomCode = fread(geomFile);
    geomCodeLength = size(geomCode, 1);
    
    fclose(geomFile);
    clear geomFile;
    
    %% read header
    
    


% end