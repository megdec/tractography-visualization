function [ s_resamp, final_size, extrema] = crop1(s, init_size, extrema)
    % Crop image to be tight to fibers, translate coordinates.
    
    if size(extrema, 2) < 1
        %crop automatique
        extrema = [floor(min(s{1}(:,1))), ceil(max(s{1}(:,1))), floor(min(s{1}(:,2))), ceil(max(s{1}(:,2))), floor(min(s{1}(:,3))), ceil(max(s{1}(:,3)))];
        
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
    end
    
    mask = zeros(init_size);
    final_size = extrema(2:end) - extrema(1:end-1)+1;
    final_size = final_size(1:2:end);
    mask(extrema(1):extrema(2), extrema(3):extrema(4), extrema(5):extrema(6)) = zeros(final_size(1), final_size(2), final_size(3)) +1;
    [~, scrop] = ref_index(mask, s, false);
    scrop = translate_coords(scrop, [-extrema(1)+1, -extrema(3)+1, -extrema(5)+1]);
    s_resamp = resample(scrop, 2);

end