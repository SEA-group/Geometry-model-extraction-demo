% input : 1 double
% output : 1 double

function outputFloat = byte2Normal8(byte1)
    
    outputFloat = 2 * (byte1 - 127.5) / 255;

end