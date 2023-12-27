    function plot_setshift_NP_spike_field_coupling_csf02_crossregional


% Author: Eric Song 
tic
figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_spike_field_coupling\CSF02\CSF02_PL_09232021\mismatchedchannels';


datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\CSF02SpikesFrom1stProbe_09232021_trimmed';
load(datafile,'trial')

datapath = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';

ratname = 'CSF02';
datadate = '09232021';
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
unit2plot = [73,76];
% unit2plot = (1:length(trial.units));
% unit2plot = 128; %CSF02 09/23
% unit2plot = 135; %CSF02 09/24
% unit2plot = 87; %CSF02 09/27
ISIsLimits = [0,inf];
plotnum = 2;
time2include = inf;
ISIsUpLimit = ISIsLimits(2);
ISIsLowerLimit = ISIsLimits(1);

for i = 7:length(frq)
    for u = 1:length(unit2plot)
        fig = figure('name',sprintf('%s-%s-%s-frqband %d-%d_unit%d_crossregional',ratname,datadate,regionname,frq(i).band(1),frq(i).band(2),unit2plot(u)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
    allunitphase = [];
    
        st = round(trial.units(unit2plot(u)).ts*Fs/1000); % spike times in samples
        st = st(st<st(1)+time2include*3000);
        trial.units(unit2plot(u)).ISIs = trial.units(unit2plot(u)).ISIs(1:length(st)-1);
%         ch = trial.units(unit2plot(u)).channel;
channels2include = 1:4:384;
        for ch = 1:length(channels2include)

        % read in the data for all channels from recording day1
        RawData=load_open_ephys_binary(datapath, 'continuous',4,'mmap');
        % choose a random channel with a single unit activity for lfp
        %lfp = double(RawData.Data.Data.mapped(ch,:));
        
        if plotnum == 1
            plotname = 'rerefd';
            
        elseif plotnum == 2
            plotname = 'raw';
            lfp = double(RawData.Data.Data.mapped(channels2include(ch),:));
            
        end

        
        % bandpass filter
        band = frq(i).band;
        
        [b, a] = butter(2, band/(Fs/2)); % 2nd order butterworth filter
        %lfp = bandstop(lfp,[59.8,61.2],Fs);
        lfp_filt = filtfilt(b, a, lfp); % bandpassed data
        data_complex = hilbert(lfp_filt); % perform a hilbert transform on the data to get the complex component.
        phase = angle(data_complex); % phase in radians! Use rad2deg() if you prefer things in degrees.
        
        subplot(ceil(sqrt(length(channels2include))),ceil(sqrt(length(channels2include))),ch)

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
        sprintf('%s-%s-%s-frqband %d-%d %d units ISI %d-%d %s unit%d_crossregional1',ratname,datadate,regionname,frq(i).band(1),frq(i).band(2),length(unit2plot),ISIsLowerLimit,ISIsUpLimit,plotname,unit2plot(u));
    saveas(fig,fullfile(figpath,figname1),'png')
    saveas(fig,fullfile(figpath,figname1),'fig')
    end
end
toc