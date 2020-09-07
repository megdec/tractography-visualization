function [C_conc] = concatenate_tracks(files)

    % Concatenate many fib files
    
    C_conc = tracks2array(files{1});
    for i = 2:length(files)
        c = tracks2array(files{i});
        C_conc = [C_conc, c];
        
    end
    
end