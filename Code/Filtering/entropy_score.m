function [score] = entropy_score(E, fiber)

[row, ~] = size(fiber);
s = 0;
l = row;

for r = 1:row
    x = floor(fiber(r,1));
    y = floor(fiber(r,2));
    z = floor(fiber(r,3));
    
    
    if isnan(E(x, y, z))
        l = l-1;
    else
        s = s + E(x, y, z);
    end
    
end

if l > row/2;
  
    score = s/l;
    
else 
  
    score = NaN;
 
end
