function[varargout]=rotMatrix(matrix, theta, phi)
    % Do a double matrix rotation according to axis x and z
    %
    % INPUT
    % theta rotation angle for axis x
    % phi rotation angle for axis z
    % matrix is the matrix to apply rotation on
    %
    % OUTPUT
    % R rotated matrix
    
    
    [r, c, d] = size(matrix);
    
    [angle, vect] = convert_angles(theta, phi);
    Rot  = AxelRot(angle, vect,[]);
    tform = affine3d(Rot);
    matrix(isnan(matrix)) = -100;
    [R, refR] = imwarp(matrix, imref3d([r, c, d]), tform,'SmoothEdges', true, 'FillValues', NaN); 
    R(R < 0) = NaN;
    varargout{1} = R;
    
   
   if nargout == 2
       
       k = 0;
       convert = nan(r, c, d, 3);
       [x, y, z] = meshgrid(1:r, 1:c, 1:d);

       
       [worldx, worldy, worldz] = transformPointsForward(tform,x, y, z);
       [newx, newy, newz] = worldToSubscript(refR , worldx, worldy, worldz);
       convert(:,:,:, 1) = newx;
       convert(:,:,:, 2) = newy;
       convert(:,:,:, 3) = newz;



       varargout{2} = convert;
   end
      
end
