% input : 4x1 double
% output : 1 double

function outputStr = uint16LE2HexStr(inputInt)
    
    outputStr = '';
    
    for indInt = 1:length(inputInt)
        str = dec2hex(inputInt(indInt));
        if isempty(str)
            outputStr = [outputStr, '0000'];
        elseif length(str) == 1
            outputStr = [outputStr, '000', str];
        elseif length(str) == 2
            outputStr = [outputStr, '00', str];
        elseif length(str) == 3
            outputStr = [outputStr, '0', str];
        else
            outputStr = [outputStr, str];
        end
    end
    
    outputStr = outputStr(:, [3, 4, 1, 2]);

end