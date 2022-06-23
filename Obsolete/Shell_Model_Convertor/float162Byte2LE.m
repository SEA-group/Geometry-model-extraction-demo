% input : 1 * double
% output : 2 * double

function bytes = float162Byte2LE(inputFloat)
    
    intermediaUint16 = storedInteger(half(inputFloat));
    byte2 = floor( intermediaUint16 / 256 );
    byte1 = mod( intermediaUint16, 256 );
    bytes = [double(byte1), double(byte2)];

end