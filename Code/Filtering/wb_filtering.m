function [Esc_mask] = wb_filtering (file, param, output)
    
    s = tracks2array(file);
    [crops, dim, ~] = crop(s, [128,128,27], [40, 90, 45, 100, 1, 27]);
    [T,P] = find_bins(60);

            
    % Calcul de la matrice d'entropie
                
    [pixs, I] = fib_3D_image(crops, 3, dim+1);
       
            
    fprintf('%s\n', "Computing orientation map...");
    DT = im2field(I);
    codegen entropy3D -args {DT, [3,3,3], 60, T, P}
    
    fprintf('%s\n', "Generating entropy matrix...");
    
    Emat = cell(1, size(param, 2));
    for i = 1:size(param,2)
        Emat{i} = entropy3D_mex(DT, repelem(param(i),3), 60, T, P);
    end
    
    Esc = multiscale(Emat, param);
            
    % Filtrage et output
          
    filter_fib_abs(s, pixs, Esc, 10:10:100, output, true); 
    Esc_mask = apply_mask(Esc, pixs);      
 
    
end
    