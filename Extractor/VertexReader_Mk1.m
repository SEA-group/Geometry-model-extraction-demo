% An experimental geometry model extractor, vertex data acquiring script
% version 2022.06.20a
% requirement:
% - byte2Float32LE.m
% - byte2Float16LE.m
% - byte2Uint16LE.m
% - byte2Normal8.m

function vertices = VertexReader_Mk1(data, numVertex, lenSingleVertex, type)

    vertices = zeros(numVertex, 10);     % we're only interested in x y z nx ny nz u v i w for model extraction
    type = type(1: end-1);

    if strcmpi(type, 'set3/xyznuviiiwwpc')    % skinned alpha model
%         vertices = zeros(numVertex,  10);   % save in xyznnnuviw
        for indVertex = 1 : numVertex
            cursor = (indVertex-1) * lenSingleVertex;
            vertices(indVertex, 1) = byte2Float32LE(data(cursor+1: cursor+4));                                      % x
            vertices(indVertex, 2) = byte2Float32LE(data(cursor+5: cursor+8));                                      % y
            vertices(indVertex, 3) = byte2Float32LE(data(cursor+9: cursor+12));                                     % z
            vertices(indVertex, 4) = byte2Normal8(data(cursor+13));                                                         % nx
            vertices(indVertex, 5) = byte2Normal8(data(cursor+14));                                                         % ny
            vertices(indVertex, 6) = byte2Normal8(data(cursor+15));                                                         % nz
            vertices(indVertex, 7) = byte2Float16LE(data(cursor+17: cursor+18)) + 0.5;                         % u
            vertices(indVertex, 8) = 0.5 - byte2Float16LE(data(cursor+19: cursor+20));                         % v
            vertices(indVertex, 9) = byte2Uint16LE(data(cursor+21: cursor+22));                                     % iii
            vertices(indVertex, 10) = byte2Uint16LE(data(cursor+23: cursor+24));                                     % ww
        end     % 24
    elseif strcmpi(type, 'set3/xyznuviiiwwrpc')    % skinned wire model
%         vertices = zeros(numVertex,  11);   % save in xyznnnuviwr
        for indVertex = 1 : numVertex
            cursor = (indVertex-1) * lenSingleVertex;
            vertices(indVertex, 1) = byte2Float32LE(data(cursor+1: cursor+4));                                      % x
            vertices(indVertex, 2) = byte2Float32LE(data(cursor+5: cursor+8));                                      % y
            vertices(indVertex, 3) = byte2Float32LE(data(cursor+9: cursor+12));                                     % z
            vertices(indVertex, 4) = byte2Normal8(data(cursor+13));                                                         % nx
            vertices(indVertex, 5) = byte2Normal8(data(cursor+14));                                                         % ny
            vertices(indVertex, 6) = byte2Normal8(data(cursor+15));                                                         % nz
            vertices(indVertex, 7) = byte2Float16LE(data(cursor+17: cursor+18)) + 0.5;                         % u
            vertices(indVertex, 8) = 0.5 - byte2Float16LE(data(cursor+19: cursor+20));                         % v
            vertices(indVertex, 9) = byte2Uint16LE(data(cursor+21: cursor+22));                                     % iii
            vertices(indVertex, 10) = byte2Uint16LE(data(cursor+23: cursor+24));                                     % ww
%             vertices(indVertex, 11) = byte2Float32LE(data(cursor+25: cursor+28));                                     % r
        end     % 28
    elseif strcmpi(type, 'set3/xyznuviiiwwtbpc')    % skinned model
%         vertices = zeros(numVertex,  12);   % save in xyznnnuviwtb
        for indVertex = 1 : numVertex
            cursor = (indVertex-1) * lenSingleVertex;
            vertices(indVertex, 1) = byte2Float32LE(data(cursor+1: cursor+4));                                      % x
            vertices(indVertex, 2) = byte2Float32LE(data(cursor+5: cursor+8));                                      % y
            vertices(indVertex, 3) = byte2Float32LE(data(cursor+9: cursor+12));                                     % z
            vertices(indVertex, 4) = byte2Normal8(data(cursor+13));                                                         % nx
            vertices(indVertex, 5) = byte2Normal8(data(cursor+14));                                                         % ny
            vertices(indVertex, 6) = byte2Normal8(data(cursor+15));                                                         % nz
            vertices(indVertex, 7) = byte2Float16LE(data(cursor+17: cursor+18)) + 0.5;                         % u
            vertices(indVertex, 8) = 0.5 - byte2Float16LE(data(cursor+19: cursor+20));                         % v
            vertices(indVertex, 9) = byte2Uint16LE(data(cursor+21: cursor+22));                                     % iii
            vertices(indVertex, 10) = byte2Uint16LE(data(cursor+23: cursor+24));                                     % ww
%             vertices(indVertex, 11) = byte2Float32LE(data(cursor+25: cursor+28));                                     % t
%             vertices(indVertex, 12) = byte2Float32LE(data(cursor+27: cursor+32));                                     % b
        end
    elseif strcmpi(type, 'set3/xyznuvpc')       % alpha model
%         vertices = zeros(numVertex,  8);   % save in xyznnnuv
        for indVertex = 1 : numVertex
            cursor = (indVertex-1) * lenSingleVertex;
            vertices(indVertex, 1) = byte2Float32LE(data(cursor+1: cursor+4));                                      % x
            vertices(indVertex, 2) = byte2Float32LE(data(cursor+5: cursor+8));                                      % y
            vertices(indVertex, 3) = byte2Float32LE(data(cursor+9: cursor+12));                                     % z
            vertices(indVertex, 4) = byte2Normal8(data(cursor+13));                                                         % nx
            vertices(indVertex, 5) = byte2Normal8(data(cursor+14));                                                         % ny
            vertices(indVertex, 6) = byte2Normal8(data(cursor+15));                                                         % nz
            vertices(indVertex, 7) = byte2Float16LE(data(cursor+17: cursor+18)) + 0.5;                         % u
            vertices(indVertex, 8) = 0.5 - byte2Float16LE(data(cursor+19: cursor+20));                         % v
        end     % 20
    elseif strcmpi(type, 'set3/xyznuvrpc')      % wire model
%         vertices = zeros(numVertex,  9);   % save in xyznnnuvr
        for indVertex = 1 : numVertex
            cursor = (indVertex-1) * lenSingleVertex;
            vertices(indVertex, 1) = byte2Float32LE(data(cursor+1: cursor+4));                                      % x
            vertices(indVertex, 2) = byte2Float32LE(data(cursor+5: cursor+8));                                      % y
            vertices(indVertex, 3) = byte2Float32LE(data(cursor+9: cursor+12));                                     % z
            vertices(indVertex, 4) = byte2Normal8(data(cursor+13));                                                         % nx
            vertices(indVertex, 5) = byte2Normal8(data(cursor+14));                                                         % ny
            vertices(indVertex, 6) = byte2Normal8(data(cursor+15));                                                         % nz
            vertices(indVertex, 7) = byte2Float16LE(data(cursor+17: cursor+18)) + 0.5;                         % u
            vertices(indVertex, 8) = 0.5 - byte2Float16LE(data(cursor+19: cursor+20));                         % v
%             vertices(indVertex, 9) = byte2Float32LE(data(cursor+21: cursor+24));                                     % r
        end     % 24
    elseif strcmpi(type, 'set3/xyznuvtbpc')     % standard model
%         vertices = zeros(numVertex,  10);   % save in xyznnnuvtb
        for indVertex = 1 : numVertex
            cursor = (indVertex-1) * lenSingleVertex;
            vertices(indVertex, 1) = byte2Float32LE(data(cursor+1: cursor+4));                                      % x
            vertices(indVertex, 2) = byte2Float32LE(data(cursor+5: cursor+8));                                      % y
            vertices(indVertex, 3) = byte2Float32LE(data(cursor+9: cursor+12));                                     % z
            vertices(indVertex, 4) = byte2Normal8(data(cursor+13));                                                         % nx
            vertices(indVertex, 5) = byte2Normal8(data(cursor+14));                                                         % ny
            vertices(indVertex, 6) = byte2Normal8(data(cursor+15));                                                         % nz
            vertices(indVertex, 7) = byte2Float16LE(data(cursor+17: cursor+18)) + 0.5;                         % u
            vertices(indVertex, 8) = 0.5 - byte2Float16LE(data(cursor+19: cursor+20));                         % v
%             vertices(indVertex, 9) = byte2Float32LE(data(cursor+21: cursor+24));                                     % t
%             vertices(indVertex, 10) = byte2Float32LE(data(cursor+25: cursor+28));                                     % b
        end     % 28
    else
        disp(['unknown vertex type ', type]);
        vertices = [];
    end

end