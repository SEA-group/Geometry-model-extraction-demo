function outputFloat = byte2Float32LE(byte1, byte2, byte3, byte4)
    
    outputFloat = typecast(uint8([byte1, byte2, byte3, byte4]), 'single');

end