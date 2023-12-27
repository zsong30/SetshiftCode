function plot_setshift_NP_spike_triggered_LFP_power_spectrum_csf02


% Author: Eric Song & Jack Major
tic

ratname = 'CSF02';
regionname = 'PL';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09202021';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-20_10-16-15\CSF02SpikesFrom1stProbe_09202021_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-20_10-16-15\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '09202021';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09212021';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-21_11-19-25\CSF02SpikesFrom1stProbe_09212021_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-21_11-19-25\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '09212021';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09222021_isolated';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\CSF02SpikesFrom1stProbe_09222021_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\structure.oebin';
%datadate = '09222021';

figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09232021_expanded';
datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\CSF02SpikesFrom1stProbe_09232021_trimmed';
datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
datadate = '09232021';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09242021_isolated';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\CSF02SpikesFrom1stProbe_09242021_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '09242021';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09272021';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50\CSF02SpikesFrom1stProbe_09272021_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '09272021';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09292021';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\CSF02SpikesFrom1stProbe_09292021_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '09292021';

load(datafile,'trial')

Fs = 2500;

% time2include = 60*40; % in seconds
% unit2plot = [111,124];
unit2plot = (1:10);
% unit2plot = [34, 42, 65, 76, 77, 97];
% unit2plot = (1:length(trial.units));
% unit2plot = 128; %CSF02 09/23
% unit2plot = 135; %CSF02 09/24
% unit2plot = 87; %CSF02 09/27
ISIsLimits = [0,inf];
plotnum = 2;
time2include = inf;
ISIsUpLimit = ISIsLimits(2);
ISIsLowerLimit = ISIsLimits(1);


fig = figure('name',sprintf('%s-%s-%s-spike_triggered_LFP_power_spectrum',ratname,datadate,regionname));
tmp_lfp_avg = [];
for u = 1:length(unit2plot)
        st = round(trial.units(unit2plot(u)).ts*Fs/1000); % spike times in samples
        st = st(st<st(1)+time2include*2500); % choose a range for analysis
        trial.units(unit2plot(u)).ISIs = trial.units(unit2plot(u)).ISIs(1:length(st)-1);
        ch = trial.units(unit2plot(u)).channel;
        

        % read in the data for all channels from recording day1
        RawData=load_open_ephys_binary(datapath, 'continuous',2,'mmap');
        % choose a random channel with a single unit activity for lfp
        %lfp = double(RawData.Data.Data.mapped(ch,:));
        
        if plotnum == 1
            plotname = 'rerefd';
            if ch == 1
                lfp = double(RawData.Data.Data.mapped(ch,:))-...
                    double(mean(RawData.Data.Data.mapped((ch+1:1:ch+5),:),1));
            elseif ch == 2
                lfp = double(RawData.Data.Data.mapped(ch,:))-...
                    double(mean(RawData.Data.Data.mapped([ch-1,(ch+1:1:ch+4)],:),1));
                
            elseif ch == 383
                lfp = double(RawData.Data.Data.mapped(ch,:))-...
                    double(mean(RawData.Data.Data.mapped([(ch-4:1:ch-1),ch+1],:),1));
            elseif ch == 384
                lfp = double(RawData.Data.Data.mapped(ch,:))-...
                    double(mean(RawData.Data.Data.mapped((ch-5:1:ch-1),:),1));
                
            else
                if mod(ch,2)== 0 % check if ch is even
                    lfp = double(RawData.Data.Data.mapped(ch,:)) - double(mean(RawData.Data.Data.mapped([(ch-3:1:ch-1),ch+1,ch+2],:),1));
                    
                else
                    lfp = double(RawData.Data.Data.mapped(ch,:)) - double(mean(RawData.Data.Data.mapped([ch-2,ch-1,(ch+1:1:ch+3)],:),1));
                    
                end
            end
            
        elseif plotnum == 2
            plotname = 'raw';
            lfp = double(RawData.Data.Data.mapped(ch,:));
            
        end

        lfp = lfp*0.195;

        subplot(ceil(sqrt(length(unit2plot))),ceil(sqrt(length(unit2plot))),u)

        if sum(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit) > 0
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      

            tmp_st = st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit);

            % tmp_lfp = nan(length(tmp_st)-5,51);  % 50 means 20 miliseconds
            tmp_lfp = nan(length(tmp_st)-5,2501);  % 2500 means 1 s
            for k = 1:length(tmp_st)-5
            % for k = 1 % 1 raw trace
                if tmp_st(k)-1250 >= 0 && tmp_st(k)+1250 <= tmp_st(end) %Added by Jack Major 6/22/23
                    % tmp_lfp(k,:) = lfp(tmp_st(k)-25:tmp_st(k)+25)- median(lfp(tmp_st(k)-25:tmp_st(k)-20));
                    tmp_lfp(k,:) = lfp(tmp_st(k)-1250:tmp_st(k)+1250)- median(lfp(tmp_st(k)-1250:tmp_st(k)-1000));
                else
                end
            end
            tmp_lfp_avg(u,:) = mean(tmp_lfp,1,'omitnan');
            % x = linspace(-Fs/2,Fs/2,length(tmp_lfp_avg));
            % fc = 100;
            % [b,a] = butter(6,(fc/Fs/2),'low');
            % y = filter(b,a,tmp_lfp_avg);
            % plot(x,20*log10(abs(fft(y))));
            % xlim([0 100])
            % xlabel('Frequency (Hz)');
            % ylabel('Power (dB)');
            % title(sprintf('Power Spectrum Unit %s',u));
        else
        end
        
end
tmp_lfp_avg;
saveas(fig,fullfile(figpath,fig.Name),'png')
saveas(fig,fullfile(figpath,fig.Name),'fig')

toc


    
