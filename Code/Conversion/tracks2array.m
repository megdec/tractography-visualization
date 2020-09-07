function [tab] = tracks2array (filename)

    % This function converts mrtrix tck file or DSI txt file of tracts
    % coordinates into a matlab cell array
    % NOTE  tckconvert -scanner2voxel dt.mif Chiasma.tck Chiasma_vox.tck
    
    if filename(length(filename)-2:length(filename))=='tck'
        conv=read_mrtrix_tracks(filename);
        tab=conv.data;

        for i=1:length(tab) % solve problem mrtrix coords at 0 and nii_reader flip
            tab{i}(:,3) = abs(tab{i}(:,3)) + 1;
            tab{i}(:,2) = 129 - tab{i}(:,2);
            tab{i}(:,1) = 129 - tab{i}(:,1);
        end
        
    
    
    elseif filename(length(filename)-2:length(filename))=='txt'
        fid = fopen(filename);
        count_inval = 0;
        count = 0;
        
        while ~feof(fid)
            fib = fgetl(fid);
            fib = str2num(fib);
            
            if mod(length(fib),3)~=0
                count_inval = count_inval+1;
            end
                
            count = count+1;
             
        end
        fclose(fid);
        tab = cell(1, count-count_inval);
        fid = fopen(filename);
        k = 1;
        while ~feof(fid)
            
            fib = fgetl(fid);
            fib = str2num(fib);
            
            if mod(length(fib),3)==0
                fib = transpose(reshape(abs(fib)+1, 3, length(fib)/3));
                tab{k} = fib;
            end
            k = k+1;
        end
        
        if count_inval~=0
            fprintf('%s %i %s\n',"Beware!", count_inval, "invalide tract were found."); 
        end
        
        fclose(fid);
        
    else    
        error('Unknown extension, conversion impossible.')
    end
        

end
