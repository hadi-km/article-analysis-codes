%% calculate correlation metrics from loaded powers (one-time run)

%loading
clc;clear;

load('/Users/hadi/Desktop/chanlocs.mat')%chanss

load('/Users/hadi/Desktop/CORR/powers3.mat')

load('/Users/hadi/Desktop/CORR/COG_vars.mat')
% myvarss = {};
% myvarnames = {};
myvarss = {a_forward, a_reverse, a_total, v_forward, v_reverse, v_total, use_amount,pererr,tonumcor,tonumerr, a_span, v_span, craving, age, onset, use_dur};
myvarnames = {'Auditory forward', 'Auditory reverse', 'Auditory total', 'Visual forward', 'Visual reverse', 'Visual total', 'Grams per day','Preservative Errors' , 'Correct Answers' , 'Incorrect Answers' , 'Auditory Span' , 'Visual Span' , 'Craving' , 'Age', 'Starting Age of Use' , 'Duration of Use'};


%edit the close condition (delete 17)
eye = input('open (1) or close(2) eye: ', 's'); eyec = '';
absolute_power = []; relative_power = [];
switch eye %choose open 1 OR close 2
    case '1'
        absolute_power = abs_power_open;
        relative_power = rel_power_open;
        eyec = 'open';
    case '2'
        absolute_power = abs_power_close;  % (17,:,:) is zero
        relative_power = rel_power_close;   % (17,:,:) is zero
        absolute_power(17, :, :) = []; % Remove the 17th row
        relative_power(17, :, :) = []; % Remove the 17th row
        eyec = 'close';
end




%% convert channels to regions:

ABSOLUTE_POWER_REGIONS = [];
RELATIVE_POWER_REGIONS = [];


    for r = 1:16 %16 regions
        indices = regionIndices(r);
        ABSOLUTE_POWER_REGIONS(:,r,:) = mean(absolute_power(:,indices,:),2);
        RELATIVE_POWER_REGIONS(:,r,:) = mean(relative_power(:,indices,:),2);
    end 
absolute_power = ABSOLUTE_POWER_REGIONS;
relative_power = RELATIVE_POWER_REGIONS;

    %% calculate ans save correlation

for vars = 1:length(myvarss)

    MYVAR = myvarss{vars}; nname = myvarnames{vars};
    if eye == '2'
        MYVAR(17) = []; %deleting row 17 that has been excluded
    end

    % Assuming 'absolute_power' and 'relative_power' are 3D matrices (30x16x5)
    % and 'MYVAR' is a vector of 30 numbers

    % Initialize arrays to store correlation coefficients and p-values
    num_subjects = size(absolute_power, 1);
    num_channels = size(absolute_power, 2);
    num_bands = size(absolute_power, 3);
    band_names = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma', 'Full'};

    corr_abs = zeros(num_channels, num_bands);
    pval_abs = zeros(num_channels, num_bands);
    corr_rel = zeros(num_channels, num_bands);
    pval_rel = zeros(num_channels, num_bands);

    % Calculate Pearson correlation and p-values for absolute power
    for ch = 1:num_channels
        for band = 1:num_bands
            [corr_abs(ch, band), pval_abs(ch, band)] = corr(absolute_power(:, ch, band), MYVAR', 'Type', 'Pearson');
        end
    end

    % Calculate Pearson correlation and p-values for relative power
    for ch = 1:num_channels
        for band = 1:num_bands
            [corr_rel(ch, band), pval_rel(ch, band)] = corr(relative_power(:, ch, band), MYVAR', 'Type', 'Pearson');
        end
    end

    % % Plot brain topography maps for correlation values
    % figure('Position',[80,357,1350,484]);
    % for band = 1:num_bands
    %     subplot(2, num_bands, band);
    %     topoplot(corr_abs(:, band), chanss, 'maplimits', [-1 1]);
    %     title(['Absolute Power Correlation - ' band_names{band} ' Band']);
    % 
    %     subplot(2, num_bands, num_bands + band);
    %     topoplot(corr_rel(:, band), chanss, 'maplimits', [-1 1]);
    %     title(['Relative Power Correlation - ' band_names{band} ' Band']);
    % end
    % colorbar('position',[0.95 ,0.3,0.01,0.5]);
    % % save figure:
    % saveas(gcf, [nname '_' eyec '.png' ]);


    %save all stat data!
    save([ nname '_' eyec '.mat'],"corr_abs","pval_abs","corr_rel","pval_rel")

end




%  % save individual p-vals in a struct together (manual)
%  visual_total = struct('corr_abs', corr_abs, 'corr_rel', corr_rel, 'pval_abs',pval_abs, 'pval_rel',pval_rel);
% clear corr_abs  corr_rel  pval_abs  pval_rel
% %variable names:      %Age, audit_forw, audit_rev, audit_span, audit_total, chanss, correct_ans, craving, dur_use, gram_use, incorrect_ans, preserv_errors, start_age_use, visual_forw, visual_rev, visual_span, visual_total
% 












%% find and pring pval_rel that are significant!

%for switching between open/close find/replace close and open
 cd('/Users/hadi/Desktop/results/qEEG correlation/open/') %close

% Plot brain topography maps for correlation values
figure('Position',[0,357,1400,700]);
num_bands = 5;
band_names = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma', 'Full'};
cols = 9; %columns of figure

load('/Users/hadi/Desktop/chanlocs.mat')%chanss


%  cd('/Users/hadi/Desktop/results/qEEG correlation/close_new/') %close
% 
% audit_forw = load('Auditory forward_close.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
% audit_rev = load('Auditory reverse_close.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
% audit_total = load('Auditory total_close.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
% visual_forw = load('Visual forward_close.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
% visual_rev = load('Visual reverse_close.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
% visual_total = load('Visual total_close.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
% gram_use = load('Grams per day_close.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');


%plot relative powers
for band = 1:num_bands



    % Demographics
    craving = load('Craving_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot(num_bands, cols , band*cols - cols +1);
    sig_lead_5 = find(craving.pval_rel(:,band) < 0.05);
    topoplot(craving.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);
    % title(['Relative Power Correlation CRAVING - ' band_names{band} ' Band']);


    Age = load('Age_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +2);
    sig_lead_5 = find(Age.pval_rel(:,band) < 0.05);
    topoplot(Age.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);


    start_age_use = load('Starting Age of Use_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +3);
    sig_lead_5 = find(start_age_use.pval_rel(:,band) < 0.05);
    topoplot(start_age_use.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);
    pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);



    dur_use = load('Duration of Use_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +4);
    sig_lead_5 = find(dur_use.pval_rel(:,band) < 0.05);
    topoplot(dur_use.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);
    pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);

    % WCST
    correct_ans = load('Correct Answers_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +5);
    sig_lead_5 = find(correct_ans.pval_rel(:,band) < 0.05);
    topoplot(correct_ans.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);
    pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);



    incorrect_ans = load('Incorrect Answers_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +6);
    sig_lead_5 = find(incorrect_ans.pval_rel(:,band) < 0.05);
    topoplot(incorrect_ans.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);
pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);


    preserv_errors = load('Preservative Errors_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +7);
    sig_lead_5 = find(preserv_errors.pval_rel(:,band) < 0.05);
    topoplot(preserv_errors.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);
pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);

    %Wechsler

    visual_span = load('Visual Span_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +8);
    sig_lead_5 = find(visual_span.pval_rel(:,band) < 0.05);
    topoplot(visual_span.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);
    pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);

    audit_span = load('Auditory Span_open.mat', 'corr_abs', 'pval_abs', 'corr_rel', 'pval_rel');
    subplot( num_bands, cols , band*cols -cols +9);
    sig_lead_5 = find(audit_span.pval_rel(:,band) < 0.05);
    topoplot(audit_span.corr_rel(:, band), chanss, 'maplimits', [-1 1],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
    % title(['Relative Power Correlation age-c - ' band_names{band} ' Band']);
    pos = get(gca, 'Position');
    pos(3) = pos(3) * 1.3; % Increase width
    pos(4) = pos(4) * 1.3; % Increase height
    set(gca, 'Position', pos);

    %make a for

% title labels
    position1 = [0.1470, 0.975, 0.052592592592593, 0.026190476190476];
    pos2 = [ position1(1) + 0.0889, position1(2), position1(3), position1(4) ];
    pos3 = [pos2(1)+0.0889 , position1(2), position1(3), position1(4) ];
    pos4 = [pos3(1)+0.0889, position1(2), position1(3), position1(4) ];
    pos5 = [pos4(1)+0.0889, position1(2), position1(3), position1(4) ];    %  0.492592592592591,
    pos6 = [pos5(1)+0.0889, position1(2), position1(3), position1(4) ];
    pos7 = [pos6(1)+0.0889, position1(2), position1(3), position1(4) ];
    pos8 = [pos7(1)+0.0889, position1(2), position1(3), position1(4) ];
    pos9 = [pos8(1)+0.0889, position1(2), position1(3), position1(4) ];

    % Create the text box annotation
    fontsize = 14;
    annotation('textbox', position1, 'String', 'Craving', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos2, 'String', 'Age', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', fontsize,   'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos3, 'String', 'Age of First Use', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', fontsize,   'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos4, 'String', 'Duration of Use', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos5, 'String', 'Correct Answers', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,   'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos6, 'String', 'Incorrect Answers', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', fontsize,   'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos7, 'String', 'Preservative Errors', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize, 'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos8, 'String', 'Visual Span', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', fontsize,   'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', pos9, 'String', 'Auditory Span', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
 
    %band labels
    p1 = [0.071714285714286 , 0.86 , 0.042571428571428,0.038571428571429];
    p2 = [p1(1), p1(2) - 0.1743, p1(3), p1(4)];
    p3 = [p1(1), p2(2) - 0.1743, p1(3), p1(4)];
    p4 = [p1(1), p3(2) - 0.1743, p1(3), p1(4)];
    p5 = [p1(1), p4(2) - 0.1743, p1(3), p1(4)];
    annotation('textbox', p1, 'String', band_names{1}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',   'FontSize', fontsize, 'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', p2, 'String', band_names{2}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', p3, 'String', band_names{3}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',   'FontSize', fontsize, 'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', p4, 'String', band_names{4}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', p5, 'String', band_names{5}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');

% Define the position of the line
x = [0.9157, 0.9157 + -0.1492];
y = [0.0832, 0.0832 ];
% hold on
% Plot the line with width 2
% line(x, y, 'LineWidth', 2);
x2 = [0.5014,0.7285];
x3 = [0.461428571428571,0.237142857142857];
x4 = [0.205,0.148571428571429];
% line(x2, y, 'LineWidth', 2);
annotation('line', x,y, 'LineWidth',2);
annotation('line', x2,y, 'LineWidth',2);
annotation('line', x3,y, 'LineWidth',2);
annotation('line', x4,y, 'LineWidth',2);


wmstextbox = [0.81889,0.02916 ,0.03375,0.0378];
annotation('textbox', wmstextbox, 'String', 'WMS', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
annotation('textbox', [ 0.5954998677, wmstextbox(2),wmstextbox(3),wmstextbox(4)], 'String', 'WCST', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
annotation('textbox', [ 0.3283, wmstextbox(2),wmstextbox(3),wmstextbox(4)], 'String', 'Demographics', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
annotation('textbox', [ 0.15049, wmstextbox(2),wmstextbox(3),wmstextbox(4)], 'String', 'MCQ-SF', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');

end
colorbar('position',[0.95 ,0.3,0.01,0.5]);
annotation('textbox',[0.9940,0.4110,0.1533,0.0378], ...
    'String', 'Power Correlation Topography', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', ...
    'FontSize', fontsize, ...
    'FitBoxToText', 'on', ...
    'EdgeColor', 'none', ...
    'Rotation', 90); 









