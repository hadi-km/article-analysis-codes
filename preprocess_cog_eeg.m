% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_biosig('/Users/hadi/Desktop/cog-eeg/edf/3-14-AlirezaNaraghi.edf');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','3','gui','off'); 

% eeglab redraw

%sampsizepwr(
clc;


SET_NUM = 1;

%% add comment (timing)

% adding_comment = '  split on 780';
% EEG = pop_comments(EEG, '', strvcat(' ',adding_comment), 1);


%% SCROLL THE EEG PLOT
pop_eegplot( EEG, 1, 1, 1);
disp(['- - - EEG half length  is ' int2str(EEG.xmax/2) ' seconds '])


%% BAND PASS AND CHANNEL SELECTION

EEG = pop_select( EEG, 'channel',{'Fp1-A1','F7-A1','T3-A1','T5-A1','O1-A1','F3-A1','C3-A1','P3-A1','Fp2-A2','F8-A2','T4-A2','T6-A2','O2-A2','F4-A2','C4-A2','P4-A2'});
EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'hicutoff',40,'plotfreqz',1);
EEG = pop_reref( EEG, []);
% EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );\
%view data after filtering:
pop_eegplot( EEG, 1, 1, 1);
disp(['- - - EEG half length  is ' int2str(EEG.xmax/2) ' seconds '])
disp('- - - band pass is done. view and reject manually...')
%% REJECT DATA MANUALLY AND then SAVE
EEG = pop_saveset( EEG, 'filename',[int2str(SET_NUM) '_rej_full_noICA.set'],'filepath','/Users/hadi/Desktop/cog-eeg/EEG_SET/');


%% split
splitt = 780;
% sp2=890  % open/ close / open
% part1 = EEG.data(:,1:splitt*256) ; part3 = EEG.data(:,sp2*256:end) ;
% part1 = [part1 part3];

all_data= EEG.data;
part1 = EEG.data(:,1:splitt*256) ; %uncomment for 3 parts CHECK!!!
part2 = EEG.data(:,splitt*256:end) ;


disp(['part 1 is ' int2str(length(part1)/256) ' seconds long'])
disp(['part 2 is ' int2str(length(part2)/256) ' seconds long'])

%% PART 1
EEG.data= part1;
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);

%VIEW AND CONFIRM THE PLOTS
pop_eegplot( EEG, 1, 1, 1);
disp(['EEG half length  is ' int2str(EEG.xmax/2) ' seconds '])
%% SAVE P1
EEG = pop_saveset( EEG, 'filename',[int2str(SET_NUM) '_open_noICA.set'],'filepath','/Users/hadi/Desktop/cog-eeg/EEG_SET/');

%% PART 2
EEG.data= part2;
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);

%VIEW AND CONFIRM THE PLOTS
pop_eegplot( EEG, 1, 1, 1);
disp(['EEG half length  is ' int2str(EEG.xmax/2) ' seconds '])
%% SAVE P2
EEG = pop_saveset( EEG, 'filename',[int2str(SET_NUM) '_close_noICA.set'],'filepath','/Users/hadi/Desktop/cog-eeg/EEG_SET/');
%NOTE: EVENT TIMES ARE NOT SYNCED IN THE PART 2 FORMAT

%%  MERGE OPEN AND CLOSE AGAIN
EEG.data= all_data;
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);

%VIEW
pop_eegplot( EEG, 1, 1, 1);
disp(['EEG half length  is ' int2str(EEG.xmax/2) ' seconds '])

%% NOW run ICA on full DATA then split again

EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'rndreset','yes','interrupt','on','pca',15);

EEG=pop_chanedit(EEG, {'lookup','/Users/hadi/Desktop/eeglab2024.0/functions/supportfiles/channel_location_files/eeglab/Standard-10-20-Cap19.ced'},'load',{'/Users/hadi/Desktop/eeglab2024.0/16locs.ced','filetype','autodetect'});


EEG = pop_iclabel(EEG, 'default');

% flag as artifacts (ICLabel)
EEG = pop_icflag(EEG, [NaN NaN;0.6 1;0.6 1;NaN NaN;0.6 NaN;NaN NaN;0.5 1]);

EEG = pop_reref( EEG, []);


% view components
pop_viewprops(EEG,0,1:15)

%view component activations
pop_eegplot( EEG, 0, 1, 1);



% remove components
%inspect by eye
%% save
EEG = pop_saveset( EEG, 'filename',[int2str(SET_NUM) '_full_ICA_removed.set'],'filepath','/Users/hadi/Desktop/cog-eeg/EEG_SET/');


%% split AFTER ICA
disp(splitt)

all_data_ica= EEG.data;
part1_ica = EEG.data(:,1:splitt*256) ;
part2_ica = EEG.data(:,splitt*256:end) ;

disp(['part 1 is ' int2str(length(part1_ica)/256) ' seconds long'])
disp(['part 2 is ' int2str(length(part2_ica)/256) ' seconds long'])

%% PART 1
EEG.data= part1_ica;
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);

%VIEW AND CONFIRM THE PLOTS
pop_eegplot( EEG, 1, 1, 1);
disp(['EEG half length  is ' int2str(EEG.xmax/2) ' seconds '])
%% SAVE P1
EEG = pop_saveset( EEG, 'filename',[int2str(SET_NUM) '_OPEN_ICA.set'],'filepath','/Users/hadi/Desktop/cog-eeg/EEG_SET/');

%% PART 2
EEG.data= part2_ica;
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);

%VIEW AND CONFIRM THE PLOTS
pop_eegplot( EEG, 1, 1, 1);
disp(['EEG half length  is ' int2str(EEG.xmax/2) ' seconds '])
%% SAVE P2
EEG = pop_saveset( EEG, 'filename',[int2str(SET_NUM) '_CLOSE_ICA.set'],'filepath','/Users/hadi/Desktop/cog-eeg/EEG_SET/');

%NOTE: EVENT TIMES ARE NOT SYNCED IN THE PART 2 FORMAT


%%





%% analysis part ...


%check analysis.m


