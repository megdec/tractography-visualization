function [histogram1, histogram2] = build_hist(E, s, current_nerve, show)
   
         [r, c, d] = size(E);
         %maxval = max(max(max(E)));
       
         E_m = apply_mask(E, s, 4);
         %E_m1 = apply_mask(E_m, allnerves, false);
         h1 = hist(reshape(E_m, 1, r*c*d), 0:0.01:1);
                 
         E_m2 = apply_mask(E, current_nerve, 4);
         h2 = hist(reshape(E_m2, 1, r*c*d), 0:0.01:1);

         histogram1 = h1/sum(h1);
         histogram2 = h2/sum(h2);
         
         if show == true
             bar(histogram1, 'r', 'FaceAlpha',.5);
             hold on;
             bar(histogram2, 'b', 'FaceAlpha',.5);
         end
         hold off;

        
end