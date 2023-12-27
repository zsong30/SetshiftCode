function trialsegments = getTrialTimes(logfn,minsec)
% trialsegments = getTrialTimes(logfn,minsec) is to get trial times for lfp
% analyses.
% Written by Eric Song, Apr, 2021.
% modified by Evan DvR Sep. 2021

% read in setshift behavior data
%logfn = 'CSF01_2021_02_25__10_43_02.csv';
% minsec = 2; minimal seconds for lfp
setshift = read_set_shift_data_one_file_only_updated(logfn);

% Evan: added time tracking based on error type
intervals_correct = []; bl_interval_correct = []; intervaltimes_correct = [];
task_correct = []; bl_task_correct = []; tasktimes_correct = [];
task_incorrect = [];bl_task_incorrect = [];tasktimes_incorrect = [];
intervals_incorrect = []; bl_interval_incorrect = []; intervaltimes_incorrect = [];
task_perseverative = []; bl_task_perseverative = []; tasktimes_perseverative = [];
intervals_perseverative = []; bl_interval_perseverative = []; intervaltimes_perseverative = [];
task_post_perseverative = []; bl_task_post_perseverative = []; tasktimes_post_perseverative = [];
intervals_post_perseverative = []; bl_interval_post_perseverative = []; intervaltimes_post_perseverative = [];
task_regressive = []; bl_task_regressive = []; tasktimes_regressive = [];
intervals_regressive = []; bl_interval_regressive = []; intervaltimes_regressive = [];

% Evan: changed start time to middle nosepoke time
for rl = 1:length(setshift.rules)
    for bl = 1:length(setshift.rules(rl).blocks)
        for trl = 1:length(setshift.rules(rl).blocks(bl).trials)
            % Evan: removed minimum trial length rejection
                if setshift.rules(rl).blocks(bl).performEval(trl,1) == 1
                    task_correct = ...
                        [task_correct; setshift.rules(rl).blocks(bl).trials(trl).end-setshift.rules(rl).blocks(bl).trials(trl).latency, setshift.rules(rl).blocks(bl).trials(trl).end]; %#ok<*AGROW>
                    intervals_correct = [intervals_correct;setshift.rules(rl).blocks(bl).trials(trl).interval];
                elseif setshift.rules(rl).blocks(bl).performEval(trl,1) == 0
                    task_incorrect = ...
                        [task_incorrect; setshift.rules(rl).blocks(bl).trials(trl).start-setshift.rules(rl).blocks(bl).trials(trl).latency, setshift.rules(rl).blocks(bl).trials(trl).end];
                    intervals_incorrect = [intervals_incorrect;setshift.rules(rl).blocks(bl).trials(trl).interval];
                    switch setshift.rules(rl).blocks(bl).trials(trl).error
                        case 1
                            task_perseverative = ...
                                [task_perseverative; setshift.rules(rl).blocks(bl).trials(trl).start-setshift.rules(rl).blocks(bl).trials(trl).latency, setshift.rules(rl).blocks(bl).trials(trl).end];
                            intervals_perseverative = [intervals_perseverative;setshift.rules(rl).blocks(bl).trials(trl).interval];
                        case 2
                            task_post_perseverative = ...
                                [task_post_perseverative; setshift.rules(rl).blocks(bl).trials(trl).start-setshift.rules(rl).blocks(bl).trials(trl).latency, setshift.rules(rl).blocks(bl).trials(trl).end];
                            intervals_post_perseverative = [intervals_post_perseverative;setshift.rules(rl).blocks(bl).trials(trl).interval];
                        case 3
                            task_regressive = ...
                                [task_regressive; setshift.rules(rl).blocks(bl).trials(trl).start-setshift.rules(rl).blocks(bl).trials(trl).latency, setshift.rules(rl).blocks(bl).trials(trl).end];
                            intervals_regressive = [intervals_regressive;setshift.rules(rl).blocks(bl).trials(trl).interval];
                    end
                end
        end
        
        bl_interval_correct = [bl_interval_correct;intervals_correct]; bl_task_correct = [bl_task_correct; task_correct];
        intervals_correct = []; task_correct = [];
        bl_interval_incorrect = [bl_interval_incorrect;intervals_incorrect]; bl_task_incorrect = [bl_task_incorrect; task_incorrect];
        intervals_incorrect = []; task_incorrect = [];
        bl_interval_perseverative = [bl_interval_perseverative;intervals_perseverative]; bl_task_perseverative = [bl_task_perseverative; task_perseverative];
        intervals_perseverative = []; task_perseverative = [];
        bl_interval_post_perseverative = [bl_interval_post_perseverative;intervals_post_perseverative]; bl_task_post_perseverative = [bl_task_post_perseverative; task_post_perseverative];
        intervals_post_perseverative = []; task_post_perseverative = [];
        bl_interval_regressive = [bl_interval_regressive;intervals_regressive]; bl_task_regressive = [bl_task_regressive; task_regressive];
        intervals_regressive = []; task_regressive = [];
    end
    
    intervaltimes_correct = [intervaltimes_correct;bl_interval_correct]; bl_interval_correct = [];
    tasktimes_correct = [tasktimes_correct; bl_task_correct];bl_task_correct = [];
    intervaltimes_incorrect = [intervaltimes_incorrect;bl_interval_incorrect]; bl_interval_incorrect = [];
    tasktimes_incorrect = [tasktimes_incorrect; bl_task_incorrect]; bl_task_incorrect = [];
    intervaltimes_perseverative = [intervaltimes_perseverative;bl_interval_perseverative]; bl_interval_perseverative = [];
    tasktimes_perseverative = [tasktimes_perseverative; bl_task_perseverative]; bl_task_perseverative = [];
    intervaltimes_post_perseverative = [intervaltimes_post_perseverative;bl_interval_post_perseverative]; bl_interval_post_perseverative = [];
    tasktimes_post_perseverative = [tasktimes_post_perseverative; bl_task_post_perseverative]; bl_task_post_perseverative = [];
    intervaltimes_regressive = [intervaltimes_regressive;bl_interval_regressive]; bl_interval_regressive = [];
    tasktimes_regressive = [tasktimes_regressive; bl_task_regressive]; bl_task_regressive = [];
    
    % Evan: fixed bug with trials being duplicated across rules
    if rl == 4
        trialsegments(1).name = 'lighttrials';
        trialsegments(1).intervaltimes_correct = intervaltimes_correct;
        trialsegments(1).intervaltimes_incorrect = intervaltimes_incorrect;
        trialsegments(1).tasktimes_correct = tasktimes_correct;
        trialsegments(1).tasktimes_incorrect = tasktimes_incorrect;
        trialsegments(1).intervaltimes_perseverative = intervaltimes_perseverative;
        trialsegments(1).tasktimes_perseverative = tasktimes_perseverative;
        trialsegments(1).intervaltimes_post_perseverative = intervaltimes_post_perseverative;
        trialsegments(1).tasktimes_post_perseverative = tasktimes_post_perseverative;
        trialsegments(1).intervaltimes_regressive = intervaltimes_regressive;
        trialsegments(1).tasktimes_regressive = tasktimes_regressive;
        intervaltimes_correct = []; intervaltimes_incorrect = []; tasktimes_correct = [];
        tasktimes_incorrect = []; intervaltimes_perseverative = []; tasktimes_perseverative = [];
        intervaltimes_post_perseverative = []; tasktimes_post_perseverative = [];
        intervaltimes_regressive = []; tasktimes_regressive = [];
    elseif rl == 6
        trialsegments(2).name = 'reartrials';
        trialsegments(2).intervaltimes_correct = intervaltimes_correct;
        trialsegments(2).intervaltimes_incorrect = intervaltimes_incorrect;
        trialsegments(2).tasktimes_correct = tasktimes_correct;
        trialsegments(2).tasktimes_incorrect = tasktimes_incorrect;
        trialsegments(2).intervaltimes_perseverative = intervaltimes_perseverative;
        trialsegments(2).tasktimes_perseverative = tasktimes_perseverative;
        trialsegments(2).intervaltimes_post_perseverative = intervaltimes_post_perseverative;
        trialsegments(2).tasktimes_post_perseverative = tasktimes_post_perseverative;
        trialsegments(2).intervaltimes_regressive = intervaltimes_regressive;
        trialsegments(2).tasktimes_regressive = tasktimes_regressive;
        intervaltimes_correct = []; intervaltimes_incorrect = []; tasktimes_correct = [];
        tasktimes_incorrect = []; intervaltimes_perseverative = []; tasktimes_perseverative = [];
        intervaltimes_post_perseverative = []; tasktimes_post_perseverative = [];
        intervaltimes_regressive = []; tasktimes_regressive = [];
    elseif rl == 8
        trialsegments(3).name = 'fronttrials';
        trialsegments(3).intervaltimes_correct = intervaltimes_correct;
        trialsegments(3).intervaltimes_incorrect = intervaltimes_incorrect;
        trialsegments(3).tasktimes_correct = tasktimes_correct;
        trialsegments(3).tasktimes_incorrect = tasktimes_incorrect;
        trialsegments(3).intervaltimes_perseverative = intervaltimes_perseverative;
        trialsegments(3).tasktimes_perseverative = tasktimes_perseverative;
        trialsegments(3).intervaltimes_post_perseverative = intervaltimes_post_perseverative;
        trialsegments(3).tasktimes_post_perseverative = tasktimes_post_perseverative;
        trialsegments(3).intervaltimes_regressive = intervaltimes_regressive;
        trialsegments(3).tasktimes_regressive = tasktimes_regressive;
        intervaltimes_correct = []; intervaltimes_incorrect = []; tasktimes_correct = [];
        tasktimes_incorrect = []; intervaltimes_perseverative = []; tasktimes_perseverative = [];
        intervaltimes_post_perseverative = []; tasktimes_post_perseverative = [];
        intervaltimes_regressive = []; tasktimes_regressive = [];
    end
    
    
end

