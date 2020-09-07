function [val] = entropy_value(M, BinsTheta, NumPhi, b, N, l, c, h)
                
                val = NaN;
                [x, y, z, ~]=size(M);
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
                
                if k1>(N(1)*N(2)*N(3))/2
                    H(l,c,h)=NaN;
                    
                    
                else
                    for indiceElm=1:N(1)*N(2)*N(3)
                        if isnan(matNeighborTheta(indiceElm))==false
                            ThetaElm=matNeighborTheta(indiceElm);
                            PhiElm=matNeighborPhi(indiceElm);

                            if (ThetaElm==BinsTheta(1))
                                BinsPhi=linspace(-pi,pi, NumPhi(1)+1);
 %                              BinsPhi=linspace(0,2*pi, NumPhi(1)+1);
 
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
 %                                      BinsPhi=linspace(0,2*pi, NumPhi(1)+1);

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

%                     if sum(count)~=length(matNeighborTheta)
%                        error('The values in M(:,:,:,1) must be between 0 and pi. The values of M(:,:,:,2) must be between -pi and pi')
%                     end

                    p=count/sum(count); % probability vector
                    
                    for t=1:b
                        if p(t)==0
                            p(t)=1;
                        end
                    end
                        
                    val=-sum(p.*log2(p))/log2(b);  % entropy computation (normalized)   
                end
end