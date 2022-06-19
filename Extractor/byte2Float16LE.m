% input : 2x1 double
% output : 1 double

function outputFloat = byte2Float16LE(bytes)
    
    outputFloat = double(half.typecast(uint16( bytes(2) * 256 + bytes(1) )));

end