function rat = do_set_shift_lfp_analyses_ES
% rat = do_set_shift_lfp_analyses_ES is to analyze lfp data
% from operent box tasks including setshift.
% written by Eric S Apr. 2021

rat = struct;
rat(1).name = 'CSF01';
rat(2).name = 'CSM01';

rat(1).day(1).epath = ...
    'F:\CSF01\CSF01_2021-02-25_10-43-03_SS\experiment1\recording1\structure.oebin';
rat(1).day(1).bpath = ...
    'F:\CSF01\CSF01_2021-02-25_10-43-03_SS';
rat(1).day(1).logfn = ...
    'CSF01_2021_02_25__10_43_02.csv';

rat(1).day(2).epath = ...
    'F:\CSF01\CSF01_2021-02-26_14-46-57_SS\experiment1\recording1\structure.oebin';
rat(1).day(2).bpath = ...
    'F:\CSF01\CSF01_2021-02-26_14-46-57_SS';
rat(1).day(2).logfn = ...
    'CSF01_2021_02_26__14_47_02.csv';

rat(1).day(3).epath = ...
    'F:\CSF01\CSF01_2021-03-01_14-50-32_SS\experiment1\recording2\structure.oebin';
rat(1).day(3).bpath = ...
    'F:\CSF01\CSF01_2021-03-01_14-50-32_SS';
rat(1).day(3).logfn = ...
    'CSF01_2021_03_01__14_51_02.csv';

rat(1).day(4).epath = ...
    'F:\CSF01\CSF01_2021-03-16_13-44-00_SS\experiment1\recording2\structure.oebin';
rat(1).day(4).bpath = ...
    'F:\CSF01\CSF01_2021-03-16_13-44-00_SS';
rat(1).day(4).logfn = ...
    'CSF01_2021_03_16__13_44_02.csv';

rat(1).day(5).epath = ...
    'F:\CSF01\CSF01_2021-03-17_13-25-40_SS\experiment1\recording1\structure.oebin';
rat(1).day(5).bpath = ...
    'F:\CSF01\CSF01_2021-03-17_13-25-40_SS';
rat(1).day(5).logfn = ...
    'CSF01_2021_03_17__13_26_02.csv';

rat(1).day(6).epath = ...
    'F:\CSF01\CSF01_2021-03-18_12-32-12_SS\experiment1\recording1\structure.oebin';
rat(1).day(6).bpath = ...
    'F:\CSF01\CSF01_2021-03-18_12-32-12_SS';
rat(1).day(6).logfn = ...
    'CSF01_2021_03_18__12_32_02.csv';

rat(1).day(7).epath = ...
    'F:\CSF01\CSF01_2021-04-27_13-51-15_SS\experiment1\recording1\structure.oebin';
rat(1).day(7).bpath = ...
    'F:\CSF01\CSF01_2021-04-27_13-51-15_SS';
rat(1).day(7).logfn = ...
    'CSF01_2021_04_27__13_51_02.csv';

%
rat(2).day(1).epath = ...
    'F:\CSM01\CSM01_2021-03-24_14-33-37_SS\experiment1\recording1\structure.oebin';
rat(2).day(1).bpath = ...
    'F:\CSM01\CSM01_2021-03-24_14-33-37_SS';
rat(2).day(1).logfn = ...
    'CSM01_2021_03_24__14_34_02.csv';

rat(2).day(2).epath = ...
    'F:\CSM01\CSM01_2021-04-26_11-35-06\experiment1\recording1\structure.oebin';
rat(2).day(2).bpath = ...
    'F:\CSM01\CSM01_2021-04-26_11-35-06';
rat(2).day(2).logfn = ...
    'CSM01_2021_04_26__11_35_02.csv';

rat(2).day(3).epath = ...
    'F:\CSM01\CSM01_2021-04-29_11-32-28_SS\Record Node 101\experiment1\recording1\structure.oebin';
rat(2).day(3).bpath = ...
    'F:\CSM01\CSM01_2021-04-29_11-32-28_SS';
rat(2).day(3).logfn = ...
    'CSM01_2021_04_29__11_32_02.csv';

rat(2).day(4).epath = ...
    'F:\CSM01\CSM01_2021-04-30_11-09-47_SS\Record Node 101\experiment1\recording1\structure.oebin';
rat(2).day(4).bpath = ...
    'F:\CSM01\CSM01_2021-04-30_11-09-47_SS';
rat(2).day(4).logfn = ...
    'CSM01_2021_04_30__11_09_02.csv';

Frq = 1500;  % it is 30000 originally but will be downsampled to 1500.
minsec = 2; % minimal length of data for analyses
condition = struct; % always 2 conditions of the setshift data for comparison: task vs baseline etc.
region = struct; % new tmp struct to save to the rat struct 
region(1).name = 'PL';% for Prelimbic cortex
region(2).name = 'ST';% for striatum data, nChan x nSamples

% channels in ventral to dorsal anatomial order; order for the 2nd is just
% V2Dorder + 32
V2Dorder = ...
    [9 8 10 7 11 6 12 5 25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17 1 16 2 15 3 14 4 13];

% now loop in all data
for rt = 1:length(rat)
    for dy = 1:length(rat(rt).day)
        cd(rat(rt).day(dy).bpath)
        logfn = rat(rt).day(dy).logfn;
        trialsegments = getTrialTimes(logfn,minsec);
        % trialsegments is to get trial times from behavioral tests
        % trialsegments(1) includes behavior times from Light rules
        % trialsegments(2) includes behavior times from Rear side rules
        % trialsegments(3) includes behavior times from Front side rules
        
        
        for comparison = 1:6 % see below for each comparison
            
            temp = []; temp2 = [];
            % comparison type
            if comparison == 1 % Task vs Interval
                condition(2*comparison-1).name = 'Task'; condition(2*comparison).name = 'Interval';
                for seg = 1:3
                    temp = ...
                        [temp;trialsegments(seg).tasktimes_correct;trialsegments(seg).tasktimes_incorrect];
                    condition(2*comparison-1).segment = temp;
                    temp2 = ...
                        [temp2;trialsegments(seg).intervaltimes_correct;trialsegments(seg).intervaltimes_incorrect];
                    condition(2*comparison).segment = temp2;
                end
            elseif comparison == 2 % Correct vs Incorrect
                condition(2*comparison-1).name = 'Correct'; condition(2*comparison).name = 'Incorrect';
                for seg = 1:3
                    temp = ...
                        [temp;trialsegments(seg).tasktimes_correct];
                    condition(2*comparison-1).segment = temp;
                    temp2 = ...
                        [temp2;trialsegments(seg).tasktimes_incorrect];
                    condition(2*comparison).segment = temp2;
                end
            elseif comparison == 3 % SideRule vs LightRule
                condition(2*comparison-1).name = 'SideRule'; condition(2*comparison).name = 'LightRule';
                for seg = 2:3
                    temp = ...
                        [temp;trialsegments(seg).tasktimes_correct;trialsegments(seg).tasktimes_incorrect];
                    condition(2*comparison-1).segment = temp;
                end
                seg = 1;
                temp2 = ...
                    [temp2;trialsegments(seg).intervaltimes_correct;trialsegments(seg).intervaltimes_incorrect];
                condition(2*comparison).segment = temp2;
            elseif comparison == 4 % RearRule vs FrontRule
                condition(2*comparison-1).name = 'RearRule'; condition(2*comparison).name = 'FrontRule';
                seg = 2;
                temp = ...
                    [temp;trialsegments(seg).tasktimes_correct;trialsegments(seg).tasktimes_incorrect];
                condition(2*comparison-1).segment = temp;
                seg = 3;
                temp2 = ...
                    [temp2;trialsegments(seg).intervaltimes_correct;trialsegments(seg).intervaltimes_incorrect];
                condition(2*comparison).segment = temp2;
            elseif comparison == 5 % SideRuleCorrect vs SideRuleIncorrect
                condition(2*comparison-1).name = 'SideRuleCorrect'; condition(2*comparison).name = 'SideRuleIncorrect';
                for seg = 2:3
                    temp = ...
                        [temp;trialsegments(seg).tasktimes_correct];
                    condition(2*comparison-1).segment = temp;
                    temp2 = ...
                        [temp2;trialsegments(seg).tasktimes_incorrect];
                    condition(2*comparison).segment = temp2;
                end
                
            elseif comparison == 6 % SideRuleCorrect vs SideRuleIncorrect
                condition(2*comparison-1).name = 'LightRuleCorrect'; condition(2*comparison).name = 'LightRuleIncorrect';
                seg = 1;
                temp = ...
                    [temp;trialsegments(seg).tasktimes_correct];
                condition(2*comparison-1).segment = temp;
                temp2 = ...
                    [temp2;trialsegments(seg).tasktimes_incorrect];
                condition(2*comparison).segment = temp2;
                
            end
            
     
            
            % read in the data for chosen channels from recording
            RawData1=load_open_ephys_binary(rat(rt).day(dy).epath, 'continuous',1,'mmap');
            if rt == 1
                trimedData = double(RawData1.Data.Data(1).mapped([V2Dorder(12:15),V2Dorder(28:31)+32],:));
            elseif rt == 2
                trimedData = double(RawData1.Data.Data(1).mapped([V2Dorder(28:31),V2Dorder(21:24)+32],:));
            end
            % fname='csf01_02252021';
            % fid = fopen(fname, 'w');
            % fwrite(fid, trimedData, 'int16');
            % fclose(fid);
            
            trimedData=downsample(trimedData',20)'; % downsampling; nChan x nSamples
            RawData1.Timestamps=double(downsample(RawData1.Timestamps,20));% downsampling timestamps;
          
          
            
            if rt == 1 && dy == 7 || rt == 2 && dy == 2 %format is ( && ) || ( && ) *means (this and this) or (this and this)
                % for those whose PulsePal doesn't show in event channel
                TSdata = RawData1.Data.Data.mapped(71,(1:30000*60*10));
                SStimestamps = double(find((TSdata>20000),1,'first'));
                % SStimestamps is the first ts of the TTL
            elseif rt == 2 && dy > 2
                % for those whose PulsePal doesn't show in event channel
                TSdata = RawData1.Data.Data.mapped(65,(1:30000*60*10));
                SStimestamps = double(find((TSdata>15000),1,'first'));
            else
                % for those whose PulsePal does show
                TSdata = load_open_ephys_binary(rat(rt).day(dy).epath, 'events',1);
                SStimestamps = double(TSdata.Timestamps); % in samples
            end
            
            % convert trial segment times to lfp times
            condition(2*comparison-1).segment = round(condition(2*comparison-1).segment*Frq*20)...
                + SStimestamps(1); % in samples
            condition(2*comparison).segment = round(condition(2*comparison).segment*Frq*20)...
                + SStimestamps(1); % in samples
            
            % find index of the trial segments in lfp times
            for i = 1:length(condition(2*comparison-1).segment)
                index_trial(i)=find(RawData1.Timestamps>condition(2*comparison-1).segment(i,1),1,'first'); %#ok<*AGROW>
            end
            segments = [index_trial;index_trial+Frq*minsec]'; % time indice in samples
            % data = [region(1).data;region(2).data]; % combine for artifact rejection
            % clean data and reject artifact
            data = trimedData;
            clean_segmented_data = get_clean_data_automatic_ES(data,RawData1.Timestamps,segments);
            
            % biplor referencing
            for i = 1:size(clean_segmented_data.trial,2)
                region(1).condition(2*comparison-1).data(i,:) = clean_segmented_data.trial{1,i}(2,:)-clean_segmented_data.trial{1,i}(1,:);
                region(2).condition(2*comparison-1).data(i,:) = clean_segmented_data.trial{1,i}(6,:)-clean_segmented_data.trial{1,i}(5,:);
            end
            region(1).condition(2*comparison-1).name = condition(2*comparison-1).name;
            region(2).condition(2*comparison-1).name = condition(2*comparison).name;
            clear index_trial segments
            
            % find index of the trial segments in lfp times for condition 2
            for i = 1:length(condition(2*comparison).segment)
                index_trial(i)=find(RawData1.Timestamps>condition(2*comparison).segment(i,1),1,'first'); %#ok<*AGROW>
            end
            segments = [index_trial;index_trial+Frq*minsec]';
            % clean data and reject artifact
            clean_segmented_data = get_clean_data_automatic_ES(data,RawData1.Timestamps,segments);
            % biplor referencing
            for i = 1:size(clean_segmented_data.trial,2)
                region(1).condition(2*comparison).data(i,:) = clean_segmented_data.trial{1,i}(2,:)-clean_segmented_data.trial{1,i}(1,:);
                region(2).condition(2*comparison).data(i,:) = clean_segmented_data.trial{1,i}(6,:)-clean_segmented_data.trial{1,i}(5,:);
            end
            region(1).condition(2*comparison).name = condition(2*comparison).name;
            region(2).condition(2*comparison).name = condition(2*comparison).name;
            clear index_trial segments
            
            
        end % end of comparison
        
        
        rat(rt).day(dy).region = region;
    end % end of day
end % end of rat
