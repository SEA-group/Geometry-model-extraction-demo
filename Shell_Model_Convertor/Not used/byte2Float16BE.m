% input : 2 * double
% output : 1 * double

function outputFloat = byte2Float16BE(byte1, byte2)
    
    outputFloat = double(half.typecast(uint16(byte1 * 256 + byte2)));

end