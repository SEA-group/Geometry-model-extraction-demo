function byte1 = normal82Byte1(inputFloat)
    
    byte1 = round((inputFloat/2) * 255 + 127.5);
    
    if byte1 < 0
        
        byte1 = 0;
        
    elseif byte1 > 255
        
        byte1 = 255;
        
    end

end