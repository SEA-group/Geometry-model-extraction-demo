function outputFloat = byte2Float32BE(byte1, byte2, byte3, byte4)
    
    outputFloat = typecast(uint8([byte4, byte3, byte2, byte1]), 'single');

end