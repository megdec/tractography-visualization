function [] = show_matrix(E, min)

    subplot(2, 2, 1);
    f = frameBufferZ(E, min);
    imagesc(f(:,:,1));
    axis equal;
    xticks([]);
    yticks([]);
    colorbar;
    title(sprintf('Axial View'));
    
    subplot(2, 2, 2);
    f = frameBufferY(E, min);
    imagesc(flipud(transpose(f(:,:,1))));
    axis equal;
    xticks([]);
    yticks([]);
    colorbar;
    title(sprintf('Coronal View'));  


    subplot(2, 2, 3);
    f = frameBufferX(E, min);
    imagesc(flipud(transpose(f(:,:,1))));
    axis equal;
    xticks([]);
    yticks([]);
    colorbar;
    title(sprintf('Sagittal View'));
    
    subplot(2, 2, 4);
    NewE = rotMatrix(E, pi/4, pi/2);
    f = frameBufferZ(NewE, min);
    imagesc(f(:,:,1));
    axis equal;
    xticks([]);
    yticks([]);
    colorbar;
    title('Phi = \pi/2, Theta = \pi/10 View');

end