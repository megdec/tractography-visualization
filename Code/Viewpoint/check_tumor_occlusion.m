function [F_corrected] = check_tumor_occlusion(Ftum, F, tumor_val, add)
    
    
    F_corrected = F(:,:,:);
    [r, c, ~] = size(Ftum);
    
    for x = 1:r
        for y = 1:c
            if Ftum(x,y,1) > 0.000001 
                F_corrected(x,y,1) = tumor_val;
                 if Ftum(x,y,2) <= F(x,y,2) 
                      F_corrected(x,y,1) = tumor_val+add;
                 end
                
            end
        end
    end
    
end