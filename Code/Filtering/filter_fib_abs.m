function [T, index] = filter_fib_abs (s_raw, s, E, percent)

    % This function generate a file of coordinate of fibers after filtering
    % WARNING: A mask of the fibers will be automatically applied, if your work
    % require any exclusion ROI please apply it before running this
    % function. 
    %
    % INPUT 
    %
    % s_raw: coordinate of the fibers to filter (see track2array function)
    % s : coordinates of the fibers in the entropy matrix referential
    % percent: list of percentage of fibers to keep
    % E: entropy matrix (see funcion entropy3D to get
    % one)
    %
    % OUTPUT
    %
    % T : The coordinates of the fibers which were kept as a struct.
    % index : The indices of the fibers which were kept
  

% Sorting fibers
nb = length(s);
M=zeros(nb,2);

%news = fib_3D_image(s, 4, size(E));

for r=1:nb
   
    M(r,1) = r;
    M(r,2) = entropy_score(E,s{r});        
end

F = sortrows(M,2);


% Writing output
T = cell(1, length(percent));
index = cell(1, length(percent));

for p = 1:size(percent,2)
    
    num = floor((percent(p)/100)*nb);
    t = cell(1,num);
    ind = zeros(1, num);

    for f=1:num
        
        t{f} = s_raw{F(f,1)} ;
        ind(f) = F(f,1);
        
    end
    
 
    T{p} = t;
    index{p} = ind;
end

end
