function rat = script_for_the_NP_setshift(plotnum)
% function script_for_the_NP_manuscript(2.5) is to produce figures for
% the NP manuscript. Example: script_for_the_NP_manuscript(2)
% plotnum == 1: raw traces & bipolar traces
% plotnum == 2: data from recording in the dPAL chamber averaging across every 10 channels as a cluster
% plotnum == 3: raw traces & bipolar traces
% plotnum == 4: raw traces & bipolar traces

% Author: Eric Song,
% Date: Feb.01. 2023
rat = struct;
params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [0 30];
params.trialave = 0;
movingwin = [0.5 0.01];
datapath = 'E:\NP Manuscript';
% figpath = 'E:\NP Manuscript\CSF03_3d_PL';
% figpath = 'E:\NP Manuscript';

% data(1).path = ...
%     'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03092021\OPEN-EPHYS-ESM04-P_2021-03-09_15-18-34_dPAL\Record Node 102\experiment1\recording1\structure.oebin';
% data(1).logfn = 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03092021\15-18\DPAL-ESM04-P-Mar_09_21-15_18-LOG_file';
% 
% data(2).path = 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03102021\OPEN-EPHYS-ESM04_2021-03-10_15-03-24_dPAL\Record Node 102\experiment1\recording1\structure.oebin';
% data(2).logfn = 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03102021\15-03\DPAL-ESM-P-Mar_10_21-15_03-LOG_file';

% this is for open field
% data(3).path = ...
% 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM06\04282021\ESM06_2021-04-28_09-04-29_OF\Record Node 101\experiment1\recording1\structure.oebin';
% data(3).path = ...
% 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM06\04282021\ESM06_2021-04-28_09-04-29_OF\Record Node 101\experiment2\recording2\structure.oebin';
% data(3).path = ...
%     'E:\SetShift\EPHYSDATA\NP\CSF02\CSF02AwakeAfterSurgery_2021-09-09_13-58-16\Record Node 102\experiment1\recording1\structure.oebin';

% this is for dPAL
%%%%% data(4).path = ...
%%%%% 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\02222021\ESM04_2021-02-22_14-12-20_OpenField\Record Node 101\experiment2\recording1\structure.oebin';
%data(4).path = ...
%    'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03092021\OPEN-EPHYS-ESM04-P_2021-03-09_15-18-34_dPAL\Record Node 102\experiment1\recording1\structure.oebin';
%%%%% data(4).path = ...
%%%%% 'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03152021\OPEN-EPHYS-ESM04-P_2021-03-15_dPAL3-17\Record Node 101\experiment1\recording1\structure.oebin';


% this is for setshift

for rt = 1:2
    
    if rt == 1
data(1).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
data(1).logfn = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\CSF02_2021_09_23__14_50_02';
data(2).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin';
data(2).logfn = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\CSF02_2021_09_24__15_17_02';

data(3).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\Record Node 101\experiment1\recording1\structure.oebin';
data(3).logfn = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\CSF02_2021_09_29__15_43_02';

    elseif rt == 2

data(1).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\structure.oebin';
data(1).logfn = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\CSF03PM_2022_03_29__14_52_00';

data(2).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\Record Node 102\experiment1\recording1\structure.oebin';
data(2).logfn = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\CSF03_2022_03_30__15_03_00';

data(3).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\Record Node 102\experiment1\recording1\structure.oebin';
data(3).logfn = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\CSF03_2022_03_31__14_47_00';

    end

% % this is for reuse
% data(7).path = ...
%     'E:\dPAL\EPHYSDATA\Neuropixel probes\ESF03\05062021\ESF03_2021-05-06_12-45-45\Record Node 102\experiment1\recording1\structure.oebin';






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%   raw traces & bipolar traces                                %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plotnum == 1
    %     whichday = input('which day do you want to visualize = ');
    
    for whichday = 5:5
        path = data(whichday).path;
        
        % read in the data for chosen channels from recording
        RawData = load_open_ephys_binary(path, 'continuous',2,'mmap');
        origdata = double(RawData.Data.Data(1).mapped);
        ch = (1:10:384);
        trimmedData = origdata(ch,:);
        data1 = downsample(trimmedData',5)'; % downsampling; from 2500 -->500
        t = 1000*(1:1000)/500; % 2 sec of data, in miliseconds
        f1 = figure('name',sprintf('raw traces day#%d%s',whichday,datestr(now,30)));
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        set(gca, 'FontName', 'Arial', 'FontSize', 28, 'FontWeight', 'bold')
        hold on
        for i = 1:size(data1,1)
            % pick times 130-132s to plot and space out the traces
            plot(t,data1(i,500*130+1:500*132)'+1000*(i-1),'LineWidth',1.5)
        end
        yticks(-5000:5000:40000);
        yticklabels({'','0','5','10','15','20','25','30','35','40'});
        xlabel('Time (milliseconds)')
        ylabel('Every 10th Channel Along the Shank')
        saveas(f1,fullfile(figpath,f1.Name),'png')
        saveas(f1,fullfile(figpath,f1.Name),'fig')
        
%         %%% figure 2 bipolar data traces
%         bipodata = nan(size(origdata,1),size(origdata,2));
%         for i = 1:size(origdata,1)
%             bipodata(i,:)=neuropixel_REreference(i,origdata);
%         end
%         data2 = bipodata(ch,:);
%         
%         f2 = figure('name',sprintf('bipolar traces day#%d%s',whichday,datestr(now,30)));
%         set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%         set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%         hold on
%         for i = 1:size(data2,1)
%             plot(data2(i,2500*130+1:2500*132)'+300*(i-1))
%         end
%         
%         saveas(f2,fullfile(figpath,f2.Name),'png')
%         saveas(f2,fullfile(figpath,f2.Name),'fig')
        
        %%% figure 3 
        %data2 = bipodata;
        %     numseg = floor(size(data2,2)/(6*2500));
        data2 = trimmedData;
        numseg = 15;
        segmentedData = nan(size(data2,1),6*2500,numseg);
        
        for i = 1:size(data2,1) % looping through channels
            for j = 1:numseg % looping through segments/trials.
                segmentedData(i,:,j) = ...
                    data2(i,(numseg-1)*6*2500+1+2500*130:numseg*6*2500+2500*130);
            end
        end
        
        params.Fs = 2500;
        [S,f] = mtspectrumc(squeeze(segmentedData(1,:,:)),params);
        power = nan(size(segmentedData,1),size(S,1));
        clear S
        for i = 1:size(segmentedData,1)
            [S,f] = mtspectrumc(squeeze(segmentedData(i,:,:)),params);
            S = median(10*log10(S),2);
            power(i,:) = S';
            clear S
        end
        %power = normalize(power,2,'zscore');
        
        %power = normalize(power,2,'norm');
        f3 = figure('name',sprintf('Neuropixel probe power spectrum day #%d%s',whichday,datestr(now,30)));
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
        %clims = [-1,3];
        imagesc(f,(1:size(power,1)),power);
        %imagesc(f,(1:size(power,1)),power,clims);
        
        axis xy;
        shading flat;%no black boxes around pixles
        colorbar;
        set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
        ylim([-.5 40.5]);
        yticks(0:5:40)
        yticklabels(0:500:40*500)
        %     xlim([.5 31.5]);
        %     xticks(0:5:31)
        %     xticklabels(0:250:31*50)
        xlabel('Frequency(Hz)','FontSize', 32, 'FontWeight', 'bold');
        ylabel('Distance from tip of probe (\mum)','FontSize', 32, 'FontWeight', 'bold');
        colormap(parula);
        %title(sprintf('Power spectrum'),'FontSize', 14, 'FontWeight', 'bold')
        
        saveas(f3,fullfile(figpath,f3.Name),'png')
        saveas(f3,fullfile(figpath,f3.Name),'fig')
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%         data from recording in the dPAL chamber                     %%%%%
    %%%          averaging across every 10 channels as a cluster             %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif plotnum == 2
    
    for dy = 1:2
        RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
        origdata = double(RawData.Data.Data(1).mapped);
        
        %ch = (1:10:384);
        ch = 1:384;
        trimmedData = origdata(ch,:);
        %data = downsample(trimmedData',5)'; % downsampling;
        
        % behavioral timestamps
        rat=do_dpal_behavior_one_file_only(data(dy).logfn);
        
        correctT = rat.stage(8).block.trial.correct.times;
        incorrectT = rat.stage(8).block.trial.incorrect.times;
        % for i = 1:length(correctT)
        % correctdata(i,:,:) = data2(:,(round(correctT(i)*500)-500:round(correctT(i)*500)+500));
        % end
        % correctdata = permute(correctdata,[3,2,1]);
        %
        % for i = 1:length(incorrectT)
        % incorrectdata(i,:,:) = data2(:,(round(incorrectT(i)*500)-500:round(incorrectT(i)*500)+500));
        % end
        % incorrectdata = permute(incorrectdata,[3,2,1]); % now sample x chan x trial
        
        segments1 = [round(correctT*2500)-2500;round(correctT*2500)+2500]';
        cleandata1 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments1);
        correctdata = nan(size(cleandata1.trial,2),size(cleandata1.label,1),size(cleandata1.trial{1,1},2));
        for i = 1:size(cleandata1.trial,2)
            correctdata(i,:,:) = cleandata1.trial{1,i};
        end
        correctdata = permute(correctdata,[3,2,1]);% now sample x chan x trial
        day(dy).correctdata = correctdata; %#ok<SAGROW>
        clear correctdata;
        
        segments2 = [round(incorrectT*2500)-2500;round(incorrectT*2500)+2500]';
        cleandata2 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments2);
        incorrectdata = nan(size(cleandata2.trial,2),size(cleandata2.label,1),size(cleandata2.trial{1,1},2));
        for i = 1:size(cleandata2.trial,2)
            incorrectdata(i,:,:) = cleandata2.trial{1,i};
        end
        incorrectdata = permute(incorrectdata,[3,2,1]); % now sample x chan x trial
        day(dy).incorrectdata = incorrectdata; %#ok<SAGROW>
        clear incorrectdata;
        
        params.Fs = 2500;
        % plot power spectrum line graphs
        % figure('name',sprintf( 'Specgram line graph'))
        % hold on
        % for c = 1:size(correctdata,2)
        %     tmpdata = squeeze(correctdata(round(size(correctdata,1)/2):end,c,:));
        % [S,f]=mtspectrumc(tmpdata,params);
        % S = 10*log(S)+40*(c-1);
        % plot(f,S,'LineWidth',2)
        % end
        % xlabel('Frequency (Hz)'); ylabel('dB');
    end
    
    correctdata = cat(3,day(1).correctdata,day(2).correctdata);
    incorrectdata = cat(3,day(1).incorrectdata,day(2).incorrectdata);
    
    
    % % % make specgram heatmap figure
    % for i = 1:38
    % f1 = figure('name',sprintf( 'Specgram heatmap'));
    % subplot(1,3,1)
    % tmpdata = squeeze(correctdata(:,i,:));
    % [S,t,f]=mtspecgramc(tmpdata,movingwin,params);
    % S = 10*log(S);
    % normS = normalize(S,1,'zscore');
    % t= t-1;
    % pcolor(t,f, normS'); colormap(jet); shading flat
    % xlabel('Time(sec)'); ylabel('Frequency (Hz)');
    % axis xy;
    % caxis([-3 3]); colorbar;
    % ylim(params.fpass);
    % set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    %
    % subplot(1,3,2)
    % tmpdata2 = squeeze(incorrectdata(:,i,:));
    % [S2,t2,f2]=mtspecgramc(tmpdata2,movingwin,params);
    % S2 = 10*log(S2);
    % normS2 = normalize(S2,1,'zscore');
    % t2= t2-1;
    % pcolor(t2,f2, normS2'); colormap(jet); shading flat
    % xlabel('Time(sec)'); ylabel('Frequency (Hz)');
    % axis xy;
    % caxis([-3 3]); colorbar;
    % ylim(params.fpass);
    % set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    %
    % subplot(1,3,3)
    % S3 = S-S2;
    % S4 = normalize(S3,1,'zscore');
    % pcolor(t,f, S4'); colormap(jet); shading flat
    % xlabel('Time(sec)'); ylabel('Frequency (Hz)');
    % axis xy;
    % caxis([-3 3]); colorbar;
    % ylim(params.fpass);
    % f1.Position = [1996 494 1798 387];
    % set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    %
    % end
    
    %%%%%%
    %%% averaging across every 10 channels
    
    for i = 1:size(trimmedData,1)
        tmpdata = squeeze(correctdata(:,i,:));
        [data(i).S,t,f]=mtspecgramc(tmpdata,movingwin,params);
        data(i).S = 10*log(data(i).S);
        
        tmpdata2 = squeeze(incorrectdata(:,i,:));
        [data(i).S2,t2,f2]=mtspecgramc(tmpdata2,movingwin,params);
        data(i).S2 = 10*log(data(i).S2);
        
    end
    
    t= t-1;
    for i = 1:floor(size(trimmedData,2)/10)
        f1 = figure('name',sprintf( 'Power specgram heatmap cluster#%d',i));
        subplot(1,3,1)
        for j = 1:10
            S(:,:,j) = data((i-1)*10+j).S; %#ok<SAGROW>
        end
        S = squeeze(mean(S,3));
        normS = normalize(S,1,'zscore');
        pcolor(t,f, normS'); colormap(jet); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-3 3]); colorbar;
        ylim(params.fpass);
        title('Correct trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        
        subplot(1,3,2)
        for j = 1:10
            S2(:,:,j) = data((i-1)*10+j).S2; %#ok<SAGROW>
        end
        S2 = squeeze(mean(S2,3));
        normS2 = normalize(S2,1,'zscore');
        pcolor(t,f, normS2'); colormap(jet); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-3 3]); colorbar;
        ylim(params.fpass);
        title('Incorrect trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        
        subplot(1,3,3)
        S3 = S-S2;
        S4 = normalize(S3,1,'zscore');
        pcolor(t,f, S4'); colormap(jet); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-3 3]); colorbar;
        ylim(params.fpass);
        title('Correct - Incorrect')
        f1.Position = [1996 494 1798 387];
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        
        saveas(f1,fullfile(figpath,f1.Name),'png')
        saveas(f1,fullfile(figpath,f1.Name),'fig')
        close
        
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%         data from recording in the SetShift chamber                 %%%%%
    %%%          averaging across every 10 channels as a cluster             %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif plotnum == 2.5
    
    for reg = 1:2
        
            
    for dy = 1:3
        
        if rt == 1
           if reg == 1 
               figpath = 'E:\NP Manuscript\CSF02_PL';
               RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
           elseif reg == 2
               figpath = 'E:\NP Manuscript\CSF02_ST';
               RawData = load_open_ephys_binary(data(dy).path, 'continuous',4,'mmap');
           end
        
        elseif rt == 2
            if reg == 1
                figpath = 'E:\NP Manuscript\CSF03_PL';
                RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
            elseif reg == 2
                figpath = 'E:\NP Manuscript\CSF03_ST';
                RawData = load_open_ephys_binary(data(dy).path, 'continuous',4,'mmap');
            end
           
           
        end
                
        
        origdata = double(RawData.Data.Data(1).mapped);
        
        %ch = (1:10:384);
        ch = 1:384;
        trimmedData = origdata(ch,:);
        %data = downsample(trimmedData',5)'; % downsampling;
        
        % behavioral timestamps
        setshift=read_set_shift_behavior_one_file_only_imcomplete_session(data(dy).logfn);
        correctInitiationT = [];incorrectInitiationT = [];
        for rl=1:length(setshift.rules)
        for bl=1:length(setshift.rules(rl).blocks)
            for tl = 1:length(setshift.rules(rl).blocks(bl).trials)
            if setshift.rules(rl).blocks(bl).trials(tl).performance == 1
                correctInitiationT = [correctInitiationT,setshift.rules(rl).blocks(bl).trials(tl).response_time];
            elseif setshift.rules(rl).blocks(bl).trials(tl).performance == 0
                incorrectInitiationT = [incorrectInitiationT,setshift.rules(rl).blocks(bl).trials(tl).response_time];
            end
            end
        end
        end
        
        correctT = correctInitiationT;
        incorrectT = incorrectInitiationT;
        
        
        segments1 = [round(correctT*2500)-2500;round(correctT*2500)+2500]';
        cleandata1 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments1);
        correctdata = nan(size(cleandata1.trial,2),size(cleandata1.label,1),size(cleandata1.trial{1,1},2));
        for i = 1:size(cleandata1.trial,2)
            correctdata(i,:,:) = cleandata1.trial{1,i};
        end
        correctdata = permute(correctdata,[3,2,1]);% now sample x chan x trial
        day(dy).correctdata = correctdata; %#ok<SAGROW>
        clear correctdata;
        
        segments2 = [round(incorrectT*2500)-2500;round(incorrectT*2500)+2500]';
        cleandata2 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments2);
        incorrectdata = nan(size(cleandata2.trial,2),size(cleandata2.label,1),size(cleandata2.trial{1,1},2));
        for i = 1:size(cleandata2.trial,2)
            incorrectdata(i,:,:) = cleandata2.trial{1,i};
        end
        incorrectdata = permute(incorrectdata,[3,2,1]); % now sample x chan x trial
        day(dy).incorrectdata = incorrectdata; %#ok<SAGROW>
        clear incorrectdata;
        
        params.Fs = 2500;
        % plot power spectrum line graphs
        % figure('name',sprintf( 'Specgram line graph'))
        % hold on
        % for c = 1:size(correctdata,2)
        %     tmpdata = squeeze(correctdata(round(size(correctdata,1)/2):end,c,:));
        % [S,f]=mtspectrumc(tmpdata,params);
        % S = 10*log(S)+40*(c-1);
        % plot(f,S,'LineWidth',2)
        % end
        % xlabel('Frequency (Hz)'); ylabel('dB');
    end

%     correctdata = day(7).correctdata;
%     incorrectdata = day(7).incorrectdata;
            correctdata = cat(3,day(1).correctdata,day(2).correctdata,day(3).correctdata);
        incorrectdata = cat(3,day(1).incorrectdata,day(2).incorrectdata,day(3).incorrectdata);

    %%%%%%
    %%% averaging across every 10 channels
    
    for i = 1:size(trimmedData,1)
        tmpdata = squeeze(correctdata(:,i,:)); % sample x chan x trial
        [data(i).S,t,f]=mtspecgramc(tmpdata,movingwin,params);
        baselineS = median(10*log(data(i).S((t<0.3),:,:)),1);
        
        data(i).S = 10*log(data(i).S)- baselineS;
        data(i).S = median(data(i).S,3);
        
        tmpdata2 = squeeze(incorrectdata(:,i,:));
        [data(i).S2,t2,f2]=mtspecgramc(tmpdata2,movingwin,params);
        baselineS2 = median(10*log(data(i).S2((t2<0.3),:,:)),1);
        data(i).S2 = 10*log(data(i).S2)-baselineS2;
        data(i).S2 = median(data(i).S2,3);
        
%         tmpdata = squeeze(correctdata(1:2500,i,:)); % sample x chan x trial
%         [data(i).S,t,f]=mtspecgramc(tmpdata,movingwin,params);
%         tmpdata = squeeze(correctdata(2501:5000,i,:)); % sample x chan x trial
%         [S_tmp,t,f]=mtspecgramc(tmpdata,movingwin,params);
%         data(i).S = 10*log([data(i).S;S_tmp]);
%         
%         tmpdata2 = squeeze(incorrectdata(1:2500,i,:));
%         [data(i).S2,t2,f2]=mtspecgramc(tmpdata2,movingwin,params);
%         tmpdata2 = squeeze(incorrectdata(2501:5000,i,:));
%         [S2_tmp,t2,f2]=mtspecgramc(tmpdata2,movingwin,params);
%         data(i).S2 = 10*log([data(i).S2;S2_tmp]);
%         
        
        
    end
%     t = [t-1,t];
    t= t-1;
    for i = 1:floor(size(trimmedData,1)/10)
        f1 = figure('name',sprintf( 'Power specgram heatmap cluster#%d',i));
        subplot(1,3,1)
        for j = 1:10
            S(:,:,j) = data((i-1)*10+j).S; %#ok<SAGROW>
        end
%         S = squeeze(mean(S,3));
        rat(rt).region(reg).cluster(i).S = squeeze(mean(S,3));
%         normS = normalize(S,1,'zscore');
% normS = S;
        normS = rat(rt).region(reg).cluster(i).S;
        pcolor(t,f, normS'); colormap(parula); shading flat
        hold on
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-5 5]); %colorbar;
        ylim(params.fpass);
        title('Correct trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
       
        
        subplot(1,3,2)
        for j = 1:10
            S2(:,:,j) = data((i-1)*10+j).S2; %#ok<SAGROW>
        end
%         S2 = squeeze(mean(S2,3));
       rat(rt).region(reg).cluster(i).S2 = squeeze(mean(S2,3));
%         normS2 = normalize(S2,1,'zscore');
% normS2 = S2;
normS2 = rat(rt).region(reg).cluster(i).S2;
        pcolor(t,f, normS2'); colormap(parula); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-5 5]); %colorbar;
        ylim(params.fpass);
        title('Incorrect trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        %colorbar.Ticks = [-5,-2.5,0,2.5,5];
        
        subplot(1,3,3)
        S3 = rat(rt).region(reg).cluster(i).S-rat(rt).region(reg).cluster(i).S2;
%         S4 = normalize(S3,1,'zscore');
S4 = S3;
        pcolor(t,f, S4'); colormap(parula); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-5 5]); %colorbar;
        ylim(params.fpass);
        title('Correct - Incorrect')
        f1.Position = [1996 494 1798 387];
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        %colorbar.Ticks = [-5,-2.5,0,2.5,5];
        
        saveas(f1,fullfile(figpath,f1.Name),'png')
        saveas(f1,fullfile(figpath,f1.Name),'fig')
        close
        
    end
    
    end
    
    fname2save = sprintf('NPrats_%s.mat',datestr(now,30));
save(fullfile(datapath,fname2save),'rat','-v7.3')
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%         data from recording in the dPAL chamber                     %%%%%
    %%%                   every 10th channels                                %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif plotnum == 3
    
    for dy = 1:2
        RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
        origdata = double(RawData.Data.Data(1).mapped);
        
        ch = (1:10:384);
        trimmedData = origdata(ch,:);
        %data = downsample(trimmedData',5)'; % downsampling;
        
        % behavioral timestamps
        rat=do_dpal_behavior_one_file_only(data(dy).logfn);
        
        correctT = rat.stage(8).block.trial.correct.times;
        incorrectT = rat.stage(8).block.trial.incorrect.times;
        % for i = 1:length(correctT)
        % correctdata(i,:,:) = data2(:,(round(correctT(i)*500)-500:round(correctT(i)*500)+500));
        % end
        % correctdata = permute(correctdata,[3,2,1]);
        %
        % for i = 1:length(incorrectT)
        % incorrectdata(i,:,:) = data2(:,(round(incorrectT(i)*500)-500:round(incorrectT(i)*500)+500));
        % end
        % incorrectdata = permute(incorrectdata,[3,2,1]); % now sample x chan x trial
        
        segments1 = [round(correctT*2500)-2500;round(correctT*2500)+2500]';
        cleandata1 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments1);
        correctdata = nan(size(cleandata1.trial,2),size(cleandata1.label,1),size(cleandata1.trial{1,1},2));
        for i = 1:size(cleandata1.trial,2)
            correctdata(i,:,:) = cleandata1.trial{1,i};
        end
        correctdata = permute(correctdata,[3,2,1]);% now sample x chan x trial
        day(dy).correctdata = correctdata; %#ok<SAGROW>
        clear correctdata;
        
        segments2 = [round(incorrectT*2500)-2500;round(incorrectT*2500)+2500]';
        cleandata2 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments2);
        incorrectdata = nan(size(cleandata2.trial,2),size(cleandata2.label,1),size(cleandata2.trial{1,1},2));
        for i = 1:size(cleandata2.trial,2)
            incorrectdata(i,:,:) = cleandata2.trial{1,i};
        end
        incorrectdata = permute(incorrectdata,[3,2,1]); % now sample x chan x trial
        day(dy).incorrectdata = incorrectdata; %#ok<SAGROW>
        clear incorrectdata;
        
        params.Fs = 2500;
        % plot power spectrum line graphs
        % figure('name',sprintf( 'Specgram line graph'))
        % hold on
        % for c = 1:size(correctdata,2)
        %     tmpdata = squeeze(correctdata(round(size(correctdata,1)/2):end,c,:));
        % [S,f]=mtspectrumc(tmpdata,params);
        % S = 10*log(S)+40*(c-1);
        % plot(f,S,'LineWidth',2)
        % end
        % xlabel('Frequency (Hz)'); ylabel('dB');
    end
    
    correctdata = cat(3,day(1).correctdata,day(2).correctdata);
    incorrectdata = cat(3,day(1).incorrectdata,day(2).incorrectdata);
    
    
    % % make specgram heatmap figure
    
    for i = 1:38
        f1 = figure('name',sprintf( 'Specgram heatmap channel#%d',ch(i)));
        subplot(1,3,1)
        tmpdata = squeeze(correctdata(:,i,:));
        [S,t,f]=mtspecgramc(tmpdata,movingwin,params);
        S = 10*log(S);
        normS = normalize(S,1,'zscore');
        t= t-1;
        pcolor(t,f, normS'); colormap(jet); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-3 3]); colorbar;
        ylim(params.fpass);
        title('Correct trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        
        subplot(1,3,2)
        tmpdata2 = squeeze(incorrectdata(:,i,:));
        [S2,t2,f2]=mtspecgramc(tmpdata2,movingwin,params);
        S2 = 10*log(S2);
        normS2 = normalize(S2,1,'zscore');
        t2= t2-1;
        pcolor(t2,f2, normS2'); colormap(jet); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-3 3]); colorbar;
        ylim(params.fpass);
        title('Incorrect trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        
        subplot(1,3,3)
        S3 = S-S2;
        S4 = normalize(S3,1,'zscore');
        pcolor(t,f, S4'); colormap(jet); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-3 3]); colorbar;
        ylim(params.fpass);
        f1.Position = [1996 494 1798 387];
        title('Correct - Incorrect')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        
        saveas(f1,fullfile(figpath,f1.Name),'png')
        saveas(f1,fullfile(figpath,f1.Name),'fig')
        close
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%         data from recording in the dPAL chamber                     %%%%%
    %%%                   spike analysis with behavior                       %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif plotnum == 4
    
    
    % behavioral timestamps
    rat=do_dpal_behavior_one_file_only(data(dy).logfn);
    
    correctT = rat.stage(8).block.trial.correct.times;
    incorrectT = rat.stage(8).block.trial.incorrect.times;
    
    segments1 = [correctT*1000-1000;correctT*1000+1000]';
    segments2 = [incorrectT*1000-1000;incorrectT*1000+1000]';
    
    for u = 1:18
        st = trial.units(u).ts;
        for sg = 1:size(segments1,2)
            timestamps = st(st> segments1(sg,1)&st< segments1(sg,2));
            h = histogram(timestamps,50);
            
        end
    end
    
end
end