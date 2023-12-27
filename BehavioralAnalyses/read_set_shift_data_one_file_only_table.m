function setshift = read_set_shift_data_one_file_only_table(logfn)
% this function setshift = read_set_shift_data_one_file_only_table
% is to read in set shift data one file at a time and output a behavior table
% with one entry for each trial
% written by Evan Dastin-van Rijn December 2021

% create the struct
setshift = struct;

% read in the .csv file, that is, the raw data file
% tmpfn = dir('*.csv');
% logfn = tmpfn(end).name;
opts = detectImportOptions(logfn);
opts.Delimiter = {','};
opts.DataLines = [1 Inf];
opts.PreserveVariableNames = true;
T = readtable(logfn,opts);

setshift.protocolname = char(T{2,6});
% only read in protocols40-47 and sessions that did not reach 90min
if contains(setshift.protocolname,'protocol')&& T{end,2} ~=5400
    % Map states to what side the light was on (1=front)
    stateMap=containers.Map({54,61,67,73,79,86,92,98,104,110,117,123,129,...
        135,141,148,154,160,166,172,179,185,191,197,203,210,216,222,228,...
        234,241,247,253,259,265,297,303,309,315,321},...
        {1,0,1,0,0,1,0,1,1,0,0,1,0,1,0,0,1,1,0,0,1,1,0,0,1,1,1,0,...
        1,0,0,1,0,1,1,0,1,1,0,0});
    if isempty(find(T{:,4} == 85,1) |...
            find(T{:,4} == 112,1) |...
            find(T{:,4} == 147,1) |...
            find(T{:,4} == 174,1) |...
            find(T{:,4} == 209,1) |...
            find(T{:,4} == 236,1)|...
            find(T{:,4} == 296,1) |...
            find(T{:,4} == 323,1) |...
            find(T{:,4} == 53,1) |...
            find(T{:,4} == 81,1) |...
            find(T{:,4} == 178,1) |...
            find(T{:,4} == 205,1) |...
            find(T{:,4} == 116,1) |...
            find(T{:,4} == 143,1) |...
            find(T{:,4} == 240,1) |...
            find(T{:,4} == 267,1))
        % if true, do nothing because that means task was incomplete or it reached 90min 
    else
        % define ranges for each rule  
        L1(1) = find(T{:,4} == 85 & strcmp(T{:,3},'Entry'), 1);
        L1(2) = find(T{:,4} == 112,1);
        L2(1) = find(T{:,4} == 147 & strcmp(T{:,3},'Entry'), 1);
        L2(2) = find(T{:,4} == 174,1);
        L3(1) = find(T{:,4} == 209 & strcmp(T{:,3},'Entry'), 1);
        L3(2) = find(T{:,4} == 236,1);
        L4(1) = find(T{:,4} == 296 & strcmp(T{:,3},'Entry'), 1);
        L4(2) = find(T{:,4} == 323,1);
        R1(1) = find(T{:,4} == 53 & strcmp(T{:,3},'Entry'), 1);
        R1(2) = find(T{:,4} == 81,1);
        R2(1) = find(T{:,4} == 178 & strcmp(T{:,3},'Entry'), 1);
        R2(2) = find(T{:,4} == 205,1);
        F1(1) = find(T{:,4} == 116 & strcmp(T{:,3},'Entry'), 1);
        F1(2) = find(T{:,4} == 143,1);
        F2(1) = find(T{:,4} == 240 & strcmp(T{:,3},'Entry'), 1);
        F2(2) = find(T{:,4} == 267,1);
        rule(1).index = L1; % index/line numbers
        rule(2).index = L2;
        rule(3).index = L3;
        rule(4).index = L4;
        rule(5).index = R1;
        rule(6).index = R2;
        rule(7).index = F1;
        rule(8).index = F2;
                        
        %%%% now fixing errors in the raw data
        %%% error 1: all L3 (Light rule 3) is labeled as L2.
        %     index2revise = find(strcmp(T{:,5},'Food delivery L2 5-5'));
        %     IndexL2 = find(contains(T{:,5},'L2'));
        %     indexL2_3 = IndexL2(IndexL2>index2revise(2));
        %     for L = 1: length(indexL2_3)
        %         T{indexL2_3,5}{L}(end-4)= '3';
        %     end
        %%%% error 2: inconsistent output, both '20 ms interval'
        %%% and '20 ms interval correct' are used that mean
        %%% the same thing.
        index2revise2 = find(strcmp(T{:,5},'20 ms interval'));
        for C = 1:length(index2revise2)
            T{index2revise2,5}{C} = '20 ms interval correct';
        end 
        
        % read in ratname, etc..
        %setshift.ratname = char(T{1,6});
        setshift.testdate = char(T{6,6});
        setshift.endtime = T{end,2};
        
        block2include = {'1-5','2-5','3-5','4-5','5-5'};
        rules = {'L1','L2','L3','L4','R1','R2','F1','F2'};
        tn=0;
        
        for rl = 1:8 % loop in rules, 8 of them
            for bl = 1:5 % loop in blocks, 5 of them
                setshift.rules(rl).blocks(bl).name = block2include{bl};
                performEval = []; % for correct vs incorrect choices, 1 or 0
                frChoices = [];
                ltSeq = [];
                blocktimes = []; % see below, times for ephys analyses
                for i = 1:length(T{:,5}) % read through the raw data file
                    if endsWith(T{i,5},block2include{bl})&&i>=rule(rl).index(1)&&...
                            i<= rule(rl).index(2)&& ~contains(T{i,5},'Food delivery')
                        blocktimes = [blocktimes,T{i,2}]; %#ok<AGROW>
                        % this will put out 4 time points for each trial
                        % excluding (if correct trial)the '20ms interval correct' before
                        % food delivery, food delivery, and 7s interval; also
                        % excluding (if incorrect trial)10ms 'interval error' and
                        % '7s interval error'
                        %%%%% the first and last of the 4 time points will be used as
                        %%%%% the trial duration (we want to exclude food delievery
                        %%%%% and rats chewing food)
                        
                        % Get the side the light was on for each trial
                        if isKey(stateMap,T{i,4})
                            ltSeq=[ltSeq,stateMap(T{i,4})];
                        end
                        if contains(T{i+1,5},'error')
                            performEval = [performEval;0,T{i+1,2}];  %#ok<AGROW> % 0 is incorrect, 2nd column is time.
                            if strcmp(T{i-1,5},'Rear')
                                frChoices=[frChoices,0];
                            elseif strcmp(T{i-1,5},'Front')
                                frChoices=[frChoices,1];
                            else
                                frChoices=[frChoices,NaN];
                            end
                        elseif contains(T{i+1,5},'correct')
                            performEval = [performEval;1,T{i+1,2}];  %#ok<AGROW> % 1 is correct, 2nd column is time.
                            if strcmp(T{i-1,5},'Rear')
                                frChoices=[frChoices,0];
                            elseif strcmp(T{i-1,5},'Front')
                                frChoices=[frChoices,1];
                            else
                                frChoices=[frChoices,NaN];
                            end
                        end
                        
                    else
                        
                    end % if endsWith(T{i,5},trials2include{trl})&&contains(T{i,5},rules{rl}) &&...
                end % for i = 1:length(T{:,5})
                for tr = 1:length(blocktimes)/4
                    tn=tn+1;
                    setshift.data(tn).cueTime=blocktimes(4*tr-3);
                    setshift.data(tn).initTime=blocktimes(4*tr-2);
                    setshift.data(tn).respTime=blocktimes(4*tr);
                    setshift.data(tn).RT=blocktimes(4*tr)-blocktimes(4*tr-2);
                    setshift.data(tn).rule=rules(rl);
                    setshift.data(tn).block=bl;
                    setshift.data(tn).performance=performEval(tr,1);
                    setshift.data(tn).error=~performEval(tr,1);
                    setshift.data(tn).front=frChoices(tr);
                    if ~isnan(frChoices(tr))
                        setshift.data(tn).light=(frChoices(tr)&&ltSeq(tr))||(~frChoices(tr)&&~ltSeq(tr));
                    else
                        setshift.data(tn).light=NaN;
                    end
                end
                
            end % end of bl = 1:5
            
        end % for rl = 1:8
        [~,I]=sort([setshift.data.cueTime]);
        setshift.data=setshift.data(I);
        for rl=1:8
            trialsForRule=setshift.data(strcmp([setshift.data.rule],rules(rl)));
            % Evan: added perseverative error tracking per trial
            if trialsForRule(1).error == 1
                index=find([trialsForRule.error]==0,1);
                trialsForRule(1).error=0;
                for i=2:index-1
                    trialsForRule(i).error=1;
                end
            elseif trialsForRule(1).error == 0
                index=find([trialsForRule(2:end).error]==0,1);
                % First there will be a correct trial in block 1, first error
                % would be an error in block 2 or later, subsequent errors would be in block
                % 1
                trialsForRule(1).error=0;
                for i=1:index-1
                    trialsForRule(i+1).error=1;
                end
                index=index+1;
            end
            for i = index+1:length(trialsForRule)
                if trialsForRule(i).error==1
                    trialsForRule(i).error=2;
                else
                    if i+3<=length(trialsForRule) && trialsForRule(i+1).error==0&&...
                            trialsForRule(i+2).error==0&&...
                            trialsForRule(i+3).error==0
                        % Evan: added regressive error tracking per trial
                        for j=i:length(trialsForRule)
                            if trialsForRule(j).error==1
                                trialsForRule(j).error=3;
                            end
                        end
                        break
                    end
                end
            end
            setshift.data(strcmp([setshift.data.rule],rules(rl)))=trialsForRule;
        end
    end
end

