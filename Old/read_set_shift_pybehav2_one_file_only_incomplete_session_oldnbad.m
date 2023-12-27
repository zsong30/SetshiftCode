function setshift = read_set_shift_pybehav2_one_file_only_incomplete_session(logfn)
% Reads setshift behavioral data one file at a time, reconfigured for
% pybehav2
% written by Eric Hoskins, based on the previous work of Eric Song
% October 2023
% 'Z:\projmon\ericsprojects\Setshift\BEHAVDATA\CSF09 09292023\09-29-2023'

setshift = struct;

pylogfn = strrep(logfn, "\", "\\");
pylogfn = strcat(pylogfn,".csv");
protocol = pyrunfile('pybehavReader.py', "proto", file=pylogfn);

opts = detectImportOptions(logfn);
opts.Delimiter = {','};
opts.DataLines = [1 Inf];
opts.PreserveVariableNames = true;
T = readtable(logfn,opts);
num_exit = 0;
num_starts = 0;
for i=1:height(T)
    if string(T{i,3}) == "Exit" && T{i,4} < 2
        num_exit = num_exit + 1;
    end
end
for j=1:height(T)
    if string(T{i,3}) == "Entry" && T{i,4} == 0
        num_starts = num_starts + 1;
    end
end
init_T = table('Size',[round(num_exit./2), 6], 'VariableTypes',["double", "double", "string", "double", "string", "string"]);
p=1;
resp_T = table('Size',[round(num_exit./2), 6], 'VariableTypes',["double", "double", "string", "double", "string", "string"]);
q=1;
start_T = table('Size',[num_starts,6],'VariableTypes',["double", "double", "string", "double", "string", "string"]);
r=1;
for i=1:height(T)
    if string(T{i,3}) == "Exit" && T{i,4} == 0
        init_T(p,:) = T(i,:);
        p = p + 1;
    end
    if string(T{i,3}) == "Exit" && T{i,4} == 1
        resp_T(q,:) = T(i,:);
        q = q + 1;
    end
    if string(T{i,3}) == "Entry" && T{i,4} == 0
        start_T(r,:) = T(i,:);
        r = r + 1;
    end
end
init_T = table2cell(init_T);
resp_T = table2cell(resp_T);
start_T = table2cell(start_T);

setshift.protocol = string(protocol);

setshift.endtime = T{end,2};

date_str = split(logfn, "\");
date_str = date_str(end-1);
setshift.testdate = strrep(date_str, "-", "/");

R1 = struct;
R1.name = 'R1';
R2 = struct;
R2.name = 'R2';
F1 = struct;
F1.name = 'F1';
F2 = struct;
F2.name = 'F2';
L1 = struct;
L1.name = 'L1';
L2 = struct;
L2.name = 'L2';
L3 = struct;
L3.name = 'L3';
L4 = struct;
L4.name = 'L4';

if protocol == "protocol44" || protocol == "protocol45" || protocol == "protocol46" || protocol == "protocol47"
    Rando = struct;
    %rule_index = -1 is Rando
    i = 1;
    
    while contains(resp_T{i,6}, "rule_index=-1")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
        end
    end
end

if protocol == "protocol40a" || protocol == "protocol44"
    if protocol == "protocol40a"
        i = 1;
    end
    %rule_index = 0 is R1
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=0")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                block1.trials(a).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                block1.trials(a).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                block2.trials(b).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                block2.trials(b).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                block3.trials(c).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                block4.trials(d).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(d).light = 0;
                else
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                block4.trials(d).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).light = 0;
                else
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                block5.trials(e).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                block5.trials(e).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    R1.performance = accuracy;
    R1.response_latency = mean(response_latencies);
    R1.initiation_latency = mean(initiation_latencies);
    R1.blocks(1) = block1;
    R1.blocks(2) = block2;
    R1.blocks(3) = block3;
    R1.blocks(4) = block4;
    R1.blocks(5) = block5;
    R1.perseverative = 0;
    R1.regressive = 0;
    %rule_index = 1 is L1
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=1")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block3.trials(c).light = 1;
                    block1.trials(a).front = 0;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).front = 0;
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 1;
                    block1.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 0;
                    block4.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 1;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 0;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    L1.performance = accuracy;
    L1.response_latency = mean(response_latencies);
    L1.initiation_latency = mean(initiation_latencies);
    L1.blocks(1) = block1;
    L1.blocks(2) = block2;
    L1.blocks(3) = block3;
    L1.blocks(4) = block4;
    L1.blocks(5) = block5;
    L1.perseverative = 0;
    L1.regressive = 0;
    for p=1:5
        if length(L1.blocks(p).performEval) < length(L1.blocks(p).trials)
            L1.blocks(p).trials = L1.blocks(p).trials(1:end-1);
        end
    end
    %rule_index = 2 is F1
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=2")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                block1.trials(a).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                block1.trials(a).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                block2.trials(b).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                block2.trials(b).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                block4.trials(d).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(d).light = 0;
                else
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                block4.trials(d).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).light = 0;
                else
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                block5.trials(e).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                block5.trials(e).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    F1.performance = accuracy;
    F1.response_latency = mean(response_latencies);
    F1.initiation_latency = mean(initiation_latencies);
    F1.blocks(1) = block1;
    F1.blocks(2) = block2;
    F1.blocks(3) = block3;
    F1.blocks(4) = block4;
    F1.blocks(5) = block5;
    F1.perseverative = 0;
    F1.regressive = 0;
    %rule_index = 3 is L2
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=3")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block3.trials(c).light = 1;
                    block1.trials(a).front = 0;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).front = 0;
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 1;
                    block1.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 0;
                    block4.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 1;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 0;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    L2.performance = accuracy;
    L2.response_latency = mean(response_latencies);
    L2.initiation_latency = mean(initiation_latencies);
    L2.blocks(1) = block1;
    L2.blocks(2) = block2;
    L2.blocks(3) = block3;
    L2.blocks(4) = block4;
    L2.blocks(5) = block5;
    L2.perseverative = 0;
    L2.regressive = 0;
    for p=1:5
        if length(L2.blocks(p).performEval) < length(L2.blocks(p).trials)
            L2.blocks(p).trials = L2.blocks(p).trials(1:end-1);
        end
    end
    %rule_index = 4 is R2
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=4")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                block1.trials(a).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                block1.trials(a).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                block2.trials(b).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                block2.trials(b).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                block3.trials(c).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                block4.trials(d).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(d).light = 0;
                else
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                block4.trials(d).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).light = 0;
                else
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                block5.trials(e).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                block5.trials(e).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    R2.performance = accuracy;
    R2.response_latency = mean(response_latencies);
    R2.initiation_latency = mean(initiation_latencies);
    R2.blocks(1) = block1;
    R2.blocks(2) = block2;
    R2.blocks(3) = block3;
    R2.blocks(4) = block4;
    R2.blocks(5) = block5;
    R2.perseverative = 0;
    R2.regressive = 0;
    %rule_index = 5 is L3
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=5")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block3.trials(c).light = 1;
                    block1.trials(a).front = 0;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).front = 0;
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 1;
                    block1.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 0;
                    block4.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 1;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 0;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    L3.performance = accuracy;
    L3.response_latency = mean(response_latencies);
    L3.initiation_latency = mean(initiation_latencies);
    L3.blocks(1) = block1;
    L3.blocks(2) = block2;
    L3.blocks(3) = block3;
    L3.blocks(4) = block4;
    L3.blocks(5) = block5;
    L3.perseverative = 0;
    L3.regressive = 0;
    for p=1:5
        if length(L3.blocks(p).performEval) < length(L3.blocks(p).trials)
            L3.blocks(p).trials = L3.blocks(p).trials(1:end-1);
        end
    end
    %rule_index = 6 is F2
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=6")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                block1.trials(a).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                block1.trials(a).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).light = 0;
                else
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                block2.trials(b).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                block2.trials(b).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).light = 0;
                else
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                else
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                block4.trials(d).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(d).light = 0;
                else
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                block4.trials(d).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).light = 0;
                else
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                block5.trials(e).front = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                block5.trials(e).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).light = 0;
                else
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    F2.performance = accuracy;
    F2.response_latency = mean(response_latencies);
    F2.initiation_latency = mean(initiation_latencies);
    F2.blocks(1) = block1;
    F2.blocks(2) = block2;
    F2.blocks(3) = block3;
    F2.blocks(4) = block4;
    F2.blocks(5) = block5;
    F2.perseverative = 0;
    F2.regressive = 0;
    %rule_index = 7 is L4
    block1 = struct;
    block1.name = '1-5';
    block1.performEval = [];
    block1.trials = struct;
    a=1;
    block2 = struct;
    block2.name = '2-5';
    block2.performEval = [];
    block2.trials = struct;
    b=1;
    block3 = struct;
    block3.name = '3-5';
    block3.performEval = [];
    block3.trials = struct;
    c=1;
    block4 = struct;
    block4.name = '4-5';
    block4.performEval = [];
    block4.trials = struct;
    d=1;
    block5 = struct;
    block5.name = '5-5';
    block5.performEval = [];
    block5.trials = struct;
    e=1;
    accuracy = [];
    response_latencies = [];
    initiation_latencies = [];
    while contains(resp_T{i,6}, "rule_index=7")
        % Block 1-5
        if contains(resp_T{i,6}, "cur_block=0")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block1.performEval = [block1.performEval;0,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block1.performEval = [block1.performEval;1,resp_T{i,2}];
                block1.trials(a).start = start_T{i,2};
                block1.trials(a).end = resp_T{i,2};
                block1.trials(a).response_latency = resp_T{i,2} - init_T{i,2};
                block1.trials(a).response_time = resp_T{i,2};
                block1.trials(a).initiation_latency = init_T{i,2} - start_T{i,2};
                block1.trials(a).initiation_time = init_T{i,2};
                block1.trials(a).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block1.trials(a).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 0;
                    block1.trials(a).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block1.trials(a).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                a = a + 1;
            end
        end
        % Block 2-5
        if contains(resp_T{i,6}, "cur_block=1")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block2.performEval = [block2.performEval;0,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block2.performEval = [block2.performEval;1,resp_T{i,2}];
                block2.trials(b).start = start_T{i,2};
                block2.trials(b).end = resp_T{i,2};
                block2.trials(b).response_latency = resp_T{i,2} - init_T{i,2};
                block2.trials(b).response_time = resp_T{i,2};
                block2.trials(b).initiation_latency = init_T{i,2} - start_T{i,2};
                block2.trials(b).initiation_time = init_T{i,2};
                block2.trials(b).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block2.trials(b).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block2.trials(b).front = 0;
                    block2.trials(b).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block2.trials(b).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                b = b + 1;
            end
        end
        % Block 3-5
        if contains(resp_T{i,6}, "cur_block=2")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block3.performEval = [block3.performEval;0,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 0;
                block3.trials(c).front = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block3.trials(c).light = 1;
                    block1.trials(a).front = 0;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block3.performEval = [block3.performEval;1,resp_T{i,2}];
                block3.trials(c).start = start_T{i,2};
                block3.trials(c).end = resp_T{i,2};
                block3.trials(c).response_latency = resp_T{i,2} - init_T{i,2};
                block3.trials(c).response_time = resp_T{i,2};
                block3.trials(c).initiation_latency = init_T{i,2} - start_T{i,2};
                block3.trials(c).initiation_time = init_T{i,2};
                block3.trials(c).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block3.trials(c).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block3.trials(c).front = 0;
                    block3.trials(c).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block3.trials(c).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                c = c + 1;
            end
        end
        % Block 4-5
        if contains(resp_T{i,6}, "cur_block=3")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block4.performEval = [block4.performEval;0,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 1;
                    block1.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block1.trials(d).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block4.performEval = [block4.performEval;1,resp_T{i,2}];
                block4.trials(d).start = start_T{i,2};
                block4.trials(d).end = resp_T{i,2};
                block4.trials(d).response_latency = resp_T{i,2} - init_T{i,2};
                block4.trials(d).response_time = resp_T{i,2};
                block4.trials(d).initiation_latency = init_T{i,2} - start_T{i,2};
                block4.trials(d).initiation_time = init_T{i,2};
                block4.trials(d).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block4.trials(d).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block4.trials(d).front = 0;
                    block4.trials(d).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block4.trials(d).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                d = d + 1;
            end
        end
        % Block 5-5
        if contains(resp_T{i,6}, "cur_block=4")
            if contains(resp_T{i,6}, "accuracy=incorrect")
                block5.performEval = [block5.performEval;0,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 0;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 1;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 0;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;0];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
            if contains(resp_T{i,6}, "accuracy=correct")
                block5.performEval = [block5.performEval;1,resp_T{i,2}];
                block5.trials(e).start = start_T{i,2};
                block5.trials(e).end = resp_T{i,2};
                block5.trials(e).response_latency = resp_T{i,2} - init_T{i,2};
                block5.trials(e).response_time = resp_T{i,2};
                block5.trials(e).initiation_latency = init_T{i,2} - start_T{i,2};
                block5.trials(e).initiation_time = init_T{i,2};
                block5.trials(e).interval = [resp_T{i,2}+4.02,resp_T{i,2}+6.02];
                block5.trials(e).performance = 1;
                if contains(init_T{i,6},"light_location=0")
                    block5.trials(e).front = 0;
                    block5.trials(e).light = 0;
                end
                if contains(init_T{i,6},"light_location=1")
                    block1.trials(a).front = 1;
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
        i = i + 1;
    end
    L4.performance = accuracy;
    L4.response_latency = mean(response_latencies);
    L4.initiation_latency = mean(initiation_latencies);
    L4.blocks(1) = block1;
    L4.blocks(2) = block2;
    L4.blocks(3) = block3;
    L4.blocks(4) = block4;
    L4.blocks(5) = block5;
    L4.perseverative = 0;
    L4.regressive = 0;
    for p=1:5
        if length(L4.blocks(p).performEval) < length(L4.blocks(p).trials)
            L4.blocks(p).trials = L4.blocks(p).trials(1:end-1);
        end
    end
end

if protocol == "protocol41" || protocol == "protocol45"
    %rule_index = 0 is L2
    %rule_index = 1 is R2
    %rule_index = 2 is L3
    %rule_index = 3 is F2
    %rule_index = 4 is L4
    %rule_index = 5 is R1
    %rule_index = 6 is L1
    %rule_index = 7 is F1
end

if protocol == "protocol42" || protocol == "protocol46"
    %rule_index = 0 is F2
    %rule_index = 1 is L4
    %rule_index = 2 is R1
    %rule_index = 3 is L1
    %rule_index = 4 is F1
    %rule_index = 5 is L2
    %rule_index = 6 is R2
    %rule_index = 7 is L3
end

if protocol == "protocol43" || protocol == "protocol47"
    %rule_index = 0 is L1
    %rule_index = 1 is F1
    %rule_index = 2 is L2
    %rule_index = 3 is R2
    %rule_index = 4 is L3
    %rule_index = 5 is F2
    %rule_index = 6 is L4
    %rule_index = 7 is R1
end

setshift.rules(1) = L1;
setshift.rules(2) = L2;
setshift.rules(3) = L3;
setshift.rules(4) = L4;
setshift.rules(5) = R1;
setshift.rules(6) = R2;
setshift.rules(7) = F1;
setshift.rules(8) = F2;

if protocol == "protocol44" || protocol == "protocol45" || protocol == "protocol46" || protocol == "protocol47"
    setshift.rules(9) = Rando;
end
