% load('/Users/hadi/Desktop/CORR/region_correlations/ALL_REGION_CORRS_OPEN.mat')
% load('/Users/hadi/Desktop/CORR/region_correlations/ALL_REGION_CORRS_CLOSE.mat')



var_name = 'craving';
myvar = craving;
cols = 1;

% figure('Position',[0,0,500,1400]);


num_bands = 5;
band_names = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma', 'Full'};


% for col = 1:cols 
for band = 1:num_bands
    % Define the regions and their corresponding values
    regions = {'F', 'C', 'P', 'O', 'T', 'RF', 'LF', 'RC', 'LC', ...
        'RP', 'LP', 'RO', 'LO', 'RT', 'LT'};
    values = myvar.corr_rel(1:15,band); % Values corresponding to the 15 regions

    % Normalize the values for coloring (e.g., between 0 and 1)
    norm_values = (values - min(values)) / (max(values) - min(values));

    % Define positions for each region to match the figure
    % Format: [x, y, width, height]
    rect_positions = [
        0.33, 0.85, 0.34, 0.1; % F - Frontal
        0.33, 0.45, 0.34, 0.1; % C - Central
        0.33, 0.15, 0.34, 0.3; % P - Parietal
        0.33, 0.05, 0.34, 0.1; % O - Occipital
        0,    0.55, 1, 0.3;   % T - Temporal (placeholder area for T regions)
        0.67, 0.85, 0.33, 0.1; % RF - Right Frontal
        0,    0.85, 0.33, 0.1; % LF - Left Frontal
        0.67,  0.45, 0.33, 0.1; % RC - Right Central
        0, 0.45, 0.33, 0.1; % LC - Left Central
        0.67,  0.25, 0.33, 0.1; % RP - Right Parietal
        0.0, 0.25, 0.33, 0.1; % LP - Left Parietal
        0.67, 0.05, 0.33, 0.1; % RO - Right Occipital
        0,    0.05, 0.33, 0.1; % LO - Left Occipital
        0.67, 0.55, 0.33, 0.3; % RT - Right Temporal
        0,    0.55, 0.33, 0.3; % LT - Left Temporal
        ];

    % Define the figure
    % subplot(num_bands, cols , band*cols - cols +col);
    figure;
    hold on;

    % Draw each rectangle and assign colors based on normalized values
    for i = 1:length(regions)
        rectangle('Position', rect_positions(i,:), ...
            'FaceColor', [1-norm_values(i), 1, norm_values(i)], ... % Color gradient
            'EdgeColor', 'k', 'LineWidth', 1.5);

        % Add text labels
        x_center = rect_positions(i,1) + rect_positions(i,3)/2;
        y_center = rect_positions(i,2) + rect_positions(i,4)/2;
        if myvar.pval_rel(i,1) <0.05
            t_color = 'r';
        else
            t_color = 'k';
        end
        text(x_center, y_center, [regions{i} string(myvar.pval_rel(i,1))], 'HorizontalAlignment', 'center', ...
            'FontSize', 10, 'FontWeight', 'bold','Color',t_color);
    end

    % Set axis properties
    axis equal;
    xlim([0 1]);
    ylim([0 1]);
    axis off;
    title([ ' ' band_names{band} ' band   (( '  var_name ' ))']);
    colorbar('position',[0.9 ,0.3,0.05,0.5]);

end
% end
