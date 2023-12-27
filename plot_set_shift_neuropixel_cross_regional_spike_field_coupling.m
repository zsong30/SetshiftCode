function plot_set_shift_neuropixel_cross_regional_spike_field_coupling(trial)


% Author: Eric Song
% updated: 12/14/2021

% figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18';
figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\cross_regional_spike_field_coupling';
% figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50';
%set path
% datapath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
datapath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin';
% datapath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50\Record Node 101\experiment1\recording1\structure.oebin';

Fs = 2500;
frq = struct;
frq(1).band = [4 8];
frq(2).band = [8 12];
frq(3).band = [12 16];
frq(4).band = [16 20];
frq(5).band = [20 30];
frq(6).band = [30 50];
frq(7).band = [50 70];
% time2include = 60*40; % in seconds
unit2plot = 135;
%unit2plot = 135;
ISIsLimits = [0,inf];
plotnum = 1;
time2include = inf;
ISIsUpLimit = ISIsLimits(2);
ISIsLowerLimit = ISIsLimits(1);
allchannels = [(1:128);(129:256);(257:384)];

for c = 1:3
channels = allchannels(c,:);

for i = 1:length(frq)

    for u = 1:length(unit2plot)
      
        st = round(trial.units(unit2plot(u)).ts*Fs/1000); % spike times in samples
        st = st(st<st(1)+time2include*3000);
        %trial.units(unit2plot(u)).ISIs = trial.units(unit2plot(u)).ISIs(1:length(st)-1);
        %ch = trial.units(unit2plot(u)).channel;
        %channels = 1:130;
        
        % read in the data for all channels from recording day1
        RawData=load_open_ephys_binary(datapath, 'continuous',4,'mmap');
        
        fig = figure;
        fig.WindowStyle = 'normal';
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
        hold on
        
        
        for ch = 1:length(channels)
            if plotnum == 1
                plotname = 'rerefd';
                if channels(ch) == 1
                    lfp = double(RawData.Data.Data.mapped(channels(ch),:))-...
                        double(mean(RawData.Data.Data.mapped((channels(ch)+1:1:channels(ch)+5),:),1));
                elseif channels(ch) == 2
                    lfp = double(RawData.Data.Data.mapped(channels(ch),:))-...
                        double(mean(RawData.Data.Data.mapped([channels(ch)-1,(channels(ch)+1:1:channels(ch)+4)],:),1));
                    
                elseif channels(ch) == 383
                    lfp = double(RawData.Data.Data.mapped(channels(ch),:))-...
                        double(mean(RawData.Data.Data.mapped([(channels(ch)-4:1:channels(ch)-1),channels(ch)+1],:),1));
                elseif channels(ch) == 384
                    lfp = double(RawData.Data.Data.mapped(channels(ch),:))-...
                        double(mean(RawData.Data.Data.mapped((channels(ch)-5:1:channels(ch)-1),:),1));
                    
                else
                    if mod(channels(ch),2)== 0 % check if ch is even
                        lfp = double(RawData.Data.Data.mapped(channels(ch),:)) - double(mean(RawData.Data.Data.mapped([(channels(ch)-3:1:channels(ch)-1),channels(ch)+1,channels(ch)+2],:),1));
                        
                    else
                        lfp = double(RawData.Data.Data.mapped(channels(ch),:)) - double(mean(RawData.Data.Data.mapped([channels(ch)-2,channels(ch)-1,(channels(ch)+1:1:channels(ch)+3)],:),1));
                        
                    end
                end
                
            elseif plotnum == 2
                plotname = 'raw';
                lfp = double(RawData.Data.Data.mapped(channels(ch),:));
                
            end
                        
            % bandpass filter
            band = frq(i).band;
            [b, a] = butter(2, band/(Fs/2)); % 2nd order butterworth filter
            %lfp = bandstop(lfp,[59.8,61.2],Fs);
            lfp_filt = filtfilt(b, a, lfp); % bandpassed data
            data_complex = hilbert(lfp_filt); % perform a hilbert transform on the data to get the complex component.
            phase = angle(data_complex); % phase in radians! Use rad2deg() if you prefer things in degrees.
                        
            subplot(ceil(sqrt(length(channels))),ceil(sqrt(length(channels))),ch)
            
            if sum(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit) > 0
                %                 set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                polh = polarhistogram(phase(st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit)),25);
                hold on
                polarplot([circ_mean(phase(st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit))');...
                    circ_mean(phase(st(trial.units(unit2plot(u)).ISIs<ISIsUpLimit & trial.units(unit2plot(u)).ISIs>ISIsLowerLimit))')], [0;max(polh.Values)],'Color','r','LineWidth',3)
            else
            end
        end
    end
    
    
    
    figname1 = ...
        sprintf('unit %d batch %d frqband %d-%d %s %s',unit2plot(u),c,frq(i).band(1),frq(i).band(2),plotname,datestr(now,30));
    saveas(fig,fullfile(figpath,figname1),'png')
    saveas(fig,fullfile(figpath,figname1),'fig')

    
end
end