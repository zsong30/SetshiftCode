function plot_set_shift_behavior_analyses(rat)

myxticklabels = [];
maxsetshiftsession = 0;
for rt = 1:length(rat)
    if length(rat(rt).setshift)>maxsetshiftsession
   maxsetshiftsession = length(rat(rt).setshift);
    end
end
s_persevarative = nan(length(rat),maxsetshiftsession);
s_postpersevarative = s_persevarative;
s_regressive = s_persevarative;
s_performEval = s_persevarative;
s_latcy = s_persevarative;

for rt = 1:length(rat)
    for s = 1:length(rat(rt).setshift)
        performEval = nan(length(rat(rt).setshift(s).rules),5);
        mn_resp_latcy = performEval;
        for rl = 1:length(rat(rt).setshift(s).rules)
            persevarative(rt,s,rl) = rat(rt).setshift(s).rules(rl).persevarative; %#ok<*AGROW,*SAGROW>
            postpersevarative(rt,s,rl) = rat(rt).setshift(s).rules(rl).postpersevarative;
            regressive(rt,s,rl) = rat(rt).setshift(s).rules(rl).regressive;
            rules=struct; rules(rl).performance = [];
            for bl = 1:length(rat(rt).setshift(s).rules(rl).blocks)
                performEval(rl,bl)...
                    = size(rat(rt).setshift(s).rules(rl).blocks(bl).performEval,1);
                rules(rl).performance = [rules(rl).performance;rat(rt).setshift(s).rules(rl).blocks(bl).performEval];
                resp_latcy=0;
                for trl = 1:length(rat(rt).setshift(s).rules(rl).blocks(bl).trials)
                    resp_latcy=resp_latcy+rat(rt).setshift(s).rules(rl).blocks(bl).trials(trl).response_latency;
                end
                mn_resp_latcy(rl,bl)=resp_latcy/length(rat(rt).setshift(s).rules(rl).blocks(bl).trials);
            end
        end
        s_persevarative(rt,s)= mean(persevarative(rt,s,:),3);
        s_postpersevarative(rt,s)= mean(postpersevarative(rt,s,:),3);
        s_regressive(rt,s)= mean(regressive(rt,s,:),3);
        s_performEval(rt,s) = mean(mean(performEval,2),1);
        s_latcy(rt,s) = mean(mean(mn_resp_latcy,2),1);
        
    end
    myxticklabels = cat(1,myxticklabels,rat(rt).name);
end
myxticklabels = string(myxticklabels);

%%% plot by rat
figure
subplot(1,3,1)
bar(mean(s_persevarative,2,'omitnan'))
xticklabels(myxticklabels)
title(sprintf('persevarative'))
box off

subplot(1,3,2)
bar(mean(s_postpersevarative,2,'omitnan'))
xticklabels(myxticklabels)
title(sprintf('postpersevarative'))
box off

subplot(1,3,3)
bar(mean(s_regressive,2,'omitnan'))
xticklabels(myxticklabels)
title(sprintf('regressive'))
box off

figure
bar(mean(s_performEval,2,'omitnan'))
xticklabels(myxticklabels)
title('trials needed to complete')
box off

figure
bar(mean(s_latcy,2,'omitnan'))
xticklabels(myxticklabels)
title('response latency')
box off

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure('name','setshift errors by rules')
% LightPerformance = mean(errors(1:4,:),1);
% RearPerformance = mean(errors(5:6,:),1);
% FrontPerformance = mean(errors(7:8,:),1);
% myylim = max([max(LightPerformance),max(RearPerformance),max(FrontPerformance)])*1.10;
% plot([LightPerformance;RearPerformance;FrontPerformance],'LineWidth',3)
% myleg = {'Light','Rear','Front'};
% legend(myleg,'Box','off')
% xlim([.5,3.5]);
% ylim([0,myylim]);
% xticks([1,2,3])
% xticklabels({'persevarative','postpersevarative','regressive'})
% xlabel('Error types', 'FontWeight', 'bold')
% ylabel('Number of errors', 'FontWeight', 'bold');
% title(sprintf('setshift errors by rules'))
% set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
% box off
% 
% LightPerformance = mean(performEval(1:4,:),1);
% RearPerformance = mean(performEval(5:6,:),1);
% FrontPerformance = mean(performEval(7:8,:),1);
% myylim = max([LightPerformance(1),RearPerformance(1),FrontPerformance(1)])*1.10;
% 
% figure('name','setshift performance by rules')
% plot([LightPerformance;RearPerformance;FrontPerformance]','LineWidth',3)
% myleg = {'Light','Rear','Front'};
% legend(myleg,'Box','off')
% xlim([.5,5.5]);
% ylim([0,myylim]);
% xlabel('Blocks', 'FontWeight', 'bold')
% ylabel('Number of trials used', 'FontWeight', 'bold');
% title(sprintf('setshift performance by rules'))
% set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
% box off
% 
% LightLatcy = mean(mn_latcy(1:4,:),1);
% RearLatcy = mean(mn_latcy(5:6,:),1);
% FrontLatcy = mean(mn_latcy(7:8,:),1);
% myylim = max([max(LightLatcy),max(RearLatcy),max(FrontLatcy)])*1.50;
% 
% figure('name','setshift performance response_latency by rules')
% plot([LightLatcy;RearLatcy;FrontLatcy]','LineWidth',3)
% myleg = {'Light','Rear','Front'};
% legend(myleg,'Box','off')
% xlim([.5,5.5]);
% ylim([0,myylim]);
% xlabel('Blocks', 'FontWeight', 'bold')
% ylabel('response_latency (seconds)', 'FontWeight', 'bold');
% title(sprintf('performance response_latency by rules'))
% set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
% box off