function bytes = uint162Byte2LE(inputFloat)
    
    byte2 = floor( inputFloat / 256 );
    byte1 = round( mod(inputFloat, 256) );
    
    bytes = [byte1, byte2];

end