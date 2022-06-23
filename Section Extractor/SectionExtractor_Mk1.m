% Modified from GeometryReader_Mk1
% version 2022.06.23a
% requirement:
% - byte2Uint16LE.m
% - byte2Uint32LE.m
% - byte2HexStr.m

%% debug params
clc
clear
fileName = 'CM001_p2g_0.10.2';

%% load raw data

geomFile = fopen(['Sample\', fileName, '.geometry'], 'r');
geomCode = fread(geomFile);

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
    blocVertexLarge{indLargeVertexBloc}.posLargeVertexBloc = anchor + 1 + byte2Uint32LE(geomCode(anchor+1: anchor+4));
%         blocVertexLarge{indLargeVertexBloc}.unknown1 = byte2Uint32LE(geomCode(anchor+5: anchor+8));
    blocVertexLarge{indLargeVertexBloc}.lenVertexTypeString = byte2Uint32LE(geomCode(anchor+9: anchor+12));
%         blocVertexLarge{indLargeVertexBloc}.unknown2 = byte2Uint32LE(geomCode(anchor+13: anchor+16));
    blocVertexLarge{indLargeVertexBloc}.posVertexTypeString = anchor + 9 + byte2Uint32LE(geomCode(anchor+17: anchor+20));
%         blocVertexLarge{indLargeVertexBloc}.unknown3 = byte2Uint32LE(geomCode(anchor+21: anchor+24));
    blocVertexLarge{indLargeVertexBloc}.lenLargeVertexBloc = byte2Uint32LE(geomCode(anchor+25: anchor+28));
    blocVertexLarge{indLargeVertexBloc}.lenSingleVertexData = byte2Uint16LE(geomCode(anchor+29: anchor+30));

    % get vertex type
    blocVertexLarge{indLargeVertexBloc}.valVertexTypeString = char( geomCode(blocVertexLarge{indLargeVertexBloc}.posVertexTypeString : ...
        blocVertexLarge{indLargeVertexBloc}.posVertexTypeString+blocVertexLarge{indLargeVertexBloc}.lenVertexTypeString-2)' );
    
    % get large bloc data
    blocVertexLarge{indLargeVertexBloc}.dataLargeVertexBloc = geomCode(blocVertexLarge{indLargeVertexBloc}.posLargeVertexBloc : ...
        blocVertexLarge{indLargeVertexBloc}.posLargeVertexBloc + blocVertexLarge{indLargeVertexBloc}.lenLargeVertexBloc - 1);
    
    % save data
    outputDataFileName = ['Extracted Sections\', fileName, '_LargeVertexBloc', num2str(indLargeVertexBloc), '.bin'];
    outputDataFile = fopen(outputDataFileName, 'w');
    fwrite(outputDataFile, blocVertexLarge{indLargeVertexBloc}.dataLargeVertexBloc);
    fclose(outputDataFile);
    
    % parse vertex blocs
    subBlocSize = [];
    for indVertexBloc = 1: numVertexBloc
        if blocVertex{indVertexBloc}.indVertexType == indLargeVertexBloc - 1
            subBlocSize = [subBlocSize; indVertexBloc, blocVertex{indVertexBloc}.numVertex];
        end
    end
    
    % save info
    outputInfoFileName = ['Extracted Sections\', fileName, '_LargeVertexBloc', num2str(indLargeVertexBloc), '.txt'];
    outputInfoFile = fopen(outputInfoFileName, 'w', 'n', 'UTF-8');
    fprintf(outputInfoFile, '%s%s\r\n', 'Vertex type: ', blocVertexLarge{indLargeVertexBloc}.valVertexTypeString);
    fprintf(outputInfoFile, '%s%d\r\n', 'Single vertex length (byte): ', blocVertexLarge{indLargeVertexBloc}.lenSingleVertexData);
    % parse vertex blocs
    subBlocSize = [];
    for indVertexBloc = 1: numVertexBloc
        if blocVertex{indVertexBloc}.indVertexType == indLargeVertexBloc - 1
            fprintf(outputInfoFile, '%s%d%s%d%s\r\n', 'Vertex bloc N¡ã', indVertexBloc, ' counts ', blocVertex{indVertexBloc}.numVertex, ' vertices.');
        end
    end
    fclose(outputInfoFile);
    
end

%% read index section

blocIndexLarge = {};

for indLargeIndexBloc = 1: numIndexType

    anchor = posIndexSection + (indLargeIndexBloc-1) * 16;

    % read large index blocs info
    blocIndexLarge{indLargeIndexBloc}.posLargeIndexBloc = anchor + 1 + byte2Uint32LE(geomCode(anchor+1: anchor+4));
    blocIndexLarge{indLargeIndexBloc}.lenLargeIndexBloc = byte2Uint32LE(geomCode(anchor+9: anchor+12));
    blocIndexLarge{indLargeIndexBloc}.valIndexType = byte2Uint16LE(geomCode(anchor+13: anchor+14));
    blocIndexLarge{indLargeIndexBloc}.lenSingleIndexData = byte2Uint16LE(geomCode(anchor+15: anchor+16));
    
    % get large bloc data
    blocIndexLarge{indLargeIndexBloc}.dataLargeIndexBloc = geomCode(blocIndexLarge{indLargeIndexBloc}.posLargeIndexBloc : ...
        blocIndexLarge{indLargeIndexBloc}.posLargeIndexBloc + blocIndexLarge{indLargeIndexBloc}.lenLargeIndexBloc - 1);
    
    % save data
    outputDataFileName = ['Extracted Sections\', fileName, '_LargeIndexBloc', num2str(indLargeIndexBloc), '.bin'];
    outputDataFile = fopen(outputDataFileName, 'w');
    fwrite(outputDataFile, blocIndexLarge{indLargeIndexBloc}.dataLargeIndexBloc);
    fclose(outputDataFile);
    
    % save info
    outputInfoFileName = ['Extracted Sections\', fileName, '_LargeIndexBloc', num2str(indLargeIndexBloc), '.txt'];
    outputInfoFile = fopen(outputInfoFileName, 'w', 'n', 'UTF-8');
    switch blocIndexLarge{indLargeIndexBloc}.valIndexType
        case 1
            fprintf(outputInfoFile, '%s\r\n%s\r\n%s\r\n', 'Index type: list32', 'Single index length (byte): 4', '*Note that 1 triangle is counted as 3 indices');
        case 0
            fprintf(outputInfoFile, '%s\r\n%s\r\n%s\r\n', 'Index type: list16', 'Single index length (byte): 2', '*Note that 1 triangle is counted as 3 indices');
        otherwise
            fprintf(outputInfoFile, '%s\r\n', 'Unknown index type');
    end
    % parse index blocs
    for indIndexBloc = 1: numIndexBloc
        if blocIndex{indIndexBloc}.indIndexType == indLargeIndexBloc - 1
            fprintf(outputInfoFile, '%s%d%s%d%s\r\n', 'Index bloc N¡ã', indIndexBloc, ' counts ', blocIndex{indIndexBloc}.numIndex, ' indices.');
        end
    end
    fclose(outputInfoFile);

end

%% Finish

fclose all;
disp('Finished');