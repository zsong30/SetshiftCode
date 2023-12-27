function plot_NP_spike_triggered_LFP_phase_locked_traces
% function plot_NP_rawtraces_power_NPmanu to plot rawtraces and power figures for the NP manuscript. 
%    It uses 3 representative days (one from dPAL, one from setshift, and one from reuse (setshift)).
%    The figures are named in the formates of "raw traces day#1_20230316T195128" and "Neuropixel probe power spectrum day #1_20230316T195139".
%    Figures are saved in folder Z:\projmon\ericsprojects\NP_manuscript\FiguresForPaper.

% Author: Eric Song,
% Date: Feb.21. 2023

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

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09222021';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\CSF02SpikesFrom1stProbe_09222021_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\structure.oebin';
%datadate = '09222021';

% figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09232021_plus200';
figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\jack analyses\CSF02_PL_09232021_phase_locked_traces\phase locked units';
datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\CSF02SpikesFrom1stProbe_09232021_trimmed';
datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
datadate = '09232021';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09242021';
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

Fs = 2500; % sampling rate (Hz)


% time2include = 60*40; % in seconds
% unit2plot = [111,124]; % sets index for units to plot from spike data file
% unit2plot = [4,6:14,16];
% unit2plot = 74; %phase locked
unit2plot = 73; % phase locked
% unit2plot = 4; % non phase locked
% unit2plot = 10; % non phase locked
% unit2plot = (1:length(trial.units));
% unit2plot = 128; %CSF02 09/23
% unit2plot = 135; %CSF02 09/24
% unit2plot = 87; %CSF02 09/27

ISIsLimits = [0,inf]; % sets inter-spike interval limits
plotnum = 2; % determines if channels will get rereferenced or not
time2include = inf;
ISIsUpLimit = ISIsLimits(2);
ISIsLowerLimit = ISIsLimits(1);

     % fig1 = figure('name',sprintf('%s-%s-%s-80to90deg_phase_locked_traces_spike_triggered_LFP_3_traces_200_ms_window_unit_%d',ratname,datadate,regionname,unit2plot));
     % fig1 = figure('name',sprintf('%s-%s-%s-non_phase_locked_traces_spike_triggered_LFP_3_traces_200_ms_window_unit_%d',ratname,datadate,regionname,unit2plot));
     fig1 = figure('name',sprintf('%s-%s-%s-phase_locked_traces_spike_triggered_LFP_3_traces_200_ms_window_unit_%d',ratname,datadate,regionname,unit2plot));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
    allunitlfp = [];
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
        %     if plotnum == 1
        %         plot(phase(st(1):st(20)))
        %         hold on
        %         scatter(st(1:20)-st(1)+1,phase(st(1:20)),'r')
        %
        %     elseif plotnum == 2
        %         subplot(ceil(sqrt(numUnits)),ceil(sqrt(numUnits)),u)
        %         plot(lfp_filt(st(1):st(20)))
        %         hold on
        %         scatter(st(1:20)-st(1)+1,lfp_filt(st(1:20)),'r')
        if sum(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit) > 0
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      

            tmp_st = st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit);

            % tmp_lfp = nan(length(tmp_st)-5,51);  % 50 means 20 miliseconds
            % tmp_lfp = nan(length(tmp_st)-5,2501);  % 2500 means 1 s
            % tmp_lfp = nan(length(tmp_st)-5,5001);  % 5000 means 2 s
            tmp_lfp = nan(length(tmp_st)-5,501);  % 500 means 200 ms
            for k = 1:length(tmp_st)-5
            % for k = 1 % 1 raw trace
                % if tmp_st(k)-1250 >= 0 && tmp_st(k)+1250 <= tmp_st(end) % 500 ms before and after
                % if tmp_st(k)- 2500 >= 0 && tmp_st(k)+2500 <= tmp_st(end) % 1 s before and after
                if tmp_st(k)- 250 >= 0 && tmp_st(k)+250 <= tmp_st(end) % 100 ms before and after
                    % tmp_lfp(k,:) = lfp(tmp_st(k)-25:tmp_st(k)+25)- median(lfp(tmp_st(k)-25:tmp_st(k)-20));
                    % tmp_lfp(k,:) = lfp(tmp_st(k)-1250:tmp_st(k)+1250)- median(lfp(tmp_st(k)-1250:tmp_st(k)-1000));
                    % tmp_lfp(k,:) = lfp(tmp_st(k)-2500:tmp_st(k)+2500)- median(lfp(tmp_st(k)-2500:tmp_st(k)-2495));
                    tmp_lfp(k,:) = lfp(tmp_st(k)-250:tmp_st(k)+250)- median(lfp(tmp_st(k)-250:tmp_st(k)-245));
                else
                end
            end
    
            % bandpass filter
        band = [30 50];
        
        % phase_lock_spikes = zeros(size(tmp_lfp,1),5001); %2 sec window
        phase_lock_spikes = zeros(size(tmp_lfp,1),501); % 200 ms window
       
        [b, a] = butter(2, band/(Fs/2)); % 2nd order butterworth filter
        %lfp = bandstop(lfp,[59.8,61.2],Fs);
        
        for j = 1:size(tmp_lfp,1)
            lfp_filt(j,:) = filtfilt(b, a, tmp_lfp(j,:)); % bandpassed data
            data_complex(j,:) = hilbert(lfp_filt(j,:)); % perform a hilbert transform on the data to get the complex component.
            phase(j,:) = angle(data_complex(j,:)); % phase in radians! Use rad2deg() if you prefer things in degrees.
            phase(j,:) = rad2deg(phase(j,:)); %convert phase from radians to degrees
            
            % if phase(j,250) >= -75 && phase(j,250) <= -65 % range for average phase locking for unit 74
            % if phase(j,250) >= -160 && phase(j,250) <= -150 % range for average phase locking for unit 4
            % if phase(j,250) >= 80 && phase(j,250) <= 90 % test range
            if phase(j,250) >= 172 && phase(j,250) <= 180 % range for average phase locking for unit 73
             % if phase(j,250) >= -104 && phase(j,250) <= -94 % range for average phase locking for unit 10
                phase_lock_spikes(j,:) = tmp_lfp(j,:); % for phase locked units
                % phase_lock_spikes(j,:) = nan(1,501); % for non phase locked units
            elseif phase(j,250) >= -178 && phase(j,250) <= -180 % for unit 73
                phase_lock_spikes(j,:) = tmp_lfp(j,:);
            else
                phase_lock_spikes(j,:) = nan(1,501); % for phase locked units
                % phase_lock_spikes(j,:) = tmp_lfp(j,:); % for non phase locked units
            
             end
        end
        phase_lock_spikes_values = phase_lock_spikes(~isnan(phase_lock_spikes(:,1)),:); % looks at first entry of each row of phase_lock_spikes: if NaN, rejects that row
        for v = 1:size(phase_lock_spikes_values,1)
            for w = 1:size(phase_lock_spikes_values,2)
                if phase_lock_spikes_values(v,w) >= 1500 || phase_lock_spikes_values(v,w) <= -1500
                    phase_lock_spikes_values(v,:) = nan(1,501);
                else
                end
            end
        end
        phase_lock_spikes_chosen = phase_lock_spikes_values(~isnan(phase_lock_spikes_values(:,1)),:);


            % plot((-20:20/25:20),mean(tmp_lfp,1));
            % plot((-1000:1000/1250:1000),mean(tmp_lfp,1,'omitnan'));
            t = linspace(-100,100,501);
            first = round(size(phase_lock_spikes_chosen,1)/4);
            second = round(size(phase_lock_spikes_chosen,1)/2);
            third = round(size(phase_lock_spikes_chosen,1)*0.75);
            % lfp_mean = mean(tmp_lfp,1,'omitnan');
            for i = [first second third]
          % for i = 1:length(phase_lock_spikes')
                % plot(t,tmp_lfp(i,:));
                % plot(t,phase_lock_spikes(i,:),'Color',[0.5 0.5 0.5]);
                plot(t,phase_lock_spikes_chosen(i,:))
                hold on
            end
            hold off
            xlabel('ms')
            ylabel('uV')
            
            saveas(fig1,fullfile(figpath,fig1.Name),'png')
            saveas(fig1,fullfile(figpath,fig1.Name),'fig')
            
            fig1 = figure('name',sprintf('%s-%s-%s-spike_triggered_LFP_phase_locked_traces_avg_200_ms_window_unit_%d',ratname,datadate,regionname,unit2plot));
            % fig2 = figure('name',sprintf('%s-%s-%s-80to90deg_spike_triggered_LFP_phase_locked_traces_avg_200_ms_window_unit_%d',ratname,datadate,regionname,unit2plot));
            % fig2 = figure('name',sprintf('%s-%s-%s-spike_triggered_LFP_non_phase_locked_traces_avg_200_ms_window_unit_%d',ratname,datadate,regionname,unit2plot));

            % avg = median(phase_lock_spikes_chosen,2,'omitnan');
            plot(t,median(phase_lock_spikes_chosen,1,'omitnan'),'LineWidth',3,'Color','r');
            xlabel('ms')
            ylabel('uV')
            % ylim([-85 40]) % Added by Eric H, 6/16/2023
            % allunitlfp = [allunitlfp; tmp_lfp]; %#ok<AGROW>

            saveas(fig2,fullfile(figpath,fig2.Name),'png')
            saveas(fig2,fullfile(figpath,fig2.Name),'fig')
     

        else
        end
        % lfp_11_units(u,:) = mean(tmp_lfp,1,'omitnan'); 
    end
     
    % saveas(fig,fullfile(figpath,fig.Name),'png')
    % saveas(fig,fullfile(figpath,fig.Name),'fig')

%% 
fig3 = figure('name',sprintf('%s-%s-%s-phase_locked_units_spike_triggered_LFP_200_ms_window_power_spectrum_unit_%d',ratname,datadate,regionname,unit2plot));
params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [20 58];
params.trialave = 0;
    params.Fs = 2500;

% figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\jack analyses\CSF02_PL_09232021_power_spectrum\non phase locked units';
figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\jack analyses\CSF02_PL_09232021_power_spectrum\phase locked units';

    [S,f] = mtspectrumc(tmp_lfp(3,:)',params);
        % f is frequency
    power = nan(200,size(S,1));
        %making an empty, appropriately sized array for each power
        %calculation
        %power is an array, each cell represents a spatial unit?
    clear S

    % for i = 3:size(tmp_lfp,1) % i: channels
    for i = 3:202 % i: channels
        [S,f] = mtspectrumc(tmp_lfp(i,:)',params);
        S = 10*log10(S); % S = frq x trial;

        power(i-2,:) = S; % power = channel x frq x trial;
        clear S
    end

    % f2 = figure('name',sprintf('Neuropixel probe power spectrum day#%d_%s',whichday,datestr(now,30)));
    % figure
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')

    % my plotting of power as a line graph
    plot(f,power')
    hold on
    plot(f,median(power,1),'r','LineWidth',2)

    xlabel('Frequency(Hz)','FontSize', 32, 'FontWeight', 'bold');
    ylabel('Power','FontSize', 32, 'FontWeight', 'bold');


    %axis xy;
    %shading flat;%no black boxes around pixles
    %colorbar;
    %set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
    %ylim([-.5 40.5]);
    %ylim([-.5 10]);
    %yticks(0:5:40)
    %yticks(0:5:10)
    %yticklabels(0:500:40*500)
    %     xlim([.5 31.5]);
    %     xticks(0:5:31)
    %     xticklabels(0:250:31*50)

    %colormap(parula);
    title(sprintf('Power spectrum'),'FontSize', 14, 'FontWeight', 'bold')

    saveas(fig3,fullfile(figpath,fig3.Name),'png')
    saveas(fig3,fullfile(figpath,fig3.Name),'fig')

end