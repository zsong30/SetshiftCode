function plot_set_shift_neuropixel_field_field_coupling(trial)

% Author: Eric Song 

% set params
params.Fs = 2500;  % it is 30000 originally but will be downsampled to 1500.
params.tapers = [2 3];
params.fpass = [1 120];
movingwin = [2 .2];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];

frq(1).band = [4,12];
frq(2).band = [30,50];
frq(3).band = [50,70];
% frq(4).band = [70,100];
% frq(5).band = [100,140];
Fs = params.Fs;
% unitindex = 1:138;
%unitindex = [12*2+2,12*2+3,12*6+9,12*7+6]; % units that showed strong phase preference
%unitindex = [12*2+2,12*2+3,12*6+9,12*7+6]; % units that showed strong phase preference
unitindex = [100,120];
figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18';
%set path
%path = 'D:\CSF02_2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin';
datapath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
% read in the data for all channels from recording day1
RawData=load_open_ephys_binary(datapath, 'continuous',2,'mmap');
timestamps = double(RawData.Timestamps); % in samples

for fr = 3:length(frq)
    
    fig = figure('name',sprintf('theta_coupling_with_frqband_%d-%d_%s',frq(fr).band(1),frq(fr).band(2),datestr(now,30)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    hold on
    
    for u = 1:length(unitindex)
        
        ch = trial.units(unitindex(u)).channel;
        lfp = double(RawData.Data.Data.mapped(ch,:));
        [S,t,f]=mtspecgramc(lfp,movingwin,params);
        %S = 10*log(S);
        S = mean(S(:,f>frq(fr).band(1)&f<frq(fr).band(2)),2);
        t = round(t*params.Fs)+timestamps(1)-1; % in samples
        
        [~,tindx] = ismember(t,timestamps);
        
        % bandpass filter
        
        band = frq(1).band;
        
        [b, a] = butter(2, band/(Fs/2)); % 2nd order butterworth filter
        %lfp = bandstop(lfp,[59.8,61.2],Fs);
        lfp_filt = filtfilt(b, a, lfp); % bandpassed data
        data_complex = hilbert(lfp_filt); % perform a hilbert transform on the data to get the complex component.
        frq(1).phase = angle(data_complex); % phase in radians! Use rad2deg() if you prefer things in degrees.
        phase2plot = frq(1).phase(tindx);
        
        subplot(ceil(sqrt(length(unitindex))),ceil(sqrt(length(unitindex))),u)
                      
        [~,edges] = histcounts(phase2plot,100);
        x = edges(1:end-1)+(edges(2)-edges(1))/2;
        Power = nan(length(edges)-1,1);
        for ed = 1:length(edges)-1
            Power(ed) = mean(S(phase2plot>edges(ed)&phase2plot<edges(ed+1)));
        end
        Power = normalize(Power,'zscore');
        plot(x,Power)
        title(sprintf('chan#%d',ch))
        xlabel('Theta phase')
        ylabel('Gamma power');
        set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
        GammaPower(u,:)= Power;  %#ok<AGROW>
    end
    
    saveas(fig,fullfile(figpath,fig.Name),'png')
    saveas(fig,fullfile(figpath,fig.Name),'fig')
    
    fig2 = figure('name',sprintf('allchan_4-12theta_coupling_with_frqband_%d-%d_%s',frq(fr).band(1),frq(fr).band(2),datestr(now,30)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    plot(x,GammaPower,'Color','k')
    hold on
    plot(x,mean(GammaPower,1),'Color','r', 'LineWidth',3)
    title(sprintf('all channels'))
    xlabel('Theta phase')
    ylabel('Gamma power - zscore');
    set(gca, 'FontName', 'Arial', 'FontSize', 18, 'FontWeight', 'bold')
    saveas(fig2,fullfile(figpath,fig2.Name),'png')
    saveas(fig2,fullfile(figpath,fig2.Name),'fig')
    
    
end