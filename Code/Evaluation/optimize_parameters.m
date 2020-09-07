function [res, Emat] = optimize_parameters(Emat, param1, param2, nerves, s)
    
    tic
    res = cell(1, size(nerves,2));
%     Emat = cell(size(param1, 2), size(param2, 2));
%    
    %CONVERSION
    mask = zeros(128,128,27);
    mask(40:85, 30:85,:) = zeros(46,56,27)+1;
    [~, scrop] = ref_index(mask, s, false);
    scrop = translate_coords(scrop, [-39, -29, 0]);
    
    s_resamp = resample(scrop, 2);
%     [~, I] = fib_3D_image(s_resamp, 4, [47,57,27]);
%     DT = im2field(I);
%     
%     
%     fprintf('%s\n', "Building all entropy matrices");
%     % Building all entropy matrices
%     for col = 1:size(param2,2)
%         
%             [BinsTheta, NumPhi] = find_bins(param2{col});
%             codegen entropy3D -args {DT, [1,1,1], 20, BinsTheta, NumPhi}
%             for row = 1: size(param1,2)
%             
%              % Building entropy matrix
%              param1{row}
%              param2{col}
%              E = entropy3D_mex(DT, param1{row}, param2{col}, BinsTheta, NumPhi);
%              Emat{row, col} = E;
%           
%              
%             end
%     end
%     save('Emat.mat', 'Emat');

    
    % Computing tables for all nerves
    for n = 1:length(nerves)
        nerves{n}
        
        current_nerve = tracks2array(nerves{n});
        
        % CONVERSION
        mask = zeros(128,128,27);
        mask(40:85, 30:85,:) = zeros(46,56,27)+1;
        [~, nerve_crop] = ref_index(mask, current_nerve, false);
        nerve_crop = translate_coords(nerve_crop, [-39, -29, 0]);
        nerve_resamp = resample(nerve_crop, 2);
        
        tab = zeros(length(param1), length(param2));
        
        for row = 1:length(param1)
            for col = 1: length(param2)
                
             E = Emat{row, col};
             
             % Creates histograms
             [histogram1, histogram2] = build_hist(E, s_resamp, nerve_resamp, false);
      
             % Bhattacharrya coefficient
             tab(row, col) = Bhattacharyya(histogram1, histogram2);
             
            end
        end
  
        res{n} = tab;
    end
   toc  
end