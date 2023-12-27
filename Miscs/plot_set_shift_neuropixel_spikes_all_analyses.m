function plot_set_shift_neuropixel_spikes_all_analyses(trial)
% function plot_set_shift_neuropixel_spikes_all_analyses(trial) is to plot
% all figures from the NP recording during setshift task, spike traits,
% spike field coupling, and spike task association.

% Author: Eric Song
% Updated: 12/7/2021

%make sure you have the task csv file in the directory.
% read in task data
tmpfn = dir('*.csv');
logfn = tmpfn.name;
setshift = read_set_shift_behavior_one_file_only(logfn);

tr=1;
units2rasterplot = [4,5,6,7,8,9];
figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18';
% figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Probe 2';
%set path
datapath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
% datapath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin';
% units2plot = [112,121];
units2plot = [111,124];

if ~isfield(trial(tr),'units')
else
    figure('name','all good units')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    for u=1:length(trial(tr).units)
        subplot(ceil(sqrt(length(trial(tr).units))),ceil(length(trial(tr).units)/ceil(sqrt(length(trial(tr).units)))),u)
        plot(mean(trial(tr).units(u).spikeData,1,'omitnan'))
    end
    
    figure('name','chosen good units for waveforms')
    numunits = length(units2plot);
    for u = 1:numunits
        %         trial(tr).units(units2plot(u)).ISIs = trial(tr).units(units2plot(u)).ISIs(trial(tr).units(units2plot(u)).ISIs>1);
        subplot(3,numunits,u)
        t=(1:82)*1000/30000;  % t in miliseconds.
        data = normalize((trial(tr).units(units2plot(u)).spikeData -median(trial(tr).units(units2plot(u)).spikeData,2))'*0.195,'zscore');
        plot(t,data,'Color',[0.5 0.5 0.5])
        hold on
        plot(t,mean(data,2),'LineWidth',3,'Color','r')
        xlabel('Time (ms)', 'FontWeight', 'bold')
        ylabel('Z-scored Voltage', 'FontWeight', 'bold');
        title(sprintf('Waveforms'))
        set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
        box off
        axis square
        
        subplot(3,numunits,numunits+u)
        x = linspace(min(trial(tr).units(units2plot(u)).ISIs),min(trial(tr).units(units2plot(u)).ISIs)+100,100);
        y=nan(100,1);
        for j = 1:100-1
            y(j) = length(trial(tr).units(units2plot(u)).ISIs(trial(tr).units(units2plot(u)).ISIs>=x(j)&trial(tr).units(units2plot(u)).ISIs<(x(j+1))));
        end
        y(100)=1;
        plot(x,y,'LineWidth',3,'Color','b')
        xlabel('ISI(ms)', 'FontWeight', 'bold')
        ylabel('Spike counts', 'FontWeight', 'bold');
        %title(sprintf('200 individual waveforms'))
        %     xlim([0,100])
        %     xticks(linspace(min(trial(tr).units(units2plot(u)).ISIs)*1000/30000,max(trial(tr).units(units2plot(u)).ISIs)*1000/30000,250));
        set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
        box off
        axis square
        
        axLin = [];
        axLog = subplot(3,numunits,numunits*2+u);
        st = trial(tr).units(units2plot(u)).ts/1000;
        %[xLin, nLin, xLog, nLog]=myACG(st, axLin, axLog);
        myACG_ES(st, axLin, axLog);
        
        set(gcf,'position',[2000,100,900,900])
    end
        
    figure('name','chosen good units for rasterplot')
    hold on
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    %     units2rasterplot = [4,5,6,7,8,9];
    numunits = length(units2rasterplot);
    st = 0; % in
    en = 100;% % in secs
    for u = 1:numunits
        
        thisunitspikes=...
            trial(tr).units(units2rasterplot(u)).ts(st*1000<trial(tr).units(units2rasterplot(u)).ts&trial(tr).units(units2rasterplot(u)).ts<en*1000);
        
        if ~isempty(thisunitspikes)
            a=thisunitspikes*ones(1,100);
        else
            a=zeros(1,100);
        end
        y = linspace(u+1,u,100);
        
        plot(a',y,'color',[0 0 0], 'LineWidth', 0.1)
        xlim([st, en*1000]);
        ylim([0,numunits+2]);
        xlabel('Time(milisec)')
        ylabel('Units');
        set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight', 'bold')
        
    end
    
end % end of if isemapty(trial(tr).units)


% function plot_set_shift_neuropixel_spike_field_coupling(trial)

% Author: Eric Song

% spike_analyses_draft(trial,10,[0,250],2)
%load('trial.mat')
%numUnits = length(trial.units);
%numUnits = 20;


Fs = 2500;
frq = struct;
% frq(1).band = [4 8];
% frq(2).band = [8 12];
% frq(3).band = [12 16];
% frq(4).band = [16 20];
% frq(5).band = [20 30];
% frq(6).band = [30 50];
frq(1).band = [50 70];
% time2include = 60*40; % in seconds
%units2plot = [122,135];
ISIsLimits = [0,inf];
time2include = inf;
ISIsUpLimit = ISIsLimits(2);
ISIsLowerLimit = ISIsLimits(1);

for i = 1:length(frq)
    fig = figure('name',sprintf('frqband %d-%d',frq(i).band(1),frq(i).band(2)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
    allunitphase = [];
    for u = 1:length(units2plot)
        st = round(trial.units(units2plot(u)).ts*Fs/1000); % spike times in samples
        st = st(st<st(1)+time2include*3000);
        trial.units(units2plot(u)).ISIs = trial.units(units2plot(u)).ISIs(1:length(st)-1);
        ch = trial.units(units2plot(u)).channel;
        
        
        % read in the data for all channels from recording day1
        RawData=load_open_ephys_binary(datapath, 'continuous',2,'mmap');
        % choose a random channel with a single unit activity for lfp
        %lfp = double(RawData.Data.Data.mapped(ch,:));
        
        
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
        
        
        
        
        % bandpass filter
        band = frq(i).band;
        
        [b, a] = butter(2, band/(Fs/2)); % 2nd order butterworth filter
        %lfp = bandstop(lfp,[59.8,61.2],Fs);
        lfp_filt = filtfilt(b, a, lfp); % bandpassed data
        data_complex = hilbert(lfp_filt); % perform a hilbert transform on the data to get the complex component.
        phase = angle(data_complex); % phase in radians! Use rad2deg() if you prefer things in degrees.
        
        subplot(ceil(sqrt(length(units2plot))),ceil(length(units2plot)/ceil(sqrt(length(units2plot)))),u)
        
        if sum(trial.units(units2plot(u)).ISIs<ISIsUpLimit & trial.units(units2plot(u)).ISIs>ISIsLowerLimit) > 0
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            ph = polarhistogram(phase(st(trial.units(units2plot(u)).ISIs<ISIsUpLimit & trial.units(units2plot(u)).ISIs>ISIsLowerLimit)),25);
            allunitphase = [allunitphase,phase(st(trial.units(units2plot(u)).ISIs<ISIsUpLimit & trial.units(units2plot(u)).ISIs>ISIsLowerLimit))]; %#ok<AGROW>
            hold on
            polarplot([circ_mean(phase(st(trial.units(units2plot(u)).ISIs<ISIsUpLimit & trial.units(units2plot(u)).ISIs>ISIsLowerLimit))');...
                circ_mean(phase(st(trial.units(units2plot(u)).ISIs<ISIsUpLimit & trial.units(units2plot(u)).ISIs>ISIsLowerLimit))')], [0;max(ph.Values)],'Color','r','LineWidth',3)
        else
        end
        
    end
    figname1 = ...
        sprintf('frqband %d-%d %d units ISI %d-%d %s %s',frq(i).band(1),frq(i).band(2),length(units2plot),ISIsLowerLimit,ISIsUpLimit,plotname,datestr(now,30));
    saveas(fig,fullfile(figpath,figname1),'png')
    saveas(fig,fullfile(figpath,figname1),'fig')
    figure('name','all unit phase preference')
    allunitplot = polarhistogram(allunitphase,25);
    figname2 = ...
        sprintf('allunitsfrqband %d-%d %d units ISI %d-%d %s %s',frq(i).band(1),frq(i).band(2),length(units2plot),ISIsLowerLimit,ISIsUpLimit,plotname,datestr(now,30));
    saveas(allunitplot,fullfile(figpath,figname2),'png')
    saveas(allunitplot,fullfile(figpath,figname2),'fig')
    
end


% function plot_set_shift_neuropixel_spikes_with_task(trial)


% times in seconds.

% read in spike data
% trial = do_set_shift_neuropixel_spikes_one_file_only(datapath,0);
% times in miliseconds.

task_starttime = load_open_ephys_binary(datapath,'events',1,'mmap'); %%% in samples!!
time_offset = double(task_starttime.Timestamps(1))/30; %%% in miliseconds !!

tasktimes = [];
for rl = 1:length(setshift.rules)
    for bl = 1: length(setshift.rules(rl).blocks)
        for tr = 1: length(setshift.rules(rl).blocks(bl).trials)
            tmp = [setshift.rules(rl).blocks(bl).trials(tr).initiation_time,setshift.rules(rl).blocks(bl).trials(tr).response_time];
            tasktimes = [tasktimes;tmp]; %#ok<AGROW>
            
        end
    end
end
%intervaltimes = intervaltimes((tasktimes(:,2)-tasktimes(:,1)>2),:); % choose those only when task took longer than 2s.
tasktimes = tasktimes((tasktimes(:,2)-tasktimes(:,1)>2),:); % choose those only when task took longer than 2s.
tasktimes = [tasktimes(:,2)-2,tasktimes(:,2)]; % cut the task to 2s. still in seconds!
intervaltimes = [tasktimes(:,2)-4,tasktimes(:,2)-2]; % cut the task to 2s. still in seconds!

tasktimes = tasktimes * 1000 + time_offset; % changed to miliseconds and adjusted by offset
intervaltimes = intervaltimes * 1000 + time_offset; % changed to miliseconds and adjusted by offset


unit = struct;
for u = 1:length(trial.units)
    unit(u).task_spikecount = 0;unit(u).interval_spikecount = 0;
    unit(u).channel = trial.units(u).channel;
    for i = 1:size(tasktimes,1)
        if sum(trial.units(u).ts>tasktimes(i,1)&trial.units(u).ts<tasktimes(i,2))== 0
            unit(u).task(i).st = NaN; unit(u).task(i).spikecount = 0;
        else
            unit(u).task(i).st = ...
                trial.units(u).ts(trial.units(u).ts>tasktimes(i,1)&trial.units(u).ts<tasktimes(i,2))...
                -tasktimes(i,1);
            unit(u).task(i).spikecount = length(unit(u).task(i).st);
            %scatter(unit(u).task(i).st_ad,ones(length(unit(u).task(i).st_ad),1)*(size(tasktimes,1)+1-i),'x','MarkerEdgecolor',[0 0 0])
        end
        
        if sum(trial.units(u).ts>intervaltimes(i,1)&trial.units(u).ts<intervaltimes(i,2))== 0
            unit(u).interval(i).st = NaN; unit(u).interval(i).spikecount = 0;
        else
            unit(u).interval(i).st =...
                trial.units(u).ts(trial.units(u).ts>intervaltimes(i,1)&trial.units(u).ts<intervaltimes(i,2))...
                -tasktimes(i,1);
            unit(u).interval(i).spikecount = length(unit(u).interval(i).st);
            %scatter(unit(u).interval(i).st_ad,ones(length(unit(u).interval(i).st_ad),1)*(size(tasktimes,1)+1-i),'x','MarkerEdgecolor',[0 0 0])
        end
        unit(u).task_spikecount = unit(u).task_spikecount + unit(u).task(i).spikecount;
        unit(u).interval_spikecount = unit(u).interval_spikecount + unit(u).interval(i).spikecount;
    end
    
end

% plot number of spikes from ALL UNITS during task vs internal
fig1 = figure('name','number of spikes from all units during task vs internal');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
task_spikecount = []; interval_spikecount = [];
for u = 1:length(unit)
    task_spikecount = [task_spikecount,unit(u).task_spikecount];  %#ok<AGROW> % spike times for all units
    interval_spikecount = [interval_spikecount,unit(u).interval_spikecount]; %#ok<AGROW>
end
bar([sum(interval_spikecount),sum(task_spikecount)])
xticklabels({'interval','task'})
box off
figname1 = ...
    fig1.Name;
saveas(fig1,fullfile(figpath,figname1),'png')
saveas(fig1,fullfile(figpath,figname1),'fig')




% plot number of spikes from EACH UNIT during task vs internal
fig2 = figure('name','number of spikes from each unit during task vs internal');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
for u = 1:length(unit)
    chanorder_orig(u) = unit(u).channel;  %#ok<AGROW>
    %chanorder_orig(u) = trial.units(u).channel;
    subplot(ceil(sqrt(length(unit))),ceil(sqrt(length(unit))),u)
    bar([unit(u).interval_spikecount,unit(u).task_spikecount])
    xticklabels({'interval','task'})
end
box off
figname2 = ...
    fig2.Name;
saveas(fig2,fullfile(figpath,figname2),'png')
saveas(fig2,fullfile(figpath,figname2),'fig')




% plot number of spikes from EACH UNIT  V2D during task vs internal
fig3 = figure('name','# of spikes from each unit V2D during task vs internal');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
hold on
[~,ind_orig,~] = unique(chanorder_orig);
ind = sort(ind_orig);
for i = 1: length(ind)
    subplot(ceil(sqrt(length(ind))),ceil(sqrt(length(ind))),i)
    bar([unit(ind(i)).interval_spikecount,unit(ind(i)).task_spikecount])
    xticklabels({'interval','task'})
end
box off
figname3 = ...
    fig3.Name;
saveas(fig3,fullfile(figpath,figname3),'png')
saveas(fig3,fullfile(figpath,figname3),'fig')



% plot only units that have 1.5 more spikes during task than interval.
fig4 = figure('name','prone task units');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
[~,a] = find(task_spikecount > 1.5*interval_spikecount); % choose index of units that have 1.5 more spikes during task than interval.

pt_task_spikecount = task_spikecount(a);
pt_interval_spikecount = interval_spikecount(a);

for i = 1:length(pt_task_spikecount)
    subplot(9,9,i)
    bar([pt_interval_spikecount(i),pt_task_spikecount(i)])
    xticklabels({'interval','task'})
    box off
end

figname4 = ...
    fig4.Name;
saveas(fig4,fullfile(figpath,figname4),'png')
saveas(fig4,fullfile(figpath,figname4),'fig')
pt_units2plot_unitindx = a(pt_task_spikecount==max(pt_task_spikecount)); % name of the unit with the most task spikes to plot
% fprintf('prone-task unit indices is %d! \n',a)

fmt = ['prone-task unit indices are: [', repmat('%d, ', 1, numel(a)-1), '%d]\n'];
fprintf(fmt, a)

figure
% bar([pt_interval_spikecount(a==111),pt_task_spikecount(a==111)])
bar([pt_interval_spikecount(a==122),pt_task_spikecount(a==122)])
xticklabels({'interval','task'})
box off


% plot only units that have 1.5 more spikes during interval than task.
fig5 = figure('name','prone interval units');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
[~,b] = find(interval_spikecount > 1.5*task_spikecount); % choose index of units that have 1.5 more spikes during task than interval.

pi_task_spikecount = task_spikecount(b);
pi_interval_spikecount = interval_spikecount(b);

for i = 1:length(pi_task_spikecount)
    subplot(9,9,i)
    bar([pi_interval_spikecount(i),pi_task_spikecount(i)])
    xticklabels({'interval','task'})
    box off
end

figure
% bar([pi_interval_spikecount(b==124),pi_task_spikecount(b==124)])
bar([pi_interval_spikecount(b==135),pi_task_spikecount(b==135)])
xticklabels({'interval','task'})
box off


figname5 = ...
    fig5.Name;
saveas(fig5,fullfile(figpath,figname5),'png')
saveas(fig5,fullfile(figpath,figname5),'fig')
pi_units2plot_unitindx = b(pi_interval_spikecount==max(pi_interval_spikecount)); % name of the unit with the most task spikes to plot
fmt = ['prone-interval unit indices are: [', repmat('%d, ', 1, numel(b)-1), '%d]\n'];
fprintf(fmt, b)



fig6 = figure('name','prone task units rasterplot');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
hold on
for u = 1:length(pt_units2plot_unitindx)
    
    for i = 1:length(tasktimes)
        if unit(pt_units2plot_unitindx(u)).task(i).spikecount == 0
        else
            scatter(unit(pt_units2plot_unitindx(u)).task(i).st,ones(length(unit(pt_units2plot_unitindx(u)).task(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[0 0 0])
            scatter(unit(pt_units2plot_unitindx(u)).interval(i).st,ones(length(unit(pt_units2plot_unitindx(u)).interval(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[0 0 0])
        end
    end
end
box off
figname6 = ...
    fig6.Name;
saveas(fig6,fullfile(figpath,figname6),'png')
saveas(fig6,fullfile(figpath,figname6),'fig')



fig7 = figure('name','prone interval units rasterplot');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
hold on
for u = 1:length(pi_units2plot_unitindx)
    
    for i = 1:length(tasktimes)
        if unit(pi_units2plot_unitindx(u)).interval(i).spikecount == 0
        else
            scatter(unit(pi_units2plot_unitindx(u)).task(i).st,ones(length(unit(pi_units2plot_unitindx(u)).task(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[0 0 0])
            scatter(unit(pi_units2plot_unitindx(u)).interval(i).st,ones(length(unit(pi_units2plot_unitindx(u)).interval(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[0 0 0])
        end
    end
end
box off
figname7 = ...
    fig7.Name;
saveas(fig7,fullfile(figpath,figname7),'png')
saveas(fig7,fullfile(figpath,figname7),'fig')








