function [T, index] = filter_fib_rand (s, percent , output)

    % This function generate a file of coordinate of fibers after random filtering
    %
    % INPUT 
    %
    % s: coordinate of the fibers to filter (see track2array function)
    %
    % percent: percentage of fibers to keep (list if many)
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
  
tic
nb = length(s);

% Writing output
T = cell(1, length(percent));
index = cell(1, length(percent));

for p = 1:length(percent)
    
    num = (percent(p)/100)*nb;
    t = cell(1,num);
    ind = zeros(1, num);
    
    if output~= "no"
        out = output + "_" + num2str(percent(p)) + ".txt";
        fid = fopen(out, 'w');
    end
    
    F = randperm(nb);
    for f=1:num
        fib=s{F(f)};
        t{f} = fib;
        ind(f) = F(f);
        
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

toc
end
