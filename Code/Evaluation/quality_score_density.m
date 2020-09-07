function [score] = quality_score_density(ref, T, sizeDT)

    % Computes a quality score Battacharya using density maps of 2 tractography
    % 
    %
    % OUTPUT
    % score: a quality score between 0 and 100 (or 0 and 1)
   
   score = repelem(0, length(T));
   % Convert fibers to image of given resolution
   [~, Ireference] = fib_3D_image(ref, 3, sizeDT);
   Ireference = Ireference/sum(sum(sum(Ireference)));
   [x2, y2, z2] = ind2sub(size(Ireference), find(Ireference>0));
   
   for i = 2:length(T)
       
       tracto = T{i};
       [~, I] = fib_3D_image(tracto, 3, sizeDT);
       I = I/sum(sum(sum(I)));
    
       
        %Crop images ?
        [x1, y1, z1] = ind2sub(size(I), find(I>0));
        
        
        b = [min(min(x1), min(x2)), max(max(x1), max(x2)), min(min(y1), min(y2)), max(max(y1), max(y2)), min(min(z1), min(z2)), max(max(z1), max(z2))];
        
        Iref = Ireference(b(1):b(2), b(3):b(4), b(5):b(6));
        I = I(b(1):b(2), b(3):b(4), b(5):b(6));

       % Compute Battacharya distance
       BC = 0;
       for x = 1:size(I, 1)
           for y = 1:size(I, 2)
               for z = 1:size(I, 3)
                  BC = BC + sqrt(I(x, y, z)*Iref(x, y, z));

               end
           end
       end
       score(i) = BC;
   end
   
  
    
end