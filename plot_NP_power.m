function plot_NP_power
% function plot_NP_rawtraces_power_NPmanu to plot rawtraces and power figures for the NP manuscript. 
%    It uses 3 representative days (one from dPAL, one from setshift, and one from reuse (setshift)).
%    The figures are named in the formates of "raw traces day#1_20230316T195128" and "Neuropixel probe power spectrum day #1_20230316T195139".
%    Figures are saved in folder Z:\projmon\ericsprojects\NP_manuscript\FiguresForPaper.

% Author: Eric Song,
% Date: Feb.21. 2023

params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [20 58];
params.trialave = 0;

% figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES';
figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09232021_expanded'


% % this is for dPAL
data(1).path = ...
   'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03092021\OPEN-EPHYS-ESM04-P_2021-03-09_15-18-34_dPAL\Record Node 102\experiment1\recording1\structure.oebin';
% % this is for setshift
% data(2).path = ...
%     'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
data(2).path = ...
       "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin"
% % this is for reuse
data(3).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\structure.oebin';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%   raw traces & bipolar traces                                %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for whichday = 2:2
%     path = data(whichday).path;
% 
%     % read in the data for chosen channels from recording
%     RawData = load_open_ephys_binary(path, 'continuous',2,'mmap');
%     origdata = double(RawData.Data.Data(1).mapped);
%     ch = (1:10:384);
%     trimmedData = origdata(ch,:);
%     data1 = downsample(trimmedData',5)'; % downsampling; from 2500 -->500
%     t = 1000*(1:1000)/500; % 2 sec of data, in miliseconds
%     f1 = figure('name',sprintf('raw traces day#%d_%s',whichday,datestr(now,30))); %#ok<*TNOW1,*DATST>
%     set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%     set(gca, 'FontName', 'Arial', 'FontSize', 28, 'FontWeight', 'bold')
%     hold on
%     for i = 1:size(data1,1)
%         % pick times 130-132s to plot and space out the traces
%         plot(t,data1(i,500*130+1:500*132)'+1000*(i-1),'LineWidth',1.5)
%     end
%     yticks(-5000:5000:40000);
%     yticklabels({'','0','5','10','15','20','25','30','35','40'});
%     xlabel('Time (milliseconds)')
%     ylabel('Every 10th Channel Along the Shank')
%     saveas(f1,fullfile(figpath,f1.Name),'png')
%     saveas(f1,fullfile(figpath,f1.Name),'fig')
    
    %         %%% figure 2 bipolar data traces
    %         bipodata = nan(size(origdata,1),size(origdata,2));
    %         for i = 1:size(origdata,1)
    %             bipodata(i,:)=neuropixel_REreference(i,origdata);
    %         end
    %         data2 = bipodata(ch,:);
    %
    %         f2 = figure('name',sprintf('bipolar traces day#%d%s',whichday,datestr(now,30)));
    %         set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    %         set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    %         hold on
    %         for i = 1:size(data2,1)
    %             plot(data2(i,2500*130+1:2500*132)'+300*(i-1))
    %         end
    %
    %         saveas(f2,fullfile(figpath,f2.Name),'png')
    %         saveas(f2,fullfile(figpath,f2.Name),'fig')
    

    numseg = 15;
    segmentedData = nan(size(trimmedData,1),6*2500,numseg);
    
    for i = 1:size(trimmedData,1) % looping through channels
        for j = 1:numseg % looping through segments/trials.
            segmentedData(i,:,j) = ...
                trimmedData(i,(numseg-1)*6*2500+1+2500*130:numseg*6*2500+2500*130);
        end
    end
    
    params.Fs = 2500;
    [S,f] = mtspectrumc(squeeze(segmentedData(1,:,:)),params);
    power = nan(size(segmentedData,1),size(S,1));
    clear S
    for i = 1:size(segmentedData,1) % i: channels
        [S,f] = mtspectrumc(squeeze(segmentedData(i,:,:)),params);
        S = median(10*log10(S),2); % S = frq x trial;
        
        power(i,:) = S; % power = channel x frq x trial;
        clear S
    end
    %power = normalize(power,2,'zscore');
    
    %power = normalize(power,2,'norm');
    f2 = figure('name',sprintf('Neuropixel probe power spectrum day#%d_%s',whichday,datestr(now,30)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
    %clims = [-1,3];
    imagesc(f,(1:size(power,1)),power);
    %imagesc(f,(1:size(power,1)),power,clims);
    
    axis xy;
    shading flat;%no black boxes around pixles
    colorbar;
    set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
    ylim([-.5 40.5]);
    yticks(0:5:40)
    yticklabels(0:500:40*500)
    %     xlim([.5 31.5]);
    %     xticks(0:5:31)
    %     xticklabels(0:250:31*50)
    xlabel('Frequency(Hz)','FontSize', 32, 'FontWeight', 'bold');
    ylabel('Distance from tip of probe (\mum)','FontSize', 32, 'FontWeight', 'bold');
    colormap(parula);
    %title(sprintf('Power spectrum'),'FontSize', 14, 'FontWeight', 'bold')
    
    saveas(f2,fullfile(figpath,f2.Name),'png')
    saveas(f2,fullfile(figpath,f2.Name),'fig')
    
    
    f3 = figure('name',sprintf('Neuropixel probe power spectrum linegraph day#%d_%s',whichday,datestr(now,30)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    
    
    chchosen = [5,17,18,30,31];
    tmppower = nan(length(chchosen),size(power,2));
    for p = 1:length(chchosen)
        tmppower(p,:) = power(chchosen(p),:)+ 10*p;
               
    end
     
    plot(f,tmppower,'LineWidth',1.5)  
    set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
        xlabel('Frequency(Hz)','FontSize', 32, 'FontWeight', 'bold');
    ylabel('Channels','FontSize', 32, 'FontWeight', 'bold');
    title('Oscillation power','FontSize', 36, 'FontWeight', 'bold')
    box off
    saveas(f3,fullfile(figpath,f3.Name),'png')
    saveas(f3,fullfile(figpath,f3.Name),'fig')
    
    
    
    
end

