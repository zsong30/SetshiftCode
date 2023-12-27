function trialsegments = get_set_shift_behavior_times(logfn,minsec)
% trialsegments = getTrialTimes(logfn,minsec) is to get trial times for lfp
% analyses.
% Written by Eric Song, Apr, 2021.

% read in setshift behavior data
%logfn = 'CSF01_2021_02_25__10_43_02.csv';
% minsec = 2; minimal seconds for lfp
setshift = read_set_shift_behavior_one_file_only(logfn);

intervals_correct = []; bl_interval_correct = []; intervaltimes_correct = [];
task_correct = []; bl_task_correct = []; tasktimes_correct = [];
task_incorrect = [];bl_task_incorrect = [];tasktimes_incorrect = [];
intervals_incorrect = []; bl_interval_incorrect = []; intervaltimes_incorrect = [];

for rl = 1:length(setshift.rules)
    for bl = 1:length(setshift.rules(rl).blocks)
        for trl = 1:length(setshift.rules(rl).blocks(bl).trials)
            if setshift.rules(rl).blocks(bl).trials(trl).end - ...
                    setshift.rules(rl).blocks(bl).trials(trl).start > minsec
                if setshift.rules(rl).blocks(bl).performEval(trl,1) == 1
                    task_correct = ...
                        [task_correct; setshift.rules(rl).blocks(bl).trials(trl).start, setshift.rules(rl).blocks(bl).trials(trl).end]; %#ok<*AGROW>
                    intervals_correct = [intervals_correct;setshift.rules(rl).blocks(bl).trials(trl).interval];
                elseif setshift.rules(rl).blocks(bl).performEval(trl,1) == 0
                    task_incorrect = ...
                        [task_incorrect; setshift.rules(rl).blocks(bl).trials(trl).start, setshift.rules(rl).blocks(bl).trials(trl).end];
                    intervals_incorrect = [intervals_incorrect;setshift.rules(rl).blocks(bl).trials(trl).interval];
                end
            else
            end
        end
        
        bl_interval_correct = [bl_interval_correct;intervals_correct]; bl_task_correct = [bl_task_correct; task_correct];
        intervals_correct = []; task_correct = [];
        bl_interval_incorrect = [bl_interval_incorrect;intervals_incorrect]; bl_task_incorrect = [bl_task_incorrect; task_incorrect];
        intervals_incorrect = []; task_incorrect = [];
        
    end
    
    intervaltimes_correct = [intervaltimes_correct;bl_interval_correct]; bl_interval_correct = [];
    tasktimes_correct = [tasktimes_correct; bl_task_correct];bl_task_correct = [];
    intervaltimes_incorrect = [intervaltimes_incorrect;bl_interval_incorrect]; bl_interval_incorrect = [];
    tasktimes_incorrect = [tasktimes_incorrect; bl_task_incorrect]; bl_task_incorrect = [];
    
    if rl < 5
        trialsegments(1).name = 'lighttrials';
        trialsegments(1).intervaltimes_correct = intervaltimes_correct;
        trialsegments(1).intervaltimes_incorrect = intervaltimes_incorrect;
        trialsegments(1).tasktimes_correct = tasktimes_correct;
        trialsegments(1).tasktimes_incorrect = tasktimes_incorrect;
    elseif rl == 5 || rl == 6
        trialsegments(2).name = 'reartrials';
        trialsegments(2).intervaltimes_correct = intervaltimes_correct;
        trialsegments(2).intervaltimes_incorrect = intervaltimes_incorrect;
        trialsegments(2).tasktimes_correct = tasktimes_correct;
        trialsegments(2).tasktimes_incorrect = tasktimes_incorrect;
        
    elseif rl == 7 || rl == 8
        trialsegments(3).name = 'fronttrials';
        trialsegments(3).intervaltimes_correct = intervaltimes_correct;
        trialsegments(3).intervaltimes_incorrect = intervaltimes_incorrect;
        trialsegments(3).tasktimes_correct = tasktimes_correct;
        trialsegments(3).tasktimes_incorrect = tasktimes_incorrect;
        
    end
    
    
end

