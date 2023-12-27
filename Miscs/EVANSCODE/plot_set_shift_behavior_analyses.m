function plot_set_shift_behavior_analyses(rat)

for r = 1:length(rat)
    for s = 1:length(rat(r).setshift)
        performEval = nan(length(rat(r).setshift(s).rules),5);
        mn_latcy = performEval;
        for rl = 1:length(rat(r).setshift(s).rules)
            persevarative(r,s,rl) = rat(r).setshift(s).rules(rl).persevarative; %#ok<*AGROW,*SAGROW>
            postpersevarative(r,s,rl) = rat(r).setshift(s).rules(rl).postpersevarative;
            regressive(r,s,rl) = rat(r).setshift(s).rules(rl).regressive;
            rules=struct; rules(rl).performance = [];
            for bl = 1:length(rat(r).setshift(s).rules(rl).blocks)
                performEval(rl,bl)...
                    = size(rat(r).setshift(s).rules(rl).blocks(bl).performEval,1);
                rules(rl).performance = [rules(rl).performance;rat(r).setshift(s).rules(rl).blocks(bl).performEval];
                latcy=0;
                for trl = 1:length(rat(r).setshift(s).rules(rl).blocks(bl).trials)
                    latcy=latcy+rat(r).setshift(s).rules(rl).blocks(bl).trials(trl).latency;
                end
                mn_latcy(rl,bl)=latcy/length(rat(r).setshift(s).rules(rl).blocks(bl).trials);
            end
            
        end
        s_persevarative(r,s)= mean(persevarative(r,s,:),3);
        s_postpersevarative(r,s)= mean(postpersevarative(r,s,:),3);
        s_regressive(r,s)= mean(regressive(r,s,:),3);
        s_performEval(r,s) = mean(mean(performEval,2),1);
        s_latcy(r,s) = mean(mean(mn_latcy,2),1);
        
    end
end

%%% plot by rat
figure
subplot(1,3,1)
bar(mean(s_persevarative,2))
xticklabels({rat(1).name,rat(2).name})
title(sprintf('persevarative'))
box off

subplot(1,3,3)
bar(mean(s_postpersevarative,2))
xticklabels({rat(1).name,rat(2).name})
title(sprintf('postpersevarative'))
box off

subplot(1,3,3)
bar(mean(s_regressive,2))
xticklabels({rat(1).name,rat(2).name})
title(sprintf('regressive'))
box off

figure
bar(mean(s_performEval,2))
xticklabels({rat(1).name,rat(2).name})
title('trials needed')
box off

figure
bar(mean(s_latcy,2))
xticklabels({rat(1).name,rat(2).name})
title('latency')
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
% figure('name','setshift performance latency by rules')
% plot([LightLatcy;RearLatcy;FrontLatcy]','LineWidth',3)
% myleg = {'Light','Rear','Front'};
% legend(myleg,'Box','off')
% xlim([.5,5.5]);
% ylim([0,myylim]);
% xlabel('Blocks', 'FontWeight', 'bold')
% ylabel('Latency (seconds)', 'FontWeight', 'bold');
% title(sprintf('performance latency by rules'))
% set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold')
% box off