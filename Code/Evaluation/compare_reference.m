function [SD] = compare_reference(filename, pixnerve, E, init_size, p, refnerve)
    
    % Automatically filters a nerves tracked by Mrtrix, saved as a tck file
    %
    % INPUT 
    %
    % filename : path to the tck or txt file or the nerve
    % E: entropy matrix of the nerve
    % p: list of percentages. If empty, the best percentage is
    % automatically set.
    % refnerve : path to the tck or txt file or the reference nerve
    % 
    % OUTPUT
    % list of Sorensen-Dice scores
    % 
    % EXAMPLE USE
    % filter_nerve('voxVD1DIM1.tck', [129,129,27], [3,5,7,9], true, 'VD_vox.tck');
    
    nerve = tracks2array(filename);
    [~, ind] = filter_nerve(filename, pixnerve, E, p, '');
    
    ref = tracks2array(refnerve);
    
    mask = zeros(init_size) +1;
    mask_ref = apply_mask(mask, ref);
    [ref_ind, ~] = ref_index(mask_ref, nerve, false); 
        
    % Compute Sorensen_Dice quality score 
    SD = quality_score(ref_ind, ind);

end