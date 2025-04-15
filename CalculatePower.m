%load STUDY
eeglab
[STUDY ,ALLEEG] = pop_loadstudy('filename', 'Cannabis_30.study', 'filepath', '/Users/hadi/Desktop/EEG study set');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw

%% power calculation (one time save)

% Load EEGLAB
% [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

% Define frequency bands
delta_band = [1 4];
theta_band = [4 8];
alpha_band = [8 13];
beta_band = [13 30];
gamma_band = [30 50];

% Initialize variables
num_datasets = length(ALLEEG);
absolute_power = cell(num_datasets, 1);
relative_power = cell(num_datasets, 1);

% Loop through each dataset
for i = 1:num_datasets
    EEG = ALLEEG(i);
    num_channels = EEG.nbchan;
    abs_power = zeros(num_channels, 5); % 5 frequency bands
    rel_power = zeros(num_channels, 5);
    
    % Calculate power for each channel
    for ch = 1:num_channels
        % Get the power spectral density (PSD) using Welch's method
        [psd, freqs] = pwelch(EEG.data(ch, :), [], [], [], EEG.srate);
        
       % Calculate absolute power for each band
        abs_power(ch, 1) = bandpower(psd, freqs, delta_band, 'psd');
        abs_power(ch, 2) = bandpower(psd, freqs, theta_band, 'psd');
        abs_power(ch, 3) = bandpower(psd, freqs, alpha_band, 'psd');
        abs_power(ch, 4) = bandpower(psd, freqs, beta_band, 'psd');
        abs_power(ch, 5) = bandpower(psd, freqs, gamma_band, 'psd');
        
        % Calculate total power
        total_power = bandpower(psd, freqs, [1 50], 'psd');
        
        % Calculate relative power for each band
        rel_power(ch, 1) = abs_power(ch, 1) / total_power;
        rel_power(ch, 2) = abs_power(ch, 2) / total_power;
        rel_power(ch, 3) = abs_power(ch, 3) / total_power;
        rel_power(ch, 4) = abs_power(ch, 4) / total_power;
        rel_power(ch, 5) = abs_power(ch, 5) / total_power;
    end
    
    % Store results
    absolute_power{i} = abs_power;
    relative_power{i} = rel_power;
end

% Display results for the first dataset
% disp('Absolute Power for first dataset:');
% disp(absolute_power{1});
% disp('Relative Power for first dataset:');
% disp(relative_power{1});

save ("powers.mat","absolute_power","relative_power");


%%  save powers of EEG (one time save)

close = {27;18;19;21;23;46;47;48;49;50;51;52;53;54;55;56;0;57;58;59;29;1;3;5;7;8;10;12;26;15};
open = {28;17;20;22;24;31;32;33;34;35;36;37;38;39;40;41;42;43;44;45;30;2;4;6;25;9;11;13;14;16};
abs_power_close = zeros(30,16,5);
abs_power_open = zeros(30,16,5);
rel_power_close = zeros(30,16,5);
rel_power_open = zeros(30,16,5);

for i = 1:30
    if close{i} ~=0
        abs_power_close(i,:,:) = absolute_power{close{i}};
    else 
        abs_power_close(i,:,:) = 0; %only true for number 17. be careful XXXXX number 17 is 0
    end

    if close{i} ~=0
       rel_power_close(i,:,:) = relative_power{close{i}};
    else 
        rel_power_close(i,:,:) = 0; %be careful XXXXX number 17 is 0
    end
    abs_power_open(i,:,:) = absolute_power{open{i}};
    rel_power_open(i,:,:) = relative_power{open{i}};

end
disp('saved')
save ("powers3.mat","abs_power_close","abs_power_open","rel_power_open","rel_power_close");



%rel and abs_power_close(17,:,:) is zero






%% calculate correlation , print and ....

