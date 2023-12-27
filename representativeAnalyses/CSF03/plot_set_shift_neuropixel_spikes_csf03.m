function plot_set_shift_neuropixel_spikes_csf03

% Author: Eric Song

figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\unittraits\plot_set_shift_neuropixel_spikes\CSF03\CSF03_PL_03312022';
% figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\unittraits\plot_set_shift_neuropixel_spikes\CSF03\CSF03_PL_03292022';
% figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\unittraits\plot_set_shift_neuropixel_spikes\CSF03\CSF03_PL_03302022';

datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\CSF03SpikesFrom1stProbe_03312022';
% datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\CSF03SpikesFrom1stProbe_03292022';
% datafile = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\CSF03SpikesFrom1stProbe1min_03302022';
load(datafile,'trial')

ratname = 'CSF03';
% datadate = '03292022';
% datadate = '03302022';
datadate = '03312022';
regionname = 'PL';
% regionname = 'ST';

tr=1;
if ~isfield(trial(tr),'units')
else
    fig1 = figure('name',sprintf('all good units %s-%s-%s',ratname,datadate,regionname));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    for u=1:length(trial(tr).units)
        subplot(ceil(sqrt(length(trial(tr).units))),ceil(sqrt(length(trial(tr).units))),u)
        plot(mean(trial(tr).units(u).spikeData,1,'omitnan'),'LineWidth',1.5,'Color','r')
        box off
        axis off

    end

    saveas(fig1,fullfile(figpath,fig1.Name),'png')
    saveas(fig1,fullfile(figpath,fig1.Name),'fig')

    fig2 = figure('name',sprintf('chosen good units for waveformISI %s-%s-%s',ratname,datadate,regionname));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    units2plot = [4,8,11,17];
    numunits = length(units2plot);
    for u = 1:numunits

        %trial(tr).units(units2plot(u)).ISIs = trial(tr).units(units2plot(u)).ISIs(trial(tr).units(units2plot(u)).ISIs>1);

        subplot(3,numunits,u)
        % subplot(numunits,3,3*(u-1)+1)
        t=(1:82)*1000/30000;  % t in miliseconds.
        %data = (trial.units(units2plot(u)).spikeData -median(trial.units(units2plot(u)).spikeData,2))'*0.195;
        data = normalize((trial(tr).units(units2plot(u)).spikeData -median(trial(tr).units(units2plot(u)).spikeData,2))'*0.195,'zscore');
%         data = normalize((trial(tr).units(units2plot(u)).spikeData -median(trial(tr).units(units2plot(u)).spikeData,2))'*0.195);
        plot(t,data,'Color',[0.5 0.5 0.5])
        hold on
        plot(t,median(data,2,'omitnan'),'LineWidth',3,'Color','r')
        xlabel('Time (ms)', 'FontWeight', 'bold')
        ylabel('Z-scored Voltage', 'FontWeight', 'bold');
        yticks([-5,0,5])
        yticklabels([-5,0,5])
        ylim([-5,5])
        title(sprintf('Waveforms'))
        set(gca, 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold')
        box off
        axis square

        subplot(3,numunits,numunits+u)
        % subplot(numunits,3,3*(u-1)+2)
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
        set(gca, 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold')
        box off
        axis square

        axLin = [];
        axLog = subplot(3,numunits,numunits*2+u);
        % axLog = subplot(numunits,3,3*(u-1)+3);
        st = trial(tr).units(units2plot(u)).ts/1000;
        %[xLin, nLin, xLog, nLog]=myACG(st, axLin, axLog);
        myACG_ES(st, axLin, axLog);

        set(gcf,'position',[2000,100,900,900])
    end


    saveas(fig2,fullfile(figpath,fig2.Name),'png')
    saveas(fig2,fullfile(figpath,fig2.Name),'fig')



    fig3 = figure('name',sprintf('chosen good units for rasterplot %s-%s-%s',ratname,datadate,regionname));
    hold on
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

    eachunitlength = [];

    for i = 1: length(trial.units)
        eachunitlength = [eachunitlength,length(trial.units(i).ts)];

    end

    [~, index] = find(eachunitlength>100);
%     [~, index] = find(eachunitlength>1000);
%     [~, index] = find(eachunitlength>10000);

    if length(index) >=10

        units2rasterplot = index(1:10);
    else

        units2rasterplot = index;


    end



    %     units2rasterplot = randperm(length(trial.units),10);
    %     units2rasterplot = 1:10;
    numunits = length(units2rasterplot);
    st = 0; % in
%     en = 100;% % in secs
%     en = 73;% % in secs
    en = 62;% % in secs
    for u = 1:numunits

        thisunitspikes=...
            trial(tr).units(units2rasterplot(u)).ts(st*1000<trial(tr).units(units2rasterplot(u)).ts&trial(tr).units(units2rasterplot(u)).ts<en*1000)

        if ~isempty(thisunitspikes)
            a=thisunitspikes*ones(1,100);
        else
            a=zeros(1,100);
        end
        y = linspace(u+1,u,100);

        plot(a',y,'color',[0 0 0], 'LineWidth', 0.1)
        xlim([st, en*1000]);
        ylim([0,numunits+2]);
        %         grid off;
        %         set(gca,'xtick',[])
        %         set(gca,'ytick',[])
        %         set(gca,'xticklabel',{[]})
        %         grid off;
        %         set(gca,'yticklabel',{[]})
        %         box off


        % xticks([2*1000,4*1000,6*1000,8*1000,10*1000]);
        % xticklabels({'2','4','6','8','10'});
        xlabel('Time(milisec)')
        % yticks([15.5,25.5,35.5,45.5]);
        % yticklabels({'40','30','20','10'});
        ylabel('Units');
        set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight', 'bold')


    end

    saveas(fig3,fullfile(figpath,fig3.Name),'png')
    saveas(fig3,fullfile(figpath,fig3.Name),'fig')



end % end of if isemapty(trial(tr).units)

