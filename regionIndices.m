function indices = regionIndices(r)



% Define channel groups
frontalChannels = {'Fp1', 'F3', 'F7',    'F4', 'Fp2', 'F8'}; 
RfrontalChannels = { 'F4', 'Fp2', 'F8'};
LfrontalChannels  = {'Fp1', 'F3', 'F7'};
centralChannels = {'C3',             'C4'};
RcentralChannels ={'C4'};
LcentralChannels = {'C3'};
parietalChannels = {'P3',          'P4' };
RparietalChannels = { 'P4' };
LparietalChannels = {'P3'};
occipitalChannels = {'O1',                   'O2'};
RoccipitalChannels =   {'O2'};
LoccipitalChannels = {'O1'};
temporalChannels = {'T3', 'T4', 'T5', 'T6'}; % not in Prashad
RtemporalChannels = {'T4','T6'};
LtemporalChannels = {'T3', 'T5'};


% Map channel names to indices
channelNames = {'Fp1','F7','T3','T5','O1','F3','C3','P3','Fp2','F8','T4','T6','O2','F4','C4','P4'};
channelIndices = struct();
for i = 1:length(channelNames)
    channelIndices.(channelNames{i}) = i;
end

% Function to get indices for a group of channels
getChannelIndices = @(channels) cellfun(@(ch) channelIndices.(ch), channels);

% Get indices for each region
frontalIndices = getChannelIndices(frontalChannels);
RfrontalIndices = getChannelIndices(RfrontalChannels); %6
LfrontalIndices = getChannelIndices(LfrontalChannels);%7

centralIndices = getChannelIndices(centralChannels);
RcentralIndices = getChannelIndices(RcentralChannels); %8
LcentralIndices = getChannelIndices(LcentralChannels);%9

parietalIndices = getChannelIndices(parietalChannels);
RparietalIndices = getChannelIndices(RparietalChannels);  %10
LparietalIndices = getChannelIndices(LparietalChannels); %11

occipitalIndices = getChannelIndices(occipitalChannels);
RoccipitalIndices = getChannelIndices(RoccipitalChannels); %12
LoccipitalIndices = getChannelIndices(LoccipitalChannels);%13

temporalIndices = getChannelIndices(temporalChannels);
RtemporalIndices = getChannelIndices(RtemporalChannels);%14
LtemporalIndices = getChannelIndices(LtemporalChannels);%15

ALL = getChannelIndices(channelNames); %16


% Compute metrics for each region and frequency band
regions = {'Frontal', 'Central', 'Parietal', 'Occipital', 'Temporal', ...
    'RF', 'LF', 'RC', 'LC', 'RP', 'LP', 'RO', 'LO', 'RT', 'LT','ALL'};
regionIndices = {frontalIndices, centralIndices, parietalIndices, occipitalIndices, temporalIndices,...
    RfrontalIndices,LfrontalIndices,RcentralIndices, LcentralIndices, RparietalIndices, LparietalIndices, RoccipitalIndices,...
    LoccipitalIndices,RtemporalIndices, LtemporalIndices, ALL};

%output :
       indices = regionIndices{r};
       disp(['  ' regions{r}  ' Channels '] )
end
