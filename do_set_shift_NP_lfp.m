function rat = do_set_shift_NP_lfp
% rat = do_set_shift_NP_lfp_analyses is to analyze dual NP probe lfp data
% from setshift task.

% Author: Eric Song
% Updated by Eric S 12/02/2021.

rat = struct;
rat(1).name = 'CSF02'; rat(1).sex = 'female';

downsamplingrate = 5;
Frq = 2500/downsamplingrate;  % sampling frequency; it is 30000 originally but will be downsampled to 500.
minsec = 0.8; % minimal length of data for analyses

% add data path
% rat #1
rat(1).day(1).epath = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
rat(1).day(1).bpath = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18';
rat(1).day(1).logfn = ...
    'CSF02_2021_09_23__14_50_02';

rat(1).day(2).epath = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin';
rat(1).day(2).bpath = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10';
rat(1).day(2).logfn = ...
    'CSF02_2021_09_24__15_17_02';

rat(1).day(3).epath = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\Record Node 101\experiment1\recording1\structure.oebin';
rat(1).day(3).bpath = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07';
rat(1).day(3).logfn = ...
    'CSF02_2021_09_29__15_43_02';


% now loop in all data
for rt = 1:length(rat)
    fprintf('Working on rat #%d\n',rt)
    for dy = 1:length(rat(rt).day)
        fprintf('\tworking on day %d\n', dy)
        cd(rat(rt).day(dy).bpath)
        logfn = rat(rt).day(dy).logfn;
        setshift = read_set_shift_behavior_one_file_only(logfn);
        % read in the data for chosen channels from recording
        RawData1=load_open_ephys_binary(rat(rt).day(dy).epath, 'continuous',2,'mmap');
        RawData2=load_open_ephys_binary(rat(rt).day(dy).epath, 'continuous',4,'mmap');
        samplelength = min(size(RawData1.Data.Data(1).mapped,2),size(RawData2.Data.Data(1).mapped,2));
        trimedData = double([RawData1.Data.Data(1).mapped(1:384,1:samplelength);RawData2.Data.Data(1).mapped(1:384,1:samplelength)]);
        trimedData=downsample(trimedData',downsamplingrate)'; % downsampling; nChan x nSamples
%         RawData1.Timestamps=double(downsample(RawData1.Timestamps,downsamplingrate));% downsampling timestamps;
        
        % now get timestamps from ADC channel to know when the SS task
        % started in open ephys time (start time).
        
        SStimestamps = load_open_ephys_binary(rat(rt).day(dy).epath,'events',1,'mmap'); %%% in samples!!
        SStimestamps.Timestamps(1) = SStimestamps.Timestamps(1)*2500/30000;        
        
        for rl = 2:length(setshift.rules)
            for bl = 1:length(setshift.rules(rl).blocks)
                for tr = 1:length(setshift.rules(rl).blocks(bl).trials)
                    if setshift.rules(rl).blocks(bl).trials(tr).response_latency > minsec
                        responsetime_sample = round(setshift.rules(rl).blocks(bl).trials(tr).response_time*Frq*downsamplingrate)...
                            + double(SStimestamps.Timestamps(1)) - double(RawData1.Timestamps(1)); % in samples
                        %endtime_index = find(RawData1.Timestamps>endtime_sample,1,'first');
                        responsetime_index = round(responsetime_sample/downsamplingrate);
                        setshift.rules(rl).blocks(bl).trials(tr).region(1).name = 'Prelimbic cortex';
                        setshift.rules(rl).blocks(bl).trials(tr).region(1).tasklfp = ...
                            trimedData(1:384,(responsetime_index-Frq*minsec+1:responsetime_index));
                        setshift.rules(rl).blocks(bl).trials(tr).region(2).name = 'Striatum';
                        setshift.rules(rl).blocks(bl).trials(tr).region(2).tasklfp = ...
                            trimedData(385:384*2,(responsetime_index-Frq*minsec+1:responsetime_index));
                        
                        cueontime_sample = round(setshift.rules(rl).blocks(bl).trials(tr).start*Frq*downsamplingrate)...
                            + double(SStimestamps.Timestamps(1)) - double(RawData1.Timestamps(1)); % in samples
                        %cueontime_index = find(RawData1.Timestamps>cueontime_sample,1,'first');
                        cueontime_index = round(cueontime_sample/downsamplingrate);
                        setshift.rules(rl).blocks(bl).trials(tr).region(1).baselinelfp = ...
                            trimedData(1:384,(cueontime_index-Frq*minsec+1:cueontime_index));
                        setshift.rules(rl).blocks(bl).trials(tr).region(2).baselinelfp = ...
                            trimedData(385:384*2,(cueontime_index-Frq*minsec+1:cueontime_index));
                        
                    end                            
                    
                end
            end
        end
        
        day(dy) = setshift;  %#ok<AGROW>
        
    end
    rat(rt).setshift = day;clear day;
end
rat = rmfield(rat,'day');

% save('2rats11days3regionsSetshift.mat','rat','-v7.3')
