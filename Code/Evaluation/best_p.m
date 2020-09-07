function [plateau] = best_p(score, e)
    
    plateau = [0,0,0];
    mink = 5;
    while plateau(1,1) == 0
        i = 1;
        c = 1;
        while i < size(score,2)

            k = 1;
            not_end = true;

            while (score(i+k) <= score(i)+e) && (score(i+k) >= score(i)-e) && not_end
                if i+k+1 <= size(score,2)
                    k = k+1;
                else
                   not_end = false;
                end

            end

            if k >= mink 
                    plateau(c,3) = score(i+k)-score(i+k-1) ;
                    plateau(c,1) = i;
                    plateau(c,2) = i+k-1;
                    c = c+1;
            end

            i = i+k;
        end
        %plateau(:, 3) = score([plateau(2:end,1); size(score,2)]) - score(plateau(:,2));
        plateau = sortrows(plateau, 3, 'descend');
        mink = mink - 1;
    end
    
end