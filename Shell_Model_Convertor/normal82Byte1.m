function byte1 = normal82Byte1(inputFloat)
    
    byte1 = (inputFloat - 0.5) * 255 + 127;
    
    if byte1 < 0
        
        byte1 = 0;
        
    elseif byte1 > 255
        
        byte1 = 255;
        
    end

end