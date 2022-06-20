% An experimental geometry model extractor, index data acquiring script
% version 2022.06.20a
% requirement:
% - byte2Uint16LE.m
% - byte2Uint32LE.m

function indices = IndexReader_Mk1(data, numIndex, lenSingleIndex, type)
    
    numRow = floor(numIndex/3);
    indices = zeros(numRow, 3); 
    
    switch type
        case 1      % list32
            for indRow = 1: numRow
                cursor = (indRow-1) * 3 * lenSingleIndex;
                indices(indRow, 1) = byte2Uint32LE(data(cursor+1: cursor+4)) + 1;
                indices(indRow, 2) = byte2Uint32LE(data(cursor+5: cursor+8)) + 1;
                indices(indRow, 3) = byte2Uint32LE(data(cursor+9: cursor+12)) + 1;
            end
        case 0      % list16
           for indRow = 1: numRow
                cursor = (indRow-1) * 3 * lenSingleIndex;
                indices(indRow, 1) = byte2Uint16LE(data(cursor+1: cursor+2)) + 1;
                indices(indRow, 2) = byte2Uint16LE(data(cursor+3: cursor+4)) + 1;
                indices(indRow, 3) = byte2Uint16LE(data(cursor+5: cursor+6)) + 1;
            end
        otherwise
            disp(['unknown index type ', num2str(type)]);
            indices = [];
    end
    
end