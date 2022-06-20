% input : 2x1 double
% output : 1 double

function outputFloat = byte2Uint16BE(bytes)
    
    outputFloat = bytes(1) * 256 + bytes(2);

end