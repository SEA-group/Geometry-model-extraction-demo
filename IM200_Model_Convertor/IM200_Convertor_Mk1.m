% version 2021.03.18.a

% requires:
% - byte2Uint32LE.m
% - float162Byte2LE.m
% - float322Byte4LE.m
% - normal82Byte1.m
% - NormalConvertor_Mk2.m
% - uint162Byte2LE.m
% - uint322Byte4LE.m
% - IM200_0.10.2/IM200.geometry

    clc
    clear
    
    primFileName = 'process\IM200.primitives';      % file to convert
    frameFileName = 'IM200_0.10.2\IM200.geometry';    % the original geometry file for reference
    geomFileName = 'process\IM200.geometry';    % file after conversion

    %% open primitives file and read in bytes

    primFile = fopen(primFileName, 'r');
    primCode = fread(primFile);
    primCodeLength = length(primCode);

    fclose(primFile);
    clear primFile;

    %% read primitives sectionName part

    sectionNamesSectionLength = primCode(primCodeLength) * 256^3 + primCode(primCodeLength - 1) * 256^2 + primCode(primCodeLength - 2) * 256 + primCode(primCodeLength - 3);
    sectionNamesSectionStart = primCodeLength - 4 - sectionNamesSectionLength + 1;
    sectionNamesSectionEnd = primCodeLength - 4;

    cursor = sectionNamesSectionStart;
    sectionCount = 0;

    while cursor < sectionNamesSectionEnd

        sectionCount = sectionCount+1;

        % get the length of the coresponding section
        sectionSize(sectionCount) = primCode(cursor + 3) * 256^3 + primCode(cursor + 2) * 256^2 + primCode(cursor +1) * 256 + primCode(cursor);

        % get the length of the section's name
        cursor = cursor+4+16;
        currentSectionNameLength = primCode(cursor + 3) * 256^3 + primCode(cursor + 2) * 256^2 + primCode(cursor +1) * 256 + primCode(cursor);
        currentSectionNameLength = 4*ceil(currentSectionNameLength/4);

        % get the section's name
        cursor = cursor+4;
        sectionName{sectionCount} = native2unicode(primCode(cursor: cursor+currentSectionNameLength-1)');

        % get the section type
        sectionClass{sectionCount} = sectionName{sectionCount}((strfind(sectionName{sectionCount}, '.')+1): end);
        sectionTitle{sectionCount} = sectionName{sectionCount}(1: (strfind(sectionName{sectionCount}, '.')-1));

        cursor = cursor+currentSectionNameLength;

    end

    % the following three lines are not necessary, but I prefer vertical arrays for easier visualisation in Matlab

    sectionSize = sectionSize';
    sectionClass = sectionClass';
    sectionTitle = sectionTitle';

    if length(sectionSize) ~= 2
        error('Section number is not correct, please check primitives file');
    end

    clear cursor sectionCount currentSectionNameLength sectionName;

    %% read primitives sections

    % this script only supports xyznuvtb+list16

    % read primCode from the first section
    cursor = 5;

    for indSect = 1: length(sectionSize)

        if strcmp(sectionClass{indSect}(1: 7), 'indices')

            data_type = primCode(cursor: cursor+63);
            data_count = primCode(cursor + 67) * 256^3 + primCode(cursor + 66) * 256^2 + primCode(cursor +65) * 256 + primCode(cursor + 64);

            sectionType{indSect} = native2unicode(data_type(1:16))';

            data_indices_mat = [];

            % read indices
            if isequal(data_type(1: 6), [108 105 115 116 0 0]')     % check if type is list

                for indInd = 1: data_count/3

                    data_indices_mat(indInd, 1) = 1 + primCode(cursor+71+(indInd-1)*6+1) + primCode(cursor+71+(indInd-1)*6+2)*256;
                    data_indices_mat(indInd, 2) = 1 + primCode(cursor+71+(indInd-1)*6+3) + primCode(cursor+71+(indInd-1)*6+4)*256;
                    data_indices_mat(indInd, 3) = 1 + primCode(cursor+71+(indInd-1)*6+5) + primCode(cursor+71+(indInd-1)*6+6)*256;

                end

            else

                error('wrong index type');

            end

            clear indInd...
                data_type...
                data_count;

        elseif strcmp(sectionClass{indSect}(1: 8), 'vertices')

            data_type = primCode(cursor: cursor+63);
            data_count = primCode(cursor + 67) * 256^3 + primCode(cursor + 66) * 256^2 + primCode(cursor + 65) * 256 + primCode(cursor + 64);

            sectionType{indSect} = native2unicode(data_type(1:16))';

            data_vertices_mat = [];

            if isequal(data_type(1: 8), [120 121 122 110 117 118 116 98]')   % if the type is xyznuvtb (standard model)

                for indVert = 1: data_count

                    % x, supposed to be signed single precision floating-point, small endian
                    data_vertices_mat(indVert,1) = typecast(uint8([primCode(cursor+68+(indVert-1)*32), primCode(cursor+68+(indVert-1)*32+1), primCode(cursor+68+(indVert-1)*32+2), primCode(cursor+68+(indVert-1)*32+3)]), 'single');
                    % y
                    data_vertices_mat(indVert,2) = typecast(uint8([primCode(cursor+68+(indVert-1)*32+4), primCode(cursor+68+(indVert-1)*32+5), primCode(cursor+68+(indVert-1)*32+6), primCode(cursor+68+(indVert-1)*32+7)]), 'single');
                    % z
                    data_vertices_mat(indVert,3) = typecast(uint8([primCode(cursor+68+(indVert-1)*32+8), primCode(cursor+68+(indVert-1)*32+9), primCode(cursor+68+(indVert-1)*32+10), primCode(cursor+68+(indVert-1)*32+11)]), 'single');
                    % normal, an unsigned integer. will be ensuite converted to 3 floats
                    normalNum = primCode(cursor+68+(indVert-1)*32+12)+primCode(cursor+68+(indVert-1)*32+13)*256+primCode(cursor+68+(indVert-1)*32+14)*256^2+primCode(cursor+68+(indVert-1)*32+15)*256^3;
                    normal3 = NormalConvertor_Mk2(normalNum);
                    data_vertices_mat(indVert,4) = normal3(1);
                    data_vertices_mat(indVert,5) = normal3(2);
                    data_vertices_mat(indVert,6) = normal3(3);
                    % u
                    data_vertices_mat(indVert,7) = typecast(uint8([primCode(cursor+68+(indVert-1)*32+16), primCode(cursor+68+(indVert-1)*32+17), primCode(cursor+68+(indVert-1)*32+18), primCode(cursor+68+(indVert-1)*32+19)]), 'single');
                    % v
    %                 data_vertices_mat(indVert,8) = 1-typecast(uint8([primCode(cursor+68+(indVert-1)*32+20), primCode(cursor+68+(indVert-1)*32+21), primCode(cursor+68+(indVert-1)*32+22), primCode(cursor+68+(indVert-1)*32+23)]), 'single');
                    data_vertices_mat(indVert,8) = typecast(uint8([primCode(cursor+68+(indVert-1)*32+20), primCode(cursor+68+(indVert-1)*32+21), primCode(cursor+68+(indVert-1)*32+22), primCode(cursor+68+(indVert-1)*32+23)]), 'single');
                    % tangent
                    tangentNum = primCode(cursor+68+(indVert-1)*32+24)+primCode(cursor+68+(indVert-1)*32+25)*256+primCode(cursor+68+(indVert-1)*32+26)*256^2+primCode(cursor+68+(indVert-1)*32+27)*256^3;
                    tangent3 = NormalConvertor_Mk2(tangentNum);
                    data_vertices_mat(indVert,9) = tangent3(1);
                    data_vertices_mat(indVert,10) = tangent3(2);
                    data_vertices_mat(indVert,11) = tangent3(3);
                    %binormal
                    binormNum = primCode(cursor+68+(indVert-1)*32+28)+primCode(cursor+68+(indVert-1)*32+29)*256+primCode(cursor+68+(indVert-1)*32+30)*256^2+primCode(cursor+68+(indVert-1)*32+31)*256^3;
                    binorm3 = NormalConvertor_Mk2(binormNum);
                    data_vertices_mat(indVert,12) = binorm3(1);
                    data_vertices_mat(indVert,13) = binorm3(2);
                    data_vertices_mat(indVert,14) = binorm3(3);

                end

                clear normalNum normal3 tangentNum tangent3 binormNum binorm3;

            else

                error('abnormal vertex type');

            end

            clear indVert...
                data_type...
                data_count;

        else

            error('Unknown data bloc');

        end

        cursor = cursor+4*ceil(sectionSize(indSect)/4);

    end

    sectionType = sectionType';

    %% prepare geometry files

    frameFile = fopen(frameFileName, 'r');
    frameCode = fread(frameFile);
    frameCodeLength = length(frameCode);

    fclose(frameFile);
    clear frameFile;

    %% generate code for new file

    % copy codes until 0x002F
    geomCode = frameCode(1:48);

    % calculate index section position for 0x0030
    geomCode(49:52) = uint322Byte4LE( 72 + 16*8 + 32 + 28*4*size(data_vertices_mat, 1) + 16 );

    % copy codes until 0x0047
    geomCode(53:72) = frameCode(53:72); 

    %% start "vertexBlocsInfo" at 0x0048
    
    cursor = 72;
    vertPosCursor = 0;

    for indVertBloc = 1:4
        geomCode(cursor+1: cursor+4) = frameCode(cursor+1: cursor+4);                     % section name
        geomCode(cursor+5: cursor+8) = [0; 0; 0; 0];                                     % vertex type index
        geomCode(cursor+9: cursor+12) = uint322Byte4LE(vertPosCursor);                                     % bloc position
        geomCode(cursor+13: cursor+16) = uint322Byte4LE(size(data_vertices_mat, 1));        % quantity of vertices
        cursor = cursor+16;
        vertPosCursor = vertPosCursor + size(data_vertices_mat, 1);
    end

    clear indVertBloc vertPosCursor;

    %% start "indexBlocsInfo"
    
    indPosCursor = 0;

    for indIndBloc = 1:4
        geomCode(cursor+1: cursor+4) = frameCode(cursor+1: cursor+4);                     % section name
        geomCode(cursor+5: cursor+8) = [0; 0; 0; 0];                                     % index type index
        geomCode(cursor+9: cursor+12) = uint322Byte4LE(indPosCursor);                                    % bloc position
        geomCode(cursor+13: cursor+16) = uint322Byte4LE(size(data_indices_mat, 1)*3);
        cursor = cursor+16;
        indPosCursor = indPosCursor + size(data_indices_mat, 1);
    end

    %% start "vertexSection"

    geomCode(cursor+1: cursor+16) = [32; 0; 0; 0; 0; 0; 0; 0;...
                                                                  16; 0; 0; 0; 0; 0; 0; 0]; 
    geomCode(cursor+17: cursor+20) = uint322Byte4LE(28*4*size(data_vertices_mat, 1) + 24);
    geomCode(cursor+21: cursor+24) = [0; 0; 0; 0];
    geomCode(cursor+25: cursor+28) = uint322Byte4LE(28*4*size(data_vertices_mat, 1));
    geomCode(cursor+29: cursor+32) = [28; 0; 0; 1];

    cursor = cursor+32;

    % write vertex blocs
    
    for indVertBloc = 1:4
        
        for indVert = 1:size(data_vertices_mat, 1)

            % x
            geomCode(cursor+1: cursor+4) = float322Byte4LE(data_vertices_mat(indVert, 1));
            % y
            geomCode(cursor+5: cursor+8) = float322Byte4LE(data_vertices_mat(indVert, 2));
            % z
            geomCode(cursor+9: cursor+12) = float322Byte4LE(data_vertices_mat(indVert, 3));
            % n
            geomCode(cursor+13) = normal82Byte1(data_vertices_mat(indVert, 4));
            geomCode(cursor+14) = normal82Byte1(data_vertices_mat(indVert, 5));
            geomCode(cursor+15) = normal82Byte1(data_vertices_mat(indVert, 6));
            geomCode(cursor+16) = 0;
            % u
            geomCode(cursor+17: cursor+18) = float162Byte2LE(data_vertices_mat(indVert, 7) - 0.5);
            % v
            geomCode(cursor+19: cursor+20) = float162Byte2LE(data_vertices_mat(indVert, 8) - 0.5);
            % t
            geomCode(cursor+21) = normal82Byte1(data_vertices_mat(indVert, 9));
            geomCode(cursor+22) = normal82Byte1(data_vertices_mat(indVert, 10));
            geomCode(cursor+23) = normal82Byte1(data_vertices_mat(indVert, 11));
            geomCode(cursor+24) = 0;
            % b
            geomCode(cursor+25) = normal82Byte1(data_vertices_mat(indVert, 12));
            geomCode(cursor+26) = normal82Byte1(data_vertices_mat(indVert, 13));
            geomCode(cursor+27) = normal82Byte1(data_vertices_mat(indVert, 14));
            geomCode(cursor+28) = 0;

            cursor = cursor+28;

        end
        
    end

    % write vertex type
    geomCode(cursor+1: cursor+16) = [115; 101; 116; 51; 47; 120; 121; 122; 110; 117; 118; 116; 98; 112; 99; 0]; % 'set3/xyznuvtbpc '
    cursor = cursor+16;

%     clear data_vertices_mat;

    %% start "indexSection"

    geomCode(cursor+1: cursor+8) = [16; 0; 0; 0; 0; 0; 0; 0]; 
    geomCode(cursor+9: cursor+12) = uint322Byte4LE(6*4*(size(data_indices_mat, 1)));
    geomCode(cursor+13: cursor+16) = [2; 0; 0; 0]; 

    cursor = cursor + 16;

    % write index blocs
    
    for indIndBloc = 1:4
        
        for indInd = 1:size(data_indices_mat, 1)

            geomCode(cursor+1: cursor+2) = uint162Byte2LE(data_indices_mat(indInd, 1) - 1);
            geomCode(cursor+3: cursor+4) = uint162Byte2LE(data_indices_mat(indInd, 2) - 1);
            geomCode(cursor+5: cursor+6) = uint162Byte2LE(data_indices_mat(indInd, 3) - 1);

            cursor = cursor+6;

        end
        
    end

    %% write code to new file

    geomFile = fopen(geomFileName, 'w');
    fwrite(geomFile, geomCode);
    fclose(geomFile);

    %% end

    fclose all;
    disp(['conversion of ', primFileName, ' is finished']);

