function outputFloat = byte2Normal8(byte1)
    
    outputFloat = 0.5 + (byte1 - 127) / 255;

end