% An experimental geometry model extractor, vertex-index pairing script
% version 2022.06.20a
% requirement: none

function combinations = BlocMatch_Mk1(blocVertex, blocIndex)

    combinations = [];
    
    % parse vertex blocs, count the quantity of vertices
    numVertex = zeros(length(blocVertex), 1);
    for indVertexBloc = 1: length(blocVertex)
        numVertex(indVertexBloc) = blocVertex{indVertexBloc}.numVertex;
    end
    
    % parse index blocs, check the number of referenced vertices
    maxIndex = zeros(length(blocIndex), 1);
    for indIndexBloc = 1: length(blocIndex)
        maxIndex(indIndexBloc) = max(max( blocIndex{indIndexBloc}.dataIndex ));
    end
    
    % sort
    

end