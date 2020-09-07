function [F]= frameBufferX(E, minimum)
    
    % This function generate the entropy framebuffer of en entropy matrix along the
    % z axis (1 dimension of the matrix)
    %
    % INPUT 
    % entropyMatrix: l x c x h entropy matrix (see funcion entropy3D to get
    % one)
    % minimum: boolean True (minimum entropy framebuffer) or False (maximum
    % entropy framebuffer)
    % 
    % OUTPUT
    % F: l x h x 2 enropy framebuffer. F(:,:,1) returns the maximum entropy
    % value for the column of coords l, h, F(:,:,2) returns the depth of
    % the corresponding value
    
if minimum
    [M, NDX] = nanmin(E, [], 1);
else
    [M, NDX] = nanmax(E, [], 1);
    
end

F = [squeeze(M(1,:,:)), squeeze(NDX(1,:,:))];
[~, y, z] = size(M);
F = reshape(F, y, z, 2);
    
end