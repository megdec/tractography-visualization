function [T, index] = filter_fib_oriented(s_raw, s, E, theta, phi, percent , output, min)

    % This function generate a file of coordinate of fibers after filtering
    % It is possible to use 2 different methods (oriented or absolute
    % filtering). 
    % WARNING: A mask of the fibers will be automatically applied, if your work
    % require any exclusion ROI please apply it before running this
    % function. 
    %
    % INPUT 
    %
    % s: coordinate of the fibers to filter (see track2array function)
    %
    % percent: percentage of fibers to keep
    %
    % E: l x c x h entropy matrix (see funcion entropy3D to get
    % one)
    %
    % output: name of the output file
    % 
    % oriented : boolean True (method oriented filtering) or False
    % (absolute filtering)
    %
    % OUTPUT
    %
    % txt file with the coordinate of the fibers after filtering, to be
    % used directly on DSI Studio
  


% Sorting fibers
nb = size(s, 2);

%news = fib_3D_image(s, l/128);

M=zeros(nb,2);
E_mask = apply_mask(E, s);
fprintf('%s\n', "Computing rotated matrix..."); 

[rotE, convert] = rotMatrix(E_mask, theta, phi);

F = frameBufferZ(rotE, min);

fprintf('%s\n', "Computing score matrix..."); 
S = score_matrix(rotE, F, min);


for r=1:nb
   
    M(r,1) = r;
    M(r,2) = oriented_score(S, convert, s{r});  
end

F = sortrows(M,2, 'descend');

find_nan = find(isnan(F(:,2)));

if size(find_nan, 2) ~= 0 && size(find_nan, 1) ~= 0
    nan_last = find_nan(1, size(find_nan, 2))+1;
    F = F(nan_last:size(F, 1),:);
    fprintf('%i %s\n', nan_last-1, "fibers were deleted because NaN."); 
end

% Writing results

T = cell(1, length(percent));
index = cell(1, length(percent));

for p = 1:length(percent)
    
    num = int64((percent(p)/100)*nb);
    t = cell(1,num);
    ind = zeros(1, num);
    
    if output~= "no"
        
        if size(percent, 2) >1
            out = output + "_" + num2str(percent(p)) + ".txt";
        else
            out = output + ".txt";
        end
        
        fid = fopen(out, 'w');  
    end

    for f=1:num
        
        fib = s_raw{F(f,1)};
        t{f} = s{F(f,1)};
        ind(f) = F(f,1);
        
        if output~= "no"
            fib=reshape(transpose(fib), 1, length(fib(:,1))*3);
            fprintf(fid,"%f ", fib(1,:));
            fprintf(fid,"\n");
        end

    end
    
    if output~= "no"
        fclose(fid);
    end
    
    T{p} = t;
    index{p} = ind;
end


end
