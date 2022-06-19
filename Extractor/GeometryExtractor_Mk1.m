% An experimental geometry model extractor, main script
% version -
% requirement:
% - GeometryReader_Mk1.m
% -

tic
clc
clear
close all;
format long;

%% Load files

fileNames = dir('Queue/*.geometry');

for indFile = 1: size(fileNames, 1)
    
    fileName = fileNames(indFileInFolder).name(1: end-9);   % remove extention
    
    %% Extract data from the current file
    sectionInfo = GeometryReader_Mk1(['Queue/', fileName, '.geometry']);
    
    
    
end