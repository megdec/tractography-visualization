function [H] = entropy(M, nbNeighbor, nbBins)

    %M=rand(100); %Matrice utilisée en input, sensée représenter un champs de vecteur. Chaque valeur correspond
%a un angle compris entre 0 et 2pi


    N=nbNeighbor; %valeur de voisinage pour la construction d'histogrammes (impair)
    b=nbBins; % nombre de classes dans les histogrammes

    [nbLines, nbCol]=size(M);

    H=zeros(nbLines, nbCol); %H est la matrice des valeurs d'entropie pour chaque point


    for l=1:nbLines
        for c=1: nbCol
            
            shiftl=1; %gestion des effets de bord
            shiftc=1;
         
            if (l>=nbLines-(N-1)/2 ) 
                shiftl=(nbLines-((N-1)/2))-l;
            elseif (l<(N-1)/2)
                shiftl=((N-1)/2)-l+1;
            end
                
            if (c>=nbCol-(N-1)/2 ) 
                shiftc=(nbCol-((N-1)/2))-c;
            elseif (c<(N-1)/2)
                shiftc=((N-1)/2)-c+1;
            end
          
            matNeighbor=reshape(M(l-((N-1)/2)+shiftl: l+((N-1)/2)+shiftl,c-((N-1)/2)+shiftc: c+((N-1)/2)+shiftc), 1, N*N);%echantillons des voisins pour création de l'histogramme
            
            bins=linspace(0,2*pi,b); % liste des bins avec espacement égal
            count=repelem(0, b-1); % liste des effectifs de classe
            
            for indiceElm=1:N*N
                elm=matNeighbor(indiceElm);
                
                for indiceBin=1:b-1
                    if (elm>bins(indiceBin)) && (elm<bins(indiceBin+1))  
                        count(indiceBin)=count(indiceBin)+1;
                        
                             
                    end
                end
            end
            
            
            p=count/(N*N);
            
            for t=1:b-1
                if p(t)==0
                    p(t)=1;
                end
            end
            
            H(l,c)=-sum(p.*log2(p))/log2(b); %calcul de l'entropie
            
        end
    end
end




   


    
    


