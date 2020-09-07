function [F] = frameBufferZ(E, minimum)

if minimum
    [M, NDX] = nanmin(E, [], 3);
else
    [M, NDX] = nanmax(E, [], 3);
    
end


F = [squeeze(M(:,:,1)), squeeze(NDX(:,:,1))];
[x, y, ~] = size(M(:,:,1));
F = reshape(F, x, y, 2);

    
end