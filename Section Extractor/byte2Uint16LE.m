% input : 2x1 double
% output : 1 double

function outputFloat = byte2Uint16LE(bytes)
    
    outputFloat = bytes(2) * 256 + bytes(1);

end