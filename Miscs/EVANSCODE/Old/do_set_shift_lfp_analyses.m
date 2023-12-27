function rat = do_set_shift_lfp_analyses(analysis)
% rat = do_set_shift_lfp_analyses(3) is to analyze lfp data
% from operent box tasks including setshift.
% written by Eric S apr. 2021

rat = struct;
% lfp data path
rat(1).name = 'CSF01';

rat(1).day(1).epath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-02-25_10-43-03_SS\experiment1\recording1\structure.oebin';
rat(1).day(1).bpath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-02-25_10-43-03_SS';
rat(1).day(1).logfn = ...
    'CSF01_2021_02_25__10_43_02.csv';

rat(1).day(2).epath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-02-26_14-46-57_SS\experiment1\recording1\structure.oebin';
rat(1).day(2).bpath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-02-26_14-46-57_SS';
rat(1).day(2).logfn = ...
    'CSF01_2021_02_26__14_47_02.csv';

rat(1).day(3).epath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-01_14-50-32_SS\experiment1\recording2\structure.oebin';
rat(1).day(3).bpath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-01_14-50-32_SS';
rat(1).day(3).logfn = ...
    'CSF01_2021_03_01__14_51_02.csv';

rat(1).day(4).epath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-16_13-44-00_SS\experiment1\recording2\structure.oebin';
rat(1).day(4).bpath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-16_13-44-00_SS';
rat(1).day(4).logfn = ...
    'CSF01_2021_03_16__13_44_02.csv';

rat(1).day(5).epath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-17_13-25-40_SS\experiment1\recording1\structure.oebin';
rat(1).day(5).bpath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-17_13-25-40_SS';
rat(1).day(5).logfn = ...
    'CSF01_2021_03_17__13_26_02.csv';

rat(1).day(6).epath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-18_12-32-12_SS\experiment1\recording1\structure.oebin';
rat(1).day(6).bpath = ...
    'G:\My Drive\Setshift\EPHYSDATA\CSF01\CSF01_2021-03-18_12-32-12_SS';
rat(1).day(6).logfn = ...
    'CSF01_2021_03_18__12_32_02.csv';





minsec = 2;
for rt = 1:length(rat)
    for dy = 1:length(rat(rt).day)
cd(rat(rt).day(dy).bpath)
logfn = rat(rt).day(dy).logfn;
trialsegments = getTrialTimes(logfn,minsec);
condition = struct; temp = []; temp2 = [];
% analysise type
if analysis == 1 % Task vs Interval
    condition(1).name = 'Task'; condition(2).name = 'Interval';
    for seg = 1:3
        temp = ...
            [temp;trialsegments(seg).tasktimes_correct;trialsegments(seg).tasktimes_incorrect];
        condition(1).segment = temp;
        temp2 = ...
            [temp2;trialsegments(seg).intervaltimes_correct;trialsegments(seg).intervaltimes_incorrect];
        condition(2).segment = temp2;
    end
elseif analysis == 2 % Correct vs Incorrect
    condition(1).name = 'Correct'; condition(2).name = 'Incorrect';
    for seg = 1:3
        temp = ...
            [temp;trialsegments(seg).tasktimes_correct];
        condition(1).segment = temp;
        temp2 = ...
            [temp2;trialsegments(seg).tasktimes_incorrect];
        condition(2).segment = temp2;
    end
elseif analysis == 3 % SideRule vs LightRule
    condition(1).name = 'SideRule'; condition(2).name = 'LightRule';
    for seg = 2:3
        temp = ...
            [temp;trialsegments(seg).tasktimes_correct;trialsegments(seg).tasktimes_incorrect];
        condition(1).segment = temp;
    end
    seg = 1;
    temp2 = ...
        [temp2;trialsegments(seg).intervaltimes_correct;trialsegments(seg).intervaltimes_incorrect];
    condition(2).segment = temp2;
elseif analysis == 4 % RearRule vs FrontRule
    condition(1).name = 'RearRule'; condition(2).name = 'FrontRule';
    seg = 2;
    temp = ...
        [temp;trialsegments(seg).tasktimes_correct;trialsegments(seg).tasktimes_incorrect];
    condition(1).segment = temp;
    seg = 3;
    temp2 = ...
        [temp2;trialsegments(seg).intervaltimes_correct;trialsegments(seg).intervaltimes_incorrect];
    condition(2).segment = temp2;
elseif analysis == 5 % SideRuleCorrect vs SideRuleIncorrect
    condition(1).name = 'SideRuleCorrect'; condition(2).name = 'SideRuleIncorrect';
    for seg = 2:3
        temp = ...
            [temp;trialsegments(seg).tasktimes_correct];
        condition(1).segment = temp;
        temp2 = ...
            [temp2;trialsegments(seg).tasktimes_incorrect];
        condition(2).segment = temp2;
    end
    
elseif analysis == 6 % SideRuleCorrect vs SideRuleIncorrect
    condition(1).name = 'LightRuleCorrect'; condition(2).name = 'LightRuleIncorrect';
    seg = 1;
        temp = ...
            [temp;trialsegments(seg).tasktimes_correct];
        condition(1).segment = temp;
        temp2 = ...
            [temp2;trialsegments(seg).tasktimes_incorrect];
        condition(2).segment = temp2;
     
end

% set params
params.Fs = 1500;  % it is 30000 originally but will be downsampled to 1500.
params.tapers = [3 5];
params.fpass = [1 30];
% movingwin = [0.5 .001];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];

% channel ventral to dorsal order
V2Dorder = ...
    [9 8 10 7 11 6 12 5 25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17 1 16 2 15 3 14 4 13];

% read in the data for chosen channels from recording
RawData1=load_open_ephys_binary(rat(rt).day(dy).epath, 'continuous',1,'mmap');
trimedData = double(RawData1.Data.Data(1).mapped([V2Dorder(12:15),V2Dorder(28:31)+32],:));
% fname='csf01_02252021';
% fid = fopen(fname, 'w');
% fwrite(fid, trimedData, 'int16');
% fclose(fid);

trimedData=downsample(trimedData',20)'; % downsampling; 1 x nSamples
RawData1.Timestamps=double(downsample(RawData1.Timestamps,20));

% for Prelimbic cortex data, 1 x nSamples
region(1).name = 'PL';
region(1).data = trimedData(1:4,:);
% for striatum data, 1 x nSamples
region(2).name = 'ST';
region(2).data = trimedData(5:8,:);

% timestamps for the event channel, this was used to sync with setshift
% task
TSdata = load_open_ephys_binary(rat(rt).day(dy).epath, 'events',1);
EVtimestamps = double(TSdata.Timestamps); % in samples
SStimestamps = downsample(EVtimestamps,20);

% convert trial segment times to lfp times
condition(1).segment = round(condition(1).segment*params.Fs*20)...
    + SStimestamps(1); % in samples
condition(2).segment = round(condition(2).segment*params.Fs*20)...
    + SStimestamps(1); % in samples

% find index of the trial segments in lfp times
for i = 1:length(condition(1).segment)
    index(i)=find(RawData1.Timestamps>condition(1).segment(i,1),1,'first'); %#ok<*AGROW>
    % index2(i)=find(RawData1.Timestamps==condition(1).segment(i,2));
end
segments = [index;index+params.Fs*minsec]';
data = [region(1).data;region(2).data]; % combine for artifact rejection
% clean data and reject artifact
clean_segmented_data = get_clean_data_automatic_ES(data,RawData1.Timestamps,segments);

% biplor referencing
for i = 1:size(clean_segmented_data.trial,2)
region(1).condition(1).data(i,:) = clean_segmented_data.trial{1,i}(2,:)-clean_segmented_data.trial{1,i}(1,:);
region(2).condition(1).data(i,:) = clean_segmented_data.trial{1,i}(6,:)-clean_segmented_data.trial{1,i}(5,:);
end
region(1).condition(1).name = condition(1).name;region(2).condition(1).name = condition(2).name;
clear index index2 segments

% find index of the trial segments in lfp times for condition 2
for i = 1:length(condition(2).segment)
     index(i)=find(RawData1.Timestamps>condition(2).segment(i,1),1,'first'); %#ok<*AGROW>
    % index2(i)=find(RawData1.Timestamps==condition(1).segment(i,2));
end
segments = [index;index+params.Fs*minsec]';
% clean data and reject artifact
clean_segmented_data = get_clean_data_automatic_ES(data,RawData1.Timestamps,segments);
% biplor referencing
for i = 1:size(clean_segmented_data.trial,2)
region(1).condition(2).data(i,:) = clean_segmented_data.trial{1,i}(2,:)-clean_segmented_data.trial{1,i}(1,:);
region(2).condition(2).data(i,:) = clean_segmented_data.trial{1,i}(6,:)-clean_segmented_data.trial{1,i}(5,:);
end
region(1).condition(2).name = condition(2).name;region(2).condition(2).name = condition(2).name;
clear index index2 segments

rat(rt).day(dy).region = region;

    end % end of day
end % end of rat
