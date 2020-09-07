function [E_conc, L] = concatenate_Emat(E, ext)

    % Find the minimum range of x, y, z required for the concatenated
    % matrix
    
    btab = zeros(1, 6);
    for i = 1:size(ext, 2)
        btab(i, 1:6) = ext{i};
    end

    L = [min(btab(:, 1)), max(btab(:, 2)), min(btab(:, 3)), max(btab(:, 4)), min(btab(:, 5)), max(btab(:, 6))];
    xlim = ([min(btab(:, 1)), max(btab(:, 2))]-1)*3 + [1 1];
    ylim = ([min(btab(:, 3)), max(btab(:, 4))]-1)*3 + [1 1];
    zlim = ([min(btab(:, 5)), max(btab(:, 6))]-1)*3 + [1 1];
    
    % Rescale matrices
    for i = 1:size(E,2)
        
        lim = (ext{i}-1)*3 + [1 1 1 1 1 1];
        Escale = nan(xlim(2), ylim(2), zlim(2));

        Escale(lim(1):lim(2)+2, lim(3):lim(4)+2, lim(5):lim(6)+2) = E{i};
        Es{i} = Escale(xlim(1):xlim(2), ylim(1):ylim(2), zlim(1):zlim(2));
               
    end
    
    % Concatenante matrices 
    E_conc = Es{1};
    
    for i = 2:size(E,2)
        
        Etest = Es{i};
        
        for x=1:size(E_conc, 1)
            for y=1:size(E_conc, 2)
                for z=1:size(E_conc, 3)
                    
                    if Etest(x,y,z) > E_conc(x,y,z) || (isnan(E_conc(x,y,z))==1 && isnan(Etest(x,y,z)) == 0)
                        E_conc(x,y,z) = Etest(x,y,z);
                    end
                    
                end
            end
        end
        
    end
    
    
    
end