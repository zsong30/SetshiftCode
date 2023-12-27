function rat = plot_NP_LFP_setshiftbehav_correlation_csf04
% function rat = plot_NP_LFP_setshiftbehav_correlation_NPmanu is to produce LFP power 
% and behavior correlation figures.
% It uses 3 sessions of recording from each rat (CSF02 and CSF03).
%    It saves figures in folders Z:\projmon\ericsprojects\NP_manuscript\Analysis\CSF02_PL, CSF02_ST, CSF03_PL, CSF03_ST.
%    Figures are named in the format of 'Power specgram heatmap cluster#%d'; cluster is 10 adjacent channels combined.  Cluster 1 is channel 1-10, most ventral.
%    Figures show the power changes over 2 seconds, centered on response, in the frequency range 0-30Hz, during correct and incorrect trials; and their difference.

% Author: Eric Song,
% Date: Mar.17. 2023

ratname = 'CSF04';
% datadate = '10122022';
% datadate = '10132022';
 datadate = '10142022';
regionname = 'ST';

rat = struct;
params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [0 100];
params.trialave = 0;
movingwin = [0.5 0.01];
datapath = 'Z:\projmon\ericsprojects\Setshift\DATA\representative analyses\CSF04';

for rt = 2:2

    if rt == 1   % rt == 1 corresponds to CSF04, PL region
        data(1).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\Record Node 101\experiment1\recording1\structure.oebin";
        data(1).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\CSM01_2021_10_12__14_20_00";

        data(2).path = ...
            'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\Record Node 101\experiment1\recording1\structure.oebin';
        data(2).logfn = "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\CSF04_2022_10_13__14_48_01";
        
        data(3).path = "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin";
        data(3).logfn = "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\CSF02_2021_09_24__15_17_02";

    elseif rt == 2 % rt == 2 corresponds to CSF04, ST region

        data(1).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\Record Node 101\experiment1\recording1\structure.oebin";
        data(1).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\CSF04_2022_10_12__13_00_01";

        data(2).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\Record Node 101\experiment1\recording1\structure.oebin";
        data(2).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\CSF04_2022_10_13__14_48_01";

        data(3).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\Record Node 101\experiment1\recording1\structure.oebin";
        data(3).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\BEHAVDATA\10142022\CSF04_2022_10_14__15_11_01";

    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%         data from recording in the SetShift chamber                 %%%%%
    %%%          averaging across every 10 channels as a cluster             %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for reg = 2:2


        for dy = 3:3

            if rt == 1
                if reg == 1
                    figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\lfp-behavior-correlation\CSF04\CSF04_PL_10132022';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
                elseif reg == 2
                    figpath = 'Z:\projmon\ericsprojects\NP_manuscript\Analysis\CSF02_ST';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',4,'mmap');
                end

        elseif  rt == 2
                if reg == 1
                    figpath ='Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\lfp-behavior-correlation\plot_NP_LFP_setshiftbehav_correlation\CSF04\CSF04_ST_10132022'; %day 2
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
                elseif reg == 2
                    % figpath ='Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\lfp-behavior-correlation\CSF04\CSF04_ST_10122022'; %day 1
%                     figpath ='Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\lfp-behavior-correlation\plot_NP_LFP_setshiftbehav_correlation\CSF04\CSF04_ST_10132022'; %day 2
                    figpath ='Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\lfp-behavior-correlation\plot_NP_LFP_setshiftbehav_correlation\CSF04\CSF04_ST_10142022'; %day 3
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
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
            day(dy).correctdata = correctdata; 
            clear correctdata;

            segments2 = [round(incorrectT*2500)-2500;round(incorrectT*2500)+2500]';
            cleandata2 = get_clean_NP_data_automatic_ES(trimmedData,RawData.Timestamps,segments2);
            incorrectdata = nan(size(cleandata2.trial,2),size(cleandata2.label,1),size(cleandata2.trial{1,1},2));
            for i = 1:size(cleandata2.trial,2)
                incorrectdata(i,:,:) = cleandata2.trial{1,i};
            end
            incorrectdata = permute(incorrectdata,[3,2,1]); % now sample x chan x trial
            day(dy).incorrectdata = incorrectdata; 
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

            % correctdata = day(1).correctdata; %day 1 
            % incorrectdata = day(1).incorrectdata; %day 1
% 
% 
%             correctdata = day(2).correctdata; %day 2
%             incorrectdata = day(2).incorrectdata; %day 2

            correctdata = day(3).correctdata; %day 3
            incorrectdata = day(3).incorrectdata; %day 3

%         correctdata = cat(3,day(1).correctdata,day(2).correctdata,day(3).correctdata);
%         incorrectdata = cat(3,day(1).incorrectdata,day(2).incorrectdata,day(3).incorrectdata);

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
            f1 = figure('name',sprintf('%s-%s-%s-Power specgram heatmap cluster#%d',ratname,datadate,regionname,i));

            subplot(1,3,1)
            for j = 1:10
                S(:,:,j) = data((i-1)*10+j).S; 
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
            clim([-5 5]); %colorbar;
            ylim(params.fpass);
            title('Correct trials')
            set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')


            subplot(1,3,2)
            for j = 1:10
                S2(:,:,j) = data((i-1)*10+j).S2; 
            end
            %         S2 = squeeze(mean(S2,3));
            rat(rt).region(reg).cluster(i).S2 = squeeze(mean(S2,3));
            %         normS2 = normalize(S2,1,'zscore');
            % normS2 = S2;
            normS2 = rat(rt).region(reg).cluster(i).S2;
            pcolor(t,f, normS2'); colormap(parula); shading flat
            xlabel('Time(sec)'); ylabel('Frequency (Hz)');
            axis xy;
            clim([-5 5]); %colorbar;
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
            clim([-5 5]); %colorbar;
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

    fname2save = sprintf('CSF02s_%s.mat',datestr(now,30)); %#ok<*TNOW1,*DATST>
    save(fullfile(datapath,fname2save),'rat','-v7.3')
end
