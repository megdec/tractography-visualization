function [F] = dt2field (DT_mat)

    % This function transforms a diffusion tensor matrix into a vector
    % field that can be used in the entropy3D function. 
    % | Dxx  Dxy |
    % | Dxy  Dyy |
    %
    % INPUT
    % filename: a diffusion tensor file in nii format
    %
    % OUTPUT
    % F: x*y*z*2 matrix. M(:,:,:,1) and M(:,:,:,2) are the values of angles
    % theta and phi (as given by the convention describe in file...), of
    % all diffusion tensor vectors in the 3D field.
    %
    % Note: Mrtrix uses convention [D11, D22, D33, D12, D13, D23] for dt
    % file.
    
 
    if isa(DT_mat, 'char')
        dt = load_untouch_nii(DT_mat);
        Dt = dt.img;
    else
        Dt = DT_mat;
    end
    
    [row, col, depth, t] = size(Dt);
    
    F = zeros(row, col, depth, 2);
    countNaN = 0;
    
    for r = 1:row 
        for c = 1:col
            for d = 1:depth
                
                diffusion_matrix = [Dt(r,c,d,1), Dt(r,c,d,4), Dt(r,c,d,5); Dt(r,c,d,4), Dt(r,c,d,2), Dt(r,c,d,6);Dt(r,c,d,5), Dt(r,c,d,6), Dt(r,c,d,3)];
                
                if sum(isnan(diffusion_matrix))>0
                    countNaN = countNaN+1;
                    theta = NaN;
                    phi = NaN;
                
                else
                    [V, L] = eig(diffusion_matrix);
                    [L, iL] = sort(diag(L),'descend'); % sort L in descending
                    L = diag(L);                       % reform eigenvalue matrix
                    V = V(:,iL);                       % reorder eigenvectors

                    %eigen_vector = V(:,1);
                    eigen_vector = V(:,3);
                    n=sqrt(eigen_vector(1)^2+eigen_vector(1)^2+eigen_vector(1)^2);

%                    if L(1,1)>0

%                     theta = abs(atan2(eigen_vector(3),eigen_vector(1)));
%                     phi = atan2(eigen_vector(2), eigen_vector(1))+pi;
                    [theta, phi, ~] = cart2sph2(eigen_vector(1),eigen_vector(2), eigen_vector(3));
                               
%                    else 
%
%                         theta = Inf;
%                          phi = Inf;
%                     end
                    
                end
                  
                
                F(r,c,d, 1) = theta;
                F(r,c, d, 2) = phi;
            end
        end
    end
    %F=permute(F,[3,2,1,4]); % remet l'image "droite" par rapport à Matlab
    
    if countNaN>0
        fprintf('%s %i %s\n', "Warning.", countNaN, "dt values were NaN.");
    end
end

    