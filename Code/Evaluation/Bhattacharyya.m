function [bcoeff] = Bhattacharyya(histogram1, histogram2)

% BHATTACHARYYA(E, nerve)
% compute the BHATTACHARYYA distance between 2 histograms
% where each histogram is a 1xN vector
    

    
    bins = size(histogram1, 2);
    
    % estimate the bhattacharyya coefficient
    
    bcoeff = 0;
    for i=1:bins

        bcoeff = bcoeff + sqrt(histogram1(i) * histogram2(i));

    end

    % get the distance between the two distributions as follows
    % bdist = -log(bcoeff);

end