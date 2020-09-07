function [H] = entropy3D(M, nbNeighbor, nbBins)
    
    % This function creates the entropy matrix of a 3D vector field.
    %
    % INPUT
    % M: x*y*z*2 matrix. M(:,:,:,1) and M(:,:,:,2) must be the values
    % of theta and phi (as given by the convention describe in file...), of
    % all vectors in the 3D field.
    % nbNeighbor: number of vectors used to compute the entropy, a list
    % according the three dimensions
    % nbBins: number of regions of the unit spheres used for creating the 
    % histogram of neigbor vectors
    %
    % OUTPUT
    % H:  x*y*z*2 matrix, containing the values of entropy for each vector
    
    
    b = nbBins;
    N = nbNeighbor;
    
    [BinsTheta, NumPhi] = find_bins(b); % extracting the intervals theta of each regions
    % and the number of regions in each interval
    [x, y, z, a] = size(M);
    
    if a~=2
        error('M must be a matrix of dimension x*y*z*2')
    end
    
    if sum(mod(N, 2)) < 3
        error('Neigbhor size cannot be even')
    end   

    H=zeros(x, y, z); 
     

    for h=1:z
   
        
        for l=1:x
            for c=1:y
            
                shiftl=1; % handling edge effect
                shiftc=1;
                shifth=1;

                if (l>=x-(N(1)-1)/2 ) 
                    shiftl=(x-((N(1)-1)/2))-l;
                elseif (l<(N(1)-1)/2)
                    shiftl=((N(1)-1)/2)-l+1;
                end

                if (c>=y-(N(2)-1)/2 ) 
                    shiftc=(y-((N(2)-1)/2))-c;
                elseif (c<(N(2)-1)/2)
                    shiftc=((N(2)-1)/2)-c+1;
                end
                
                if (h>=z-(N(3)-1)/2 ) 
                    shifth=(z-((N(3)-1)/2))-h;
                elseif (h<(N(3)-1)/2)
                    shifth=((N(3)-1)/2)-h+1;
                end
                
                %creating of the sample used for the computation of entropy
                matNeighborTheta=reshape(M(l-((N(1)-1)/2)+shiftl: l+((N(1)-1)/2)+shiftl, c-((N(2)-1)/2)+shiftc: c+((N(2)-1)/2)+shiftc, h-((N(3)-1)/2)+shifth: h+((N(3)-1)/2)+shifth,1), 1, N(1)*N(2)*N(3));
                matNeighborPhi=reshape(M(l-((N(1)-1)/2)+shiftl: l+((N(1)-1)/2)+shiftl, c-((N(2)-1)/2)+shiftc: c+((N(2)-1)/2)+shiftc, h-((N(3)-1)/2)+shifth: h+((N(3)-1)/2)+shifth,2), 1, N(1)*N(2)*N(3));
                
                count=repelem(0, b); % vector of occurences for all regions
                
                % If too much NaN in original matrix, entropy is marked NaN 

                k1 = sum(isnan(matNeighborTheta)); 
                
                if false
                    H(l,c,h) = NaN;
                    
                    
                else
                    for indiceElm=1:N(1)*N(2)*N(3)
                        
                        if isnan(matNeighborTheta(indiceElm)) == false
                            ThetaElm=matNeighborTheta(indiceElm);
                            PhiElm=matNeighborPhi(indiceElm);

                            if (ThetaElm==BinsTheta(1))
                                BinsPhi=linspace(-pi,pi, NumPhi(1)+1);

 
                                if (PhiElm==BinsPhi(1))
                                    count(2)=count(2)+1;


                                else
                                    for iP=1:length(BinsPhi)-1

                                        if (PhiElm>BinsPhi(iP)) && (PhiElm<=BinsPhi(iP+1))
                                            count(iP+1)=count(iP+1)+1;

                                        end

                                    end
                                end



                            else
                                for iT=1:length(BinsTheta)-1

                                    if (ThetaElm>BinsTheta(iT)) && (ThetaElm<=BinsTheta(iT+1))
                                        BinsPhi=linspace(-pi,pi, NumPhi(1)+1);

                                        if (PhiElm==BinsPhi(1))
                                                count(1+iT)=count(1+iT)+1;


                                        else
                                            for iP=1:length(BinsPhi)-1

                                                if (PhiElm>BinsPhi(iP)) && (PhiElm<=BinsPhi(iP+1))
                                                    count(iP+iT)=count(iP+iT)+1;

                                                end

                                            end
                                        end

                                    end
                                end
                            end

                        end
                    end

                    if sum(count)~= (size(matNeighborTheta,2) - k1)
                       error('The values in M(:,:,:,1) must be between 0 and pi. The values of M(:,:,:,2) must be between -pi and pi')
                    end

                    p=count/sum(count); % probability vector
                    
                    for t=1:b
                        if p(t)==0
                            p(t)=1;
                        end
                    end
                        
                    H(l,c,h)=-sum(p.*log2(p))/log2(b);  % entropy computation (normalized)                  
                    
                end
            end
        end
    end
end
