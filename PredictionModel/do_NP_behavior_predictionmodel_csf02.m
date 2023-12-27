

% load('z:\projmon\ericsprojects\Setshift\DATA\PredictionModel\CSF02_lfp_predictionmodel_09242023.mat','lfpdata')
load('z:\projmon\ericsprojects\Setshift\DATA\PredictionModel\CSF02_lfp_predictionmodel_09242023.mat','lfpdata')
x = lfpdata.prelimbic.correctsampleinfo(:,1)+1; % timestamps (seconds)
y = lfpdata.prelimbic.incorrectsampleinfo(:,1)+1;
dy = 3;
data(dy).logfn = 'Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\CSF02_2021_09_24__15_17_02.csv';

T_correct = NaN(1,5);  T_incorrect = NaN(1,5);

  % behavioral timestamps
            setshift=read_set_shift_behavior_one_file_only_imcomplete_session(data(dy).logfn);
            correctT = [];incorrectT = [];
            for rl=1:length(setshift.rules)
                for bl=1:length(setshift.rules(rl).blocks)
                    for tl = 1:length(setshift.rules(rl).blocks(bl).trials)
                        if setshift.rules(rl).blocks(bl).trials(tl).performance == 1 && ismember(round(setshift.rules(rl).blocks(bl).trials(tl).response_time),round(x))
                            % when would ismember ever be true?
T_correct(end+1,(1:5)) = [setshift.rules(rl).blocks(bl).trials(tl).response_time,setshift.rules(rl).blocks(bl).trials(tl).response_latency,rl,bl,tl]; 
correctT = [correctT;setshift.rules(rl).blocks(bl).trials(tl).initiation_time,setshift.rules(rl).blocks(bl).trials(tl).response_time];
                        elseif setshift.rules(rl).blocks(bl).trials(tl).performance == 0 && ismember(round(setshift.rules(rl).blocks(bl).trials(tl).response_time),round(y))
                            T_incorrect(end+1,(1:5)) = [setshift.rules(rl).blocks(bl).trials(tl).response_time,setshift.rules(rl).blocks(bl).trials(tl).response_latency,rl,bl,tl]; %#ok<*SAGROW>
                            incorrectT = [incorrectT,; setshift.rules(rl).blocks(bl).trials(tl).initiation_time, setshift.rules(rl).blocks(bl).trials(tl).response_time];
                        end
                    end
                end
            end



T_correct(1,:) = []; T_incorrect(1,:) = [];

T_correct = sortrows(T_correct,1,"ascend");
table_correct = array2table(T_correct);
table_correct.Properties.VariableNames(1) = "ResponseTime";
table_correct.Properties.VariableNames(2) = "ResponseLatency";
table_correct.Properties.VariableNames(3) = "RuleID";
table_correct.Properties.VariableNames(4) = "BlockNum";
table_correct.Properties.VariableNames(5) = "TrialNum";


T_incorrect = sortrows(T_incorrect,1,"ascend");
table_incorrect = array2table(T_incorrect);
table_incorrect.Properties.VariableNames(1) = "ResponseTime";
table_incorrect.Properties.VariableNames(2) = "ResponseLatency";
table_incorrect.Properties.VariableNames(3) = "RuleID";
table_incorrect.Properties.VariableNames(4) = "BlockNum";
table_incorrect.Properties.VariableNames(5) = "TrialNum";


save(fullfile('z:\projmon\ericsprojects\Setshift\DATA\PredictionModel','CSF02_behav_predictionmodel_correcttrials_09242023'),'table_correct','-v7.3')
save(fullfile('z:\projmon\ericsprojects\Setshift\DATA\PredictionModel','CSF02_behav_predictionmodel_incorrecttrials_09242023'),'table_incorrect','-v7.3')