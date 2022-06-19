% input : 4x1 double
% output : 1 double

function outputFloat = byte2Float32LE(bytes)
    
    outputFloat = typecast(uint8([bytes(1), bytes(2), bytes(3), bytes(4)]), 'single');

end