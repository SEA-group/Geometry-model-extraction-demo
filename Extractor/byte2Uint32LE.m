function outputFloat = byte2Uint32LE(byte1, byte2, byte3, byte4)
    
    outputFloat = byte4 * 256^3 + byte3 * 256^2 + byte2 * 256 + byte1;

end