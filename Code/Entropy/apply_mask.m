function [E_mask] = apply_mask(varargin) 
    
    % Applies the mask to a matrix, keeping only values within the mask.
    %
    % INPUT: 
    % E: entropy matrix
    % fib: cell array of fiber coordinate OR filename of nii file
    % Note: if third argument "false", mask is a ROA
    % varargin: E, fib, (false) 
    %
    % OUTPUT:
    % E_mask: new entropy matrix masked=> mask : matrix of the same dimensions, filled with 0(reject value) and
    % 1(accept value)
    
    E = varargin{1};
    fib = varargin{2};
    
    [row, col, depth] = size(E);
    
    if class(fib) == "char"
        
        m = load_untouch_nii(fib);
        mask = m.img;
       
    elseif class(fib) == "double"
        mask = fib;
        
    else
        A = fib;
        if nargin == 3 && varargin{3} ~= false
            A = fib_3D_image(fib, varargin{3} , size(E));
        end
        
        if nargin == 3 && varargin{3} == false
            mask = zeros(row, col, depth) +1;
            fill = NaN;
        else
            mask = nan(row, col, depth);
            fill = 1;
        end
        
        for k = 1:length(A)
            for i = 1:length(A{k}(:,1))
                
                x = floor(A{k}(i,1));
                y = floor(A{k}(i,2));
                z = floor(A{k}(i,3));
                
                if sum([x, y, z] > [row, col, depth]) > 0 || sum([x, y, z] <= [0,0,0]) > 0
                    [x,y,z]
                    error('Coordinates out of boundaries');
                end
                
                mask(x, y, z) = fill;    
                
            end
        end
    end
  
    E_mask = mask.*E;
    
end
