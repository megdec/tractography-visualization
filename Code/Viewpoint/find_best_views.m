function [A, FB] = find_best_views(varargin)

    % This function plots a figure of the selected best views of a vector
    % field, based on the computation of the Entropy Score of the associated
    % framebuffer. 
    %
    % INPUT
    % varargin = E, n, tumor_file, bounds
    % E: entropy matrix, calculated with the entropy3D function
    % n: number of angles to test (given in spherical coords)
    % quick: boolean value, if true matlab rotation function is used 
    % 
    % OUTPUT
    % A:  nb_views x 3  matrix. A(:,2) and A(:,3) gives theta and phi angles of the
    % view, A(:,1) the entropy score.
    %
    % EXAMPLE USE
    % [A, FB] = find_best_views(E, 60, false, 'registered_tumor.niḯ', ext);
    
    E = varargin{1};
    n = varargin{2};
    quick = varargin{3};
          
    
    %%%%% Pre-processing entropy matrix %%%%%
    % Taking  into account tumor oclusion
    if nargin > 3
       
        L = (varargin{5}-1)*3 + [1 1 1 1 1 1];
        filename = varargin{4};
        tumor = niftiread(filename);
        tumor = flip(tumor, 1);
        tumor = flip(tumor, 2);
        %tumor = permute(tumor, [2 1 3]);
        
 
        [x,y,z] = ind2sub(size(tumor), find(tumor~=0));
        Ltum = ([min(x), max(x), min(y), max(y), min(z), max(z)]-1)*3 +[1 1 1 1 1 1];
         
        lim(1:2:6) = min(Ltum(1:2:6),L(1:2:6));
        lim(2:2:6) = max(Ltum(2:2:6),L(2:2:6));

        tumor = imresize3(tumor, 3);
         
        Enew = zeros(lim(2), lim(4), lim(6))+1;
        Enew(L(1):L(2), L(3):L(4), L(5):L(6)) = E;
        
        for x = 1:size(tumor, 1)
            for y = 1:size(tumor, 2)
                for z = 1:size(tumor, 3)
                   
                    if tumor(x,y,z) ~=0
                        Enew(x,y,z) = -1;
                    end

                end
            end
        end
        
        E = Enew(lim(1):lim(2), lim(3):lim(4), lim(5):lim(6));
   
        
    end
    
    
    % Finding bounding sphere
     s = size(E);
     center = floor(s/2);
     radius = ceil(sqrt(sum(([1,1,1]-center).^2)));
     
%Uncomment for computation of the MINIMUM bounding sphere
%     [x,y,z] = ind2sub(size(E) ,find(isnan(E) == 0));
%     xyz = [x,y,z];
%     [center,radius] = minboundsphere(xyz);
%     center = floor(center);
%     radius = ceil(radius);
    
    % Reshaping entropy matrix to sphere diameter
    new_E = nan(radius*2+1, radius*2+1, radius*2+1);
    new_E(radius-center(1)+1:radius+s(1)-center(1),radius-center(2)+1:radius+s(2)-center(2), radius-center(3)+1:radius+s(3)-center(3))= E;
    E = new_E;
    
    % Setting background value to 1 (maximum)
    E(isnan(E)) = 1;

    % Setting out of the bounding sphere to NaN
    
    for x = 1:radius*2+1
        for y = 1:radius*2+1
            for z = 1:radius*2+1
                if sqrt(sum(([x,y,z]-[radius+1, radius+1, radius+1]).^2)) > radius
                    E(x,y,z)= NaN;

                end
            end
        end
    end
    
    
    %%%%% Computing best view points %%%%%
    
    % Finding angles
    angles = eq_point_set_polar(2,n);
    angles(1,:) = angles(1, :) - pi;
    A_all = zeros(n,3);
    
    MepList = cell(1, n);
    
    
    for ind = 1:n
        disp(['Rotating to angle (' num2str(angles(2,ind)) ', ' num2str(angles(1,ind)) ')']);
        if quick
        
            E_rotate = rotMatrix(E, angles(2,ind), angles(1,ind));
            F = frameBufferZ(E_rotate, true);
                   
        else
            F = frameBufferZ(rotate_matrix2(E, angles(2,ind), angles(1,ind), 1.5), true);
        end
        
        if nargin > 4
            F(F < 0) = 1; % 1
        end
       
        Mep = F(:,:,1);
  
        
        MepList{ind} = Mep;
        A_all(ind,1) = nanmean(Mep(:));
        A_all(ind,2) = angles(2,ind); % matrix of theta angles
        A_all(ind,3) = angles(1,ind); % matrix of phi angles

    end
    
    %[A, index] = sortrows(A_all, 'descend'); % sorting array according to the ES values
    [A, index] = sortrows(A_all);
    A = A(1:n,:); % keeping the nv best views
    
    nv = size(MepList, 2);
    FB = cell(1, nv);
    for i = 1:nv
        FB{i} = MepList{index(i)};
    end
    
    
end
