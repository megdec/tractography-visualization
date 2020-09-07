function [score_tot] = oriented_score(S, convert, fiber)
    
    % Computes the score of a given fiber. The score depends on the
    % distance to the min/ max entropy location, and the entropy difference
    
    row = size(fiber, 1);
    r = row;
    score = 0;

    
    for i = 1:row
        x = convert(floor(fiber(i, 1)), floor(fiber(i, 2)), floor(fiber(i, 3)), 1);
        y = convert(floor(fiber(i, 1)), floor(fiber(i, 2)), floor(fiber(i, 3)), 2);
        z = convert(floor(fiber(i, 1)), floor(fiber(i, 2)), floor(fiber(i, 3)), 3);
        
        if isnan(x) || isnan(y) || isnan(z) || isnan(S(x,y,z))     
            r = r - 1;
        else
            score = score + S(x, y, z);
        end
        
        if r > row/2
            score_tot = score/r;
        else
            score_tot = NaN;
        end
    end
    
%     if nan>0
%         fprintf('%f %s\n', nan, "NaN found either in the rotation matrix or in the score matrix.")
%     end
%    
end
