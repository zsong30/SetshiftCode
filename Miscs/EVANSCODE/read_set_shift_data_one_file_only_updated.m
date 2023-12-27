function setshift = read_set_shift_data_one_file_only_updated(logfn)
% this function setshift = read_set_shift_data_one_file_only_updated
% is to read in set shift data one file at a time
% written by Eric Song Mar. 2021
% modified by Evan DvR Sep. 2021

% create the struct
setshift = struct;

% assuming in the data folder and it has one .csv file.
% read in the .csv file, that is, the raw data file
% tmpfn = dir('*.csv');
% logfn = tmpfn.name;
opts = detectImportOptions(logfn);
opts.Delimiter = {','};
opts.DataLines = [1 Inf];
opts.PreserveVariableNames = true;
T = readtable(logfn,opts);

setshift.protocolname = char(T{2,6});
% only read in protocols44-47
if sum(strcmp(setshift.protocolname,{'protocol44','protocol45','protocol46','protocol47',}))==1
%%%% now fixing errors in the raw data
%%% error 1: all L3 (Light rule 3) is labeled as L2.
index2revise = find(strcmp(T{:,5},'Food delivery L2 5-5'));
IndexL2 = find(contains(T{:,5},'L2'));
indexL2_3 = IndexL2(IndexL2>index2revise(2));
for L = 1: length(indexL2_3)
    T{indexL2_3,5}{L}(end-4)= '3';
end
%%%% error 2: inconsistent output, both '20 ms interval'
%%% and '20 ms interval correct' are used that mean
%%% the same thing.
index2revise2 = find(strcmp(T{:,5},'20 ms interval'));
for C = 1:length(index2revise2)
    T{index2revise2,5}{C} = '20 ms interval correct';
end

if strcmp(setshift.protocolname,'protocol46')
    %%% first changing all F1 to F2
    IndexF1 = find(contains(T{:,5},'F1'));
    for F = 1: length(IndexF1)
        T{IndexF1,5}{F}(end-4)= '2'; %#ok<FNDSB>
    end
    %%% second F2 is labeled as F1.
    index2revise = find(strcmp(T{:,5},'Food delivery F2 5-5'));
    IndexF2 = find(contains(T{:,5},'F2'));
    indexF2_1 = IndexF2(IndexF2>index2revise(2));
    for F = 1: length(indexF2_1)
        T{indexF2_1,5}{F}(end-4)= '1';
    end
    
elseif strcmp(setshift.protocolname,'protocol47')
    %%% error 1: second F1 is labeled as F2.
    index2revise = find(strcmp(T{:,5},'Food delivery F1 5-5'));
    IndexF1 = find(contains(T{:,5},'F1'));
    indexF1_2 = IndexF1(IndexF1>index2revise(2));
    for F = 1: length(indexF1_2)
        T{indexF1_2,5}{F}(end-4)= '2';
    end
    
else
end


% read in ratname, etc..
setshift.ratname = char(T{1,6});
setshift.testdate = char(T{6,6});

% there may be cases we want to include just part of the trials/rules
% so we can adjust these here if needed.  
block2include = {'1-5','2-5','3-5','4-5','5-5'};
rules = {'L1','L2','L3','L4','R1','R2','F1','F2',};

for rl = 1:8 % loop in rules, 8 of them
    setshift.rules(rl).name = rules{rl};
    for bl = 1:5 % loop in blocks, 5 of them
        setshift.rules(rl).blocks(bl).name = block2include{bl};
        performEval = []; % for correct vs incorrect choices, 1 or 0 
        blocktimes = []; % see below, times for ephys analyses
        for i = 1:length(T{:,5}) % read through the raw data file
            % Evan: changed block comparison to endsWith to avoid cases
            % like R1-5-5 being counted as 1-5
            if endsWith(T{i,5},block2include{bl})&&contains(T{i,5},rules{rl}) &&...
                    ~contains(T{i,5},'Food delivery')
                blocktimes = [blocktimes,T{i,2}]; %#ok<AGROW>
                % this will put out 4 time points for each trial
                % excluding (if correct trial)the '20ms interval correct' before
                % food delivery, food delivery, and 7s interval; also
                % excluding (if incorrect trial)10ms 'interval error' and
                % '7s interval error'
                %%%%% the first and last of the 4 time points will be used as
                %%%%% the trial duration (we want to exclude food delievery
                %%%%% and rats chewing food)
                
                if contains(T{i+1,5},'error')
                    performEval = [performEval;0,T{i+1,2}];  %#ok<AGROW>
                elseif contains(T{i+1,5},'correct')
                    performEval = [performEval;1,T{i+1,2}];  %#ok<AGROW>
                end
                
            else
                
            end % if contains(T{i,5},trials2include{trl})&&contains(T{i,5},rules{rl}) &&...
                        
            for tr = 1:length(blocktimes)/4
                setshift.rules(rl).blocks(bl).trials(tr).start = blocktimes(4*tr-3);
                setshift.rules(rl).blocks(bl).trials(tr).end = blocktimes(4*tr);
                setshift.rules(rl).blocks(bl).trials(tr).latency =...
                    blocktimes(4*tr)-blocktimes(4*tr-2);
                setshift.rules(rl).blocks(bl).trials(tr).interval = ...
                    [blocktimes(4*tr)+4.02,blocktimes(4*tr)+6.02]; 
                % taking just 2 seconds from interval, rats may be chewing
                % so we will take the later 2 secs.
            end
            
             setshift.rules(rl).blocks(bl).performEval = performEval;
            
        end % for i = 1:length(T{:,5})
               
    end % end of bl = 1:5
        
end % for rl = 1:8



performEval = nan(length(setshift.rules),5);
mn_latcy = performEval;
for rl = 1:length(setshift.rules)
    rules=struct; rules(rl).performance = [];
    for bl = 1:length(setshift.rules(rl).blocks)
        performEval(rl,bl)...
            = size(setshift.rules(rl).blocks(bl).performEval,1);
        rules(rl).performance = [rules(rl).performance;setshift.rules(rl).blocks(bl).performEval];
        latcy=0;
        for trl = 1:length(setshift.rules(rl).blocks(bl).trials)
            latcy=latcy+setshift.rules(rl).blocks(bl).trials(trl).latency;
        end
        mn_latcy(rl,bl)=latcy/length(setshift.rules(rl).blocks(bl).trials);
    end
    
    %rules(rl).name = setshift.rules(rl).name;
    rules(rl).performance=sortrows(rules(rl).performance,2);
    setshift.rules(rl).performance = rules(rl).performance(:,1);
    setshift.rules(rl).latency = mean(mn_latcy(rl,:),2);
    
    blockCounts=zeros(5,1);
    % Evan: added perseverative error tracking per trial
    if rules(rl).performance(1) == 0
        index=find(rules(rl).performance(:,1)==1,1);
        rules(rl).persevarative = index -2; %#ok<*SAGROW>
        setshift.rules(rl).blocks(1).trials(1).error=0;
        setshift.rules(rl).blocks(1).trials(index).error=0;
        for i=2:index-1
            setshift.rules(rl).blocks(1).trials(i).error=1;
        end
        blockCounts(1)=index;
        curBlock=2;
    elseif rules(rl).performance(1) == 1
        index=find(rules(rl).performance(2:end,1)==1,1);
        rules(rl).persevarative = index -1; %#ok<*SAGROW>
        % First there will be a correct trial in block 1, first error
        % would be an error in block 2 or later, subsequent errors would be in block
        % 1
        bNum=1;
        setshift.rules(rl).blocks(bNum).trials(1).error=0;
        blockCounts(bNum)=blockCounts(bNum)+1;
        bNum=bNum+1;
        for i=1:index-1
            blockCounts(bNum)=blockCounts(bNum)+1;
            setshift.rules(rl).blocks(bNum).trials(i).error=1;
            bNum=1;
        end
        setshift.rules(rl).blocks(bNum).trials(index).error=0;
        blockCounts(bNum)=blockCounts(bNum)+1;
        index=index+1;
        curBlock=bNum+1;
    end
    rules(rl).postpersevarative = 0;
    rules(rl).regressive = 0;
    for i = index+1:size(rules(rl).performance,1)
        if rules(rl).performance(i,1)== 0
            % Evan: added postperseverative error tracking per trial
            rules(rl).postpersevarative = rules(rl).postpersevarative +1;
            setshift.rules(rl).blocks(curBlock).trials(blockCounts(curBlock)+1).error=2;
            blockCounts(curBlock)=blockCounts(curBlock)+1;
            curBlock=1;
        elseif rules(rl).performance(i,1)==1
            setshift.rules(rl).blocks(curBlock).trials(blockCounts(curBlock)+1).error=0;
            if i+3<=size(rules(rl).performance,1) && rules(rl).performance(i+1,1)==1&&...
                    rules(rl).performance(i+2,1)==1&&...
                    rules(rl).performance(i+3,1)==1
                rules(rl).regressive =...
                    length(find(rules(rl).performance(i+4:end,1)==0));
                % Evan: added regressive error tracking per trial
                for j=i:size(rules(rl).performance,1)
                    if rules(rl).performance(j,1)== 0
                        setshift.rules(rl).blocks(curBlock).trials(blockCounts(curBlock)+1).error=3;
                        blockCounts(curBlock)=blockCounts(curBlock)+1;
                        curBlock=1;
                    else
                        setshift.rules(rl).blocks(curBlock).trials(blockCounts(curBlock)+1).error=0;
                        if curBlock < 5
                            blockCounts(curBlock)=blockCounts(curBlock)+1;
                            curBlock=curBlock+1;
                        end
                    end
                end
                break
            end
            if curBlock < 5
                blockCounts(curBlock)=blockCounts(curBlock)+1;
                curBlock=curBlock+1;
            end
        end
        
    end
    setshift.rules(rl).persevarative = rules(rl).persevarative;
    setshift.rules(rl).postpersevarative = rules(rl).postpersevarative;
    setshift.rules(rl).regressive = rules(rl).regressive;
end

else
end

