%%
% Add folders to path

addpath('Conversion'); 
addpath('Entropy');
addpath('Evaluation');
addpath('Filtering');
addpath('Geometry');
addpath('Geometry/Partition/eq_partitions');
addpath('Geometry/Partition/eq_point_set_props');
addpath('Geometry/Partition/eq_region_props');
addpath('Geometry/Partition/eq_utilities');
addpath('Viewpoint');
addpath('Codegen');

%%
% Filter one single nerve 

% Path to the nerve
filename = '../Data/Nerves/DSI/NF.txt'; 

% Compute the entropy matrix
[E_NF, bounds_NF, pix_NF] = entropy_matrix(filename, [129,129,27], [3 3 3]);
show_matrix(E_NF, true)

% Filter the nerve with percentages p and write the result in the result
% folder
p = 0:10:100;
[fib, ind] = filter_nerve(filename, pix_NF, E_NF, p, '../Results/Filter/');

%%
% Plots the result in Matlab (for a better rendering, open the txt
% fiber files in DSI Studio)
plot_nerve('../Results/Filter/filtered_nerve_90.txt');

%%

% Displays the Sorensen-Dice score between the filtered nerve and a
% reference nerve for all percentages 
SD = compare_reference(filename, pix_NF, E_NF, [129,129,27], p, filename);

plot(p, SD)
ylabel('Sorensen-Dice score');
xlabel('Filtering percentage');

%%
% Best point of view on a single nerve (among 60)
[angle_NF, projections_NF] = find_best_views(E_NF, 60, false); 

% Display the 4 best viewpoints
display_views(angle_NF, projections_NF, 4, true)

% Display the 4 worse viewpoints
display_views(angle_NF, projections_NF, 4, false)

%% 
% Best point of view on several nerves and tumor

% Compute the entropy matrices
[E_V, bounds_V, pix_V] = entropy_matrix('../Data/Nerves/DSI/V.txt', [129,129,27], [7 7 5]);
[E_NM, bounds_NM, pix_NM] = entropy_matrix('../Data/Nerves/DSI/NM.txt', [129,129,27], [3 3 3]);

% Concatenate matrices
[E, bounds] = concatenate_Emat({E_V, E_NM, E_NF}, {bounds_V, bounds_NM, bounds_NF});

% Compute best point of view
[angle, projections] = find_best_views(E, 60, false, '../Data/Tumor/Tumor.nii', bounds); 
%%
% Display the 4 best viewpoints
display_views(angle, projections, 4, true)

