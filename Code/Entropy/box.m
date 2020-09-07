function [vol] = box(s)
    
    if size(s, 2) == 0
        vol = 0;
    else
    
        extrema = [min(s{1}(:,1)), max(s{1}(:,1)), min(s{1}(:,2)), max(s{1}(:,2)), min(s{1}(:,3)), max(s{1}(:,3))];

        for k = 1:size(s,2)
            for i = 1:3
                if min(s{k}(:,i)) < extrema(2*i-1)
                    extrema(2*i-1) = floor(min(s{k}(:,i)));
                end
                if max(s{k}(:,i)) > extrema(2*i)
                    extrema(2*i) = ceil(max(s{k}(:,i)));
                end
            end
        end   
        final_size = extrema(2:end) - extrema(1:end-1)+1;
        final_size = final_size(1:2:end);
        vol = final_size(1)*final_size(2)*final_size(3);
    end
end