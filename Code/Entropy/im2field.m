function [DT] = im2field(I)

    % This function returns a 3D image of the fibers whose coordinates are
    % given in the fib array
    %
    % OUTPUT
    % DT : vector field
    % 
    % INPUT
    % I : 3D grayscale image of tractography
    
    [un, vn, wn] = dgvf_calc(I, 200, 0, 0.4, 1,1,1);
    dim = size(un);
    
    % using reorient_mex (speed x7)
    un_fill = nan([129,129,27]*3);
    un_fill(1:dim(1), 1:dim(2), 1:dim(3)) = un;
    vn_fill = nan([129,129,27]*3);
    vn_fill(1:dim(1), 1:dim(2), 1:dim(3)) = vn;
    wn_fill = nan([129,129,27]*3);
    wn_fill(1:dim(1), 1:dim(2), 1:dim(3)) = wn;
    
    [unew, vnew, wnew] = reorient_codegen(un_fill, vn_fill, wn_fill, dim); 
     
    %using reorient.m
    %[unew, vnew, wnew] = reorient(un, vn, wn);
    
    [theta, phi, rho] = cart2sph2(unew, vnew, wnew);
    masque = im2bin(rho, 0);

    [r, c, d] = size(un);  
    DT = zeros(r, c, d, 2);
    DT(:,:,:,1) = apply_mask(theta, masque);
    DT(:,:,:,2) = apply_mask(phi, masque);


end