% Save mesh to obj file, for geometry model extractor
% version 2022.06.21a
% requirement:
% - uint32LE2HexStr.m

function mesh2obj(matVertexCoord, matVertexNorm, matTextureCoord, matIndex, listEntity, fileName)
    
    % create file
    Fobj = fopen(fileName, 'w');
    
    % write title
    fprintf(Fobj, '%s\r\n%s\r\n\r\n', '# obj file generated by GeometryExtractor Mk1 by SEA group', '# Program working in progress, for test purpose only');

    % write vertex coordinates
    for indVertex = 1: size(matVertexCoord,1)        
        fprintf(Fobj, 'v %f %f %f\r\n', matVertexCoord(indVertex, 1), matVertexCoord(indVertex, 2), matVertexCoord(indVertex, 3));      
    end
    
    % write vertex normals
    for indNormal = 1: size(matVertexNorm,1)        
        fprintf(Fobj, 'vn %f %f %f\r\n', matVertexNorm(indNormal, 1), matVertexNorm(indNormal, 2), matVertexNorm(indNormal, 3));      
    end
    
    % write texture coordinates
    for indTexture = 1: size(matTextureCoord,1)        
        fprintf(Fobj, 'vt %f %f\r\n', matTextureCoord(indTexture, 1), matTextureCoord(indTexture, 2));      
    end
    
    % Write faces
    listEntityUnique = unique(listEntity);
    for indEntity = 1: size(listEntityUnique)
        fprintf(Fobj, '\r\n%s%s\r\n', 'g ', uint32LE2HexStr(listEntityUnique(indEntity)) );
        for indTriangle = 1: size(matIndex,1)
            if listEntity(matIndex(indTriangle, 1)) == listEntityUnique(indEntity)
                fprintf(Fobj, 'f %d/%d/%d %d/%d/%d %d/%d/%d\r\n', ...
                    matIndex(indTriangle, 1), matIndex(indTriangle, 1), matIndex(indTriangle, 1), ...
                    matIndex(indTriangle, 2), matIndex(indTriangle, 2), matIndex(indTriangle, 2), ...
                    matIndex(indTriangle, 3), matIndex(indTriangle, 3), matIndex(indTriangle, 3) );
            end
        end
    end
    
    % close files and finish
    fclose(Fobj);
    
end