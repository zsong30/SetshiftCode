
figure
hold on
setshift = read_set_shift_behavior_one_file_only(logfn);

for r = 1:8
RT = [];
setshift.rules(r).performEval = [];
for b = 1:length(setshift.rules(r).blocks)
    for tr = 1:size(setshift.rules(r).blocks(b).performEval,1)
    RT = setshift.rules(r).blocks(b).trials(tr).response_latency; 
    setshift.rules(r).blocks(b).performEval(tr,3) = RT;
    clear TR
    end
    setshift.rules(r).performEval = [setshift.rules(r).performEval;setshift.rules(r).blocks(b).performEval];
    
end
setshift.rules(r).performEval = sortrows(setshift.rules(r).performEval,2);
setshift.rules(r).performEval(setshift.rules(r).performEval(:,3)>7,3)=nan;

plot(setshift.rules(r).performEval(:,3))
end


