% input : 4x1 double
% output : 1 double

function outputStr = uint32LE2HexStr(inputInt)
    
    outputStr = '';
    
    for indInt = 1:length(inputInt)
        str = dec2hex(inputInt(indInt));
        switch length(str)
            case 0
                outputStr = [outputStr, '00000000'];
            case 1
                outputStr = [outputStr, '0000000', str];
            case 2
                outputStr = [outputStr, '000000', str];
            case 3
                outputStr = [outputStr, '00000', str];
            case 4
                outputStr = [outputStr, '0000', str];
            case 5
                outputStr = [outputStr, '000', str];
            case 6
                outputStr = [outputStr, '00', str];
            case 7
                outputStr = [outputStr, '0', str];
            otherwise
                outputStr = [outputStr, str];
        end
    end
    
    outputStr = outputStr(:, [7, 8, 5, 6, 3, 4, 1, 2]);

end