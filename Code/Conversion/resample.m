function [s] = resample(s, steps)
        
    for j = 1:steps
            for k = 1:size(s, 2)
                fib = s{k};
                resamp_fib = zeros(size(fib, 1)*2-1,3);
                resamp_fib(1, :) = fib(1, :);
                count = 2;
                for i = 1:size(fib, 1)-1
                    diff = fib(i+1,:)-fib(i,:);
                    resamp_fib(count, :) = fib(i, :) + diff/2;
                    resamp_fib(count+1, :) = fib(i+1, :);
                    count = count +2;
                    
                end
                s{k} = resamp_fib;

            end
          
    end
end