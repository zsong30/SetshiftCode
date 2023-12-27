
clear;clc
tic
figpath = 'E:\SetShift\ANALYSES';
FrameRate = 30;
raw_sample = 10*60*30000; % 10min 

ratname = 'CSF02';

path = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
logfn = 'E:\DeepLabCut\RAWDATA\Test-Eric-2022-08-25\videos\csf02-09232021 (online-video-cutter.com)DLC_resnet50_TestAug25shuffle1_50000_analyzed.csv';

params.Fs = 1500;  
params.tapers = [3 5];
params.fpass = [4 8];
movingwin = [0.5 0.1];

RawData = load_open_ephys_binary(path, 'continuous',3,'mmap');
RawData_event = load_open_ephys_binary(path, 'events',1,'mmap');
[~,b] = ismember(RawData_event.Timestamps(1),RawData.Timestamps);
allchdata = RawData.Data.Data.mapped(:,b:end);
allchdata_ds = downsample(allchdata',20);


channel = [11,161,311];
for ch = 1:3
singlechlfp = neuropixel_REreference(channel(ch),allchdata_ds');
[s,t,f]=mtspecgramc(singlechlfp(1,:),movingwin,params);
S(:,1) = squeeze(mean(10*log(s),2)); 


opts = detectImportOptions(logfn);
opts.Delimiter = {','};
opts.DataLines = [1 Inf];
opts.PreserveVariableNames = true;
T = readtable(logfn,opts);
speed_raw = T{(2:end),1};

t_vid = 1/60:1/60:length(speed_raw)*1/60;
t_vid = t_vid - 5.9667; % adjust from the beginning of the video


speed_new = nan(length(t),1);

for i = 1:length(t)

    speed_new(i) = mean(speed_raw(t_vid>(i-1)*movingwin(2)&t_vid<movingwin(1)+(i-1)*movingwin(2)));
   
end


S_new = S(1:length(speed_new));


speed_newS = smoothdata(speed_new,'gaussian',30);
S_newS = smoothdata(S_new,'gaussian',30);

figname =sprintf('ThetaPowerVsMoveSpeed%s0923chan#%d_%s',ratname,channel(ch),datestr(now,30));
fig = figure('name',figname);
scatter(speed_newS,S_newS,[],[0,0,0])
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
R = corrcoef(speed_new,S_new);
ylabel('Theta power','FontSize',20,'FontWeight', 'bold')
xlabel('Movement speed(cm/s)','FontSize',20,'FontWeight', 'bold')

            saveas(fig,fullfile(figpath,figname),'png')
            saveas(fig,fullfile(figpath,figname),'fig')
end

toc