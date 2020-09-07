function [S] = score_matrix(E, F, min)
    
    [l, c, d] = size(E);
    S = zeros(l, c, d);
    
    
    for x=1:l
        for y=1:c
            for z=1:d
    
                DZ = z - F(x, y, 2);
                DE = F(x, y, 1) - E(x, y, z) ;
        
                
                if DZ<0
                    score = - F(x, y, 1)*(1-exp(-abs(DZ)*abs(DE)));
                    
                else
                    if min
                        score = (1-E(x, y, z))*(exp(-abs(DZ)*abs(DE)));
                        
                    else
                        score = E(x, y, z)*(exp(-abs(DZ)*abs(DE)));
                    end
                    
                end
                
                S(x, y, z) = score;
            end
        end
    end
                
        
end
