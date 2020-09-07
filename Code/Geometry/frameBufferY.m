function [F]= frameBufferY(E, minimum)

if minimum
    [M, NDX] = nanmin(E, [], 2);
else
    [M, NDX] = nanmax(E, [], 2);
    
end


F = [squeeze(M(:,1,:)), squeeze(NDX(:,1,:))];
[x, ~, z] = size(M);
F = reshape(F, x, z, 2);


end