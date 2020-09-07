function [] = stats_nerves(E, files, output)

    % This function computes the entropy mean and the volume (nb voxel) of 
    % each nerves whose tck file in given. It also perform statistical
    % tests to check wether the mean entropy difference is significant.
    % 
    % INPUT
    % E: entropy matrix
    % files: cell with file names of only right part
    % output: name of output txt file
    %
    % OUTPUT
    % A text file containing the detailed result
    
    fid = fopen(output, 'w');
    fprintf(fid, '%s\t %s\t %s\t %s\n', "filename", "entropy mean", "entropy variance", "volume (nb voxels)");
    [l, c, d] = size(E);
    
    for i=1:length(files)
        
        %right nerve
        filename_d = files{i};
        
        a = tracks2array(filename_d);
        E_mask = apply_mask(E, a);

        
        X = reshape(E_mask, 1, l*c*d);
        X = X(~isnan(X));

        moy = nanmean(X);
        var = nanvar(X);
        vol = length(X); 
        
        
        % file for left nerve
        filename_g = filename_d;
        filename_g(length(filename_g) - 8) = 'G';
        fidg = fopen(filename_g, 'r');
        
        if fidg<0
           fprintf(fid, '\n%s\t %f\t %f\t %i\n', filename_d, moy, var, vol);
        else
           
            ag=tracks2array(filename_g);
            E_mask = apply_mask(E, ag);

            Y = reshape(E_mask, 1, l*c*d);
            Y = Y(~isnan(Y));

            moyg = nanmean(Y);
            varg = nanvar(Y);
            volg = length(Y);
          
            
            fprintf(fid, '\n%s\t %f\t %f\t %i\n', filename_d, moy, var, vol);
            fprintf(fid, '%s\t %f\t %f\t %i\n', filename_g, moyg, varg, volg);

            % perform some statistical tests
            %histogram(X)

            if isnan(moyg) == false && isnan(moy) == false
                [~, norm_d] = kstest(X);
                [~, norm_g] = kstest(Y);

                if norm_d> 0.05 && norm_g> 0.05
                    [~, p] = ttest2(X, Y);
                    p2 = NaN;

                else
                    [~, p] = kstest2(X, Y);
                    p2 = ranksum(X, Y);
                end

                if p<0.05
                    fprintf('%s\n', filename_d);
                end


                fprintf(fid, '%s\t %s\n', "p-value ks", "p-value wilcoxon");
                fprintf(fid, '%f\t %f\n', p, p2);
            end
        end
    end
    fprintf(fid, '\n%s\t %s\n', "min entropy", "max entropy");
    fprintf(fid, '%f\t %f\n', nanmin(nanmin(nanmin(E))), nanmax(nanmax(nanmax(E))));
    fclose(fid);
end

