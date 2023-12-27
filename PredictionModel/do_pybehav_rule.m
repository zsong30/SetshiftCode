function rule = do_pybehav_rule(rule_index, resp_T, init_T, start_T, rule_type, rule_name)
rule.name = rule_name;
rule_index_str = strcat("rule_index=",rule_index);
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
for i=1:length(init_T)
    if contains(resp_T{i,6}, rule_index_str)
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
                if rule_type == "Front"
                    block1.trials(a).front = 0;
                end
                if rule_type == "Rear"
                    block1.trials(a).front = 1;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block1.trials(a).front = 1;
                    end
                    block1.trials(a).light = 0;
                else
                    if rule_type == "Light"
                        block1.trials(a).front = 0;
                    end
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
                if rule_type == "Front"
                    block1.trials(a).front = 1;
                end
                if rule_type == "Rear"
                    block1.trials(a).front = 0;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block1.trials(a).front = 0;
                    end
                    block1.trials(a).light = 0;
                else
                    if rule_type == "Light"
                        block1.trials(a).front = 1;
                    end
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
                if rule_type == "Front"
                    block2.trials(b).front = 0;
                end
                if rule_type == "Rear"
                    block2.trials(b).front = 1;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block2.trials(b).front = 1;
                    end
                    block2.trials(b).light = 0;
                else
                    if rule_type == "Light"
                        block.trials(b).front = 0;
                    end
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
                if rule_type == "Front"
                    block2.trials(b).front = 1;
                end
                if rule_type == "Rear"
                    block2.trials(b).front = 0;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block2.trials(b).front = 0;
                    end
                    block2.trials(b).light = 0;
                else
                    if rule_type == "Light"
                        block2.trials(b).front = 1;
                    end
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
                if rule_type == "Front"
                    block3.trials(c).front = 0;
                end
                if rule_type == "Rear"
                    block3.trials(c).front = 1;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block3.trials(c).front = 1;
                    end
                    block3.trials(c).light = 0;
                else
                    if rule_type == "Light"
                        block3.trials(c).front = 0;
                    end
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
                if rule_type == "Front"
                    block3.trials(c).front = 1;
                end
                if rule_type == "Rear"
                    block3.trials(c).front = 0;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block3.trials(c).front = 0;
                    end
                    block3.trials(c).light = 0;
                else
                    if rule_type == "Light"
                        block3.trials(c).front = 1;
                    end
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
                if rule_type == "Front"
                    block4.trials(d).front = 0;
                end
                if rule_type == "Rear"
                    block4.trials(d).front = 1;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block4.trials(d).front = 1;
                    end
                    block4.trials(d).light = 0;
                else
                    if rule_type == "Light"
                        block4.trials(d).front = 0;
                    end
                    block4.trials(d).light = 1;
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
                if rule_type == "Front"
                    block4.trials(d).front = 1;
                end
                if rule_type == "Rear"
                    block4.trials(d).front = 0;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block4.trials(d).front = 0;
                    end
                    block4.trials(d).light = 0;
                else
                    if rule_type == "Light"
                        block4.trials(d).front = 1;
                    end
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
                if rule_type == "Front"
                    block5.trials(e).front = 0;
                end
                if rule_type == "Rear"
                    block5.trials(e).front = 1;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block5.trials(e).front = 1;
                    end
                    block5.trials(e).light = 0;
                else
                    if rule_type == "Light"
                        block5.trials(e).front = 0;
                    end
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
                if rule_type == "Front"
                    block5.trials(e).front = 1;
                end
                if rule_type == "Rear"
                    block5.trials(e).front = 0;
                end
                if contains(init_T{i,6},"light_location=0")
                    if rule_type == "Light"
                        block5.trials(e).front = 0;
                    end
                    block5.trials(e).light = 0;
                else
                    if rule_type == "Light"
                        block5.trials(e).front = 1;
                    end
                    block5.trials(e).light = 1;
                end
                accuracy = [accuracy;1];
                response_latencies = [response_latencies, resp_T{i,2} - init_T{i,2}];
                initiation_latencies = [initiation_latencies, init_T{i,2} - start_T{i,2}];
                e = e + 1;
            end
        end
    end
end
rule.performance = accuracy;
rule.response_latency = mean(response_latencies);
rule.initiation_latency = mean(initiation_latencies);
rule.blocks(1) = block1;
rule.blocks(2) = block2;
rule.blocks(3) = block3;
rule.blocks(4) = block4;
rule.blocks(5) = block5;
rule.perseverative = 0;
rule.regressive = 0;