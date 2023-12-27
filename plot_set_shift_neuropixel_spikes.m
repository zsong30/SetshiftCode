function plot_set_shift_neuropixel_spikes(trial)

% Author: Eric Song 

tr=1;
if ~isfield(trial(tr),'units')
else
    figure('name','all good units')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    for u=1:length(trial(tr).units)
        subplot(ceil(sqrt(length(trial(tr).units))),ceil(sqrt(length(trial(tr).units))),u)
        plot(mean(trial(tr).units(u).spikeData,1,'omitnan'))
    end
        
    figure('name','chosen good units for waveforms')
%    units2plot = [7,12,];
% units2plot = [15,17,20,22];
%      units2plot = [1,4,10,18];
     units2plot = [4,8,11,17]; 
    numunits = length(units2plot);
    for u = 1:numunits
        
        %trial(tr).units(units2plot(u)).ISIs = trial(tr).units(units2plot(u)).ISIs(trial(tr).units(units2plot(u)).ISIs>1);
        
        subplot(3,numunits,u)
% subplot(numunits,3,3*(u-1)+1)
        t=(1:82)*1000/30000;  % t in miliseconds.
        %data = (trial.units(units2plot(u)).spikeData -median(trial.units(units2plot(u)).spikeData,2))'*0.195;
        data = normalize((trial(tr).units(units2plot(u)).spikeData -median(trial(tr).units(units2plot(u)).spikeData,2))'*0.195,'zscore');
% data = normalize((trial(tr).units(units2plot(u)).spikeData -median(trial(tr).units(units2plot(u)).spikeData,2))'*0.195);
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
    
    
    figure('name','chosen good units for rasterplot')
    hold on
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    
    
    
    eachunitlength = [];

for i = 1: length(trial.units)
eachunitlength = [eachunitlength,length(trial.units(i).ts)];

end

[~, index] = find(eachunitlength>10000);

if length(index) >=10
    
    units2rasterplot = index(1:10);
else
    
    units2rasterplot = index;
    
    
end
    
    
    
%     units2rasterplot = randperm(length(trial.units),10);    
%     units2rasterplot = 1:10;
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
    
end % end of if isemapty(trial(tr).units)




% figure, plot(mean(data,2),'LineWidth',3,'Color','r')
%  SEM_data=std(data,0,2)./sqrt(size(data,2));
% tmpT=(1:82);
%     hold on
%     patch([tmpT,fliplr(tmpT)], [(mean(data,2)-SEM_data)',flipud(mean(data,2)+SEM_data)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
% %     xlim([0,100]);
% %     ylim([0,70]);
%     xlabel('Samples', 'FontWeight', 'bold')
%     ylabel('Z-scored Voltage', 'FontWeight', 'bold');
%     title(sprintf('Averaged waveform'))
%     set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
%     box off






%%% Choose 10 sec;



%     % plot a moving windows spike frequence graph.
%     figure; hold on
%     for u=1:length(trial(tr).units)-3% numClusters
%
%         st = trial(tr).units(u).ts(1); % in sample
%         en = trial(tr).units(u).ts(1)+10*30000;% % in sample
%
%         total_time = (en-st+1)*1000/30000;  % in miliseconds
%         bin_size = 400; % in miliseconds
%               x=(bin_size+trial(tr).units(u).ts(1)*1000/30000:bin_size:total_time+trial(tr).units(u).ts(1)*1000/30000); %in millisecs
%
%
%               y=[];
%         tmp=trial(tr).units(u).ts(st<trial(tr).units(u).ts&trial(tr).units(u).ts<en);
%         tmp=tmp*1000/30000;% in miliseconds
%
%
%
%
%
%         for i=1:length(x)-1
%             y(i)=length(tmp(tmp>x(i)&tmp<x(i+1)));
%         end
%         z=length(tmp(tmp<x(1)));
%         y=[z y]; %#ok<AGROW>
%         %subplot(2, 2, u)
%         plot(x,y,'LineWidth',2,'Color','r')
%         ylim([0,500])
%     end
%     % text(1,8,'Number of spikes')
%     %hold off
%     %%% for the same 10sec data, plot a raster graph.
%     hold on
%
%     for u=1:length(trial(tr).units)-3% numClusters
%
%         tmp=trial(tr).units(u).ts(st<trial(tr).units(u).ts&trial(tr).units(u).ts<en);
%         tmp=tmp*1000/30000; % in miliseconds
%
%         if ~isempty(tmp)
%             tmp2=ones(1,100);
%             a=tmp*tmp2;
%         else
%             a=zeros(1,100);
%         end
%         y = linspace(100-u,65-u,100);% this is to make the first rat on top.
%         %figure
%         plot(a,y,'color',[0 0 0], 'LineWidth', 0.1)
%         xlim([st*1000/30000, en*1000/30000]);
%         %ylim([60,80]);
%         grid off;
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
%         set(gca,'xticklabel',{[]})
%         grid off;
%         set(gca,'yticklabel',{[]})
%         box off
%
%     end
% %     xticks([2*1000,4*1000,6*1000,8*1000,10*1000]);
% %     xticklabels({'2','4','6','8','10'});
% %     xlabel('Time(sec)')
% %     yticks([0,10,20,30,40,50,60]);
% %     yticklabels({'70','60','50','40','30','20','10'});
% %     ylabel('Unit No.');
%
%
% axes('Position',[.7 .7 .2 .2])
%
% %figure
% plot(mean(data,2),'LineWidth',3,'Color','r')
%  SEM_data=std(data,0,2)./sqrt(size(data,2));
% tmpT=(1:82);
%     hold on
%     patch([tmpT,fliplr(tmpT)], [(mean(data,2)-SEM_data)',flipud(mean(data,2)+SEM_data)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
% %     xlim([0,100]);
% %     ylim([0,70]);
%     xlabel('Time(miliseconds)', 'FontWeight', 'bold')
%     ylabel('Normalized Voltage', 'FontWeight', 'bold');
%     title(sprintf('Averaged waveform'))
%     set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
%     box off



%
%
%     figure
%     h=histogram(trial(tr).units(u).ISIs*1000/30000,100);
%
%     h.FaceColor = [0 0 0];
%     xlabel('Time(miliseconds)', 'FontWeight', 'bold')
%     ylabel('Spike counts', 'FontWeight', 'bold');
%     %title(sprintf('200 individual waveforms'))
%     xlim([0,100])
%     %h.BinLimits=[min(trial(tr).units(u).ISIs)*1000/30000,max(trial(tr).units(u).ISIs)*1000/30000]:
%     xticks(linspace(min(trial(tr).units(u).ISIs)*1000/30000,max(trial(tr).units(u).ISIs)*1000/30000,250));
%
%     set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
%

%     h =
%   Histogram with properties:
%
%              Data: [1000x1 double]
%            Values: [1x23 double]
%           NumBins: 23
%          BinEdges: [1x24 double]
%          BinWidth: 0.3000
%         BinLimits: [-3.3000 3.6000]
%     Normalization: 'count'
%         FaceColor: 'auto'
%         EdgeColor: [0 0 0]