% An experimental geometry model extractor, main script
% version 2022.06.21a
% requirement:
% - GeometryReader_Mk1.m
% - - byte2Uint16LE.m
% - - byte2Uint32LE.m
% - - byte2HexStr.m
% - - VertexReader_Mk1.m
% - - - byte2Float16LE.m
% - - - byte2Float32LE.m
% - - - byte2Uint16LE.m
% - - - byte2Normal8.m
% - - IndexReader_Mk1.m
% - - - byte2Uint16LE.m*
% - - - byte2Uint32LE.m*
% - - BlocMatch_Mk1.m
% - mesh2obj.m
% - - uint32LE2HexStr.m

tic
clc
clear
close all;
format long;

%% Load files

fileNames = dir('Queue/*.geometry');

%% Prepare output folder

if ~exist('./Extract', 'dir') 
    mkdir('./Extract');
end

%% Parse files

for indFile = 1: size(fileNames, 1)
    
    fileName = fileNames(indFile).name(1: end-9);   % remove extention
    
    %% Extract data from the current file
    
    [blocVertex, blocIndex, combinations] = GeometryReader_Mk1(['Queue/', fileName, '.geometry']);
    
    %% Prepare mesh matrices
    
    for indPair = 1: size(combinations, 1)
        
        objFileName = [fileName, '_', blocVertex{combinations(indPair, 1)}.nameVertexBloc, '_', blocIndex{combinations(indPair, 2)}.nameIndexBloc, '.obj'];
        
        % parse vertices
        matVertex = blocVertex{combinations(indPair, 1)}.dataVertex;
        % get vertex coordinates
        matVertexCoord = matVertex(:, 1: 3);
        % get vertex normals
        matVertexNorm = matVertex(:, 4: 6);
        % get texture coordinates
        matTextureCoord = matVertex(:, [7, 8]);
        % create list of entities
        listEntity = matVertex(:, 9) + matVertex(:, 10) * (256^4);
        
        % parse indices
        matIndex = blocIndex{combinations(indPair, 2)}.dataIndex;
        
        % save files
        mesh2obj(matVertexCoord, matVertexNorm, matTextureCoord, matIndex, listEntity, ['Extract/', objFileName]);
        
    end
    
end

%% End

fclose all;
toc
disp('Finished');