function outputFloat = byte2Float16BE(byte1, byte2)
    
    outputFloat = half.typecast(uint16(byte1 * 256 + byte2));

end