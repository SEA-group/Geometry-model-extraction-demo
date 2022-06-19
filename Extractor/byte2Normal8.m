function outputFloat = byte2Normal8(byte1)
    
    outputFloat = 2 * (byte1 - 127.5) / 255;

end