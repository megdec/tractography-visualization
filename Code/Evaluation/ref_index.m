function [index_ref, fib_int] = ref_index(maskRef, fibinit, show)

    % Creates a reference index from a expert tractography and a whole
    % brain tractography
    %
    % INPUT
    % fibref a cell array of the coordinates of reference fibers (cf
    % tracks2array)
    % fib a cell array of the coordinates of fibers we want to quantify
    % quality
    % size: size of the matrix from whom the coordinates were taken
    %
    % OUTPUT
    % index_ref: indices of the fibers considered to belong to nerves
    
    
%     r = size(maskRef, 1);
%     if r ~= 128
%         [fibinit, I] = fib_3D_image(fibinit, [128, 128, 26] , r/128);
%     end
    
    index_ref = zeros(0,0);
    n = 1;
    for k = 1:length(fibinit)
        s = 0;
        for j = 1:size(fibinit{k}, 1)
            s = s + maskRef(floor(fibinit{k}(j, 1)), floor(fibinit{k}(j, 2)), floor(fibinit{k}(j, 3))); 
        end
        if s >= (3/4)*length(fibinit{k})
            index_ref(n) = k;
            n = n + 1;
        end
    end
    
    nb = size(index_ref,2);
   
    if nb
        fib_int = cell(1, nb);
        for i = 1:nb
            fib_int{i} = fibinit{index_ref(i)};
        end  
    else
        fprintf('%s\n', 'No fibers within mask.');
        fib_int = {};
    end
   
    
    if show

        
        [~, Iint] = fib_3D_image(fib_int, 1, size(maskRef));
        [~, I] = fib_3D_image(fibinit, 1, size(maskRef));
        
        f = frameBufferZ(Iint, false);
        f2 = frameBufferZ(maskRef, false);
        f3 = frameBufferZ(I, false);
        
        subplot(2,2,1);
        imagesc(f2(:,:,1));
        colorbar;
        xticks([]);
        yticks([]);
        ax = gca;
        ax.FontSize = 24; 
        title(sprintf('%s', "Masque à appliquer"));
        
        subplot(2,2,2);
        imagesc(f(:,:,1));
        colorbar;
        xticks([]);
        yticks([]);
        ax = gca;
        ax.FontSize = 24; 
        title(sprintf('%s %i%s', "Intersection: ", nb, " fibres dans la zone"));
        
        subplot(2,2,3);
        imagesc(f3(:,:,1));
        colorbar;
        xticks([]);
        yticks([]);
        ax = gca;
        ax.FontSize = 24; 
        title(sprintf('%s', "Tracto à tester"));
    end
    
   
end