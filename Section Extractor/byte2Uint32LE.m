% input : 4x1 double
% output : 1 double

function outputFloat = byte2Uint32LE(bytes)
    
    outputFloat = bytes(4) * 256^3 + bytes(3) * 256^2 + bytes(2) * 256 + bytes(1);

end