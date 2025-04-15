%% find and pring pval_rel that are significant!

clc;clear;close all;
cd('/Users/hadi/Desktop/code Tools/eeglab2024.0/') % add to path: functions
% Plot brain topography maps for correlation values


num_bands = 5;
band_names = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma', 'Full'};
load('/Users/hadi/Desktop/chanlocs.mat')%chanss

o_e = load('/Users/hadi/Desktop/CORR/channel correlations/ALL_OPEN_Corrs.mat');
c_e = load('/Users/hadi/Desktop/CORR/channel correlations/ALL_CLOSE_Corrs.mat');

for figs = 1:4

    figure('Position',[0,357,1400,700]);

    switch figs
        case 1
            %fig 1
            titpos1 = 0.173;
            col_order = { o_e.start_age_use, o_e.dur_use, o_e.craving ,c_e.start_age_use, c_e.dur_use, c_e.craving}%, correct_ans, incorrect_ans, preserv_errors, visual_span, audit_span, audit_forw, audit_rev, audit_total, visual_forw, visual_rev, visual_total, gram_use};
            name_order = { 'Starting Age of Use' , 'Duration of Use', 'Craving', 'Starting Age of Use' , 'Duration of Use', 'Craving'}% ,'Correct Answers' , 'Incorrect Answers','Preservative Errors' ,  'Visual Span', 'Auditory Span','Auditory forward', 'Auditory reverse', 'Auditory total', 'Visual forward', 'Visual reverse', 'Visual total', 'Grams per day' };
            % extra: { , 'Age',};
        case 2
            %fig2
            titpos1 = 0.173;
            col_order = { o_e.correct_ans, o_e.incorrect_ans, o_e.preserv_errors        ,c_e.correct_ans, c_e.incorrect_ans, c_e.preserv_errors}%, correct_ans, incorrect_ans, preserv_errors, visual_span, audit_span, audit_forw, audit_rev, audit_total, visual_forw, visual_rev, visual_total, gram_use};
            name_order = {'Correct Answers' , 'Incorrect Answers','Preservative Errors', 'Correct Answers' , 'Incorrect Answers','Preservative Errors'}% ,'Correct Answers' , 'Incorrect Answers','Preservative Errors' ,  'Visual Span', 'Auditory Span','Auditory forward', 'Auditory reverse', 'Auditory total', 'Visual forward', 'Visual reverse', 'Visual total', 'Grams per day' };
        case 3
            %fig3
            titpos1 = 0.155;
            col_order = { o_e.visual_span, o_e.visual_forw, o_e.visual_rev, o_e.visual_total,      c_e.visual_span, c_e.visual_forw, c_e.visual_rev, c_e.visual_total}%, correct_ans, incorrect_ans, preserv_errors, visual_span, audit_span, audit_forw, audit_rev, audit_total, visual_forw, visual_rev, visual_total, gram_use};
            name_order = { 'Visual Span', 'Visual forward', 'Visual reverse', 'Visual total',       'Visual Span', 'Visual forward', 'Visual reverse', 'Visual total'}% ,'Correct Answers' , 'Incorrect Answers','Preservative Errors' ,  'Visual Span', 'Auditory Span','Auditory forward', 'Auditory reverse', 'Auditory total', 'Visual forward', 'Visual reverse', 'Visual total', 'Grams per day' };
        case 4
            %fig 4
            titpos1 = 0.155;
            col_order = { o_e.audit_span, o_e.audit_forw, o_e.audit_rev, o_e.audit_total ,     c_e.audit_span, c_e.audit_forw, c_e.audit_rev, c_e.audit_total}%, correct_ans, incorrect_ans, preserv_errors, visual_span, audit_span, audit_forw, audit_rev, audit_total, visual_forw, visual_rev, visual_total, gram_use};
            name_order = { 'Auditory Span','Auditory forward', 'Auditory reverse', 'Auditory total',     'Auditory Span','Auditory forward', 'Auditory reverse', 'Auditory total'}% ,'Correct Answers' , 'Incorrect Answers','Preservative Errors' ,  'Visual Span', 'Auditory Span','Auditory forward', 'Auditory reverse', 'Auditory total', 'Visual forward', 'Visual reverse', 'Visual total', 'Grams per day' };
        otherwise
            disp("error ")
    end

    cols =  length(col_order); %columns of figure
    posTitle = [titpos1, 0.975, 0.05259, 0.02619]; %position of the first title 0.151
    posBand = [0.0717 , 0.86 , 0.0425, 0.0385];
    fontsize = 12;

    %plot relative powers
    for col = 1:cols
        for band = 1:num_bands

            col_var = col_order{col};
            subplot(num_bands, cols , band*cols - cols +col);
            sig_lead_5 = find(col_var.pval_rel(:,band) < 0.05);
            topoplot(col_var.corr_rel(:, band), chanss, 'maplimits', [-0.6 0.6],  'emarker2', {sig_lead_5, 'o', 'r', 4, 2});
            pos = get(gca, 'Position');
            pos(3) = pos(3) * 1.3; % Increase width
            pos(4) = pos(4) * 1.3; % Increase height
            set(gca, 'Position', pos);
            % title(['Relative Power Correlation CRAVING - ' band_names{band} ' Band']);
            if col ==1
                p2 = [posBand(1), posBand(2) - (0.1743 *(band-1)), posBand(3), posBand(4)];
                annotation('textbox', p2, 'String', band_names{band}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',   'FontSize', fontsize, 'FitBoxToText', 'on', 'EdgeColor', 'none','FontWeight','bold');
            end

        end
        ratio = 0.1 * 8/cols ;% 0.1 for 8 cols.
        %title and text box
        pos1 = [ posTitle(1) + ratio *(col-1), posTitle(2), posTitle(3), posTitle(4) ];
        annotation('textbox', pos1, 'String', name_order{col}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',...
            'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none','FontWeight','bold');

    end




    colorbar('position',[0.94 ,0.3,0.01,0.5]);   %changed recently!
    % legpos = [0.9940,0.4110,0.1533,0.0378];
    legpos = [0.999 ,0.18,0.01,0.5];
    annotation('textbox',legpos, ...
        'String', 'Power Correlation Topography', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', fontsize, ...
        'FitBoxToText', 'on', ...
        'EdgeColor', 'none', ...
        'Rotation', 90);

    annotation('line', [0.53,0.53],[0, 1], 'LineWidth',5);
    annotation('textbox', [0.3,0.02916 ,0.03375,0.0378], 'String', 'Open Eye', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', 20,  'FitBoxToText', 'on', 'EdgeColor', 'none');
    annotation('textbox', [0.75,0.02916 ,0.03375,0.0378], 'String', 'Close Eye', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', 20,  'FitBoxToText', 'on', 'EdgeColor', 'none');


end
%% band labels
%
% % Define the position of the line
% x = [0.9157, 0.9157 + -0.1492];
% y = [0.0832, 0.0832 ];
% % hold on
% % Plot the line with width 2
% % line(x, y, 'LineWidth', 2);
% x2 = [0.5014,0.7285];
% x3 = [0.461428571428571,0.237142857142857];
% x4 = [0.205,0.148571428571429];
% % line(x2, y, 'LineWidth', 2);
% annotation('line', x,y, 'LineWidth',2);
% annotation('line', x2,y, 'LineWidth',2);
% annotation('line', x3,y, 'LineWidth',2);
% annotation('line', x4,y, 'LineWidth',2);
%
%
% wmstextbox = [0.81889,0.02916 ,0.03375,0.0378];
% annotation('textbox', wmstextbox, 'String', 'WMS', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
% annotation('textbox', [ 0.5954998677, wmstextbox(2),wmstextbox(3),wmstextbox(4)], 'String', 'WCST', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
% annotation('textbox', [ 0.3283, wmstextbox(2),wmstextbox(3),wmstextbox(4)], 'String', 'Demographics', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');
% annotation('textbox', [ 0.15049, wmstextbox(2),wmstextbox(3),wmstextbox(4)], 'String', 'MCQ-SF', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',  'FontSize', fontsize,  'FitBoxToText', 'on', 'EdgeColor', 'none');




