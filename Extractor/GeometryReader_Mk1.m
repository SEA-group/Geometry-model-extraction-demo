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
    
    numVertexType = byte2Uint32LE(geomCode(1:4));
    numIndexType = byte2Uint32LE(geomCode(5:8));
    numVertexBloc = byte2Uint32LE(geomCode(9:12));
    numIndexBloc = byte2Uint32LE(geomCode(13:16));
%     numCmodlBloc = byte2Uint32LE(geomCode(17:20));
%     numArmorBloc = byte2Uint32LE(geomCode(21:24));
    
    posVertexInfo = byte2Uint32LE(geomCode(25:28));
    posIndexInfo = byte2Uint32LE(geomCode(33:36));
    posVertexSection = byte2Uint32LE(geomCode(41:44));
    posIndexSection = byte2Uint32LE(geomCode(49:52));
%     posCmodlSection = byte2Uint32LE(geomCode(57:60));
%     posArmorSection = byte2Uint32LE(geomCode(65:68));

    %% read vertex blocs info
    
    infoVertexBloc = {};
    for indVertexBloc = 1:numVertexBloc
        cursor = posVertexInfo + (indVertexBloc-1) * 16;
        infoVertexBloc{indVertexBloc}.nameVertexBloc = byte2HexStr(geomCode(cursor+1:cursor+4));
        infoVertexBloc{indVertexBloc}.indVertexType = byte2Uint32LE(geomCode(cursor+5:cursor+8));
        infoVertexBloc{indVertexBloc}.posVertexBloc = byte2Uint32LE(geomCode(cursor+9:cursor+12));
        infoVertexBloc{indVertexBloc}.numVertex = byte2Uint32LE(geomCode(cursor+13:cursor+16));
    end
    
    %% read index blocs info
    
    infoIndexBloc = {};
    for indIndexBloc = 1:numVertexBloc
        cursor = posIndexInfo + (indIndexBloc-1) * 16;
        infoIndexBloc{indIndexBloc}.nameIndexBloc = byte2HexStr(geomCode(cursor+1:cursor+4));
        infoIndexBloc{indIndexBloc}.indIndexType = byte2Uint32LE(geomCode(cursor+5:cursor+8));
        infoIndexBloc{indIndexBloc}.posIndexBloc = byte2Uint32LE(geomCode(cursor+9:cursor+12));
        infoIndexBloc{indIndexBloc}.numIndex = byte2Uint32LE(geomCode(cursor+13:cursor+16));
    end
    
    %% read vertex section
    
    % read large vertex blocs info
    infoLargeVertexBloc = {};
    for indLargeVertexBloc = 1:numVertexType
        cursor = posVertexSection + (indLargeVertexBloc-1) * 32;
        infoLargeVertexBloc{indLargeVertexBloc}.posLargeVertexBloc = byte2Uint32LE(geomCode(cursor+1:cursor+4));
        infoLargeVertexBloc{indLargeVertexBloc}.lenVertexTypeString = byte2Uint32LE(geomCode(cursor+9:cursor+12));
        infoLargeVertexBloc{indLargeVertexBloc}.posVertexTypeString = byte2Uint32LE(geomCode(cursor+17:cursor+20));
        infoLargeVertexBloc{indLargeVertexBloc}.lenLargeVertexBloc = byte2Uint32LE(geomCode(cursor+25:cursor+28));
        infoLargeVertexBloc{indLargeVertexBloc}.lenSingleVertexData = byte2Uint16LE(geomCode(cursor+29:cursor+30));
    end


% end