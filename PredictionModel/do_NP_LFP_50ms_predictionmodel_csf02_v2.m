function lfpdata = do_NP_LFP_50ms_predictionmodel_csf02_v2
% Used to generate part of the LASSO table.

% Author: Eric Song, Eric Hoskins
% Date: November 7, 2023

ratname = 'CSF02';
% datadate = '09222021';
% datadate = '09232021';
datadate = '09242021';
regionname = 'PL';

rat = struct;
params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [0 100];
params.trialave = 0;
% movingwin = [0.5 0.01];
movingwin = [0.5 0.01];
datapath = 'Z:\projmon\ericsprojects\Setshift\DATA\representative analyses\CSF02';

load('z:\projmon\ericsprojects\Setshift\DATA\PredictionModel\CSF02_lfp_predictionmodel_09242023.mat','lfpdata');

for rt = 1:1 

    if rt == 1  % rt == 1 corresponds to CSF02 PL region
        data(1).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\Record Node 102\experiment1\recording1\structure.oebin";
        data(1).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-22_09-53-40\CSF03_2021_09_22__14_40_00";
        data(2).path = ...
            'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
        data(2).logfn = "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\CSF02_2021_09_23__14_50_02";

        data(3).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin";
        data(3).logfn = "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\CSF02_2021_09_24__15_17_02";

    elseif rt == 2

        data(1).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\structure.oebin";
        data(1).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\CSF03PM_2022_03_29__14_52_00";

        data(2).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\Record Node 102\experiment1\recording1\structure.oebin";
        data(2).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\CSF03_2022_03_30__15_03_00.csv";

        data(3).path = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\Record Node 102\experiment1\recording1\structure.oebin";
        data(3).logfn = ...
            "Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\CSF03_2022_03_31__14_47_00.csv";

    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%         data from recording in the SetShift chamber                 %%%%%
    %%%          averaging across every 10 channels as a cluster             %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for reg = 1:2


        for dy = 3:3

            if rt == 1
                if reg == 1
%                     figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\lfp-behavior-correlation\CSF02\CSF02_PL_09222021';
%                     figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\lfp-behavior-correlation\CSF02\CSF02_PL_09232021';
                    figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\PredictionModel';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
                 
                    x = lfpdata.prelimbic.correctsampleinfo(:,1)+1;
                    y = lfpdata.prelimbic.incorrectsampleinfo(:,1)+1;
                elseif reg == 2
                    figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\PredictionModel';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',4,'mmap');
                    x = lfpdata.striatum.correctsampleinfo(:,1)+1;
                    y = lfpdata.striatum.incorrectsampleinfo(:,1)+1;
                end

            elseif rt == 2
                if reg == 1
                    figpath = 'Z:\projmon\ericsprojects\NP_manuscript\Analysis\CSF03_PL';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',2,'mmap');
                 
                    x = lfpdata.prelimbic.correctsampleinfo(:,1)+1;
                    y = lfpdata.prelimbic.incorrectsampleinfo(:,1)+1;
                elseif reg == 2
                    figpath = 'Z:\projmon\ericsprojects\NP_manuscript\Analysis\CSF03_ST';
                    RawData = load_open_ephys_binary(data(dy).path, 'continuous',4,'mmap');
                    x = lfpdata.striatum.correctsampleinfo(:,1)+1;
                    y = lfpdata.striatum.incorrectsampleinfo(:,1)+1;
                end

            end

            origdata = double(RawData.Data.Data(1).mapped);
            
            %ch = (1:10:384);
            ch = 1:384;
            trimmedData = origdata(ch,:);
            %data = downsample(trimmedData',5)'; % downsampling;

            % behavioral timestamps
            setshift=read_set_shift_behavior_one_file_only_imcomplete_session(data(dy).logfn);
            correctInitiationT = []; incorrectInitiationT = [];
            correctResponseT = [];incorrectResponseT = [];
            for rl=1:length(setshift.rules)
                for bl=1:length(setshift.rules(rl).blocks)
                    for tl = 1:length(setshift.rules(rl).blocks(bl).trials)
                        if setshift.rules(rl).blocks(bl).trials(tl).performance == 1 && ismember(round(setshift.rules(rl).blocks(bl).trials(tl).response_time),round(x))
                            correctResponseT = [correctResponseT,setshift.rules(rl).blocks(bl).trials(tl).response_time];
                            correctInitiationT = [correctInitiationT,setshift.rules(rl).blocks(bl).trials(tl).initiation_time];
                        elseif setshift.rules(rl).blocks(bl).trials(tl).performance == 0 && ismember(round(setshift.rules(rl).blocks(bl).trials(tl).response_time),round(y))
                            incorrectResponseT = [incorrectResponseT,setshift.rules(rl).blocks(bl).trials(tl).response_time];
                            incorrectInitiationT = [incorrectInitiationT,setshift.rules(rl).blocks(bl).trials(tl).initiation_time];
                        end
                    end
                end
            end


            correctResponseT = sortrows(correctResponseT',1);
            correctInitiationT = sortrows(correctInitiationT',1);
            incorrectResponseT = sortrows(incorrectResponseT',1);
            incorrectInitiationT = sortrows(incorrectInitiationT',1);
            %correctResponseT = correctResponseT';
            %correctInitiationT = correctInitiationT';
            %incorrectResponseT = incorrectResponseT';
            %incorrectInitiationT = incorrectInitiationT';



            table_dm_correct = [];
            table_ln_correct = [];
            table_dm_incorrect = [];
            table_ln_incorrect = [];
            correctsegone = (correctInitiationT * 2500) - 625;
            correctsegtwo = (correctResponseT * 2500) + 3125;
            correctSegments = horzcat(correctsegone, correctsegtwo);

            %correctSegments = [round(correctInitiationT*2500)-625,round(correctResponseT*2500) + 3125]';
            cleandatacorrect = get_clean_NP_data_automatic_ES(trimmedData, RawData.Timestamps, correctSegments);
            % cleandata1.sampleinfo has all the segments1 that have been
            % kept --- that is, those were not rejected. 1st dimension is
            % num of trial, 2nd dimension is the start and end of the
            % segment.
            params.Fs = 2500;

            % CORRECT TRIALS %
            correctlnsegments = [round(correctResponseT * 2500)-625;round(correctResponseT * 2500) + 3125]';
            cleandatacorrectln = get_clean_NP_data_automatic_ES(trimmedData, RawData.Timestamps, correctlnsegments);
            %for i=1:size(cleandatacorrect.trial,2) % Iterate through all correct trials.
            for i=1:3
                % DECISION MAKING %
                tmpdata = cleandatacorrect.trial{1,i}'; % LFP data for individual trial.
                [spect,tim,freqs] = mtspecgramc(tmpdata,movingwin,params); % Power spectrum for each trial.
                spect = 10*log(spect); % Converts to decibels.
                % adjustedRT = cleandatacorrect.time{1,i}(end) - 1.25; % cleandatacorrect.time{1,i}(end) is the end of the learning period. We know this will always be 1.25 seconds after the response time.
                adjustedRT = cleandatacorrect.time{1,i}(end) - 1.25; % cleandatacorrect.time{1,i}(end) is the end of the learning period. We know this will always be 1.25 seconds after the response time.
                foundIndex = 0;
                for z=1:length(tim)
                    if foundIndex == 0 && tim(z) >= adjustedRT
                        foundIndex = 1;
                        respIndex = z - 1;
                    end
                end
                dmSpect = spect(1:respIndex,:,:); % dmspect is 3D = time * frequency * channel
                % Clustering
                counter = 0;
                j = 1;
                working = nan(respIndex, length(freqs), 10);
                hold = nan(respIndex, length(freqs), 38);
                p = 1;
                while j<size(dmSpect,3) % Iterate through all 384 channels.
                    counter = counter + 1;
                    working(:,:,counter) = dmSpect(:,:,j);
                    if counter == 10 % Once there are 10 channels in a cluster, average them and add it to the new matrix.
                        hold(:,:,p) = mean(working, 3);
                        counter = 0;
                        working = nan(respIndex, length(freqs), 10); % Reset the working matrix.
                        p = p + 1;
                    end
                    j = j + 1;
                end
                dmSpect = hold; % dmSpect,3 is now 38 for the 38 channels.
                % Binning
                x = size(dmSpect,1);
                totalBins = floor(x/5); % Calculate the number of 50 ms bins we need.
                counter = 0;
                j = 1;
                working = nan(5, length(freqs), 38);
                hold = nan(totalBins, length(freqs), 38);
                p = 1;
                while j<size(dmSpect,1)
                    counter = counter + 1;
                    working(counter,:,:) = dmSpect(j,:,:);
                    if counter == 5
                        hold(p,:,:) = mean(working, 1);
                        counter = 0;
                        working = nan(5, length(freqs), 38); % Reset the working matrix.
                        p = p + 1;
                    end
                    j = j + 1;
                end
                dmSpect = hold;
                % Frequency
                theta = nan(size(dmSpect,1),1,38);
                alpha = nan(size(dmSpect,1),1,38);
                beta = nan(size(dmSpect,1),1,38);
                lowgamma = nan(size(dmSpect,1),1,38);
                highgamma = nan(size(dmSpect,1),1,38);
                for h=1:38
                    thetasub = [];
                    alphasub = [];
                    betasub = [];
                    lowgammasub = [];
                    highgammasub = [];
                    for o=1:82
                        if freqs(o) > 4 && freqs(o) < 8 % Theta 4-8Hz
                            thetasub = horzcat(thetasub,dmSpect(:,o,h));
                        elseif freqs(o) > 8 && freqs(o) < 12 % Alpha 8-12Hz
                            alphasub = horzcat(alphasub,dmSpect(:,o,h));
                        elseif freqs(o) > 13 && freqs(o) < 30 % Beta 13-30Hz
                            betasub = horzcat(betasub,dmSpect(:,o,h));
                        elseif freqs(o) > 30 && freqs(o) < 50 % Low Gamma 30-50Hz
                            lowgammasub = horzcat(lowgammasub,dmSpect(:,o,h));
                        elseif freqs(o) > 70 && freqs(o) < 100 % Hight Gamma 70-100Hz
                            highgammasub = horzcat(highgammasub,dmSpect(:,o,h));
                        end
                    end
                    theta(:,1,h) = mean(thetasub,2); % Average the data for each band
                    alpha(:,1,h) = mean(alphasub,2);
                    beta(:,1,h) = mean(betasub,2);
                    lowgamma(:,1,h) = mean(lowgammasub,2);
                    highgamma(:,1,h) = mean(highgammasub,2);
                end
                dmSpect = horzcat(theta,beta,alpha,lowgamma,highgamma); % Combine the frequency bands together
                % Adding nans
                if size(dmSpect,1) < 20 % If there are less than 20 bins (20 x 50ms = 1 second), then the learning period could be longer than decision making which would imbalance the matrix.
                    diff = 20 - size(dmSpect,1); % Find the number of rows we need to add.
                    nanarray = nan(diff,5,38); % Make a n,5,38 nan matrix to add to the spectrum.
                    dmSpect = vertcat(dmSpect,nanarray); % Add the nans to the spectrum.
                end
                table_dm_correct = vertcat(table_dm_correct, dmSpect); % Add this trial to the overall table for decision-making for correct trials.
                
                % LEARNING %
                tmpdata = cleandatacorrectln.trial{1,i}'; % LFP data for individual trial.
                [spectln,lntim,freqs] = mtspecgramc(tmpdata,movingwin,params); % Power spectrum for each trial.
                lnSpect = 10*log(spectln); % Converts to decibels.
                % Clustering
                counter = 0;
                j = 1;
                working = nan(21, length(freqs), 10);
                hold = nan(21, length(freqs), 38);
                p = 1;
                while j<size(lnSpect,3)
                    counter = counter + 1;
                    working(:,:,counter) = lnSpect(:,:,j);
                    if counter == 10
                        hold(:,:,p) = mean(working, 3);
                        counter = 0;
                        working = nan(21, length(freqs), 10);
                        p = p + 1;
                    end
                    j = j + 1;
                end
                lnSpect = hold;
                % Binning
                x = size(lnSpect,1);
                totalBins = floor(x/5);
                counter = 0;
                j = 1;
                working = nan(5, length(freqs), 38);
                hold = nan(totalBins, length(freqs), 38);
                p = 1;
                while j<size(lnSpect,1)
                    counter = counter + 1;
                    working(counter,:,:) = lnSpect(j,:,:);
                    if counter == 5
                        hold(p,:,:) = mean(working, 1);
                        counter = 0;
                        working = nan(5, length(freqs), 38);
                        p = p + 1;
                    end
                    j = j + 1;
                end
                lnSpect = hold;
                % Frequency Bands
                theta = nan(size(lnSpect,1),1,38);
                alpha = nan(size(lnSpect,1),1,38);
                beta = nan(size(lnSpect,1),1,38);
                lowgamma = nan(size(lnSpect,1),1,38);
                highgamma = nan(size(lnSpect,1),1,38);
                for h=1:38
                    thetasub = [];
                    alphasub = [];
                    betasub = [];
                    lowgammasub = [];
                    highgammasub = [];
                    for o=1:82
                        if freqs(o) > 4 && freqs(o) < 8
                            thetasub = horzcat(thetasub,lnSpect(:,o,h));
                        elseif freqs(o) > 8 && freqs(o) < 12
                            alphasub = horzcat(alphasub,lnSpect(:,o,h));
                        elseif freqs(o) > 13 && freqs(o) < 30
                            betasub = horzcat(betasub,lnSpect(:,o,h));
                        elseif freqs(o) > 30 && freqs(o) < 50
                            lowgammasub = horzcat(lowgammasub,lnSpect(:,o,h));
                        elseif freqs(o) > 70 && freqs(o) < 100
                            highgammasub = horzcat(highgammasub,lnSpect(:,o,h));
                        end
                    end
                    theta(:,1,h) = mean(thetasub,2);
                    alpha(:,1,h) = mean(alphasub,2);
                    beta(:,1,h) = mean(betasub,2);
                    lowgamma(:,1,h) = mean(lowgammasub,2);
                    highgamma(:,1,h) = mean(highgammasub,2);
                end
                lnSpect = horzcat(theta,beta,alpha,lowgamma,highgamma);
                % Adding nans
                if size(dmSpect,1) > size(lnSpect,1) % If the decision-making spectrum is larger, we need to add nans to learning so the lengths match.
                    diff = size(dmSpect,1) - size(lnSpect,1); % Find the number of rows we need.
                    nanarray = nan(diff,5,38); % Make the matrix of nans
                    lnSpect = vertcat(lnSpect,nanarray); % Add the nan matrix to the learning spectrum.
                end
                table_ln_correct = vertcat(table_ln_correct, lnSpect);
            end

            % INCORRECT TRIALS %
            incorrectSegments = [round(incorrectInitiationT*2500)-625;round(incorrectResponseT*2500) + 3125]';
            cleandataincorrect = get_clean_NP_data_automatic_ES(trimmedData, RawData.Timestamps, incorrectSegments);
            incorrectlnsegments = [round(incorrectResponseT * 2500)-625;round(incorrectResponseT * 2500) + 3125]';
            cleandataincorrectln = get_clean_NP_data_automatic_ES(trimmedData, RawData.Timestamps, incorrectlnsegments);
            %for i=1:size(cleandataincorrect.trial,2) % Iterate through all correct trials.
            for i=1:3
                % DECISION MAKING %
                tmpdata = cleandataincorrect.trial{1,i}'; % LFP data for individual trial.
                [spectinc,timinc,freqs] = mtspecgramc(tmpdata,movingwin,params); % Power spectrum for each trial.
                spectinc = 10*log(spectinc); % Converts to decibels.
                adjustedRT = cleandataincorrect.time{1,i}(end) - 1.25; % cleandataincorrect.time{1,i}(end) is the end of the learning period. We know this will always be 1.25 seconds after the response time.
                foundIndex = 0;
                for z=1:length(timinc)
                    if foundIndex == 0 && timinc(z) >= adjustedRT
                        foundIndex = 1;
                        respIndex = z - 1;
                    end
                end
                dmSpectinc = spectinc(1:respIndex,:,:); % dmspect is 3D = time * frequency * channel
                % Clustering
                counter = 0;
                j = 1;
                working = nan(respIndex, length(freqs), 10);
                hold = nan(respIndex, length(freqs), 38);
                p = 1;
                while j<size(dmSpectinc,3)
                    counter = counter + 1;
                    working(:,:,counter) = dmSpectinc(:,:,j);
                    if counter == 10
                        hold(:,:,p) = mean(working, 3);
                        counter = 0;
                        working = nan(respIndex, length(freqs), 10);
                        p = p + 1;
                    end
                    j = j + 1;
                end
                dmSpectinc = hold;
                % Binning
                x = size(dmSpectinc,1);
                totalBins = floor(x/5);
                counter = 0;
                j = 1;
                working = nan(5, length(freqs), 38);
                hold = nan(totalBins, length(freqs), 38);
                p = 1;
                while j<size(dmSpectinc,1)
                    counter = counter + 1;
                    working(counter,:,:) = dmSpectinc(j,:,:);
                    if counter == 5
                        hold(p,:,:) = mean(working, 1);
                        counter = 0;
                        working = nan(5, length(freqs), 38);
                        p = p + 1;
                    end
                    j = j + 1;
                end
                dmSpectinc = hold;
                % Frequency Bands
                theta = nan(size(dmSpectinc,1),1,38);
                alpha = nan(size(dmSpectinc,1),1,38);
                beta = nan(size(dmSpectinc,1),1,38);
                lowgamma = nan(size(dmSpectinc,1),1,38);
                highgamma = nan(size(dmSpectinc,1),1,38);
                for h=1:38
                    thetasub = [];
                    alphasub = [];
                    betasub = [];
                    lowgammasub = [];
                    highgammasub = [];
                    for o=1:82
                        if freqs(o) > 4 && freqs(o) < 8
                            thetasub = horzcat(thetasub,dmSpectinc(:,o,h));
                        elseif freqs(o) > 8 && freqs(o) < 12
                            alphasub = horzcat(alphasub,dmSpectinc(:,o,h));
                        elseif freqs(o) > 13 && freqs(o) < 30
                            betasub = horzcat(betasub,dmSpectinc(:,o,h));
                        elseif freqs(o) > 30 && freqs(o) < 50
                            lowgammasub = horzcat(lowgammasub,dmSpectinc(:,o,h));
                        elseif freqs(o) > 70 && freqs(o) < 100
                            highgammasub = horzcat(highgammasub,dmSpectinc(:,o,h));
                        end
                    end
                    theta(:,1,h) = mean(thetasub,2);
                    alpha(:,1,h) = mean(alphasub,2);
                    beta(:,1,h) = mean(betasub,2);
                    lowgamma(:,1,h) = mean(lowgammasub,2);
                    highgamma(:,1,h) = mean(highgammasub,2);
                end
                dmSpectinc = horzcat(theta,beta,alpha,lowgamma,highgamma);
                % Adding nans
                if size(dmSpectinc,1) < 20
                    diff = 20 - size(dmSpectinc,1);
                    nanarray = nan(diff,5,38);
                    dmSpectinc = vertcat(dmSpectinc,nanarray);
                end
                table_dm_incorrect = vertcat(table_dm_incorrect, dmSpectinc);
                
                % LEARNING %
                tmpdata = cleandataincorrectln.trial{1,i}'; % LFP data for individual trial.
                [spectlnic,lntim,freqs] = mtspecgramc(tmpdata,movingwin,params); % Power spectrum for each trial.
                lnSpectinc = 10*log(spectlnic); % Converts to decibels.
                % Clustering
                counter = 0;
                j = 1;
                working = nan(21, length(freqs), 10);
                hold = nan(21, length(freqs), 38);
                p = 1;
                while j<size(lnSpect,3)
                    counter = counter + 1;
                    working(:,:,counter) = lnSpectinc(:,:,j);
                    if counter == 10
                        hold(:,:,p) = mean(working, 3);
                        counter = 0;
                        working = nan(21, length(freqs), 10);
                        p = p + 1;
                    end
                    j = j + 1;
                end
                lnSpectinc = hold;
                % Binning
                x = size(lnSpectinc,1);
                totalBins = floor(x/5);
                counter = 0;
                j = 1;
                working = nan(5, length(freqs), 38);
                hold = nan(totalBins, length(freqs), 38);
                p = 1;
                while j<size(lnSpectinc,1)
                    counter = counter + 1;
                    working(counter,:,:) = lnSpectinc(j,:,:);
                    if counter == 5
                        hold(p,:,:) = mean(working, 1);
                        counter = 0;
                        working = nan(5, length(freqs), 38);
                        p = p + 1;
                    end
                    j = j + 1;
                end
                lnSpectinc = hold;
                % Frequency Bands
                theta = nan(size(lnSpectinc,1),1,38);
                alpha = nan(size(lnSpectinc,1),1,38);
                beta = nan(size(lnSpectinc,1),1,38);
                lowgamma = nan(size(lnSpectinc,1),1,38);
                highgamma = nan(size(lnSpectinc,1),1,38);
                for h=1:38
                    thetasub = [];
                    alphasub = [];
                    betasub = [];
                    lowgammasub = [];
                    highgammasub = [];
                    for o=1:82
                        if freqs(o) > 4 && freqs(o) < 8
                            thetasub = horzcat(thetasub,lnSpectinc(:,o,h));
                        elseif freqs(o) > 8 && freqs(o) < 12
                            alphasub = horzcat(alphasub,lnSpectinc(:,o,h));
                        elseif freqs(o) > 13 && freqs(o) < 30
                            betasub = horzcat(betasub,lnSpectinc(:,o,h));
                        elseif freqs(o) > 30 && freqs(o) < 50
                            lowgammasub = horzcat(lowgammasub,lnSpectinc(:,o,h));
                        elseif freqs(o) > 70 && freqs(o) < 100
                            highgammasub = horzcat(highgammasub,lnSpectinc(:,o,h));
                        end
                    end
                    theta(:,1,h) = mean(thetasub,2);
                    alpha(:,1,h) = mean(alphasub,2);
                    beta(:,1,h) = mean(betasub,2);
                    lowgamma(:,1,h) = mean(lowgammasub,2);
                    highgamma(:,1,h) = mean(highgammasub,2);
                end
                lnSpectinc = horzcat(theta,beta,alpha,lowgamma,highgamma);
                % Adding nans
                if size(dmSpectinc,1) > size(lnSpectinc,1)
                    diff = size(dmSpectinc,1) - size(lnSpectinc,1);
                    nanarray = nan(diff,5,38);
                    lnSpectinc = vertcat(lnSpectinc,nanarray);
                end
                table_ln_incorrect = vertcat(table_ln_incorrect, lnSpectinc);
            end
            table_dm = vertcat(table_dm_correct, table_dm_incorrect); % Stack correct on top of incorrect for decision making
            table_ln = vertcat(table_ln_correct, table_ln_incorrect); % Stack correct on top of incorrect for learning
            final_table = horzcat(table_dm, table_ln); % Combine the decision making and learning tables together. This final table is added to the LASSO table.
        end
    end
end
