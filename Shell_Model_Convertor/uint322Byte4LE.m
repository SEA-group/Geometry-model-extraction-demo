% input : 1 * double
% output : 4 * double

function bytes = uint322Byte4LE(inputFloat)
    
    byte4 = floor( inputFloat / 256^3 );
    byte3 = floor( mod(inputFloat, 256^3) / 256^2 );
    byte2 = floor( mod(inputFloat, 256^2) / 256 );
    byte1 = mod(inputFloat, 256);
    
    bytes = [byte1, byte2, byte3, byte4];

end