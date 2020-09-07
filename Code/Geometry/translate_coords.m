function [s] = translate_coords(s, t)
    
 
    for k = 1:size(s, 2)
        s{k}(:,1) = s{k}(:,1) + t(1);
        s{k}(:,2) = s{k}(:,2) + t(2);
        s{k}(:,3) = s{k}(:,3) + t(3);
    end
end