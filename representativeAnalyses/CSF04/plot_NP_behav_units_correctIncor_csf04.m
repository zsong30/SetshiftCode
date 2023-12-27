function plot_NP_behav_units_correctIncor_csf04
% function plot_NP_setshiftbehav_unitspiking_correctIncor_NPmanu is to produce 3 sets of figures for the NP manuscript.
% One set shows spiking rate of all correct-prone units during correct vs incorrect trials
% one set shows spiking rate of all incorrect-prone units during correct vs incorrect trials
% one set shows spiking rate of all units during correct vs incorrect trials.

% r = 1, reg = 2, dy = 2, is currently used to produce figures for the manuscript. 

% Author: Eric Song,
% Date: Mar.20. 2023

ratname = 'CSF04';

% datadate = '10122022';
% datadate = '10132022';
datadate = '10142022';

regionname = 'ST';
% regionname = 'PL';


for rt = 1:1  % we can't do rt =2 yet as of now because the spike files did not include the entire recording time

    if rt == 1  
        data(1).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\Record Node 101\experiment1\recording1\structure.oebin";
        data(1).unitfilepath = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\CSF04SpikesFrom1stProbe_10122022_trimmed";
      data(1).unitfilepath2 = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\CSF04SpikesFrom2ndProbe_10122022";
        data(1).logfn = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-12_13-00-28\CSF04_2022_10_12__13_00_01';

        data(2).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\Record Node 101\experiment1\recording1\structure.oebin";
        data(2).unitfilepath = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\CSF04SpikesFrom1stProbe_10132022_trimmed";
        data(2).unitfilepath2 = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\CSF04SpikesFrom2ndProbe_10132022";
        data(2).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-13_14-48-21\CSF04_2022_10_13__14_48_01";
%         data(2).ratname = 'CSF02';
%         data(2).datadate = '09232021';
        
        data(3).path = ...
             "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\Record Node 101\experiment1\recording1\structure.oebin";        
        data(3).unitfilepath = ...
           "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\CSF04SpikesFrom1stProbe_10142022_trimmed";
        data(3).unitfilepath2 = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\CSF04SpikesFrom2ndProbe_10142022";
        data(3).logfn = "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF04\2022-10-14_15-11-41\CSF04_2022_10_14__15_11_01";


    elseif rt == 2  % we can't do rt =2 yet as of now because the spike files did not include the entire recording time

        data(1).path = ...
            'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\structure.oebin';

        data(1).logfn = ...
            'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\CSF03PM_2022_03_29__14_52_00';

        % data(2).path = ...
        %     'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\Record Node 102\experiment1\recording1\structure.oebin';
        % data(2).logfn = ...
        %     'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\CSF03_2022_03_30__15_03_00';
        % 
        data(3).path = ...
            'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\Record Node 102\experiment1\recording1\structure.oebin';
                data(3).unitfilepath = ...
            'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\CSF03SpikesFrom1stProbe_03312022';
        data(3).logfn = ...
            'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\CSF03_2022_03_31__14_47_00';

    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%         data from recording in the SetShift chamber                 %%%%%
    %%%          averaging across every 10 channels as a cluster             %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for reg = 2:2


        for dy = 3:3

            if rt == 1
                if reg == 1
                    figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\unit-behavior-correlation\CSF04\CSF04_PL_10122022';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',1,'mmap');
                    RawData_evt = load_open_ephys_binary(data(dy).path, 'events',1);
                    load(data(dy).unitfilepath,'trial')
                elseif reg == 2
%                     figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\unit-behavior-correlation\CSF04\CSF04_ST_10122022';
%                     figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\unit-behavior-correlation\CSF04\CSF04_ST_10132022';
                    figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\unit-behavior-correlation\plot_NP_behav_units_correctIncor\CSF04\CSF04_ST_10142022';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',1,'mmap');
                    RawData_evt = load_open_ephys_binary(data(dy).path, 'events',1);
                    load(data(dy).unitfilepath2,'trial')
                    %RawData = load_open_ephys_binary(data(dy).path, 'continuous',4,'mmap');
                end

            elseif rt == 2
                if reg == 1
                    figpath = '\\rds01.storage.umn.edu\hst_widge\projmon\ericsprojects\Setshift\ANALYSES\NP spike analyses\CSF03_PL';
                    %RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
                elseif reg == 2
                    figpath = 'Z:\projmon\ericsprojects\NP_manuscript\Analysis\CSF03_ST';
                    %RawData = load_open_ephys_binary(data(dy).path, 'continuous',4,'mmap');
                end


            end

            %unitdata = trial; 
recordstarttime = RawData.Timestamps(1);
setshiftstarttime = RawData_evt.Timestamps(1);
offsettime = double((setshiftstarttime - recordstarttime)/30); % in millisec.


for u = 1:length(trial.units)
    for i = 1:size(trial.units(u).ts,1)
trial.units(u).newts(i,1) = double((trial.units(u).ts(i,1) + offsettime)/1000);
    end
end


            % behavioral timestamps
            setshift=read_set_shift_behavior_one_file_only_imcomplete_session(data(dy).logfn);
            correctInitiationT = [];incorrectInitiationT = [];
            for rl=1:length(setshift.rules)
                for bl=1:length(setshift.rules(rl).blocks)
                    for tl = 1:length(setshift.rules(rl).blocks(bl).trials)
                        if setshift.rules(rl).blocks(bl).trials(tl).performance == 1

correctInitiationT = [correctInitiationT;setshift.rules(rl).blocks(bl).trials(tl).initiation_time,setshift.rules(rl).blocks(bl).trials(tl).response_time];
                        elseif setshift.rules(rl).blocks(bl).trials(tl).performance == 0
                            incorrectInitiationT = [incorrectInitiationT,; setshift.rules(rl).blocks(bl).trials(tl).initiation_time, setshift.rules(rl).blocks(bl).trials(tl).response_time];
                        end
                    end
                end
            end




            correctT = correctInitiationT;
            incorrectT = incorrectInitiationT;


            % segments1 = [round(correctT*2500)-2500;round(correctT*2500)+2500]';

spikerate_correct = [];
for cor = 1:size(correctT,1)
for u = 1:length(trial.units)
% calculate spiking rate for each unit during each trial
    spikerate_correct(cor,u) = sum(trial.units(u).newts>correctT(cor,1)&trial.units(u).newts<correctT(cor,2))/(correctT(cor,2)-correctT(cor,1));

end
end

% averaged spiking rate for each unit over trial
spikerate_correct_aver = mean(spikerate_correct,1);
if dy ==1 && reg == 2
spikerate_correct_aver(83) = mean([spikerate_correct_aver(82),spikerate_correct_aver(84)]);
end



spikerate_incorrect = [];
for incor = 1:size(incorrectT,1)
for u = 1:length(trial.units)

    spikerate_incorrect(incor,u) = sum(trial.units(u).newts>incorrectT(incor,1)&trial.units(u).newts<incorrectT(incor,2))/(incorrectT(incor,2)-incorrectT(incor,1));



end
end

spikerate_incorrect_aver = mean(spikerate_incorrect,1);
if dy ==1 && reg == 2
spikerate_incorrect_aver(83) = mean([spikerate_incorrect_aver(82),spikerate_incorrect_aver(84)]);
end


% calculate the ratio of correct over incorrect
xx = spikerate_correct_aver./spikerate_incorrect_aver;
% figure('name',sprintf('day%dregion%d prone task units',dy,reg))
ProneCorrectIDs = find(xx>1.5);
% singleunitid = find(max(mean(spikerate_correct(:,find(xx>1.5)),1)));
% %#ok<FNDSB>+
unitCorrectData = spikerate_correct(:,ProneCorrectIDs);
unitIncorrectData = spikerate_incorrect(:,ProneCorrectIDs);

fig1 = figure('name',sprintf('%s-%s-%s-prone correct units',ratname,datadate,regionname));
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
plot(1:size(unitCorrectData,2),mean(unitCorrectData,1),'LineWidth',3,'Color','r')
hold on
plot(1:size(unitIncorrectData,2),mean(unitIncorrectData,1),'LineWidth',3,'Color','b')
set(gca, 'FontName', 'Arial', 'FontSize', 50, 'FontWeight', 'bold');
ylabel('Spike rate','FontSize',70);
xlabel('Unit IDs','FontSize',80);
xlim([0,size(unitCorrectData,2)+1])
    
    % SEM_unitCorrectData= std(unitCorrectData,0,1,'omitnan')./sqrt(size(unitCorrectData,1));
    % patch([1:size(unitCorrectData,2),fliplr(1:size(unitCorrectData,2))], [(mean(unitCorrectData,1)-SEM_unitCorrectData),fliplr(mean(unitCorrectData,1)+SEM_unitCorrectData)],'r','EdgeColor','none', 'FaceAlpha',0.2);
    % SEM_unitIncorrectData= std(unitIncorrectData,0,1,'omitnan')./sqrt(size(unitIncorrectData,1));
    % patch([1:size(unitIncorrectData,2),fliplr(1:size(unitIncorrectData,2))], [(mean(unitIncorrectData,1)-SEM_unitIncorrectData),fliplr(mean(unitIncorrectData,1)+SEM_unitIncorrectData)],'b','EdgeColor','none', 'FaceAlpha',0.2);

legend('Correct trials','Incorrect trials','Location','northwest')
box off
legend boxoff 

    saveas(fig1,fullfile(figpath,fig1.Name),'png')
    saveas(fig1,fullfile(figpath,fig1.Name),'fig')

ProneIncorrectIDs = find(xx<1/1.5);
% singleunitid = find(max(mean(spikerate_correct(:,find(xx>1.5)),1))); %#ok<FNDSB>
unitCorrectData = spikerate_correct(:,ProneIncorrectIDs);
unitIncorrectData = spikerate_incorrect(:,ProneIncorrectIDs);

fig2 = figure('name',sprintf('%s-%s-%s-prone incorrect units',ratname,datadate,regionname));
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
plot(mean(unitCorrectData,1),'LineWidth',3,'Color','r')
hold on
plot(mean(unitIncorrectData,1),'LineWidth',3,'Color','b')
set(gca, 'FontName', 'Arial', 'FontSize', 50, 'FontWeight', 'bold')
ylabel('Spike rate','FontSize',80);
xlabel('Unit IDs','FontSize',80)
xlim([0,size(unitIncorrectData,2)+1])
legend('Correct trials','Incorrect trials','location','northwest')
box off
legend boxoff 

    saveas(fig2,fullfile(figpath,fig2.Name),'png')
    saveas(fig2,fullfile(figpath,fig2.Name),'fig')


fig3 = figure('name',sprintf('%s-%s-%s-spikerate from each unit during correct vs. incorrect trials',ratname,datadate,regionname));
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
plot(spikerate_correct_aver,'LineWidth',3,'Color','r')
hold on, plot(spikerate_incorrect_aver,'LineWidth',3,'Color','b')
set(gca, 'FontName', 'Arial', 'FontSize', 35, 'FontWeight', 'bold')
ylabel('Spike rate','FontSize',80)
xlabel('Unit IDs','FontSize',65)
legend('Correct trials','Incorrect trials','FontSize',45,'location','northeast')
box off
legend boxoff 
clear spikerate_correct_aver spikerate_incorrect_aver

tempname1 = sprintf('%s.png',fig3.Name);
saveas(fig3,fullfile(figpath,tempname1))
tempname2 = sprintf('%s.fig',fig3.Name);
saveas(fig3,fullfile(figpath,tempname2))

        end

    end
end
