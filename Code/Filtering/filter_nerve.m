function [fib, ind] = filter_nerve(filename, pixnerve, E, p, outfolder)
    
    % Automatically filters a nerves tracked by Mrtrix, saved as a tck file
    %
    % INPUT 
    %
    % filename : path to the tck or txt file or the nerve
    % pixnerve : coordinates of the nerve in the referential of the entropy
    % matrix (see entropy_matrix)
    % E: entropy matrix of the nerve (see entropy_matrix)
    % p: list of percentages. If empty, the best percentage is
    % automatically set.
    % outfolder : output folder for filtered nerves files. If empty, the filtered nerves files are
    % not writen.
    % 
    % OUTPUT
    % txt files of the filtered nerves you can read with DSI Studio. 
    % fib : coordinates of the fibers which were kept
    % ind : indices of the fibers which were kept
    % 
    % EXAMPLE USE
    % filter_nerve('voxVD1DIM1.tck', pix_V, [129,129,27], [3 3 3]);

    nerve = tracks2array(filename);

    if size(nerve,2) < 20
        error('Empty file or not enought fibers');
    end
 
   
    fprintf('%s\n', "Filtering data...");
    
    if isempty(p)
    
        p = 0:100;
        [fib, ~] = filter_fib_abs(nerve, pixnerve, E, p, true);   

        % Find optimal threshold
        score = zeros(1,size(p, 2));
    
        for i = 1:size(fib, 2) 
            score(i) = box(fib{i});
        end 
        
        thres = score(end)/100;
        [bornes] = best_p(score, thres);
            
        opti = p(bornes(1,2)); 
        fprintf('%s %f %s\n', "Setting optimal filtering percentage at", opti, "%");
        p = (opti);
    end

    
    % Filters
    [fib, ind] = filter_fib_abs(nerve, pixnerve, E, p); 
   

    % Writes files
    if isempty(outfolder) == 0
        
        for i=1:size(p,2)
             
             output = "filtered_nerve_" + num2str(p(i)) + ".txt";
             fid = fopen(outfolder + output, 'w');
             n = fib{i};
             
             for j = 1:size(n,2)
                 
                f = n{j};
                f = reshape(transpose(f), 1, length(f(:,1))*3);
                fprintf(fid,"%f ", f(1,:));
                fprintf(fid,"\n");
             end
             
             fclose(fid);  
             
        end
    end


end