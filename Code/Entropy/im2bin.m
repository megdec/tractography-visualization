function [I] = im2bin(I, level)
    
    I(I>level) = 1;
    I(I<= level) = NaN;
       
end