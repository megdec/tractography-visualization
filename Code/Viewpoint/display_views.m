function [] = display_views(A, FB, nv, best)

    % This function plots a figure of the best views of a vector
    % field, based on the computation of the Entropy Score of the associated
    % framebuffer. 
    % 
    % INPUT
    % A: list of angles and entropy score (see find_best_views)
    % FB : 2D projection according to angles given in A (see find_best_views)
    % nv : number of projections to display
    % best : true to display the best views, false to display the worst

    if best
        frame = 1:nv;
    else
        frame = (size(FB, 2)-nv+1): size(FB, 2);
    end
    
    for i = 1:nv
        
        j = frame(i);
        nsub = floor(nv/4) +1;
        if (mod(nv, 4)==0)
            nsub = nsub - 1;
        end
        subplot(nsub,4,i);
      
        imagescwithnan(flipud(transpose(fliplr(FB{j}))), gray, [0 0 0]);

        axis equal;
        xticks([])
        yticks([])
        
           

        title(sprintf('score: %1.3f\n (%1.3f, %1.3f)', A(j,1), A(j,2), A(j,3)), 'Fontsize', 16);
        %title(['E.S: ' num2str(A(i,1)) '\n' '( \theta = ' num2str(A(i,2)) ', \phi = ' num2str(A(i,3)) ')'], 'Fontsize', 22);
    end
  
        colorbar('Position', [0.93 0.38 0.015 0.30])

 
end
