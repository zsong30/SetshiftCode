function plot_NP_power_MakCopy
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

figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% importing raw data files. one from dPAL, one from setshift, and one misc
% % this is for dPAL
data(1).path = ...
   'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03092021\OPEN-EPHYS-ESM04-P_2021-03-09_15-18-34_dPAL\Record Node 102\experiment1\recording1\structure.oebin';
% % this is for setshift
data(2).path = ...
       "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin";
% % this is for reuse
data(3).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\structure.oebin';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting raw traces                               

for whichday = 2:2 %allows us to pick which raw data file to use (this is using the setshift raw data file)
    path = data(whichday).path; %this is setting path to be the setshit raw data path
    
    % read in the data for chosen channels from recording
    RawData = load_open_ephys_binary(path, 'continuous',2,'mmap');
        %loading in raw data, continuous type, as a structure
    origdata = double(RawData.Data.Data(1).mapped);
        %array with 2500 data points, each data point is 
    ch = (1:10:384);
        %this makes a vector counting from 1 to 384 by 10s (this is for the
        %y-axis of the power line plot)
    trimmedData = origdata(ch,:);
        %trimming the data to only take the raw data from every 10th
        %channel
    data1 = downsample(trimmedData',5)'; % downsampling; from 2500 -->500
    t = 1000*(1:1000)/500; % 2 sec of data, in miliseconds
    f1 = figure('name',sprintf('raw traces day#%d_%s',whichday,datestr(now,30))); %#ok<*TNOW1,*DATST>
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gca, 'FontName', 'Arial', 'FontSize', 28, 'FontWeight', 'bold')
    hold on
    for i = 1:size(data1,1) %plots each 10th channel's raw trace
        %changing this to for i = 1:1 plots 1 channel's raw trace
        % pick times 130-132s to plot and space out the traces
        plot(t,data1(i,500*130+1:500*132)'+1000*(i-1),'LineWidth',1.5)
    end
    yticks(-5000:5000:40000);
    yticklabels({'','0','5','10','15','20','25','30','35','40'});
    xlabel('Time (milliseconds)')
    ylabel('Every 10th Channel Along the Shank')
    saveas(f1,fullfile(figpath,f1.Name),'png')
    saveas(f1,fullfile(figpath,f1.Name),'fig')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting power
    numseg = 15;
        %%%what does this number of segments mean?
    segmentedData = nan(size(trimmedData,1),6*2500,numseg);
        %%%what does this do????
    
    for i = 1:size(trimmedData,1) % looping through i channels
        %changing this to i = 1:1 plots only 1 channel of data in the power
        %line spectrum
        for j = 1:numseg % looping through segments/trials.
            segmentedData(i,:,j) = ...
                trimmedData(i,(numseg-1)*6*2500+1+2500*130:numseg*6*2500+2500*130);
            %%% what is this doing?
        end
    end
    
    params.Fs = 2500;
        %%% what is the significance of the number 2500?
    [S,f] = mtspectrumc(squeeze(segmentedData(1,:,:)),params);
        % f is frequency
    power = nan(size(segmentedData,1),size(S,1));
        %making an empty, appropriately sized array for each power
        %calculation
        %power is an array, each cell represents a spatial unit?
    clear S
    
    for i = 1:size(segmentedData,1) % i: channels
        [S,f] = mtspectrumc(squeeze(segmentedData(i,:,:)),params);
        S = median(10*log10(S),2); % S = frq x trial;
        
        power(i,:) = S; % power = channel x frq x trial;
        clear S
    end

    f2 = figure('name',sprintf('Neuropixel probe power spectrum day#%d_%s',whichday,datestr(now,30)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')

    % my plotting of power as a line graph
    plot(f,power)
    xlim([20 55]);
    xticks(20:5:55)
    xticklabels(20:5:55)
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
    
    saveas(f2,fullfile(figpath,f2.Name),'png')
    saveas(f2,fullfile(figpath,f2.Name),'fig')
    
end

