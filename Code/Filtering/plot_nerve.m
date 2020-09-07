function [] = plot_nerve(filename)

    % Plots a nerve given as txt or tck file.
    
    nerve = tracks2array(filename);
    
    for i = 1:length(nerve)

        fib = nerve{i};
        size(fib)
        plot3(fib(:,1), fib(:,2), fib(:,3))
        hold on;
        pbaspect([1 1 1])
    end
    hold off;
     
end