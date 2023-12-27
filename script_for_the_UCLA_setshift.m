function rat = script_for_the_UCLA_setshift
% function script_for_the_UCLA_setshift is to produce figures for
% the NP manuscript. Example: script_for_the_NP_manuscript(2)


% Author: Eric Song,
% Date: Feb.01. 2023
rat = struct;
params.Fs = 30000;
params.tapers = [3 5];
params.fpass = [0 30];
params.trialave = 0;
movingwin = [0.5 .01];
datapath = 'E:\NP Manuscript';
% figpath = 'E:\NP Manuscript';

for rt = 1:2
    
    if rt == 1 
% rat #1
data(1).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-25_10-43-03_SS\experiment1\recording1\structure.oebin';
data(1).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-25_10-43-03_SS\CSF01_2021_02_25__10_43_02.csv';

data(2).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-26_14-46-57_SS\experiment1\recording1\structure.oebin';
data(2).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-02-26_14-46-57_SS\CSF01_2021_02_26__14_47_02.csv';

data(3).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-01_14-50-32_SS\experiment1\recording2\structure.oebin';
data(3).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-01_14-50-32_SS\CSF01_2021_03_01__14_51_02.csv';

data(4).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-16_13-44-00_SS\experiment1\recording2\structure.oebin';
data(4).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSF01\CSF01_2021-03-16_13-44-00_SS\CSF01_2021_03_16__13_44_02.csv';



    elseif rt == 2
data(1).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-03-24_14-33-37_SS\experiment1\recording1\structure.oebin';
data(1).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-03-24_14-33-37_SS\CSM01_2021_03_24__14_34_02.csv';


data(2).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-26_11-35-06\experiment1\recording1\structure.oebin';
data(2).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-26_11-35-06\CSM01_2021_04_26__11_35_02.csv';

data(3).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-29_11-32-28_SS\Record Node 101\experiment1\recording1\structure.oebin';
data(3).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-29_11-32-28_SS\CSM01_2021_04_29__11_32_02.csv';

data(4).path = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-30_11-09-47_SS\Record Node 101\experiment1\recording1\structure.oebin';
data(4).logfn = ...
    'E:\SetShift\EPHYSDATA\UCLA\CSM01\CSM01_2021-04-30_11-09-47_SS\CSM01_2021_04_30__11_09_02.csv';



    end

for reg = 1:2
    params.Fs = 30000;

    for dy = 1:4
        RawData = load_open_ephys_binary(data(dy).path, 'continuous',1,'mmap');
        origdata = double(RawData.Data.Data(1).mapped);
        
        %ch = (1:10:384);
%         ch = 1:32;
%         ch = 33:64;

V2Dorder_PL = ...
    [9 8 10 7 11 6 12 5 25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17 1 16 2 15 3 14 4 13];
V2Dorder_ST = [57 56 58 55 59 54 60 53 41 40 42 39 43 38 44 37 45 36 46 35 47 34 48 33 49 64 50 63 51 62 52 61];

if rt == 1
    if reg == 1
        figpath = 'E:\NP Manuscript\CSF01_PL';
        trimmedData = origdata(V2Dorder_PL,:);
    elseif reg == 2
        figpath = 'E:\NP Manuscript\CSF01_ST';
        trimmedData = origdata(V2Dorder_ST,:);
    end
elseif rt == 2
        if reg == 1
        figpath = 'E:\NP Manuscript\CSM01_PL';
        trimmedData = origdata(V2Dorder_PL,:);
    elseif reg == 2
        figpath = 'E:\NP Manuscript\CSM01_ST';
        trimmedData = origdata(V2Dorder_ST,:);
        end
      
    
end
   
   
        
        
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
        
        
        segments1 = [round(correctT*params.Fs)-params.Fs;round(correctT*params.Fs)+params.Fs]';
        cleandata1 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments1);
        correctdata = nan(size(cleandata1.trial,2),size(cleandata1.label,1),size(cleandata1.trial{1,1},2));
        for i = 1:size(cleandata1.trial,2)
            correctdata(i,:,:) = cleandata1.trial{1,i};
        end
        correctdata = permute(correctdata,[3,2,1]);% now sample x chan x trial
        day(dy).correctdata = correctdata;
        clear correctdata;
        
        segments2 = [round(incorrectT*params.Fs)-params.Fs;round(incorrectT*params.Fs)+params.Fs]';
        cleandata2 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments2);
        incorrectdata = nan(size(cleandata2.trial,2),size(cleandata2.label,1),size(cleandata2.trial{1,1},2));
        for i = 1:size(cleandata2.trial,2)
            incorrectdata(i,:,:) = cleandata2.trial{1,i};
        end
        incorrectdata = permute(incorrectdata,[3,2,1]); % now sample x chan x trial
        day(dy).incorrectdata = incorrectdata; 
        clear incorrectdata;
        
        
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

%     correctdata = day(1).correctdata;
%     incorrectdata = day(1).incorrectdata;
correctdata = cat(3,day(1).correctdata,day(2).correctdata,day(3).correctdata,day(4).correctdata);
incorrectdata = cat(3,day(1).incorrectdata,day(2).incorrectdata,day(3).incorrectdata,day(4).incorrectdata);

    %%%%%%
    %%% averaging across every 10 channels
    
    for i = 1:32
        tmpdata = squeeze(correctdata(:,i,:)); % sample x chan x trial
        tmpdata = downsample(tmpdata,300/25);
        params.Fs = 2500;
        [data(i).S,t,f]=mtspecgramc(tmpdata,movingwin,params);
        baselineS = median(10*log(data(i).S((t<0.3),:,:)),1);
        data(i).S = 10*log(data(i).S)- baselineS;
        data(i).S = median(data(i).S,3);
        
        tmpdata2 = squeeze(incorrectdata(:,i,:));
                tmpdata2 = downsample(tmpdata2,300/25);
                [data(i).S2,t2,f2]=mtspecgramc(tmpdata2,movingwin,params);
        baselineS2 = median(10*log(data(i).S2((t2<0.3),:,:)),1);
        data(i).S2 = 10*log(data(i).S2)-baselineS2;
        data(i).S2 = median(data(i).S2,3);
        

        
    end

    t= t-1;
    for i = 1:32
        f1 = figure('name',sprintf( 'Power specgram heatmap cluster#%d',i));
        subplot(1,3,1)

%         S = data(i).S;
rat(rt).region(reg).cluster(i).S = data(i).S;
normS = rat(rt).region(reg).cluster(i).S;
%         normS = S;
        pcolor(t,f, normS'); colormap(parula); shading flat
        hold on
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-5 5]); 
        % colorbar
        ylim(params.fpass);
        title('Correct trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
       
        
        subplot(1,3,2)
% S2 = data(i).S2;
%         
% %         normS2 = normalize(S2,1,'zscore');
% normS2 = S2;

rat(rt).region(reg).cluster(i).S2 = data(i).S2;
normS2 = rat(rt).region(reg).cluster(i).S2;



        pcolor(t,f, normS2'); colormap(parula); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-5 5]); 
        % colorbar;
        ylim(params.fpass);
        title('Incorrect trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        colorbar.Ticks = [-5,-2.5,0,2.5,5];
        
        subplot(1,3,3)
        S3 = rat(rt).region(reg).cluster(i).S-rat(rt).region(reg).cluster(i).S2;
%         S4 = normalize(S3,1,'zscore');
S4 = S3;
        pcolor(t,f, S4'); colormap(parula); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        caxis([-5 5]); 
        % colorbar;
        ylim(params.fpass);
        title('Correct - Incorrect')
        f1.Position = [1996 494 1798 387];
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        colorbar.Ticks = [-5,-2.5,0,2.5,5];
        
        saveas(f1,fullfile(figpath,f1.Name),'png')
        saveas(f1,fullfile(figpath,f1.Name),'fig')
        close
        
    end
    
end
 
    fname2save = sprintf('UCLArats_%s.mat',datestr(now,30));
save(fullfile(datapath,fname2save),'rat','-v7.3')


end
