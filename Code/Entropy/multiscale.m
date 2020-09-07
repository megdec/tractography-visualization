function [E, S] = multiscale(Emat, scales)
    
    [r,c,d] = size(Emat{1});
    E = Emat{1};
    S = zeros(r,c,d) + scales(1);
    
    for i = 2:size(Emat,2)
        Etest = Emat{i} - nanmin(nanmin(nanmin(Emat{i})));
        
        for x=1:r
            for y=1:c
                for z=1:d
                    if Etest(x,y,z) < E(x,y,z)
                        E(x,y,z) = Etest(x,y,z);
                        S(x,y,z) = scales(i);
                    end
                end
            end
        end
    end