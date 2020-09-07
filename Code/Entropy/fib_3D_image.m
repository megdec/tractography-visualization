function [varargout] = fib_3D_image(f, grid, siz)

    % This function returns a 3D image of the fibers whose coordinates are
    % given in the fib array
    %
    % INPUT
    % fib : cell array of fiber coordinates (see tracks2array func)
    % size : initial size of the dt file 
    % grid : precision of the discretization wanted to make the image
    % sigma: variance (e-t) for gaussian filter 
    % 
    % OUTPUT
    % varagout(1) fib :  new fib pixel coordinates
    % varagout(2) I : 3D grayscale image of tractography (0-1)
    
    s = [floor(siz(1)*grid), floor(siz(2)*grid), floor(siz(3)*grid)];
    I = zeros(s(1), s(2), s(3));
    fib = f;

    for k = 1:size(fib, 2)
        
        before = [NaN, NaN, NaN]; 
      
        fib{k}(:,1) = floor(axes2pix(s(1), [1, siz(1)], fib{k}(:,1)));
        fib{k}(:,2) = floor(axes2pix(s(2), [1, siz(2)], fib{k}(:,2)));
        fib{k}(:,3) = floor(axes2pix(s(3), [1, siz(3)], fib{k}(:,3)));
        
        
        
        if nargout >= 2
            for i = 1:size(fib{k},1)
                
                if sum(before == [fib{k}(i,1), fib{k}(i,2), fib{k}(i,3)]) < 3
                    I(fib{k}(i,1), fib{k}(i,2), fib{k}(i,3)) = I(fib{k}(i,1), fib{k}(i,2), fib{k}(i,3)) + 1; 
                    before = [fib{k}(i,1), fib{k}(i,2), fib{k}(i,3)];  
                end
            end
        end

    end
  
    if nargout >= 2
        
        if nargout == 3
            varargout{3} = max(max(max(I)));
        end
        
        I = I ./ max(max(max(I)));
        varargout{2} = I;
     
    end
    
    varargout{1} = fib;
    
end