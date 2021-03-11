% version 2021.03.11.a
% requires:
% - byte2Uint32LE.m
% - float162Byte2LE.m
% - float322Byte4LE.m
% - normal82Byte1.m
% - NormalConvertor_Mk2.m
% - uint162Byte2LE.m
% - uint322Byte4LE.m
% - Frames/CPA001_Shell_AP.geometry
% - Frames/CPA002_Shell_HE.geometry
% - Frames/CPA003_Shell_CS.geometry

function succes = ShellModelConvertor_Mk1(primPath, shellType)

    succes = 0;

%     %% debug attributes bloc
%     clc
%     clear
    
    shellName{1} = 'CPA001_Shell_AP';
    shellName{2} = 'CPA002_Shell_HE';
    shellName{3} = 'CPA003_Shell_CS';
    
    primFileName = [primPath, '\', shellName{shellType}, '.primitives'];      % file before conversion
    frameFileName = ['Frames\', shellName{shellType}, '.geometry'];    % a true grometry file as example
    geomFileName = [primPath, '\', shellName{shellType}, '.geometry'];    % file after conversion

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

    if length(sectionSize) ~= 6
        error('Section number is not correct, please check shell file');
    end

    clear cursor sectionCount currentSectionNameLength sectionName;

    %% read primitives sections

    % normally a shell model can only be xyznuvtb+list16

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

                if contains(sectionTitle(indSect), 'body')
                    body_indices = data_indices_mat;
                elseif contains(sectionTitle(indSect), 'tail')
                    tail_indices = data_indices_mat;
                elseif contains(sectionTitle(indSect), 'friction')
                    friction_indices = data_indices_mat;
                else
                    error('wrong section name');
                end

            else

                error('wrong index type');

            end

            clear indInd...
                data_indices_mat...
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

                if contains(sectionTitle(indSect), 'body')
                    body_vertices = data_vertices_mat;
                elseif contains(sectionTitle(indSect), 'tail')
                    tail_vertices = data_vertices_mat;
                elseif contains(sectionTitle(indSect), 'friction')
                    friction_vertices = data_vertices_mat;
                else
                    error('wrong section name');
                end

                clear normalNum normal3 tangentNum tangent3 binormNum binorm3;

            else

                error('abnormal vertex type');

            end

            clear indVert...
                data_vertices_mat...
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
    geomCode(49:52) = uint322Byte4LE( 72 + 16*6 + 32 + 28*(size(body_vertices, 1) + size(friction_vertices, 1) + size(tail_vertices, 1)) + 16 );

    % copy codes until 0x0047
    geomCode(53:72) = frameCode(53:72); 

    %% start "vertexBlocsInfo" at 0x0048

    % write first bloc info
    geomCode(73:76) = frameCode(73:76);                     % section name
    geomCode(77:80) = [0; 0; 0; 0];                                     % vertex type index
    geomCode(81:84) = [0; 0; 0; 0];                                     % bloc position

    % write the quantity of vertices in this bloc
    if isequal(frameCode(73:76), [126; 177; 63; 224])      % tailShape.vertices

        geomCode(85:88) = uint322Byte4LE(size(tail_vertices, 1));
        vertPosCursor = size(tail_vertices, 1);
        vertOrder{1} = 'tail';

    elseif isequal(frameCode(73:76), [191; 159; 214; 72]) || isequal(frameCode(73:76), [220; 86; 70; 105])       % body.vertices or bodyShape.vertices   

        geomCode(85:88) = uint322Byte4LE(size(body_vertices, 1));
        vertPosCursor = size(body_vertices, 1);
        vertOrder{1} = 'body';

    elseif isequal(frameCode(73:76), [144; 115; 119; 120])       % frictionShape.vertices

        geomCode(85:88) = uint322Byte4LE(size(friction_vertices, 1));
        vertPosCursor = size(friction_vertices, 1);
        vertOrder{1} = 'friction';

    else

        error('unknown vertex section identifier in first info bloc');

    end

    % write second bloc info
    geomCode(89:92) = frameCode(89:92);                     % section name
    geomCode(93:96) = [0; 0; 0; 0];                                     % vertex type index

    % write bloc position
    geomCode(97:100) = uint322Byte4LE(vertPosCursor);

    % write the quantity of vertices in this bloc
    if isequal(frameCode(89:92), [126; 177; 63; 224])      % tailShape.vertices

        geomCode(101:104) = uint322Byte4LE(size(tail_vertices, 1));
        vertPosCursor = vertPosCursor + size(tail_vertices, 1);
        vertOrder{2} = 'tail';

    elseif isequal(frameCode(89:92), [191; 159; 214; 72]) || isequal(frameCode(89:92), [220; 86; 70; 105])       % body.vertices or bodyShape.vertices   

        geomCode(101:104) = uint322Byte4LE(size(body_vertices, 1));
        vertPosCursor = vertPosCursor + size(body_vertices, 1);
        vertOrder{2} = 'body';

    elseif isequal(frameCode(89:92), [144; 115; 119; 120])       % frictionShape.vertices

        geomCode(101:104) = uint322Byte4LE(size(friction_vertices, 1));
        vertPosCursor = vertPosCursor + size(friction_vertices, 1);
        vertOrder{2} = 'friction';

    else

        error('unknown vertex section identifier in second info bloc');

    end

    % write third bloc info
    geomCode(105:108) = frameCode(105:108);                     % section name
    geomCode(109:112) = [0; 0; 0; 0];                                     % vertex type index

    % write bloc position
    geomCode(113:116) = uint322Byte4LE(vertPosCursor);

    % write the quantity of vertices in this bloc
    if isequal(frameCode(105:108), [126; 177; 63; 224])      % tailShape.vertices

        geomCode(117:120) = uint322Byte4LE(size(tail_vertices, 1));
        vertOrder{3} = 'tail';

    elseif isequal(frameCode(105:108), [191; 159; 214; 72]) || isequal(frameCode(105:108), [220; 86; 70; 105])       % body.vertices or bodyShape.vertices   

        geomCode(117:120) = uint322Byte4LE(size(body_vertices, 1));
        vertOrder{3} = 'body';

    elseif isequal(frameCode(105:108), [144; 115; 119; 120])       % frictionShape.vertices

        geomCode(117:120) = uint322Byte4LE(size(friction_vertices, 1));
        vertOrder{3} = 'friction';

    else

        error('unknown vertex section identifier in third info bloc');

    end

    clear vertPosCursor;

    %% start "indexBlocsInfo" at 0x0078

    % write first bloc info
    geomCode(121:124) = frameCode(121:124);                     % section name
    geomCode(125:128) = [0; 0; 0; 0];                                     % index type index
    geomCode(129:132) = [0; 0; 0; 0];                                     % bloc position

    % write the quantity of vertices in this bloc
    if isequal(frameCode(121:124), [142; 36; 226; 78])      % tailShape.indices

        geomCode(133:136) = uint322Byte4LE(size(tail_indices, 1));
        indPosCursor = size(tail_indices, 1);
        indOrder{1} = 'tail';

    elseif isequal(frameCode(121:124), [234; 42; 84; 92]) || isequal(frameCode(121:124), [16; 101; 4; 233])       % body.indices or bodyShape.indices   

        geomCode(133:136) = uint322Byte4LE(size(body_indices, 1));
        indPosCursor = size(body_indices, 1);
        indOrder{1} = 'body';

    elseif isequal(frameCode(121:124), [27; 59; 30; 97])       % frictionShape.vertices

        geomCode(133:136) = uint322Byte4LE(size(friction_indices, 1));
        indPosCursor = size(friction_indices, 1);
        indOrder{1} = 'friction';

    else

        error('unknown index section identifier in first info bloc');

    end

    % write second bloc info
    geomCode(137:140) = frameCode(137:140);                     % section name
    geomCode(141:144) = [0; 0; 0; 0];                                     % index type index

    % write bloc position
    geomCode(145:148) = uint322Byte4LE(indPosCursor);

    % write the quantity of vertices in this bloc
    if isequal(frameCode(137:140), [142; 36; 226; 78])      % tailShape.indices

        geomCode(149:152) = uint322Byte4LE(size(tail_indices, 1));
        indPosCursor = indPosCursor + size(tail_indices, 1);
        indOrder{2} = 'tail';

    elseif isequal(frameCode(137:140), [234; 42; 84; 92]) || isequal(frameCode(137:140), [16; 101; 4; 233])       % body.indices or bodyShape.indices   

        geomCode(149:152) = uint322Byte4LE(size(body_indices, 1));
        indPosCursor = indPosCursor + size(body_indices, 1);
        indOrder{2} = 'body';

    elseif isequal(frameCode(137:140), [27; 59; 30; 97])       % frictionShape.vertices

        geomCode(149:152) = uint322Byte4LE(size(friction_indices, 1));
        indPosCursor = indPosCursor + size(friction_indices, 1);
        indOrder{2} = 'friction';

    else

        error('unknown index section identifier in second info bloc');

    end

    % write third bloc info
    geomCode(153:156) = frameCode(153:156);                     % section name
    geomCode(157:160) = [0; 0; 0; 0];                                     % index type index

    % write bloc position
    geomCode(161:164) = uint322Byte4LE(indPosCursor);

    % write the quantity of vertices in this bloc
    if isequal(frameCode(153:156), [142; 36; 226; 78])      % tailShape.indices

        geomCode(165:168) = uint322Byte4LE(size(tail_indices, 1));
        indOrder{3} = 'tail';

    elseif isequal(frameCode(153:156), [234; 42; 84; 92]) || isequal(frameCode(153:156), [16; 101; 4; 233])       % body.indices or bodyShape.indices   

        geomCode(165:168) = uint322Byte4LE(size(body_indices, 1));
        indOrder{3} = 'body';

    elseif isequal(frameCode(153:156), [27; 59; 30; 97])       % frictionShape.vertices

        geomCode(165:168) = uint322Byte4LE(size(friction_indices, 1));
        indOrder{3} = 'friction';

    else

        error('unknown index section identifier in third info bloc');

    end

    %% start "vertexSection" at 0x00A8

    geomCode(169:184) = frameCode(169:184); 
    geomCode(185:188) = uint322Byte4LE(28*(size(body_vertices, 1) + size(friction_vertices, 1) + size(tail_vertices, 1)) + 24);
    geomCode(189:192) = [0; 0; 0; 0];
    geomCode(193:196) = uint322Byte4LE(28*(size(body_vertices, 1) + size(friction_vertices, 1) + size(tail_vertices, 1)));
    geomCode(197:200) = frameCode(197:200);

    cursor = 200;

    % write first vertex bloc

    switch vertOrder{1}
        case 'tail'
            currentVertMat = tail_vertices;
        case 'body'
            currentVertMat = body_vertices;
        case 'friction'
            currentVertMat = friction_vertices;
        otherwise
            error('a wild bug appears');
    end

    for indVert = 1:size(currentVertMat, 1)

        % x
        geomCode(cursor+1: cursor+4) = float322Byte4LE(currentVertMat(indVert, 1));
        % y
        geomCode(cursor+5: cursor+8) = float322Byte4LE(currentVertMat(indVert, 2));
        % z
        geomCode(cursor+9: cursor+12) = float322Byte4LE(currentVertMat(indVert, 3));
        % n
        geomCode(cursor+13) = normal82Byte1(currentVertMat(indVert, 4));
        geomCode(cursor+14) = normal82Byte1(currentVertMat(indVert, 5));
        geomCode(cursor+15) = normal82Byte1(currentVertMat(indVert, 6));
        geomCode(cursor+16) = 0;
        % u
        geomCode(cursor+17: cursor+18) = float162Byte2LE(currentVertMat(indVert, 7) - 0.5);
        % v
        geomCode(cursor+19: cursor+20) = float162Byte2LE(currentVertMat(indVert, 8) - 0.5);
        % t
        geomCode(cursor+21) = normal82Byte1(currentVertMat(indVert, 9));
        geomCode(cursor+22) = normal82Byte1(currentVertMat(indVert, 10));
        geomCode(cursor+23) = normal82Byte1(currentVertMat(indVert, 11));
        geomCode(cursor+24) = 0;
        % b
        geomCode(cursor+25) = normal82Byte1(currentVertMat(indVert, 12));
        geomCode(cursor+26) = normal82Byte1(currentVertMat(indVert, 13));
        geomCode(cursor+27) = normal82Byte1(currentVertMat(indVert, 14));
        geomCode(cursor+28) = 0;

        cursor = cursor+28;

    end

    % write second vertex bloc

    switch vertOrder{2}
        case 'tail'
            currentVertMat = tail_vertices;
        case 'body'
            currentVertMat = body_vertices;
        case 'friction'
            currentVertMat = friction_vertices;
        otherwise
            error('a wild bug appears');
    end

    for indVert = 1:size(currentVertMat, 1)

        % x
        geomCode(cursor+1: cursor+4) = float322Byte4LE(currentVertMat(indVert, 1));
        % y
        geomCode(cursor+5: cursor+8) = float322Byte4LE(currentVertMat(indVert, 2));
        % z
        geomCode(cursor+9: cursor+12) = float322Byte4LE(currentVertMat(indVert, 3));
        % n
        geomCode(cursor+13) = normal82Byte1(currentVertMat(indVert, 4));
        geomCode(cursor+14) = normal82Byte1(currentVertMat(indVert, 5));
        geomCode(cursor+15) = normal82Byte1(currentVertMat(indVert, 6));
        geomCode(cursor+16) = 0;
        % u
        geomCode(cursor+17: cursor+18) = float162Byte2LE(currentVertMat(indVert, 7) - 0.5);
        % v
        geomCode(cursor+19: cursor+20) = float162Byte2LE(currentVertMat(indVert, 8) - 0.5);
        % t
        geomCode(cursor+21) = normal82Byte1(currentVertMat(indVert, 9));
        geomCode(cursor+22) = normal82Byte1(currentVertMat(indVert, 10));
        geomCode(cursor+23) = normal82Byte1(currentVertMat(indVert, 11));
        geomCode(cursor+24) = 0;
        % b
        geomCode(cursor+25) = normal82Byte1(currentVertMat(indVert, 12));
        geomCode(cursor+26) = normal82Byte1(currentVertMat(indVert, 13));
        geomCode(cursor+27) = normal82Byte1(currentVertMat(indVert, 14));
        geomCode(cursor+28) = 0;

        cursor = cursor+28;

    end

    % write third vertex bloc

    switch vertOrder{3}
        case 'tail'
            currentVertMat = tail_vertices;
        case 'body'
            currentVertMat = body_vertices;
        case 'friction'
            currentVertMat = friction_vertices;
        otherwise
            error('a wild bug appears');
    end

    for indVert = 1:size(currentVertMat, 1)

        % x
        geomCode(cursor+1: cursor+4) = float322Byte4LE(currentVertMat(indVert, 1));
        % y
        geomCode(cursor+5: cursor+8) = float322Byte4LE(currentVertMat(indVert, 2));
        % z
        geomCode(cursor+9: cursor+12) = float322Byte4LE(currentVertMat(indVert, 3));
        % n
        geomCode(cursor+13) = normal82Byte1(currentVertMat(indVert, 4));
        geomCode(cursor+14) = normal82Byte1(currentVertMat(indVert, 5));
        geomCode(cursor+15) = normal82Byte1(currentVertMat(indVert, 6));
        geomCode(cursor+16) = 0;
        % u
        geomCode(cursor+17: cursor+18) = float162Byte2LE(currentVertMat(indVert, 7) - 0.5);
        % v
        geomCode(cursor+19: cursor+20) = float162Byte2LE(currentVertMat(indVert, 8) - 0.5);
        % t
        geomCode(cursor+21) = normal82Byte1(currentVertMat(indVert, 9));
        geomCode(cursor+22) = normal82Byte1(currentVertMat(indVert, 10));
        geomCode(cursor+23) = normal82Byte1(currentVertMat(indVert, 11));
        geomCode(cursor+24) = 0;
        % b
        geomCode(cursor+25) = normal82Byte1(currentVertMat(indVert, 12));
        geomCode(cursor+26) = normal82Byte1(currentVertMat(indVert, 13));
        geomCode(cursor+27) = normal82Byte1(currentVertMat(indVert, 14));
        geomCode(cursor+28) = 0;

        cursor = cursor+28;

    end

    % write vertex type
    geomCode(cursor+1: cursor+16) = [115; 101; 116; 51; 47; 120; 121; 122; 110; 117; 118; 116; 98; 112; 99; 0]; % 'set3/xyznuvtbpc '
    cursor = cursor+16;

    clear currentVertMat;

    %% start "indexSection" at cursor+1

    % find frameCode's indexSectionPosition
    frameIndexPosition = byte2Uint32LE(frameCode(49), frameCode(50), frameCode(51), frameCode(52));

    geomCode(cursor+1: cursor+8) = frameCode(frameIndexPosition+1: frameIndexPosition+8); 
    geomCode(cursor+9: cursor+12) = uint322Byte4LE(6*(size(body_indices, 1) + size(tail_indices, 1) + size(friction_indices, 1)));
    geomCode(cursor+13: cursor+16) = frameCode(frameIndexPosition+13: frameIndexPosition+16); 

    cursor = cursor + 16;

    % write first index bloc

    switch indOrder{1}
        case 'tail'
            currentIndMat = tail_indices;
        case 'body'
            currentIndMat = body_indices;
        case 'friction'
            currentIndMat = friction_indices;
        otherwise
            error('a wild bug appears');
    end

    for indInd = 1:size(currentIndMat, 1)

        geomCode(cursor+1: cursor+2) = uint162Byte2LE(currentIndMat(indInd, 1) - 1);
        geomCode(cursor+3: cursor+4) = uint162Byte2LE(currentIndMat(indInd, 2) - 1);
        geomCode(cursor+5: cursor+6) = uint162Byte2LE(currentIndMat(indInd, 3) - 1);

        cursor = cursor+6;

    end

    % write second index bloc

    switch indOrder{2}
        case 'tail'
            currentIndMat = tail_indices;
        case 'body'
            currentIndMat = body_indices;
        case 'friction'
            currentIndMat = friction_indices;
        otherwise
            error('a wild bug appears');
    end

    for indInd = 1:size(currentIndMat, 1)

        geomCode(cursor+1: cursor+2) = uint162Byte2LE(currentIndMat(indInd, 1) - 1);
        geomCode(cursor+3: cursor+4) = uint162Byte2LE(currentIndMat(indInd, 2) - 1);
        geomCode(cursor+5: cursor+6) = uint162Byte2LE(currentIndMat(indInd, 3) - 1);

        cursor = cursor+6;

    end

    % write third index bloc

    switch indOrder{3}
        case 'tail'
            currentIndMat = tail_indices;
        case 'body'
            currentIndMat = body_indices;
        case 'friction'
            currentIndMat = friction_indices;
        otherwise
            error('a wild bug appears');
    end

    for indInd = 1:size(currentIndMat, 1)

        geomCode(cursor+1: cursor+2) = uint162Byte2LE(currentIndMat(indInd, 1) - 1);
        geomCode(cursor+3: cursor+4) = uint162Byte2LE(currentIndMat(indInd, 2) - 1);
        geomCode(cursor+5: cursor+6) = uint162Byte2LE(currentIndMat(indInd, 3) - 1);

        cursor = cursor+6;

    end

    %% write code to new file

    geomFile = fopen(geomFileName, 'w');
    fwrite(geomFile, geomCode);
    fclose(geomFile);

    %% end

    fclose all;
    disp(['conversion of ', primFileName, ' is finished']);
    
    succes = 1;
    
end
