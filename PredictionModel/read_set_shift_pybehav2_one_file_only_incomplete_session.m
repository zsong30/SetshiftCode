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
R2 = struct;
F1 = struct;
F2 = struct;
L1 = struct;
L2 = struct;
L3 = struct;
L4 = struct;

if protocol == "protocol40a" || protocol == "protocol44"
    %rule_index = 0 is R1
    R1 = do_pybehav_rule("0", resp_T, init_T, start_T, "Rear", "R1");
    %rule_index = 1 is L1
    L1 = do_pybehav_rule("1", resp_T, init_T, start_T, "Light", "L1");
    %rule_index = 2 is F1
    F1 = do_pybehav_rule("2", resp_T, init_T, start_T, "Front", "F1");
    %rule_index = 3 is L2
    L2 = do_pybehav_rule("3", resp_T, init_T, start_T, "Light", "L2");
    %rule_index = 4 is R2
    R2 = do_pybehav_rule("4", resp_T, init_T, start_T, "Rear", "R2");
    %rule_index = 5 is L3
    L3 = do_pybehav_rule("5", resp_T, init_T, start_T, "Light", "L3");
    %rule_index = 6 is F2
    F2 = do_pybehav_rule("6", resp_T, init_T, start_T, "Front", "F2");
    %rule_index = 7 is L4
    L4 = do_pybehav_rule("7", resp_T, init_T, start_T, "Light", "L4");
    setshift.order = ["R1", "L1", "F1", "L2", "R2", "L3", "F2", "L4"];
end

if protocol == "protocol41" || protocol == "protocol45"
    %rule_index = 0 is L2
    L2 = do_pybehav_rule("0", resp_T, init_T, start_T, "Light", "L2");
    %rule_index = 1 is R2
    R2 = do_pybehav_rule("1", resp_T, init_T, start_T, "Rear", "R2");
    %rule_index = 2 is L3
    L3 = do_pybehav_rule("2", resp_T, init_T, start_T, "Light", "L3");
    %rule_index = 3 is F2
    F2 = do_pybehav_rule("3", resp_T, init_T, start_T, "Front", "F2");
    %rule_index = 4 is L4
    L4 = do_pybehav_rule("4", resp_T, init_T, start_T, "Light", "L4");
    %rule_index = 5 is R1
    R1 = do_pybehav_rule("5", resp_T, init_T, start_T, "Rear", "R1");
    %rule_index = 6 is L1
    L1 = do_pybehav_rule("6", resp_T, init_T, start_T, "Light", "L1");
    %rule_index = 7 is F1
    F1 = do_pybehav_rule("7", resp_T, init_T, start_T, "Front", "F1");
    setshift.order = ["L2", "R2", "L3", "F2", "L4", "R1", "L1", "F1"];
end

if protocol == "protocol42" || protocol == "protocol46"
    %rule_index = 0 is F2
    F2 = do_pybehav_rule("0", resp_T, init_T, start_T, "Front", "F2");
    %rule_index = 1 is L4
    L4 = do_pybehav_rule("1", resp_T, init_T, start_T, "Light", "L4");
    %rule_index = 2 is R1
    R1 = do_pybehav_rule("2", resp_T, init_T, start_T, "Rear", "R1");
    %rule_index = 3 is L1
    L1 = do_pybehav_rule("3", resp_T, init_T, start_T, "Light", "L1");
    %rule_index = 4 is F1
    F1 = do_pybehav_rule("4", resp_T, init_T, start_T, "Front", "F1");
    %rule_index = 5 is L2
    L2 = do_pybehav_rule("5", resp_T, init_T, start_T, "Light", "L2");
    %rule_index = 6 is R2
    R2 = do_pybehav_rule("6", resp_T, init_T, start_T, "Rear", "R2");
    %rule_index = 7 is L3
    L3 = do_pybehav_rule("7", resp_T, init_T, start_T, "Light", "L3");
    setshift.order = ["F2", "L4", "R1", "L1", "F1", "L2", "R2", "L3"];
end

if protocol == "protocol43" || protocol == "protocol47"
    %rule_index = 0 is L1
    L1 = do_pybehav_rule("0", resp_T, init_T, start_T, "Light", "L1");
    %rule_index = 1 is F1
    F1 = do_pybehav_rule("1", resp_T, init_T, start_T, "Front", "F1");
    %rule_index = 2 is L2
    L2 = do_pybehav_rule("2", resp_T, init_T, start_T, "Light", "L2");
    %rule_index = 3 is R2
    R2 = do_pybehav_rule("3", resp_T, init_T, start_T, "Rear", "R2");
    %rule_index = 4 is L3
    L3 = do_pybehav_rule("4", resp_T, init_T, start_T, "Light", "L3");
    %rule_index = 5 is F2
    F2 = do_pybehav_rule("5", resp_T, init_T, start_T, "Front", "F2");
    %rule_index = 6 is L4
    L4 = do_pybehav_rule("6", resp_T, init_T, start_T, "Light", "L4");
    %rule_index = 7 is R1
    R1 = do_pybehav_rule("7", resp_T, init_T, start_T, "Rear", "R1");
    setshift.order = ["L1", "F1", "L2", "R2", "L3", "F2", "L4", "R1"];
end

setshift.rules(1) = L1;
setshift.rules(2) = L2;
setshift.rules(3) = L3;
setshift.rules(4) = L4;
setshift.rules(5) = R1;
setshift.rules(6) = R2;
setshift.rules(7) = F1;
setshift.rules(8) = F2;
