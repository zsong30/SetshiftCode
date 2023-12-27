
%clear;clc
figpath = 'E:\dPAL\ANALYSES';
FrameRate = 30;
raw_sample = 5*60*30000; 
V2Dorder = ...
    [9 8 10 7 11 6 12 5 25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17 1 16 2 15 3 14 4 13];

% path = 'E:\dPAL\EPHYSDATA\DF06\05162022\RAW_PRE_2022-05-16_14-09-14\Record Node 101\experiment1\recording1\structure.oebin';
% logfn = 'E:\DeepLabCut\RAWDATA\Erictest4-Eric-2022-05-17\videos\speeddata_pre.csv';
% path = 'E:\dPAL\EPHYSDATA\DF06\05162022\RAW_POST_2022-05-16_14-51-32\Record Node 101\experiment1\recording1\structure.oebin';
% logfn = 'E:\DeepLabCut\RAWDATA\Erictest4-Eric-2022-05-17\videos\speeddata_post.csv';


% path = 'E:\dPAL\EPHYSDATA\DF06\6102022\RAW_PRE_2022-06-10_12-16-32\Record Node 101\experiment1\recording1\structure.oebin';
% logfn = 'E:\DeepLabCut\RAWDATA\ClosedLoopTE2Hippo-Eric-2022-06-14\videos\RAW_PRE_DF06_061022DLC_resnet50_ClosedLoopTE2HippoJun14shuffle1_80000_analyzed.csv';
% path = 'E:\dPAL\EPHYSDATA\DF06\6102022\RAW_POST_2022-06-10_12-58-57\Record Node 101\experiment1\recording1\structure.oebin';
% logfn = 'E:\DeepLabCut\RAWDATA\ClosedLoopTE2Hippo-Eric-2022-06-14\videos\analyses with tail\RAW_POST_DF06_061022DLC_resnet50_ClosedLoopTE2HippoJun14shuffle1_80000_analyzed.csv';
% path = 'E:\dPAL\EPHYSDATA\DF06\07082022\RAW_PRE_2022-07-08_13-37-07\Record Node 115\experiment1\recording1\structure.oebin';
% logfn = 'E:\dPAL\EPHYSDATA\DF06\07082022\RAW_PREDLC_resnet50_ClosedLoopTE2HippoJun14shuffle1_80000_analyzed.csv';
% adjust_logfn = 'E:\dPAL\EPHYSDATA\DF06\07082022\raw_pre_test_times.xlsx';



path = 'E:\dPAL\EPHYSDATA\DF06\07262022\RAW_PRE_2022-07-26_14-10-28\Record Node 115\experiment1\recording1\structure.oebin';
logfn = 'E:\dPAL\EPHYSDATA\DF06\07262022\RAW_PRE_DF06_07262022DLC_resnet50_ClosedLoopTE2HippoJun14shuffle1_80000_analyzed.csv';
adjust_logfn = 'E:\dPAL\EPHYSDATA\DF06\07262022\raw_pre_test_times.xlsx';






ratname = 'DF06';
figname =sprintf('ThetaCohVsMoveSpeed%s0726raw_pre%s',ratname,datestr(now,30));

params.Fs = 30000;  % it is 30000 originally but will be downsampled to 1500.
% params.tapers = [2 3];
params.tapers = [3 5];
params.fpass = [6 10];
movingwin = [0.5 0.1];



RawData = load_open_ephys_binary(path, 'continuous',1,'mmap');
%lfpdata = double(RawData.Data.Data.mapped(flip(V2Dorder),:));
hippolfpdata = double(RawData.Data.Data.mapped(11,1:raw_sample))-double(RawData.Data.Data.mapped(6,1:raw_sample));
te2lfpdata = double(RawData.Data.Data.mapped(33,1:raw_sample))-double(RawData.Data.Data.mapped(34,1:raw_sample));

for ch = 1 : size(hippolfpdata,1)
[c,phi,s12,s1,s2,t,f] = cohgramc(te2lfpdata',hippolfpdata(ch,:)',movingwin,params);
S(:,ch) = squeeze(mean(10*log(s2),2)); %#ok<SAGROW>
C(:,ch) = squeeze(mean(c,2)); %#ok<SAGROW>
end


opts = detectImportOptions(logfn);
opts.Delimiter = {','};
opts.DataLines = [1 Inf];
opts.PreserveVariableNames = true;
T = readtable(logfn,opts); % has an x.
speed_raw = T{(2:end),1};

T2 = readtable(adjust_logfn);
times = T2{(1:end),1};
diff_time = diff(times);

speed = nan(size(speed_raw));
for i = 1:length(speed)
   speed(i) = (speed_raw(i)/diff_time(i))/30; % 30 is frame per second.  Correcting DeepLabCut values because the frame intervals are not consistent.
end


%t_vid = (1/FrameRate)*(1:length(speed))+(9000-length(speed))*(1/FrameRate);
tmptimes = 1/30; t_vid = nan(size(times));
t_vid(1) = 1/30;
for i = 2:length(times)
    tmptimes = tmptimes+times(i)-times(i-1);
    t_vid(i) = tmptimes;
end

speed_new = nan(length(t),1);
% for i = 1:length(t)
%     if i ==1
%     speed_new(i) = speed(find(t_vid>t(i),1,'first')); 
%     else
%     speed_new(i) = mean(speed(find(t_vid>t(i-1),1,'first')+1:1:find(t_vid>t(i),1,'first'))); 
%     end
%     
% end


for i = 1:length(t)

        speed_new(i) = mean(speed(t_vid>(i-1)*movingwin(2)&t_vid<movingwin(1)+(i-1)*movingwin(2)));
   
end



%S_new = S(1:length(speed_new));
C_new = C(1:length(speed_new));

% speed_new = speed_new(speed_new<700);
% C_new = C_new(speed_new<700);

speed_newS = smoothdata(speed_new,'gaussian',30);
C_newS = smoothdata(C_new,'gaussian',30);

fig = figure('name',figname);
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

scatter(speed_newS,C_newS)
R = corrcoef(speed_new,C_new);
ylabel('Theta coherence','FontSize',24)
xlabel('Moving speed(cm/s)','FontSize',24)

            saveas(fig,fullfile(figpath,figname),'png')
            saveas(fig,fullfile(figpath,figname),'fig')

