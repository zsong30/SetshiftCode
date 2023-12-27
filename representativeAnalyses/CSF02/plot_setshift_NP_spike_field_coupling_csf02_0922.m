    function plot_setshift_NP_spike_field_coupling_csf02_0922


% Author: Eric Song 
tic
figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_spike_field_coupling\CSF02';


datafile = 'Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF02SpikesFrom1stProbe_09222021_trimmed.mat';
load(datafile,'trial')

datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\structure.oebin';

ratname = 'CSF02';
datadate = '09222021';
regionname = 'PL';

Fs = 2500;
frq = struct;
frq(1).band = [4 8];
frq(2).band = [8 12];
frq(3).band = [12 16];
frq(4).band = [16 20];
frq(5).band = [20 30];
frq(6).band = [30 50];
frq(7).band = [70,100];
% time2include = 60*40; % in seconds
% unit2plot = [111,124];
unit2plot = (1:length(trial.units));
% unit2plot = [109,111]; %CSF02 09/23
% unit2plot = 135; %CSF02 09/24
% unit2plot = 87; %CSF02 09/27
ISIsLimits = [0,inf];
plotnum = 1;
time2include = inf;
ISIsUpLimit = ISIsLimits(2);
ISIsLowerLimit = ISIsLimits(1);

for i = 6:length(frq)-1
    fig = figure('name',sprintf('%s-%s-%s-frqband %d-%d',ratname,datadate,regionname,frq(i).band(1),frq(i).band(2)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
    allunitphase = [];
    for u = 1:length(unit2plot)
        st = round(trial.units(unit2plot(u)).ts*Fs/1000); % spike times in samples
        st = st(st<st(1)+time2include*Fs);
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

        
        % bandpass filter
        band = frq(i).band;
        
        [b, a] = butter(2, band/(Fs/2)); % 2nd order butterworth filter
        %lfp = bandstop(lfp,[59.8,61.2],Fs);
        lfp_filt = filtfilt(b, a, lfp); % bandpassed data
        data_complex = hilbert(lfp_filt); % perform a hilbert transform on the data to get the complex component.
        phase = angle(data_complex); % phase in radians! Use rad2deg() if you prefer things in degrees.
        
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
            ph = polarhistogram(phase(st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit)),25);
            allunitphase = [allunitphase,phase(st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit))]; %#ok<AGROW>
            hold on
            polarplot([circ_mean(phase(st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit))');...
                circ_mean(phase(st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit))')], [0;max(ph.Values)],'Color','r','LineWidth',3)
        else
        end
        
    end
    figname1 = ...
        sprintf('%s-%s-%s-frqband %d-%d %d units ISI %d-%d %s %s',ratname,datadate,regionname,frq(i).band(1),frq(i).band(2),length(unit2plot),ISIsLowerLimit,ISIsUpLimit,plotname,datestr(now,30));
    saveas(fig,fullfile(figpath,figname1),'png')
    saveas(fig,fullfile(figpath,figname1),'fig')
    figure('name','all unit phase preference')
    allunitplot = polarhistogram(allunitphase,25);
    figname2 = ...
        sprintf('%s-%s-%s-allunitsfrqband %d-%d %d units ISI %d-%d %s %s',ratname,datadate,regionname,frq(i).band(1),frq(i).band(2),length(unit2plot),ISIsLowerLimit,ISIsUpLimit,plotname,datestr(now,30));
    saveas(allunitplot,fullfile(figpath,figname2),'png')
    saveas(allunitplot,fullfile(figpath,figname2),'fig')
    
end
toc