function outputFloat = byte2FloatBE(byte1, byte2, byte3, byte4)
    
    outputFloat = typecast(uint8([byte4, byte3, byte2, byte1]), 'single');

end