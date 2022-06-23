function bytes = float322Byte4LE(inputFloat)
    
    bytes = typecast(single(inputFloat), 'uint8');

end