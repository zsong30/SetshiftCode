function setshift = read_set_shift_behavior_one_file_only(logfn)
% this function setshift = read_set_shift_data_one_file_only
% is to read in set shift data one file at a time
% written by Eric Song Mar. 2021
% updated by Eric Song Nov.26 2021

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
        
        %     if strcmp(setshift.protocolname,'protocol46')
        %         %%% first changing all F1 to F2
        %         IndexF1 = find(contains(T{:,5},'F1'));
        %         for F = 1: length(IndexF1)
        %             T{IndexF1,5}{F}(end-4)= '2';
        %         end
        %         %%% second F2 is labeled as F1.
        %         index2revise = find(strcmp(T{:,5},'Food delivery F2 5-5'));
        %         IndexF2 = find(contains(T{:,5},'F2'));
        %         indexF2_1 = IndexF2(IndexF2>index2revise(2));
        %         for F = 1: length(indexF2_1)
        %             T{indexF2_1,5}{F}(end-4)= '1';
        %         end
        %
        % %     elseif strcmp(setshift.protocolname,'protocol47')
        % %         %%% error 1: second F1 is labeled as F2.
        % %         index2revise = find(strcmp(T{:,5},'Food delivery F1 5-5'));
        % %         IndexF1 = find(contains(T{:,5},'F1'));
        % %         indexF1_2 = IndexF1(IndexF1>index2revise(2));
        % %         for F = 1: length(indexF1_2)
        % %             T{indexF1_2,5}{F}(end-4)= '2';
        % %         end
        % %
        %     else
        %     end
        
        
        % read in ratname, etc..
        %setshift.ratname = char(T{1,6});
        setshift.testdate = char(T{6,6});
        setshift.endtime = T{end,2};
        
        block2include = {'1-5','2-5','3-5','4-5','5-5'};
        rules = {'L1','L2','L3','L4','R1','R2','F1','F2'};
        
        for rl = 1:8 % loop in rules, 8 of them
            setshift.rules(rl).name = rules{rl};
            for bl = 1:5 % loop in blocks, 5 of them
                setshift.rules(rl).blocks(bl).name = block2include{bl};
                performEval = []; % for correct vs incorrect choices, 1 or 0
                blocktimes = []; % see below, times for ephys analyses
                frChoices = [];
                ltSeq = [];
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
                        
                    end % if contains(T{i,5},trials2include{trl})&&contains(T{i,5},rules{rl}) &&...
                    
                    for tr = 1:length(blocktimes)/4
                        setshift.rules(rl).blocks(bl).trials(tr).start = blocktimes(4*tr-3); % 1st ones, initiation
                        setshift.rules(rl).blocks(bl).trials(tr).end = blocktimes(4*tr); % last ones, response
                        setshift.rules(rl).blocks(bl).trials(tr).response_latency =...
                            blocktimes(4*tr)-blocktimes(4*tr-2); % last ones minus 2nd ones (cue on)
                        setshift.rules(rl).blocks(bl).trials(tr).response_time = blocktimes(4*tr); % when rats respond
                        setshift.rules(rl).blocks(bl).trials(tr).initiation_latency =...
                            blocktimes(4*tr-2)-blocktimes(4*tr-3); % 2nd ones minus 1st ones (cue on)
                        setshift.rules(rl).blocks(bl).trials(tr).initiation_time = blocktimes(4*tr-2); % when rats nosepoke the middle hole
                        setshift.rules(rl).blocks(bl).trials(tr).interval = ...
                            [blocktimes(4*tr)+4.02,blocktimes(4*tr)+6.02];
                        % taking just 2 seconds from interval, rats may be chewing
                        % so we will take the later 2 secs of the 7s interval. 
                        setshift.rules(rl).blocks(bl).trials(tr).performance = performEval(tr,1);
                        
                        %%%from Evan for the light/choice information
                        setshift.rules(rl).blocks(bl).trials(tr).front=frChoices(tr);
                        if ~isnan(frChoices(tr))
                            setshift.rules(rl).blocks(bl).trials(tr).light=(frChoices(tr)&&ltSeq(tr))||(~frChoices(tr)&&~ltSeq(tr));
                        else
                            setshift.rules(rl).blocks(bl).trials(tr).light=NaN;
                        end
                        
                        
                    end
                    
                    setshift.rules(rl).blocks(bl).performEval = performEval;
                    
                end % for i = 1:length(T{:,5})
                
            end % end of bl = 1:5
            
        end % for rl = 1:8
               
        
        mn_resp_latcy = nan(length(setshift.rules),5); mn_init_latcy = mn_resp_latcy; % mean latencies 8 x 5;
        for rl = 1:length(setshift.rules)
            rules=struct; rules(rl).performance = [];
            for bl = 1:length(setshift.rules(rl).blocks)
                rules(rl).performance = [rules(rl).performance;setshift.rules(rl).blocks(bl).performEval];
                resp_latcy=0; init_latcy=0; 
                for trl = 1:length(setshift.rules(rl).blocks(bl).trials)
                    resp_latcy=resp_latcy+setshift.rules(rl).blocks(bl).trials(trl).response_latency;
                    init_latcy=init_latcy+setshift.rules(rl).blocks(bl).trials(trl).initiation_latency;
                end
                mn_resp_latcy(rl,bl)=resp_latcy/length(setshift.rules(rl).blocks(bl).trials); % mean response_latency across all trials within a block
                mn_init_latcy(rl,bl)=init_latcy/length(setshift.rules(rl).blocks(bl).trials); 
            end
            
            rules(rl).performance=sortrows(rules(rl).performance,2);
            setshift.rules(rl).performance = rules(rl).performance(:,1); % 1 is correct and 0 is incorrect, in chronological order. 
            setshift.rules(rl).response_latency = mean(mn_resp_latcy(rl,:),2); % now mean response_latency across all blocks
            setshift.rules(rl).initiation_latency = mean(mn_init_latcy(rl,:),2); % now mean response_latency across all blocks
            
            if rules(rl).performance(1,1) == 0
                index=find(rules(rl).performance(:,1)==1,1);
                rules(rl).persevarative = index -2; %#ok<*SAGROW> % the 1st error ignored.
            elseif rules(rl).performance(1,1) == 1
                index=find(rules(rl).performance(2:end,1)==1,1);
                rules(rl).persevarative = index -1; %#ok<*SAGROW>
            end
            
            rules(rl).postpersevarative = 0;
            for i = index+1:size(rules(rl).performance,1)
                if rules(rl).performance(i,1)== 0
                    rules(rl).postpersevarative = rules(rl).postpersevarative +1;
                elseif rules(rl).performance(i,1)==1
                    if rules(rl).performance(i+1,1)==1&&...
                            rules(rl).performance(i+2,1)==1&&...
                        rules(rl).performance(i+3,1)==1
                        rules(rl).regressive =...
                            length(find(rules(rl).performance(i+4:end,1)==0));
                        break
                    else
                    end
                    
                end
                
            end
            setshift.rules(rl).persevarative = rules(rl).persevarative;
            setshift.rules(rl).postpersevarative = rules(rl).postpersevarative;
            setshift.rules(rl).regressive = rules(rl).regressive;
        end
    end
else
end

