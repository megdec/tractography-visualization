function NewM = rotate_matrix2(E, theta, phi, greed) %#codegen

    % Creates a new matrix containing the rotation of the original, returns
    % a coordinate conversion matrix.

    
    if greed > 2
        error("Precision asked will surely kill your computer! Please give up :'( ")
    end
    
    [angle, vect] = convert_angles(theta, phi);
    [re, ce, de] = size(E);
    
    
    dim = sqrt(max([re, ce, de])^2 + max([re, ce, de])^2)+20;
    r = length(1:1/greed:dim);
    c = length(1:1/greed:dim);
    d = length(1:1/greed:dim);
    
    NewM = nan(r, c, d);
  
    
    coord_init = zeros(3, r*c*d); % coords the the intersections of the grid 
    % before rotation
    
    
    l = 1;
    for i = 1:1/greed:dim
        for j = 1:1/greed:dim
            for k = 1:1/greed:dim
                coord_init(1,l) = i;
                coord_init(2,l) = j;
                coord_init(3,l) = k;
                l=l+1;
            end
        end
    end

    % Coordinates rotation
    [Newcoord, ~, ~]=AxelRot(coord_init, angle, vect, []);

    
    % Translation of the coordinates so that it covers the initial matrix.
 
    t1 = re/2 -(min(Newcoord(1,:)) + max(Newcoord(1,:)))/2;
    t2 = ce/2 - (min(Newcoord(2,:)) + max(Newcoord(2,:)))/2;
    t3 = de/2 - (min(Newcoord(3,:)) + max(Newcoord(3,:)))/2;
    
    
    Newcoord(1,:) = Newcoord(1,:)+t1;
    Newcoord(2,:) = Newcoord(2,:)+t2;
    Newcoord(3,:) = Newcoord(3,:)+t3;
    
    Newcoord = int16(Newcoord);
 
    % Fill new entropy matrix    
    l = 1;
    for i = 1:r
        for j = 1:c
            for k = 1:d
                
                if Newcoord(1,l) >0 && Newcoord(2,l)>0 && Newcoord(3,l)>0 && Newcoord(1,l) <= re && Newcoord(2,l) <= ce && Newcoord(3,l)<= de
                    NewM(i,j,k) = E(Newcoord(1,l), Newcoord(2,l), Newcoord(3,l));

                end
                
                l=l +1;
            end
        end
    end
   
    
end
    
    