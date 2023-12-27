function do_UCLA_probe_lfp_analyses_one_file_only(analysis)
% do_UCLA_probe_lfp_analyses_one_file_only(2) is to analyze lfp data
% from operent box tasks including setshift.
% written by Eric S apr. 2021

% lfp data path
% path1 = 'F:\Copied\CSF01_2021-03-18_12-32-12_SS\experiment1\recording1\structure.oebin';
% % behavior data path
% logfn = 'CSF01_2021_03_18__12_32_02.csv';

path1 = 'F:\CSM01_2021-04-30_11-09-47_SS\Record Node 101\experiment1\recording1\structure.oebin';
% behavior data path
logfn = 'CSM01_2021_04_30__11_09_02.csv';

minsec = 2;
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
    
end

% set params
params.Fs = 1500;  % it is 30000 originally but will be downsampled to 1500.
params.tapers = [3 5];
params.fpass = [1 30];
movingwin = [0.5 .001];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];

% open ephys channel ventral to dorsal order
V2Dorder = ...
    [9 8 10 7 11 6 12 5 25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17 1 16 2 15 3 14 4 13];

% read in the data for chosen channels from recording
RawData1=load_open_ephys_binary(path1, 'continuous',1,'mmap');
trimedData = double(RawData1.Data.Data(1).mapped([V2Dorder(28:31),V2Dorder(21:24)+32],:));
%trimedData =
%double(RawData1.Data.Data(1).mapped([V2Dorder(12:15),V2Dorder(28:31)+32],:));useforCSF01
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
% TSdata = load_open_ephys_binary(path1, 'events',1);
% EVtimestamps = double(TSdata.Timestamps); % in samples
% TSdata = load_open_ephys_binary(rat(rt).day(dy).epath, 'events',1);
TSdata = RawData1.Data.Data.mapped(65,(1:30000*60*10));
EVtimestamps = double(find((TSdata>20000),1,'first'));
% EVtimestamps = double(EVtimestamps); % in samples
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
%region(1).condition(1).data(i,:) = clean_segmented_data.trial{1,i}(2,:)-clean_segmented_data.trial{1,i}(1,:);
region(1).condition(1).data(i,:) = clean_segmented_data.trial{1,i}(2,:);
%region(2).condition(1).data(i,:) = clean_segmented_data.trial{1,i}(6,:)-clean_segmented_data.trial{1,i}(5,:);
region(2).condition(1).data(i,:) = clean_segmented_data.trial{1,i}(6,:);
end
region(1).condition(1).name = condition(1).name;region(2).condition(1).name = condition(2).name;
clear index index2 segments

% find index of the trial segments in lfp times for condiiton 2
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




data1=region(1).condition(1).data';
%     cdata1=rmlinesmovingwinc(data1,[2 .05],50,params,.005,'n', 60);
%     data1=cdata1;
data2=region(2).condition(1).data';
%     cdata2=rmlinesmovingwinc(data2,[2 .05],100,params,.005,'n', 60);
%     data2=cdata2;
[C_1,phi,S12_1,S1_1,S2_1,t,f]=cohgramc(data1,data2,movingwin,params); %#ok<ASGLU>
S1_1=10*log10(S1_1);
S2_1=10*log10(S2_1);
% C S1, S2 are structured as times x frequencies x trials.
%
%     [C_ven,phi,S12,S1,S2_ven,t,f]=cohgramc(data1,data3,movingwin,params); %#ok<ASGLU>
%     S1=10*log10(S1);
%     S2_ven=10*log10(S2_ven);

data3=region(1).condition(2).data';
%     cdata1=rmlinesmovingwinc(data1,[2 .05],50,params,.005,'n', 60);
%     data1=cdata1;
data4=region(2).condition(2).data';
%     cdata2=rmlinesmovingwinc(data2,[2 .05],100,params,.005,'n', 60);
%     data2=cdata2;
%     cdata2=rmlinesmovingwinc(data2,[2 .05],100,params,.005,'n', 60);
%     data2=cdata2;
[C_2,phi,S12_2,S1_2,S2_2,t,f]=cohgramc(data3,data4,movingwin,params); %#ok<ASGLU>
S1_2=10*log10(S1_2);
S2_2=10*log10(S2_2);
% C S1_side, S2 are structured as times x frequencies x trials.
%     [C_side_ven,phi,S1_side2,S1_side,S2_side_ven,t,f]=cohgramc(data1,data3,movingwin,params); %#ok<ASGLU>
%     S1_side=10*log10(S1_side);
%     S2_side_ven=10*log10(S2_side_ven);

Mn_S1_1=mean(squeeze(mean(S1_1,1)),2);
SEM_S1_1=std(squeeze(mean(S1_1,1)),0,2)./sqrt(size(data1,1));

Mn_S2_1=mean(squeeze(mean(S2_1,1)),2);
SEM_S2_1=std(squeeze(mean(S2_1,1)),0,2)./sqrt(size(data1,1));

Mn_C_1=mean(squeeze(mean(C_1,1)),2);
SEM_C_1=std(squeeze(mean(C_1,1)),0,2)./sqrt(size(data1,1));


Mn_S1_2=mean(squeeze(mean(S1_2,1)),2);
SEM_S1_2=std(squeeze(mean(S1_2,1)),0,2)./sqrt(size(data3,1));

Mn_S2_2=mean(squeeze(mean(S2_2,1)),2);
SEM_S2_2=std(squeeze(mean(S2_2,1)),0,2)./sqrt(size(data3,1));

Mn_C_2=mean(squeeze(mean(C_2,1)),2);
SEM_C_2=std(squeeze(mean(C_2,1)),0,2)./sqrt(size(data3,1));


figure('name','set shift')
subplot(3,2,1)
hp1=plot(f,Mn_S1_1','LineWidth',3,'Color','g');
hold on
hp2=plot(f,Mn_S2_1','LineWidth',3,'Color','b');
%hp2_2=plot(f,Mn_S2_ven','LineWidth',3,'Color','b','LineStyle',':');
patch([f,fliplr(f)], [(Mn_S1_1-SEM_S1_1)',flipud(Mn_S1_1+SEM_S1_1)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
patch([f,fliplr(f)], [(Mn_S2_1-SEM_S2_1)',flipud(Mn_S2_1+SEM_S2_1)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
%patch([f,fliplr(f)], [(Mn_S2_ven-SEM_S2_ven)',flipud(Mn_S2_ven+SEM_S2_ven)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
myleg = {region(1).name,region(2).name};
legend([hp1,hp2], myleg);
legend boxoff
xlim(params.fpass);
%ylim([0,1.2]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Power', 'FontWeight', 'bold');
%title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
title(sprintf('Power during %s',condition(1).name'))
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
box off

subplot(3,2,2)
p1 = plot(f,Mn_C_1','LineWidth',3,'Color','r'); %#ok<*NASGU>
hold on
patch([f,fliplr(f)], [(Mn_C_1-SEM_C_1)',flipud(Mn_C_1+SEM_C_1)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
%     p2 = plot(f,Mn_C_ven','LineWidth',3,'Color','r','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_C_ven-SEM_C_ven)',flipud(Mn_C_ven+SEM_C_ven)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsal Str','PL - ventral Str'};
%     legend([p1,p2], myleg);
%     legend boxoff
xlim(params.fpass);
%     ylim([0.4,0.8]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Coherence', 'FontWeight', 'bold');
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
title(sprintf('%s - %s coherence during %s', region(1).name,region(2).name, condition(1).name))
box off

subplot(3,2,3)
hp1=plot(f,Mn_S1_2','LineWidth',3,'Color','g');
hold on
hp2=plot(f,Mn_S2_2','LineWidth',3,'Color','b');
%     hp2_2=plot(f,Mn_S2_side_ven','LineWidth',3,'Color','b','LineStyle',':');
patch([f,fliplr(f)], [(Mn_S1_2-SEM_S1_2)',flipud(Mn_S1_2+SEM_S1_2)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
patch([f,fliplr(f)], [(Mn_S2_2-SEM_S2_2)',flipud(Mn_S2_2+SEM_S2_2)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
%     patch([f,fliplr(f)], [(Mn_S2_side_ven-SEM_S2_side_ven)',flipud(Mn_S2_side_ven+SEM_S2_side_ven)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
myleg = {region(1).name,region(2).name};
legend([hp1,hp2], myleg);
legend boxoff
xlim(params.fpass);
%ylim([0,1.2]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Power', 'FontWeight', 'bold');
%title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
title(sprintf('Power during %s', condition(2).name))
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
box off

subplot(3,2,4)
p1 = plot(f,Mn_C_2','LineWidth',3,'Color','r');
hold on
patch([f,fliplr(f)], [(Mn_C_2-SEM_C_2)',flipud(Mn_C_2+SEM_C_2)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
%     p2 = plot(f,Mn_C_side_ven','LineWidth',3,'Color','r','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_C_side_ven-SEM_C_side_ven)',flipud(Mn_C_side_ven+SEM_C_side_ven)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsal Str','PL - ventral Str'};
%     legend([p1,p2], myleg);
%     legend boxoff
xlim(params.fpass);
%     ylim([0.4,0.8]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Coherence', 'FontWeight', 'bold');
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
title(sprintf('%s - %s coherence during %s', region(1).name,region(2).name, condition(2).name))
box off

% Plot the diff
if size(S1_1,3)> size(S1_2,3)
    numtrials = size(S1_2,3);
else
    numtrials = size(S1_1,3);
end

S1_d=(S1_1(:,:,1:numtrials) - S1_2(:,:,1:numtrials));
S2_d=(S2_1(:,:,1:numtrials) - S2_2(:,:,1:numtrials));
C_d=(C_1(:,:,1:numtrials) - C_2(:,:,1:numtrials));
%     S2_ven_d=(S2_side_ven(:,:,1:numtrials) - S2_ven(:,:,1:numtrials));
%     C_ven_d=(C_side_ven(:,:,1:numtrials) - C_ven(:,:,1:numtrials));

Mn_S1_d=mean(squeeze(mean(S1_d,1)),2);
SEM_S1_d=std(squeeze(mean(S1_d,1)),0,2)./sqrt(numtrials);

Mn_S2_d=mean(squeeze(mean(S2_d,1)),2);
SEM_S2_d=std(squeeze(mean(S2_d,1)),0,2)./sqrt(numtrials);

Mn_C_d=mean(squeeze(mean(C_d,1)),2);
SEM_C_d=std(squeeze(mean(C_d,1)),0,2)./sqrt(numtrials);
%     Mn_S2_ven_d=mean(squeeze(mean(S2_ven_d,1)),2)/max(mean(squeeze(mean(S2_2,1)),2));
%     SEM_S2_ven_d=std(squeeze(mean(S2_ven_d,1)),0,2)./sqrt(size(plData_side,1))/max(mean(squeeze(mean(S2_2,1)),2));
%
%     Mn_C_ven_d=mean(squeeze(mean(C_ven_d,1)),2);
%     SEM_C_ven_d=std(squeeze(mean(C_ven_d,1)),0,2)./sqrt(size(plData_side,1));

subplot(3,2,5)
hp5 = plot(f,Mn_S1_d','LineWidth',3,'Color','g');
hold on
patch([f,fliplr(f)], [(Mn_S1_d-SEM_S1_d)',flipud(Mn_S1_d+SEM_S1_d)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
hp6 = plot(f,Mn_S2_d','LineWidth',3,'Color','b');
patch([f,fliplr(f)], [(Mn_S2_d-SEM_S2_d)',flipud(Mn_S2_d+SEM_S2_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)

% hp7 = plot(f,Mn_S2_ven_d','LineWidth',3,'Color','r');
% patch([f,fliplr(f)], [(Mn_S2_ven_d-SEM_S2_ven_d)',flipud(Mn_S2_ven_d+SEM_S2_ven_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
myleg = {region(1).name,region(2).name};
legend([hp5,hp6], myleg);
legend boxoff

xlim(params.fpass);
%ylim([-5,15]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Power change', 'FontWeight', 'bold');
title(sprintf('%s - %s power difference', condition(1).name,condition(2).name))
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
box off

subplot(3,2,6)
p3 = plot(f,Mn_C_d','LineWidth',3,'Color','r');
hold on
patch([f,fliplr(f)], [(Mn_C_d-SEM_C_d)',flipud(Mn_C_d+SEM_C_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     p4 = plot(f,Mn_C_ven_d','LineWidth',3,'Color','r');
%     patch([f,fliplr(f)], [(Mn_C_ven_d-SEM_C_ven_d)',flipud(Mn_C_ven_d+SEM_C_ven_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsal Str','PL - ventral Str'};
%     legend([p3,p4], myleg);
%     legend boxoff

xlim(params.fpass);
%ylim([-0.05,0.15]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Coherence change', 'FontWeight', 'bold');
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
title(sprintf('%s - %s coherence difference', condition(1).name,condition(2).name))
box off
