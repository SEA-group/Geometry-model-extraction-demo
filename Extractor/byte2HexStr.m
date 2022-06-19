% input : 4x1 double
% output : 1 double

function outputStr = byte2HexStr(bytes)
    
    outputStr = '';
    
    for indByte = 1:length(bytes)
        str = dec2hex(bytes(indByte));
        outputStr = [outputStr, str];
    end

end