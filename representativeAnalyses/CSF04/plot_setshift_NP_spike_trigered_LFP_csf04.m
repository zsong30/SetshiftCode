    function plot_setshift_NP_spike_trigered_LFP_csf04


% Author: Eric Song 
tic

ratname = 'CSF04';
regionname = 'ST';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF04\CSF04_ST_10122022';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\CSF04SpikesFrom1stProbe_10122022_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '10122022';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF04\CSF04_ST_10132022';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\CSF04SpikesFrom1stProbe_10132022_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '10132022';

%figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF04\CSF04_ST_10142022';
%datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\CSF04SpikesFrom1stProbe_10142022_trimmed';
%datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\Record Node 101\experiment1\recording1\structure.oebin';
%datadate = '10142022';

load(datafile,'trial')

Fs = 2500;

% time2include = 60*40; % in seconds
% unit2plot = [111,124];
unit2plot = (1:10);
% unit2plot = (1:length(trial.units));
% unit2plot = 128; %CSF02 09/23
% unit2plot = 135; %CSF02 09/24
% unit2plot = 87; %CSF02 09/27
ISIsLimits = [0,inf];
plotnum = 2;
time2include = inf;
ISIsUpLimit = ISIsLimits(2);
ISIsLowerLimit = ISIsLimits(1);


    fig = figure('name',sprintf('%s-%s-%s-spike_triggered_LFP',ratname,datadate,regionname));
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

            tmp_lfp = nan(length(tmp_st)-5,51);  % 50 means 20 miliseconds
            for k = 1:length(tmp_st)-5
                tmp_lfp(k,:) = lfp(tmp_st(k)-25:tmp_st(k)+25)- median(lfp(tmp_st(k)-25:tmp_st(k)-20));
            end


            plot((-20:20/25:20),mean(tmp_lfp,1));
            xlabel('ms')
            ylabel('uV')
            ylim([-85 40]) % Added by Eric H, 6/16/2023
            allunitlfp = [allunitlfp; tmp_lfp]; %#ok<AGROW>
     

        else
        end
        
    end
    saveas(fig,fullfile(figpath,fig.Name),'png')
    saveas(fig,fullfile(figpath,fig.Name),'fig')

    fig2 = figure('name',sprintf('%s-%s-%s-spike_triggered_LFP_allunits',ratname,datadate,regionname));


                plot((-20:20/25:20),mean(allunitlfp,1));
            xlabel('ms')
            ylabel('uV')
            ylim([-85 40])
  
    saveas(fig2,fullfile(figpath,fig2.Name),'png')
    saveas(fig2,fullfile(figpath,fig2.Name),'fig')
    
toc