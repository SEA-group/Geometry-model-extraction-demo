% input : 4x1 double
% output : 1 double

function outputFloat = byte2Float32BE(bytes)
    
    outputFloat = typecast(uint8([bytes(4), bytes(3), bytes(2), bytes(1)]), 'single');

end