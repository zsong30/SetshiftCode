function trial=do_set_shift_neuropixel_spikes_one_file_only
% this trial=do_UCLA_probe_spike_analyses is to do spike analyses for the data obtained from the UCLA probes
% at UMN
% Author: Eric Song, updated on 10/20/2020

offset = 0; % in samples; offset for when kilosort sorting started in the data. 
% offset = 30000*60*10; % in samples; offset for when kilosort sorting started in the data. 

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
% 
% offset = 10*30000; % in samples; offset for when kilosort sorting started in the data. 
% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';






% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF04\2022-10-06_14-58-47\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';




%%%%% from https://github.com/cortex-lab/spikes/blob/master/analysis/getWaveForms.m

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-16_14-48-13_rightaftersurgery\Record Node 104\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-16_14-48-13_rightaftersurgery\Record Node 104\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'D:\CSF02_2021-09-24_15-17-10\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.2\KS3_output';
% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
gwfparams.dataDir...   % KiloSort/Phy output folder
    = 'Z:\projmon\ericsprojects\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3_orig';
% % gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';
% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\dPAL\EPHYSDATA\ESF03\ESF03_2021-05-03_14-11-47\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03102021\OPEN-EPHYS-ESM04_2021-03-10_15-03-24_dPAL\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-101.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESF03\05062021\ESF03_2021-05-06_12-45-45\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-101.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-20_10-16-15\Record Node 102\experiment2\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-20_10-16-15\Record Node 102\experiment2\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder  %%%%%%%%% beginning of NP for manuscript
%     = 'Z:\projmon\ericsprojects\SetShift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3_orig';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';
% 
% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03092021\OPEN-EPHYS-ESM04-P_2021-03-09_15-18-34_dPAL\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-101.0\kilosort3';


% gwfparams.dataDir...   % KiloSort/Phy output folder
%     = 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03102021\OPEN-EPHYS-ESM04_2021-03-10_15-03-24_dPAL\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-101.0\kilosort3';




gwfparams.fileName = 'continuous.dat';         % .dat file containing the raw
gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
gwfparams.nCh = 384;                      % Number of channels that were streamed to disk in .dat file
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 200;                    % Number of waveforms per unit to pull out
gwfparams.spikeTimes...  % Vector of cluster spike times (in samples) same length as .spikeClusters
    = readNPY(fullfile(gwfparams.dataDir,'spike_times.npy'))+offset;
gwfparams.spikeClusters...% Vector of cluster IDs (Phy nomenclature)   same length as .spikeTimes
    = readNPY(fullfile(gwfparams.dataDir,'spike_clusters.npy'));
wf = getWaveForms(gwfparams);
% % OUTPUT
% wf.unitIDs                               % [nClu,1]            List of cluster IDs; defines order used in all wf.* variables
% wf.spikeTimeKeeps                        % [nClu,nWf]          Which spike times were used for the waveforms
% wf.waveForms                             % [nClu,nWf,nCh,nSWf] Individual waveforms
% wf.waveFormsMean                         % [nClu,nCh,nSWf]     Average of all waveforms (per channel)
%                                          % nClu: number of different clusters in .spikeClusters
%                                          % nSWf: number of samples per waveform

%%%%% choose the channel with biggest amplitude for plotting wf.
tempChannelAmps = squeeze(max(wf.waveFormsMean,[],3))-squeeze(min(wf.waveFormsMean,[],3));
% amplitude of each template on each channel, size nTemplates x nChannels
[~,maxChannel] = max(tempChannelAmps,[],2);
% index of the largest amplitude channel for each template, size nTemplates x 1
% maxChannel(8)=49;

trial = [];
tr = 1; % trial =1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Plot waveforms for clusters  analysis==1             %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% looking through all clusters to plot mean waveforms for each cluster using best channel data.
% because sometimes there are hundreds of clusters, you would like to
% see some of them first.
if size(wf.waveFormsMean,1)< 100
    figure('name','Waveforms for all clusters')
    for cl=1:size(wf.waveFormsMean,1)
        
        subplot(ceil(sqrt(size(wf.waveFormsMean,1))),ceil(sqrt(size(wf.waveFormsMean,1))),cl)
        
        plot(squeeze(wf.waveFormsMean(cl,maxChannel(cl),:)))

    end
else
    figure('name','Waveforms for first 100 clusters')
    for cl=1:100
        subplot(10,10,cl)

        plot(squeeze(wf.waveFormsMean(cl,maxChannel(cl),:)))

    end
    sprintf('NOTE:THERE ARE MORE THAN 100 CLUSTERS!')
end

% after manual clustering, a file called cluster_group.tsv will be
% created with information on good single unit clusters, mua, noise
% etc.
% so we would like to choose only good clusters to plot.

fn = fullfile(gwfparams.dataDir,'cluster_group.tsv');
fid = fopen(fn);
clusters = textscan(fid, '%n %s' ,'HeaderLines', 1);
fclose(fid);
clusterIDs = [];mua_clusterIDs=[];
for g = 1:size(clusters{1,2},1)
    if strcmp(clusters{1,2}(g),'good')
        clusterIDs = [clusterIDs, clusters{1,1}(g)];
    elseif strcmp(clusters{1,2}(g),'mua')
        mua_clusterIDs = [mua_clusterIDs, clusters{1,1}(g)];
    end
end


% clusterIDs = wf.unitIDs(clusterIDIndices(2:11));

% clusterIDIndices = [4 6 9 11];
% clusterIDIndices = (1:length(wf.unitIDs));
%clusterIDs = wf.unitIDs(clusterIDIndices);


% examples of good cluster IDs.
% clusterIDs = [64,69,70,73,116,136,154,157,209,232,233,338,341, 342,442,445,450];
% plot them in one figure with subplots
if isempty(clusterIDs)
    fprintf('NOTE:THERE ARE NO GOOD CLUSTERS!')
else
    
%     clusterIDIndices = nan(length(clusterIDs),1);
%     for i =1:length(clusterIDs)
%         clusterIDIndices(i) = find(wf.unitIDs==clusterIDs(i));
%     end
%     
    [~, clusterIDIndices] = ismember(clusterIDs, wf.unitIDs);
    
    
    figure('name',sprintf('Waveforms for good clusters'))
        
        %%% read in the data
        data = gwfparams.spikeTimes;
        dataC = gwfparams.spikeClusters;
        
        for u=1:length(clusterIDs)
            
            subplot(ceil(sqrt(length(clusterIDs))),ceil(sqrt(length(clusterIDs))),u)
            plot(squeeze(wf.waveFormsMean(clusterIDIndices(u),maxChannel(clusterIDIndices(u)),:))*0.195)
            ylabel('uV')
            xlabel('Sample')
            
            
            clusterID=clusterIDs(u);
            channel = maxChannel(clusterIDIndices(u));
            tempdata=squeeze(wf.waveForms(clusterIDIndices(u),:,maxChannel(clusterIDIndices(u)),:));% nWF x nSWF (200 X 82)

            for i = 1:size(tempdata,1)
                if ~isnan(tempdata(i,:))
                    spikewidth(i)= abs(find(tempdata(i,:)==min(tempdata(i,:)),1)-find(tempdata(i,:)==max(tempdata(i,:)),1));
                else
                end
            end
            spikewidth=spikewidth*1000/30000;% convert to milliseconds
                        
            spikeAMP=abs(max(tempdata,[],2)-min(tempdata,[],2))*0.195;
            
            % if isnan(wf.spikeTimeKeeps(clusterIDIndices(u),gwfparams.nWf))    % [nClu,nWf]  Which spike times were used for the waveforms
            % 
            %     tmp=find(isnan(wf.spikeTimeKeeps(clusterIDIndices(u),:)),1)-1;
            %     spike_frequency_estimated=(tmp-1)*30000/(wf.spikeTimeKeeps(clusterIDIndices(u),tmp)-wf.spikeTimeKeeps(clusterIDIndices(u),1));
            % 
            % else
            %     spike_frequency_estimated=(gwfparams.nWf-1)*30000/(wf.spikeTimeKeeps(clusterIDIndices(u),gwfparams.nWf)-wf.spikeTimeKeeps(clusterIDIndices(u),1));
            % end
            
            trial(tr).units(u).name = clusterID;  %#ok<*AGROW>
            trial(tr).units(u).channel = channel;
            trial(tr).units(u).spikeData = tempdata;
            trial(tr).units(u).spikeWidth = spikewidth'; % in miliseconds
            trial(tr).units(u).spikeAmp = spikeAMP; % in uV
            % trial(tr).units(u).spike_frequency_estimated = spike_frequency_estimated; % in Hz
            trial(tr).units(u).ts=double((data(dataC==clusterID))*1000/30000); % convert timestamps to miliseconds

%%% changed by Eric S on 05/31/2023

trial(tr).units(u).spike_rate = 1000*length(trial(tr).units(u).ts)/(trial(tr).units(u).ts(end)-trial(tr).units(u).ts(1));


            trial(tr).units(u).ISIs=[]; % will be in miliseconds as well
            for i = 1: length(trial(tr).units(u).ts)-1
                trial(tr).units(u).ISIs = [trial(tr).units(u).ISIs, trial(tr).units(u).ts(i+1)-trial(tr).units(u).ts(i)];
            end
            clear spikewidth
            
           
        end
        
  
    
end



%mua_clusterIDs = wf.unitIDs(mua_clusterIDIndices);

% examples of good cluster IDs.
% clusterIDs = [64,69,70,73,116,136,154,157,209,232,233,338,341, 342,442,445,450];
% plot them in one figure with subplots
if isempty(mua_clusterIDs)
    fprintf('NOTE:THERE ARE NO MUA CLUSTERS!')
else
    
%         mua_clusterIDIndices = nan(length(mua_clusterIDs),1);
%     for i =1:length(mua_clusterIDs)
%         mua_clusterIDIndices(i) = find(wf.unitIDs==mua_clusterIDs(i));
%     end
    
    [~, mua_clusterIDIndices] = ismember(mua_clusterIDs, wf.unitIDs);
    
    
    figure('name',sprintf('Waveforms for MUA clusters'))
        
        %%% read in the data
        data = gwfparams.spikeTimes;
        dataC = gwfparams.spikeClusters;
        
        mua_clusterIDs = mua_clusterIDs(mua_clusterIDIndices>0);
        mua_clusterIDIndices=mua_clusterIDIndices(mua_clusterIDIndices>0);
        
        if length(mua_clusterIDIndices) > 100
            fprintf('NOTE:THERE ARE MORE THAN MUA CLUSTERS!')
            fprintf('PLOTTING FIRST 100 MUA CLUSTERS!')
            mua_units2plot = 100;
        else
            mua_units2plot = length(mua_clusterIDIndices);
        end  
        for u=1:length(mua_clusterIDIndices)
            
            if u <=100
            subplot(ceil(sqrt(mua_units2plot)),ceil(sqrt(mua_units2plot)),u)
            plot(squeeze(wf.waveFormsMean(mua_clusterIDIndices(u),maxChannel(mua_clusterIDIndices(u)),:))*0.195)
            ylabel('uV')
            xlabel('Sample')
            else
            end
                        
            clusterID=mua_clusterIDs(u);
            channel = maxChannel(mua_clusterIDIndices(u));
            tempdata=squeeze(wf.waveForms(mua_clusterIDIndices(u),:,maxChannel(mua_clusterIDIndices(u)),:));% nWF x nSWF (200 X 82)

            for i = 1:size(tempdata,1)
                if ~isnan(tempdata(i,:))
                    spikewidth(i)= abs(find(tempdata(i,:)==min(tempdata(i,:)),1)-find(tempdata(i,:)==max(tempdata(i,:)),1));
                else
                end
            end
            spikewidth=spikewidth*1000/30000;% convert to milliseconds
                        
            spikeAMP=abs(max(tempdata,[],2)-min(tempdata,[],2))*0.195;
            
            if isnan(wf.spikeTimeKeeps(mua_clusterIDIndices(u),gwfparams.nWf))    % [nClu,nWf]  Which spike times were used for the waveforms
                
                tmp=find(isnan(wf.spikeTimeKeeps(mua_clusterIDIndices(u),:)),1)-1;
                spike_frequency_estimated=(tmp-1)*30000/(wf.spikeTimeKeeps(mua_clusterIDIndices(u),tmp)-wf.spikeTimeKeeps(mua_clusterIDIndices(u),1));
                
            else
                spike_frequency_estimated=(gwfparams.nWf-1)*30000/(wf.spikeTimeKeeps(mua_clusterIDIndices(u),gwfparams.nWf)-wf.spikeTimeKeeps(mua_clusterIDIndices(u),1));
            end
            
            trial(tr).mua_units(u).name = clusterID;  %#ok<*AGROW>
            trial(tr).mua_units(u).channel = channel;
            trial(tr).mua_units(u).spikeData = tempdata;
            trial(tr).mua_units(u).spikeWidth = spikewidth';
            trial(tr).mua_units(u).spikeAmp = spikeAMP;
            trial(tr).mua_units(u).spike_frequency_estimated = spike_frequency_estimated;
            trial(tr).mua_units(u).ts=double((data(dataC==clusterID))*1000/30000); % convert timestamps to miliseconds
            trial(tr).mua_units(u).ISIs=[];
            for i = 1: length(trial(tr).mua_units(u).ts)-1
                trial(tr).mua_units(u).ISIs = [trial(tr).mua_units(u).ISIs, trial(tr).mua_units(u).ts(i+1)-trial(tr).mua_units(u).ts(i)];
            end
            clear spikewidth
            
           
        end
        
  
    
end


