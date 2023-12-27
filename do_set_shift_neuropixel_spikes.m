function subject = do_set_shift_neuropixel_spikes
% this subject = do_set_shift_neuropixel_spikes is to do spike analyses for the data obtained from the neuropixel probes
% at UMN
% Author: Eric Song 
% Updated on 10/20/2020

%%%%% the offset values for each day could be wrong and need double
%%%%% checking!!!!!!!!!!


rootZ = 'E:\SetShift\EPHYSDATA\NP';% where the rawdata are stored
path2save = 'E:\SetShift\DATA';
subject = [];
subject(1).name = 'CSF02';
subject(1).day(1).testingdate = '09232021';
subject(1).day(1).offset = 0;
subject(1).day(1).region(1).dataDir =...
    'CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
subject(1).day(1).region(2).dataDir =...
    'CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

subject(1).day(2).testingdate = '09242021';
subject(1).day(2).offset = 0;   
subject(1).day(2).region(1).dataDir =...
    'CSF02\CSF02_2021-09-24_15-17-10\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
subject(1).day(2).region(2).dataDir =...
    'CSF02\CSF02_2021-09-24_15-17-10\Record Node 101\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

subject(1).day(3).testingdate = '09222021';
subject(1).day(3).offset = 30000;
subject(1).day(3).region(1).dataDir =...
    'CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
subject(1).day(3).region(2).dataDir =...
    'CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

subject(2).name = 'CSF03';
subject(2).day(1).testingdate = '03292022';
subject(2).day(1).offset = 0;
subject(2).day(1).region(1).dataDir =...
    'CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
subject(2).day(1).region(2).dataDir =...
    'CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

subject(2).day(2).testingdate = '03302022';
subject(2).day(2).offset = 30000;
subject(2).day(2).region(1).dataDir =...
    'CSF03\CSF03_2022-03-30_15-02-57\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
subject(2).day(2).region(2).dataDir =...
    'CSF03\CSF03_2022-03-30_15-02-57\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';

subject(2).day(3).testingdate = '03312022';
subject(2).day(3).offset = 30000;
subject(2).day(3).region(1).dataDir =...
    'CSF03\CSF03_2022-03-31_14-46-54\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort3';
subject(2).day(3).region(2).dataDir =...
    'CSF03\CSF03_2022-03-31_14-46-54\Record Node 102\experiment1\recording1\continuous\Neuropix-PXI-100.2\kilosort3';


for sub = 1:length(subject)
for dy = 1:length(subject(sub).day)
for rg = 1:2
%%%%% from https://github.com/cortex-lab/spikes/blob/master/analysis/getWaveForms.m
gwfparams.dataDir...   % KiloSort/Phy output folder
    = fullfile(rootZ,subject(sub).day(dy).region(rg).dataDir);
gwfparams.fileName = 'continuous.dat';         % .dat file containing the raw
gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
gwfparams.nCh = 384;                      % Number of channels that were streamed to disk in .dat file
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 200;                    % Number of waveforms per unit to pull out
gwfparams.spikeTimes...  % Vector of cluster spike times (in samples) same length as .spikeClusters
    = readNPY(fullfile(gwfparams.dataDir,'spike_times.npy'))+subject(sub).day(dy).offset;
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

day = []; region = [];

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
            
            region(rg).units(u).name = clusterID;  %#ok<*AGROW>
            region(rg).units(u).channel = channel;
            region(rg).units(u).spikeData = tempdata;
            region(rg).units(u).spikeWidth = spikewidth'; % in miliseconds
            region(rg).units(u).spikeAmp = spikeAMP; % in uV
            % region(rg).units(u).spike_frequency_estimated = spike_frequency_estimated; % in Hz
            region(rg).units(u).ts=double((data(dataC==clusterID))*1000/30000); % convert timestamps to miliseconds


%%% changed by Eric S on 05/31/2023

trial(tr).units(u).spike_rate = 1000*length(trial(tr).units(u).ts)/(trial(tr).units(u).ts(end)-trial(tr).units(u).ts(1));




            region(rg).units(u).ISIs=[]; % will be in miliseconds as well
            for i = 1: length(region(rg).units(u).ts)-1
                region(rg).units(u).ISIs = [region(rg).units(u).ISIs, region(rg).units(u).ts(i+1)-region(rg).units(u).ts(i)];
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
            
            region(rg).mua_units(u).name = clusterID;  %#ok<*AGROW>
            region(rg).mua_units(u).channel = channel;
            region(rg).mua_units(u).spikeData = tempdata;
            region(rg).mua_units(u).spikeWidth = spikewidth';
            region(rg).mua_units(u).spikeAmp = spikeAMP;
            region(rg).mua_units(u).spike_frequency_estimated = spike_frequency_estimated;
            region(rg).mua_units(u).ts=double((data(dataC==clusterID))*1000/30000); % convert timestamps to miliseconds
            region(rg).mua_units(u).ISIs=[];
            for i = 1: length(region(rg).mua_units(u).ts)-1
                region(rg).mua_units(u).ISIs = [region(rg).mua_units(u).ISIs, region(rg).mua_units(u).ts(i+1)-region(rg).mua_units(u).ts(i)];
            end
            clear spikewidth
            
           
        end
        
  
    
end
end % end of region
region(rg).region = region; 

end % end of day

subject(sub).day = day;
end



fname2save = [];
for i = 1:length(subject)
   tmp = sprintf('%s_%ddays',subject(i).name,length(subject(i).day));
    fname2save = sprintf('%s%s',fname2save,tmp);
end
fname2save = sprintf('%s_%s.mat',fname2save,datestr(now,30));
save(fullfile(path2save,fname2save),'subject','-v7.3')


