% input : 4x1 double
% output : 1 double

function outputStr = byte2HexStr(bytes)
    
    outputStr = '';
    
    for indByte = 1:length(bytes)
        str = dec2hex(bytes(indByte));
        if isempty(str)
            outputStr = [outputStr, '00'];
        elseif length(str) == 1
            outputStr = [outputStr, '0', str];
        else
            outputStr = [outputStr, str];
        end
            
    end

end