function [E, bounds, pixnerve] = entropy_matrix(filename, init_size, param)
    
    % Returns the entropy matrix for a given nerve txt or tck file
    %
    % INPUT 
    %
    % filename: name of the tck or txt fiber file
    % init_size: dimensions of the DTI used to track the nerve 
    % param : neigbhorhood sizes you wish to use for the computation of the
    % entropy matrix. Recommended: [3,3,3]
    % 
    % OUTPUT
    % E: Entropy matrix (use show_matrix to
    % visualise)
    % bounds : boundaries of the croped matrix
    % pixnerve : coordinates of the nerve in the entropy matrix referential
    % 
    % EXAMPLE USE
    % filter_nerve('voxVD1DIM1.tck', [129,129,27], [3,3,3]);
    
    fprintf('%s\n', "Computing entropy matrix...");
    nerve = tracks2array(filename);
    
    if size(nerve,2) < 20
        error('Empty file or not enought fibers');
    end
    
    % Crop image for computation cost 
    [crop_nerve, dim, bounds] = crop1(nerve, init_size, []); 
    
    % Creates image and resample x3
    [pixnerve, I] = fib_3D_image(crop_nerve, 3, dim); 
   
    % Creates vector field
    DT = im2field(I); 
    
    % Computes entropy matrices
    [T, P] = find_bins(60);
    Emat = cell(1, size(param, 1));
    
    % Use same matrix size for C wraped code
    DT_fill = nan(init_size*3);
    DT_fill(1:size(DT,1), 1:size(DT, 2), 1:size(DT, 3), 1:size(DT,4)) = DT; 
    
    %codegen entropy3D_codegen -args {DT, [3,3,3], 60, T, P}
    
    % Computes entropy map
    for i = 1:size(param, 1)
        mat = entropy3D_codegen(DT_fill, [size(DT,1), size(DT,2), size(DT,3)], param(i, :), 60, T, P); 
        Emat{i} = apply_mask(mat, pixnerve); 
    end
    
    % Multi-scale if required
    if size(param, 1) == 1
        E = Emat{1};
    else
        E = multiscale(Emat, param); 
    end 
    
    % Normalizing entropy to [0, 1] for comparison purposes
    minV = nanmin(nanmin(nanmin(E)));
    maxV = nanmax(nanmax(nanmax(E)));
    E = (E-minV)/(maxV-minV);

end