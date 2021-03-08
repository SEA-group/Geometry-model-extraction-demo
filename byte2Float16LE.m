function outputFloat = byte2Float16LE(byte1, byte2)
    
    outputFloat = half.typecast(uint16(byte2 * 256 + byte1));

end