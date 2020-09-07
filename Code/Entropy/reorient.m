function [unew, vnew, wnew] = reorient(un, vn, wn)

    [r, c, d] = size(un);
    unew = zeros(r, c, d);
    vnew = zeros(r, c, d);
    wnew = zeros(r, c, d);

    parfor x = 2:r-1
        for y = 2:c-1
            for z = 2:d-1
              
                vect = [un(x, y, z), vn(x, y, z), wn(x, y, z)];
                
                Nu = reshape(un(x-1:x+1, y-1:y+1, z-1:z+1), 1, 27);
                Nv = reshape(vn(x-1:x+1, y-1:y+1, z-1:z+1), 1, 27);
                Nw = reshape(wn(x-1:x+1, y-1:y+1, z-1:z+1), 1, 27);

                norm = nan(size(Nu,2),3);
                
                for i = 1:size(Nu, 2)
                    
                    voisin = [Nu(i), Nv(i), Nw(i)];
                    normal = cross(voisin, vect);
                    
                        if (normal == [0,0,0]) < 3
                            norm(i, :) = abs(normal);
                        end
                end

                unew(x, y, z) = nanmean(norm(:,1));
                vnew(x, y, z) = nanmean(norm(:,2));
                wnew(x, y, z) = nanmean(norm(:,3));
                

            end
        end
    end

end