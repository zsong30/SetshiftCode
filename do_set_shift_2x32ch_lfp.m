function rat = do_set_shift_2x32ch_lfp
% rat = do_set_shift_2x32ch_lfp_analyses is to analyze dual ucla probe lfp data
% from setshift task.

% Author: Eric Song
% Updated by Eric S 12/02/2021.

rat = struct;
rat(1).name = 'CSF01'; rat(1).sex = 'female';
rat(2).name = 'CSM01'; rat(2).sex = 'male';

downsamplingrate = 60;
Frq = 30000/downsamplingrate;  % sampling frequency; it is 30000 originally but will be downsampled (to 500).
minsec = 1; % minimal length of data for analyses

% add data path
% rat #1
rat(1).day(1).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-25_10-43-03_SS\experiment1\recording1\structure.oebin';
rat(1).day(1).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-25_10-43-03_SS';
rat(1).day(1).logfn = ...
    'CSF01_2021_02_25__10_43_02.csv';

rat(1).day(2).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-26_14-46-57_SS\experiment1\recording1\structure.oebin';
rat(1).day(2).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-26_14-46-57_SS';
rat(1).day(2).logfn = ...
    'CSF01_2021_02_26__14_47_02.csv';

rat(1).day(3).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-01_14-50-32_SS\experiment1\recording2\structure.oebin';
rat(1).day(3).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-01_14-50-32_SS';
rat(1).day(3).logfn = ...
    'CSF01_2021_03_01__14_51_02.csv';

rat(1).day(4).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-16_13-44-00_SS\experiment1\recording2\structure.oebin';
rat(1).day(4).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-16_13-44-00_SS';
rat(1).day(4).logfn = ...
    'CSF01_2021_03_16__13_44_02.csv';

rat(1).day(5).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-17_13-25-40_SS\experiment1\recording1\structure.oebin';
rat(1).day(5).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-17_13-25-40_SS';
rat(1).day(5).logfn = ...
    'CSF01_2021_03_17__13_26_02.csv';

rat(1).day(6).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-18_12-32-12_SS\experiment1\recording1\structure.oebin';
rat(1).day(6).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-18_12-32-12_SS';
rat(1).day(6).logfn = ...
    'CSF01_2021_03_18__12_32_02.csv';

rat(1).day(7).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-04-27_13-51-15_SS\experiment1\recording1\structure.oebin';
rat(1).day(7).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-04-27_13-51-15_SS';
rat(1).day(7).logfn = ...
    'CSF01_2021_04_27__13_51_02.csv';
% 
% % rat #2
rat(2).day(1).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-03-24_14-33-37_SS\experiment1\recording1\structure.oebin';
rat(2).day(1).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-03-24_14-33-37_SS';
rat(2).day(1).logfn = ...
    'CSM01_2021_03_24__14_34_02.csv';

rat(2).day(2).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-26_11-35-06\experiment1\recording1\structure.oebin';
rat(2).day(2).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-26_11-35-06';
rat(2).day(2).logfn = ...
    'CSM01_2021_04_26__11_35_02.csv';

rat(2).day(3).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-29_11-32-28_SS\Record Node 101\experiment1\recording1\structure.oebin';
rat(2).day(3).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-29_11-32-28_SS';
rat(2).day(3).logfn = ...
    'CSM01_2021_04_29__11_32_02.csv';

rat(2).day(4).epath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-30_11-09-47_SS\Record Node 101\experiment1\recording1\structure.oebin';
rat(2).day(4).bpath = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-30_11-09-47_SS';
rat(2).day(4).logfn = ...
    'CSM01_2021_04_30__11_09_02.csv';



V2Dorder = ...
    [9 8 10 7 11 6 12 5 25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17 1 16 2 15 3 14 4 13];
V2Dorder2 = [57 56 58 55 59 54 60 53 41 40 42 39 43 38 44 37 45 36 46 35 47 34 48 33 49 64 50 63 51	62 52 61];

D2Vorder = flip(V2Dorder);
D2Vorder2 = flip(V2Dorder2);

% now loop in all data
for rt = 1:length(rat)
    fprintf('Working on rat #%d\n',rt)
    for dy = 1:length(rat(rt).day)
        fprintf('\tworking on day %d\n', dy)
        cd(rat(rt).day(dy).bpath)
        logfn = rat(rt).day(dy).logfn;
        setshift = read_set_shift_behavior_one_file_only(logfn);
        % read in the data for chosen channels from recording
        RawData1=load_open_ephys_binary(rat(rt).day(dy).epath, 'continuous',1,'mmap');
        
        trimedData = double(RawData1.Data.Data(1).mapped([D2Vorder,D2Vorder2],:));
        
        trimedData=downsample(trimedData',downsamplingrate)'; % downsampling; nChan x nSamples
        RawData1.Timestamps=double(downsample(RawData1.Timestamps,downsamplingrate));% downsampling timestamps;
        
        % now get timestamps from ADC channel to know when the SS task
        % started in open ephys time (start time).
        if rt == 1 && dy == 7 || rt == 2 && dy == 2 %format is ( && ) || ( && ) *means (this and this) or (this and this)
            % for those whose PulsePal doesn't show in event channel BUT
            % those that have 6 accelerometer channels
            TSdata = RawData1.Data.Data.mapped(71,(1:30000*60*2));
            SStimestamps = double(find((TSdata>20000),1,'first'));
            % SStimestamps is the first ts of the TTL
            SStimestamps = SStimestamps + double(RawData1.Timestamps(1));
        elseif rt == 2 && dy ~= 2
            % for those whose PulsePal doesn't show in event channel BUT
            % those that DON'T have 6 accelerometer channels
            TSdata = RawData1.Data.Data.mapped(65,(1:30000*60*2));
            SStimestamps = double(find((TSdata>15000),1,'first'));
            SStimestamps = SStimestamps + double(RawData1.Timestamps(1));
        else
            % for those that have the event channel 
            SStimestamps = load_open_ephys_binary(rat(rt).day(dy).epath,'events',1,'mmap'); %%% in samples!!
            SStimestamps = double(SStimestamps.Timestamps(1));
            % we don't need to have SStimestamps = SStimestamps +
            % RawData1.Timestamps(1) because this time SStimestamps starts
            % counting
            % from data acquizition.
        end
        
        

        for rl = 1:length(setshift.rules)
            for bl = 1:length(setshift.rules(rl).blocks)
                for tr = 1:length(setshift.rules(rl).blocks(bl).trials)
                  
                        responsetime_sample = round(setshift.rules(rl).blocks(bl).trials(tr).end*Frq*downsamplingrate)...
                            + SStimestamps - double(RawData1.Timestamps(1)); % in samples
                        %responsetime_index = find(RawData1.Timestamps>responsetime_sample,1,'first');
                        responsetime_index = round(responsetime_sample/downsamplingrate);
                        setshift.rules(rl).blocks(bl).trials(tr).region(1).name = 'Prelimbic cortex';
                        setshift.rules(rl).blocks(bl).trials(tr).region(1).responselfp = ...
                            trimedData(1:32,(responsetime_index-Frq*minsec+1:responsetime_index + Frq*minsec));
                        setshift.rules(rl).blocks(bl).trials(tr).region(2).name = 'Striatum';
                        setshift.rules(rl).blocks(bl).trials(tr).region(2).responselfp = ...
                            trimedData(33:64,(responsetime_index-Frq*minsec+1:responsetime_index + Frq*minsec));
                        
                        cueontime_sample = round(setshift.rules(rl).blocks(bl).trials(tr).start*Frq*downsamplingrate)...
                            + SStimestamps - double(RawData1.Timestamps(1)); % in samples
                        %cueontime_index = find(RawData1.Timestamps>cueontime_sample,1,'first');
                        cueontime_index = round(cueontime_sample/downsamplingrate);
                        setshift.rules(rl).blocks(bl).trials(tr).region(1).cuelfp = ...
                            trimedData(1:32,(cueontime_index-Frq*minsec+1:cueontime_index + Frq*minsec));
                        setshift.rules(rl).blocks(bl).trials(tr).region(2).cuelfp = ...
                            trimedData(33:64,(cueontime_index-Frq*minsec+1:cueontime_index + Frq*minsec));
                        
                                                
                   
                end
            end
        end
        
        day(dy) = setshift;  %#ok<AGROW>
        
    end
    rat(rt).setshift = day;clear day;
end
rat = rmfield(rat,'day');

% save('2rats11days3regionsSetshift.mat','rat','-v7.3')
