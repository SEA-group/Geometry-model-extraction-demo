function outputFloat = byte2Uint32BE(byte1, byte2, byte3, byte4)
    
    outputFloat = byte1 * 256^3 + byte2 * 256^2 +byte3 * 256 + byte4;

end