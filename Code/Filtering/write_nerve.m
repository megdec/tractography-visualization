function [] = write_nerve(varargin)

    % This function creates a txt file of the coords of the fibers correponding to one nerve in a whole brain,
    % if the whole brain tracto is given as third parameter. Otherwise, output txt file of the coords of the input cell array 
    % varargin = nerve, out, s
    
    nerve = varargin{1};
    out = varargin{2};
    
    
    if nargin == 3
        s = varargin{3};
        mask = zeros(128,128,27) +1;
        mask = apply_mask(mask, nerve);
        index_ref = ref_index(mask, s, false);

        fid = fopen(out, 'w');

        for i = 1:length(index_ref)


            fib = s{index_ref(i)};
            fib=reshape(transpose(fib), 1, length(fib(:,1))*3);
            fprintf(fid,"%f ", fib(1,:));
            fprintf(fid,"\n");

        end

        fclose(fid);

    else
        fid = fopen(out, 'w');
        
        for i = 1:length(nerve)

            fib = nerve{i};
            fib = reshape(transpose(fib), 1, length(fib(:,1))*3);
            fprintf(fid,"%f ", fib(1,:));
            fprintf(fid,"\n");

        end
        fclose(fid);
    end
    
end