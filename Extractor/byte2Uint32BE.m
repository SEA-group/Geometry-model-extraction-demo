% input : 4x1 double
% output : 1 double

function outputFloat = byte2Uint32BE(bytes)
    
    outputFloat = bytes(1) * 256^3 + bytes(2) * 256^2 + bytes(3) * 256 + bytes(4);

end