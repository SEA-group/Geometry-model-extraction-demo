% An experimental geometry model extractor, data acquiring script
% version 2022.06.20a
% requirement:
% - byte2Uint16LE.m
% - byte2Uint32LE.m
% - byte2HexStr.m
% - VertexReader_Mk1.m
% - - byte2Float16LE.m
% - - byte2Float32LE.m
% - - byte2Uint16LE.m
% - - byte2Normal8.m
% - IndexReader_Mk1.m
% - - byte2Uint16LE.m*
% - - byte2Uint32LE.m*
% - BlocMatch_Mk1.m

function [blocVertex, blocIndex, combinations] = GeometryReader_Mk1(fileName)

%     %% debug params
%     clc
%     clear
%     fileName = 'Queue/CPA001_Shell_AP_0.11.5.geometry';
    
    %% load raw data
    
    geomFile = fopen(fileName, 'r');
    geomCode = fread(geomFile);
%     geomCodeLength = size(geomCode, 1);
    
    fclose(geomFile);
    clear geomFile;
    
    %% read header
    
    numVertexType = byte2Uint32LE(geomCode(1: 4));
    numIndexType = byte2Uint32LE(geomCode(5: 8));
    numVertexBloc = byte2Uint32LE(geomCode(9: 12));
    numIndexBloc = byte2Uint32LE(geomCode(13: 16));
%     numCmodlBloc = byte2Uint32LE(geomCode(17: 20));
%     numArmorBloc = byte2Uint32LE(geomCode(21: 24));
    
    posVertexInfo = byte2Uint32LE(geomCode(25: 28));
    posIndexInfo = byte2Uint32LE(geomCode(33: 36));
    posVertexSection = byte2Uint32LE(geomCode(41: 44));
    posIndexSection = byte2Uint32LE(geomCode(49: 52));
%     posCmodlSection = byte2Uint32LE(geomCode(57: 60));
%     posArmorSection = byte2Uint32LE(geomCode(65: 68));

    %% read vertex blocs info
    
    blocVertex = {};
    for indVertexBloc = 1: numVertexBloc
        anchor = posVertexInfo + (indVertexBloc-1) * 16;
        blocVertex{indVertexBloc}.nameVertexBloc = byte2HexStr(geomCode(anchor+1: anchor+4));
        blocVertex{indVertexBloc}.indVertexType = byte2Uint16LE(geomCode(anchor+5: anchor+6));
%         infoVertexBloc{indVertexBloc}.indParing = byte2Uint16LE(geomCode(anchor+7: anchor+8));
        blocVertex{indVertexBloc}.posVertexBloc = byte2Uint32LE(geomCode(anchor+9: anchor+12));
        blocVertex{indVertexBloc}.numVertex = byte2Uint32LE(geomCode(anchor+13: anchor+16));
    end
    
    %% read index blocs info
    
    blocIndex = {};
    for indIndexBloc = 1: numVertexBloc
        anchor = posIndexInfo + (indIndexBloc-1) * 16;
        blocIndex{indIndexBloc}.nameIndexBloc = byte2HexStr(geomCode(anchor+1: anchor+4));
        blocIndex{indIndexBloc}.indIndexType = byte2Uint16LE(geomCode(anchor+5: anchor+6));
%         infoIndexBloc{indIndexBloc}.indParing = byte2Uint16LE(geomCode(anchor+7: anchor+8));
        blocIndex{indIndexBloc}.posIndexBloc = byte2Uint32LE(geomCode(anchor+9: anchor+12));
        blocIndex{indIndexBloc}.numIndex = byte2Uint32LE(geomCode(anchor+13: anchor+16));
    end
    
    %% read vertex section
    
    blocVertexLarge = {};

    for indLargeVertexBloc = 1: numVertexType
        
        anchor = posVertexSection + (indLargeVertexBloc-1) * 32;
        
        % read large vertex blocs info
        blocVertexLarge{indLargeVertexBloc}.posLargeVertexBloc = byte2Uint32LE(geomCode(anchor+1: anchor+4));
        blocVertexLarge{indLargeVertexBloc}.lenVertexTypeString = byte2Uint32LE(geomCode(anchor+9: anchor+12));
        blocVertexLarge{indLargeVertexBloc}.posVertexTypeString = byte2Uint32LE(geomCode(anchor+17: anchor+20));
        blocVertexLarge{indLargeVertexBloc}.lenLargeVertexBloc = byte2Uint32LE(geomCode(anchor+25: anchor+28));
        blocVertexLarge{indLargeVertexBloc}.lenSingleVertexData = byte2Uint16LE(geomCode(anchor+29: anchor+30));
        
        % get vertex type
        blocVertexLarge{indLargeVertexBloc}.valVertexTypeString = char( geomCode(anchor+9+blocVertexLarge{indLargeVertexBloc}.posVertexTypeString : ...
            anchor+9+blocVertexLarge{indLargeVertexBloc}.posVertexTypeString+blocVertexLarge{indLargeVertexBloc}.lenVertexTypeString-1)' );
        
    end
    
    anchor = posVertexSection + numVertexType * 32;
    cursor = anchor;
            
    % read vertex blocs
    for indVertexBloc = 1: numVertexBloc
        
        vertexType = blocVertexLarge{blocVertex{indVertexBloc}.indVertexType+1}.valVertexTypeString;
        lenSingleVertexData = blocVertexLarge{blocVertex{indVertexBloc}.indVertexType+1}.lenSingleVertexData;
        numVertex = blocVertex{indVertexBloc}.numVertex;
        lenTotalVertexData = numVertex * lenSingleVertexData;

        blocVertex{indVertexBloc}.dataVertex = VertexReader_Mk1(geomCode(cursor+1: cursor+lenTotalVertexData), numVertex, lenSingleVertexData, vertexType);
        
        cursor = cursor + lenTotalVertexData;
        
    end
    
    %% read index section
    
    blocIndexLarge = {};
    
    for indLargeIndexBloc = 1: numIndexType
        
        anchor = posIndexSection + (indLargeIndexBloc-1) * 16;
        
        % read large index blocs info
        blocIndexLarge{indLargeIndexBloc}.posLargeIndexBloc = byte2Uint32LE(geomCode(anchor+1: anchor+4));
        blocIndexLarge{indLargeIndexBloc}.lenLargeIndexBloc = byte2Uint32LE(geomCode(anchor+9: anchor+12));
        blocIndexLarge{indLargeIndexBloc}.valIndexType = byte2Uint16LE(geomCode(anchor+13: anchor+14));
        blocIndexLarge{indLargeIndexBloc}.lenSingleIndexData = byte2Uint16LE(geomCode(anchor+15: anchor+16));
        
    end
    
    anchor = posIndexSection + numIndexType * 16;
    cursor = anchor;
    
    % read index blocs
    for indIndexBloc = 1: numIndexBloc
        
        indexType = blocIndexLarge{blocIndex{indIndexBloc}.indIndexType+1}.valIndexType;
        lenSingleIndexData = blocIndexLarge{blocIndex{indIndexBloc}.indIndexType+1}.lenSingleIndexData;
        numIndex = blocIndex{indIndexBloc}.numIndex;
        lenTotalIndexData = numIndex * lenSingleIndexData;
        
        blocIndex{indIndexBloc}.dataIndex = IndexReader_Mk1(geomCode(cursor+1: cursor+lenTotalIndexData), numIndex, lenSingleIndexData, indexType);
        
        cursor = cursor + lenTotalIndexData;
        
    end
    
    %% pair vertex-index blocs
    
    combinations = BlocMatch_Mk1(blocVertex, blocIndex);

end