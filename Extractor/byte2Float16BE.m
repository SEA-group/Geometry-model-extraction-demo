% input : 2x1 double
% output : 1 double

function outputFloat = byte2Float16BE(bytes)
    
    outputFloat = double(half.typecast(uint16( bytes(1) * 256 + bytes(2) )));

end