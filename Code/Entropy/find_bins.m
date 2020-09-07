function [r, num]= find_bins(N)
    
    REGIONS = eq_regions(2,N);

    R=ones(1,N*2).*20;
    reg=reshape(REGIONS(2,:,:),1,N*2);
    p=1;
    for i=1:N*2
        k=0;

        for j=1:p
            if(single(reg(i))==single(R(j)))
                k=1;

            end
        end

        if k==0

            R(p)=reg(i);
            p=p+1;
        end
    end
    r=R(1:p-1);

    num=ones(1,(length(r)-1));
    for i=1:(length(r)-1)
        k=0;
        for j=1:N
          if single(REGIONS(2,1,j))==single(r(i))
              k=k+1;
          end
        end
        num(i)=k;            
    end

   
    
end

