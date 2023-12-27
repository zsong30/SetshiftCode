function plot_set_shift_behavior(rat)

myxticklabels = [];
maxsetshiftsession = 0;
for rt = 1:length(rat)
    if length(rat(rt).setshift)>maxsetshiftsession
        maxsetshiftsession = length(rat(rt).setshift);
    end
end
persevarative = nan(length(rat),maxsetshiftsession,length(rat(1).setshift(1).rules));
postpersevarative = persevarative; 
regressive = persevarative; 
performance = persevarative;
response_latency = persevarative; 
initiation_latency = persevarative;

for rt = 1:length(rat)
    for s = 1:length(rat(rt).setshift)
        for rl = 1:length(rat(rt).setshift(s).rules)
            persevarative(rt,s,rl) = rat(rt).setshift(s).rules(rl).persevarative; %#ok<*AGROW,*SAGROW>
            postpersevarative(rt,s,rl) = rat(rt).setshift(s).rules(rl).postpersevarative;
            regressive(rt,s,rl) = rat(rt).setshift(s).rules(rl).regressive;
            performance(rt,s,rl)= length(rat(rt).setshift(s).rules(rl).performance);
            response_latency(rt,s,rl)= length(rat(rt).setshift(s).rules(rl).response_latency);
            initiation_latency(rt,s,rl)= length(rat(rt).setshift(s).rules(rl).initiation_latency);
        end
    end
    myxticklabels = cat(1,myxticklabels,rat(rt).name);
end
myxticklabels = string(myxticklabels);


setshiftvalues(:,:,:,1) = persevarative;
setshiftvalues(:,:,:,2) = postpersevarative;
setshiftvalues(:,:,:,3) = regressive;
setshiftvalues(:,:,:,4) = response_latency;
setshiftvalues(:,:,:,5) = initiation_latency;
setshiftvalues(:,:,:,6) = performance;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name','error rates for all rats')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
hold on
b = bar(squeeze(mean(mean(setshiftvalues(:,:,:,1:3),3,'omitnan'),2,'omitnan')),'grouped'); % 5 x 3
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(squeeze(mean(mean(setshiftvalues(:,:,:,1:3),3,'omitnan'),2)));
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
denominator4errorbar = sqrt(sum(setshiftvalues(:,:,1,4)>0,2))*ones(1,3);
errorbar(x',squeeze(mean(mean(setshiftvalues(:,:,:,1:3),3,'omitnan'),2,'omitnan')),...
    squeeze(std(mean(setshiftvalues(:,:,:,1:3),3,'omitnan'),0,2,'omitnan'))...
    ./denominator4errorbar,'k','linestyle','none');
hold off
xticks(1:5)
xticklabels(myxticklabels)
title(sprintf('error types'))
myleg = {'persevarative','postpersevarative','regresive'};
legend(myleg,'Box','off')
box off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data2plotL = mean(setshiftvalues(:,:,(1:4),:),3,'omitnan');
data2plotR = mean(setshiftvalues(:,:,(5:6),:),3,'omitnan');
data2plotF = mean(setshiftvalues(:,:,(7:8),:),3,'omitnan');
data2plot = cat(3,data2plotL,data2plotR,data2plotF);
rulenames = {'Light','Rear','Front'};
figure('name','error rates for all rats separated by rules')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
for i = 1:3
subplot(1,3,i)
hold on
b = bar(squeeze(mean(data2plot(:,:,i,(1:3)),2,'omitnan')));
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(squeeze(mean(mean(setshiftvalues(:,:,:,1:3),3,'omitnan'),2,'omitnan')));
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for j = 1:nbars
    x(j,:) = b(j).XEndPoints;
end
denominator4errorbar = sqrt(sum(setshiftvalues(:,:,1,4)>0,2))*ones(1,3);
errorbar(x',squeeze(mean(data2plot(:,:,i,(1:3)),2,'omitnan')),...
    squeeze(std(data2plot(:,:,i,(1:3)),0,2,'omitnan'))...
    ./denominator4errorbar,'k','linestyle','none');

xticks(1:5)
xticklabels(myxticklabels)
title(rulenames{i})
myleg = {'persevarative','postpersevarative','regresive'};
legend(myleg,'Box','off')
box off
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
errortypes = {'Perservarative','Postperservarative','Regressive'};
figure('name','error rates for all rats separated by rules line graph')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
myleg = myxticklabels;
for i = 1:3 % rules
for j = 1:3 % error types
    subplot(3,3,3*(i-1)+j)
plot(squeeze(data2plot(:,:,i,j)'))
title(rulenames{i})
ylabel(errortypes(j))
xlabel('sessions')
legend(myleg,'Box','off')
box off
end
end


errortypes = {'Perservarative','Postperservarative','Regressive'};
for rt = 1:length(rat)
figure('name',sprintf('error rates for rat%s separated by rules line graph',rat(rt).name))
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
myleg = myxticklabels;
for i = 1:3 % rules
for j = 1:3 % error types
    subplot(3,3,3*(i-1)+j)
plot(squeeze(data2plot(rt,:,i,j)'))
title(rulenames{i})
ylabel(errortypes(j))
xlabel('sessions')
legend(myleg{rt},'Box','off')
box off
end
end
end







% figure('name','error rates for all rats')
% bar(squeeze(mean(setshiftvalues(:,:,(1:3)),2,'omitnan')))
% xticklabels(myxticklabels)
% title(sprintf('error types'))
% myleg = {'persevarative','postpersevarative','regresive'};
% legend(myleg,'Box','off')
% box off


% figure('name','trials needed to complete for all rats')
% bar(mean(s_performance,2,'omitnan'))
% xticklabels(myxticklabels)
% title('trials needed to complete')
% box off
% 
% figure('name','latency for all rats')
% bar(squeeze(mean(setshiftvalues(:,:,(4:5)),2,'omitnan')))
% xticklabels(myxticklabels)
% title(sprintf('latency'))
% myleg = {'response latency','initiation latency'};
% legend(myleg,'Box','off')
% box off

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