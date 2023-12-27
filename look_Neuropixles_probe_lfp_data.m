function look_Neuropixles_probe_lfp_data(plotnum)
% function look_Neuropixles_probe_lfp_data(1) is for analyzing pilot data obtained
% from NP probes
% written by Eric S. Updated on 12/29/2020

%set path
path = 'D:\OPEN-EPHYS-ESM04_2021-03-10_15-03-24_dPAL\Record Node 102\experiment1\recording1\structure.oebin';
% read in the data for all channels from recording day1
% path = 'D:\test\ESM04_2021-02-22_14-12-20_OpenField\Record Node 101\experiment1\recording1\structure.oebin';
% path = 'D:\test\ESM04_2021-02-22_14-12-20_OpenField\Record Node 101\experiment2\recording1\structure.oebin';
% path = 'D:\test\ESM04_2021-02-22_14-12-20_OpenField\Record Node 101\experiment3\recording1\structure.oebin';
Trange = 1:5300000; % time range

RawData=load_open_ephys_binary(path, 'continuous',2,'mmap');

%trimedData = double(RawData.Data.Data(1).mapped); % nCh x nSample

% set params
params.Fs = 2500;  
params.tapers = [2 3];
params.fpass = [1 100];
movingwin = [0.5 .01];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];


if plotnum == 1
             
%to choose a random channel to analyze
chanNum = input('choose a channel to analyze = ');
%  data for the channel specified by chanNum.
data = double(RawData.Data.Data(1).mapped(chanNum,Trange));
%data= data(1:2500*6);

% plot raw data
figure('name',sprintf( 'Raw data of Channel # %d', chanNum))
plot(data*0.195,'LineWidth',3,'Color','b')
xlabel('sample'); ylabel('uV');
ylim([-800,800])
set(gca, 'FontName', 'Arial', 'FontSize', 28, 'FontWeight', 'bold')

% plot power spectrum line graphs
[S,f]=mtspectrumc(data',params);
S = 10*log(S);
figure('name',sprintf( 'Specgram line graph of Channel # %d', chanNum))
plot(f,S,'LineWidth',2,'Color','r')
xlabel('Frequency (Hz)'); ylabel('dB');

% % make specgram heatmap figure
[S,t,f]=mtspecgramc(data',movingwin,params);
S = 10*log(S);
figure('name',sprintf( 'Specgram heatmap of Channel # %d', chanNum))
pcolor(t,f, S'); colormap(jet); shading flat
xlabel('Time(sec)'); ylabel('Frequency (Hz)');
axis xy;
caxis([0 100]); colorbar;
ylim(params.fpass);
clear data

% plot raw data every 10th channel
ch = (1:10:384);
for c = 1:length(ch)
data(c,:) = double(RawData.Data.Data(1).mapped(ch(c),Trange))-median(double(RawData.Data.Data(1).mapped(ch(c),Trange)),2)+500*(c)/0.195;
end
data = data(:,2500*60:2500*65);
figure('name',sprintf( 'Raw data of every 10th channel'))
plot(data'*0.195)
yticks(500:2500:20500);
yticklabels(200:500:5700) %from 0 to 500 to 1000 ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% xticks, xticklabels need to be revised %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ylabel('Distance from tip in microns','Fontsize',28)
xticks(0:500*2:500*10)  
xticklabels(0:2/5:2)
xlabel('Time in seconds')
xlim([-500,5500])
ylim([0,22500])
set(gca, 'FontName', 'Arial', 'FontSize', 22, 'FontWeight', 'bold')
clear data

% plot raw data every channel for 50 consecutive channels.
ch = (1:1:50);
for c = 1:length(ch)
data(c,:) = double(RawData.Data.Data(1).mapped(ch(c),Trange))-median(double(RawData.Data.Data(1).mapped(ch(c),Trange)),2)+3000*(c);
%originally +500
end
data = data(:,2500*60:2500*65);
figure('name',sprintf( 'Raw data of every channel for 50 channels'))
plot(data'*0.195)
% yticks(0:500*5:500*40*5) %original
% yticklabels(0:500:100*40*5) %original

yticks(0:3000*5:3000*40*5)
yticklabels(0:5:50)

ylabel('Channels')
xticks(0:1000*2:1000*10)
xticklabels(0:5:1000)
xlabel('time in seconds')
xlim([-500,5500])
ylim([0,21000])
clear data

% plot power spectrum for consecutive channels.
ch = (1:1:25);
figure('name',sprintf( 'power spectrum for 25 consecutive channels'))
hold on
for c = 1:length(ch)
data(c,:) = double(RawData.Data.Data(1).mapped(ch(c),1:2500*6));
[S,f]=mtspectrumc(data(c,:)',params);
S = 10*log(S);
S = S + 10*(c-1);
plot(f,S)
clear S
end
xlabel('Frequency (Hz)'); ylabel('dB');



elseif plotnum == 2  % analyze data organized into 6sec consecutive 'trials'.

%to choose a random channel to analyze
chanNum = input('choose a channel to analyze = ');

% cut the data into 6-sec segments/'trials'
numtrials = floor(size(double(RawData.Data.Data(1).mapped(chanNum,Trange)),2)/(6*params.Fs));
%numtrials=20;
tempData = [];
for tr = 1: numtrials
    tempData = cat(3,tempData, double(RawData.Data.Data(1).mapped(chanNum:chanNum+1,1+(tr-1)*6*params.Fs:6*params.Fs*tr)));
end
tempData=permute(tempData,[3,2,1]); %%% now Data is trials*samples*channels


data=squeeze(tempData(:,:,1));

% plot power spectrum line graphs
[S,f]=mtspectrumc(data',params);
S = mean(S,2);
S = 10*log(S);
figure('name',sprintf( 'Specgram line graph of Channel # %d', chanNum))
plot(f,S,'LineWidth',2,'Color','r')
xlabel('Frequency (Hz)'); ylabel('dB');

% % make specgram heatmap figure
[S,t,f] = mtspecgramc(data',movingwin,params);
S = mean(S,3);
S = 10*log(S);
figure('name',sprintf( 'Specgram heatmap of Channel # %d', chanNum))
pcolor(t,f, S'); colormap(jet); shading flat
xlabel('Time(sec)'); ylabel('Frequency (Hz)');
axis xy;
caxis([0 100]); colorbar;
ylim(params.fpass);
clear data


% plot power spectrum for consecutive channels.
ch = (1:1:25)+50;

tempData = [];
for tr = 1: numtrials
    tempData = cat(3,tempData, double(RawData.Data.Data(1).mapped(ch,1+(tr-1)*6*params.Fs:6*params.Fs*tr)));
end
tempData=permute(tempData,[3,2,1]); %%% now Data is trials*samples*channels


data = nan(numtrials,6*params.Fs,length(ch));
figure('name',sprintf( 'power spectrum for 25 consecutive channels'))
hold on
for c = 1:length(ch)
    data(:,:,c) = tempData(:,:,c);
%data(c,:) = bipol_Data(ch(c),1:2500*6);
[S,f]=mtspectrumc(squeeze(data(:,:,c))',params);
S = mean(S,2);
S = 10*log(S);
S = S + 10*(c-1);
plot(f,S)
clear S
end
xlabel('Frequency (Hz)'); ylabel('dB');


end

