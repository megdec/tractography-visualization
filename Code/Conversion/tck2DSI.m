function [fib] = tck2DSI(tab, dim)
    
% Converts tck Mrtrix file to txt DSI file. 
%
% INPUT:
% infile : full name of the tck file to be converted
% outfile :  name of the output DSI file, with .txt extension
% dim : array of the 3 dimensions of the DTI image used to get tck file from
% Mrtrix
%
% EXAMPLE: Mrtrix2DSI('Chiasma_vox.tck', 'dsiChiasma.txt', [128,128,26]);
% Warning: Mrtrix coordinates must be voxel coordinates. To convert from
% world coordinate, please use the following command "tckconvert -scanner2voxel dt.mif Chiasma.tck Chiasma_vox.tck"

    
    for k = 1:size(tab, 2)

        fib = tab{k};
        fib(:,2) = dim(2) + 1 - fib(:,2);
        fib(:,1) = dim(1) + 1 - fib(:,1);
        
        fib=reshape(transpose(fib), 1, size(fib, 1)*3);     
    end
    
