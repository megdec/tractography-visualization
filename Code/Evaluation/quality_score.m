function [S_D] = quality_score(index_ref, index)

    % Computes a quality score by checking which percentage of the reference fibers is 
    % kept 
    %
    % OUTPUT
    % score: a quality score between 0 and 100 (or 0 and 1)
    
       
    S_D = repelem(0, length(index));
    for i = 1:length(index)
        intersect = sum(ismember(index_ref, index{i}));
        S_D(i) = (2*intersect)/(length(index{i})+length(index_ref));
        %S_D(i) = (intersect/length(index_ref))*100;
    end
    
end