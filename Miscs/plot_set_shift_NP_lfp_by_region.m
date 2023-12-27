function plot_set_shift_NP_lfp_by_region(rat)
% plot_set_shift_NP_lfp(rat,2)

% Author: Eric Song
% Updated by Eric S 12/02/2021.


r_lfpindices = [];
r_baseline_lfp = [];
r_task_lfp = [];

for rt = 1:length(rat)
    s_lfpindices = [];
    s_baseline_lfp = [];
    s_task_lfp = [];
    
    for s = 1:length(rat(rt).setshift)
        
        rl_lfpindices = []; rl_baseline_lfp = []; rl_task_lfp = [];
        for rl = 1:length(rat(rt).setshift(s).rules)
            bl_lfpindices = []; bl_baseline_lfp = []; bl_task_lfp = [];
            for bl = 1:length(rat(rt).setshift(s).rules(rl).blocks)
                lfpindices = []; baseline_lfp = [];task_lfp = [];
                for tr = 1:length(rat(rt).setshift(s).rules(rl).blocks(bl).trials)
                    %             if rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).end - ...
                    %                     rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).start > minsec
                    if isfield(rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr),'region') ...
                            && ~isempty(rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region)
                        
                        lfpindices(end+1,:) = [rt,s,rl,bl,tr,rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).performance];
                        baseline_lfp = ... % 768 chan x timestamps x trials
                            cat(3,baseline_lfp,[rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(1).baselinelfp; ...
                            rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(2).baselinelfp]);
                        task_lfp = ... % 768 chan x timestamps x trials
                            cat(3,task_lfp, [rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(1).tasklfp; ...
                            rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(2).tasklfp]); %#ok<*AGROW>
                    end
                end
                bl_lfpindices = [bl_lfpindices;lfpindices];
                
                if size(bl_baseline_lfp,1) == 0
                    bl_baseline_lfp = [];
                end
                bl_baseline_lfp = cat(3,bl_baseline_lfp, baseline_lfp);
                
                if size(bl_task_lfp,1) == 0
                    bl_task_lfp = [];
                end
                bl_task_lfp = cat(3,bl_task_lfp, task_lfp);
                
            end
            rl_lfpindices = [rl_lfpindices;bl_lfpindices];
            rl_baseline_lfp = cat(3,rl_baseline_lfp,bl_baseline_lfp);
            rl_task_lfp = cat(3,rl_task_lfp,bl_task_lfp);
            
        end
        s_lfpindices = [s_lfpindices;rl_lfpindices];
        s_baseline_lfp = cat(3,s_baseline_lfp,rl_baseline_lfp);
        s_task_lfp = cat(3,s_task_lfp,rl_task_lfp);
        
    end
    r_lfpindices = [r_lfpindices;s_lfpindices];
    r_baseline_lfp = cat(3,r_baseline_lfp,s_baseline_lfp);
    r_task_lfp = cat(3,r_task_lfp,s_task_lfp);
    
end



% set params for Chronux
params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [1 30];
movingwin = [0.5 0.1];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];

Prelimbic = struct; % creat a new region struct to organize data.
Striatum = struct;

Prelimbic.name = 'PL';
Prelimbic.subregion(1).name = 'dorsalPL';
Prelimbic.subregion(1).channel = 380;


Prelimbic.subregion(2).name = 'ventralPL';
Prelimbic.subregion(2).channel = 25;


Striatum.name = 'ST';
Striatum.subregion(1).name = 'dorsalST';
Striatum.subregion(1).channel = 380+384;
Striatum.subregion(1).refch = 381+384;

Striatum.subregion(2).name = 'ventralST';
Striatum.subregion(2).channel = 25+384;
Striatum.subregion(2).refch = 24+384;


interval = find(r_lfpindices(:,1) > 0); % all points
task = find(r_lfpindices(:,1) > 0); % all points

correct = find(r_lfpindices(:,6) == 1);
incorrect = find(r_lfpindices(:,6) == 0);
side = find(r_lfpindices(:,3) >4);
light = find(r_lfpindices(:,3) < 5);


comparison(1).condition(1).index = interval;
comparison(1).condition(1).name = 'Interval';
comparison(1).condition(2).index = task;
comparison(1).condition(2).name = 'Task';

comparison(2).condition(1).index = incorrect;
comparison(2).condition(1).name = 'Incorrect';
comparison(2).condition(2).index = correct;
comparison(2).condition(2).name = 'Correct';

comparison(3).condition(1).index = light;
comparison(3).condition(1).name = 'Light';
comparison(3).condition(2).index = side;
comparison(3).condition(2).name = 'Side';




for comp = 1:3 % loop in all comparisons; 6 is hard coded, but can be any number.
    
    
    for reg = 1:2
        % 768 chan x timestamps x trial for r_task_lfp
        if comp == 1
            data1 = neuropixel_REreference(Prelimbic.subregion(reg).channel,r_baseline_lfp);
            data1 = data1(:,comparison(comp).condition(1).index);
            
            data2 = neuropixel_REreference(Striatum.subregion(reg).channel,r_baseline_lfp);
            data2 = data2(:,comparison(comp).condition(1).index);
            
            
            data3 = neuropixel_REreference(Prelimbic.subregion(reg).channel,r_task_lfp);
            data3 = data3(:,comparison(comp).condition(2).index);
            
            data4 = neuropixel_REreference(Striatum.subregion(reg).channel,r_task_lfp);
            data4 = data4(:,comparison(comp).condition(2).index);
            
        else
            
            data1 = neuropixel_REreference(Prelimbic.subregion(reg).channel,r_task_lfp);
            data1 = data1(:,comparison(comp).condition(1).index);
            
            data2 = neuropixel_REreference(Striatum.subregion(reg).channel,r_task_lfp);
            data2 = data2(:,comparison(comp).condition(1).index);
            
            
            data3 = neuropixel_REreference(Prelimbic.subregion(reg).channel,r_task_lfp);
            data3 = data3(:,comparison(comp).condition(2).index);
            
            data4 = neuropixel_REreference(Striatum.subregion(reg).channel,r_task_lfp);
            data4 = data4(:,comparison(comp).condition(2).index);
            
            
        end
        
        [C_1,phi1,S12_1,S1_1,S2_1,f1,~,~,~] = coherencyc(data1,data2,params); %#ok<ASGLU>
        
        % C: frqs x trials.
        
        S1_1=10*log10(S1_1);
        S2_1=10*log10(S2_1);
        
        
        [C_2,phi2,S12_2,S1_2,S2_2,f2,~,~,~]=coherencyc(data3,data4,params); %#ok<ASGLU>
        S1_2=10*log10(S1_2);
        S2_2=10*log10(S2_2);
        
        
        
        
        
        
        
        
        if max(mean(S1_1,2)) > max(mean(S2_1,2))
            NormFactor1 = max(mean(S1_1,2));
        else
            NormFactor1 = max(mean(S2_1,2));
        end
        
        
        if max(mean(S1_2,2)) > max(mean(S2_2,2))
            NormFactor2 = max(mean(S1_2,2));
        else
            NormFactor2 = max(mean(S2_2,2));
        end
        
        if NormFactor1 > NormFactor2
            NormFactor = NormFactor1;
        else
            NormFactor = NormFactor2;
        end
        
        
        Mn_S1_1= mean(S1_1,2)/NormFactor;
        SEM_S1_1= std(S1_1,0,2)./sqrt(size(data1,1))/NormFactor;
        
        Mn_S2_1= mean(S2_1,2)/NormFactor;
        SEM_S2_1= std(S2_1,0,2)./sqrt(size(data1,1))/NormFactor;
        
        Mn_C_1= mean(C_1,2);
        SEM_C_1= std(C_1,0,2)./sqrt(size(data1,1));
        
        
        Mn_S1_2= mean(S1_2,2)/NormFactor;
        SEM_S1_2= std(S1_2,0,2)./sqrt(size(data1,1))/NormFactor;
        
        Mn_S2_2= mean(S2_2,2)/NormFactor;
        SEM_S2_2= std(S2_2,0,2)./sqrt(size(data1,1))/NormFactor;
        
        Mn_C_2= mean(C_2,2);
        SEM_C_2= std(C_2,0,2)./sqrt(size(data1,1));
        
        
        
        fig = figure('name',sprintf('setshift %s vs %s ', Prelimbic.name,Striatum.name));
        fig.WindowStyle = 'normal';
        set(gcf, 'Position', get(0, 'Screensize'));
        
        subplot(3,2,1)
        hp1=plot(f1,Mn_S1_1','LineWidth',3,'Color','g');
        hold on
        hp2=plot(f1,Mn_S2_1','LineWidth',3,'Color','b');
        
        patch([f1,fliplr(f1)], [(Mn_S1_1-SEM_S1_1)',flipud(Mn_S1_1+SEM_S1_1)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
        patch([f1,fliplr(f1)], [(Mn_S2_1-SEM_S2_1)',flipud(Mn_S2_1+SEM_S2_1)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
        
        myleg = {Prelimbic.subregion(reg).name,Striatum.subregion(reg).name};
        legend([hp1,hp2], myleg);
        
        legend boxoff
        xlim(params.fpass);
        ylim([0.2,1]);
        xlabel('Frequency (Hz)', 'FontWeight', 'bold')
        ylabel('Percent power', 'FontWeight', 'bold');
        %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
        title(sprintf('Percent power during %s',comparison(comp).condition(1).name'))
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        box off
        
        subplot(3,2,2)
        p1 = plot(f1,Mn_C_1','LineWidth',3,'Color','r'); %#ok<*NASGU>
        hold on
        patch([f1,fliplr(f1)], [(Mn_C_1-SEM_C_1)',flipud(Mn_C_1+SEM_C_1)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
        
        
        %     p2 = plot(f1,Mn_C_1b','LineWidth',3,'Color','r','LineStyle',':');
        %     patch([f1,fliplr(f)], [(Mn_C_1b-SEM_C_1b)',flipud(Mn_C_1b+SEM_C_1b)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
        %     myleg = {'PL - dorsalStr','PL - ventralStr'};
        %     legend([p1,p2], myleg);
        %     legend boxoff
        
        
        xlim(params.fpass);
        %     ylim([0.4,0.8]);
        xlabel('Frequency (Hz)', 'FontWeight', 'bold')
        ylabel('Coherence', 'FontWeight', 'bold');
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        title(sprintf('%s - %s coherence during %s', Prelimbic.subregion(reg).name, Striatum.subregion(reg).name,comparison(comp).condition(1).name))
        box off
        
        
        
        subplot(3,2,3)
        hp1=plot(f1,Mn_S1_2','LineWidth',3,'Color','g');
        hold on
        hp2=plot(f1,Mn_S2_2','LineWidth',3,'Color','b');
        
        patch([f1,fliplr(f1)], [(Mn_S1_2-SEM_S1_2)',flipud(Mn_S1_2+SEM_S1_2)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
        patch([f1,fliplr(f1)], [(Mn_S2_2-SEM_S2_2)',flipud(Mn_S2_2+SEM_S2_2)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
        %     myleg = {region(1).name,region(2).name};
        %     legend([hp1,hp2], myleg);
        
        myleg = {Prelimbic.subregion(reg).name,Striatum.subregion(reg).name};
        legend([hp1,hp2], myleg);
        
        legend boxoff
        xlim(params.fpass);
        ylim([0.2,1]);
        xlabel('Frequency (Hz)', 'FontWeight', 'bold')
        ylabel('Percent power', 'FontWeight', 'bold');
        %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
        title(sprintf('Percent power during %s',comparison(comp).condition(2).name'))
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        box off
        
        subplot(3,2,4)
        p1 = plot(f1,Mn_C_2','LineWidth',3,'Color','r'); %#ok<*NASGU>
        hold on
        patch([f2,fliplr(f2)], [(Mn_C_2-SEM_C_2)',flipud(Mn_C_2+SEM_C_2)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
        
        
        %     p2 = plot(f1,Mn_C_1b','LineWidth',3,'Color','r','LineStyle',':');
        %     patch([f1,fliplr(f)], [(Mn_C_1b-SEM_C_1b)',flipud(Mn_C_1b+SEM_C_1b)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
        %     myleg = {'PL - dorsalStr','PL - ventralStr'};
        %     legend([p1,p2], myleg);
        %     legend boxoff
        
        
        xlim(params.fpass);
        %     ylim([0.4,0.8]);
        xlabel('Frequency (Hz)', 'FontWeight', 'bold')
        ylabel('Coherence', 'FontWeight', 'bold');
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        title(sprintf('%s - %s coherence during %s', Prelimbic.subregion(reg).name, Striatum.subregion(reg).name,comparison(comp).condition(2).name))
        box off
        
        
        
        
        % Plot the diff
        %     if size(S1_1,2)> size(S1_2,2)
        %         numtrials = size(S1_2,2);
        %     else
        %         numtrials = size(S1_1,2);
        %     end
        
        numtrials = size(S1_1,2);
        
        S1_d=(S1_2(:,1:numtrials) - S1_1(:,1:numtrials));
        S2_d=(S2_2(:,1:numtrials) - S2_1(:,1:numtrials));
        C_d=(C_2(:,1:numtrials) - C_1(:,1:numtrials));
        
        
        
        Mn_S1_d= mean(S1_d,2)/NormFactor;
        SEM_S1_d= std(S1_d,0,2)./sqrt(numtrials)/NormFactor;
        
        Mn_S2_d= mean(S2_d,2)/NormFactor;
        SEM_S2_d= std(S2_d,0,2)./sqrt(numtrials)/NormFactor;
        
        Mn_C_d= mean(C_d,2);
        SEM_C_d= std(C_d,0,2)./sqrt(numtrials);
        
        
        subplot(3,2,5)
        hp5 = plot(f1,Mn_S1_d','LineWidth',3,'Color','g');
        hold on
        patch([f1,fliplr(f1)], [(Mn_S1_d-SEM_S1_d)',flipud(Mn_S1_d+SEM_S1_d)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
        hp6 = plot(f1,Mn_S2_d','LineWidth',3,'Color','b');
        patch([f1,fliplr(f1)], [(Mn_S2_d-SEM_S2_d)',flipud(Mn_S2_d+SEM_S2_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
        
        %     hp7 = plot(f1,Mn_S2_b_d','LineWidth',3,'Color','b','LineStyle',':');
        %     patch([f1,fliplr(f)], [(Mn_S2_b_d-SEM_S2_b_d)',flipud(Mn_S2_b_d+SEM_S2_b_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
        
        myleg = {Prelimbic.subregion(reg).name,Striatum.subregion(reg).name};
        legend([hp5,hp6], myleg);
        legend boxoff
        
        xlim(params.fpass);
        %ylim([-5,15]);
        xlabel('Frequency (Hz)', 'FontWeight', 'bold')
        ylabel('Power change', 'FontWeight', 'bold');
        title(sprintf('%s - %s power difference', comparison(comp).condition(2).name,comparison(comp).condition(1).name))
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        box off
        
        subplot(3,2,6)
        p3 = plot(f1,Mn_C_d','LineWidth',3,'Color','r');
        hold on
        patch([f1,fliplr(f1)], [(Mn_C_d-SEM_C_d)',flipud(Mn_C_d+SEM_C_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
        %     p4 = plot(f1,Mn_C_b_d','LineWidth',3,'Color','r','LineStyle',':');
        %     patch([f1,fliplr(f)], [(Mn_C_b_d-SEM_C_b_d)',flipud(Mn_C_b_d+SEM_C_b_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
        %     myleg = {'PL - dorsalStr','PL - ventralStr'};
        %     legend([p3,p4], myleg);
        %     legend boxoff
        
        xlim(params.fpass);
        %ylim([-0.05,0.15]);
        xlabel('Frequency (Hz)', 'FontWeight', 'bold')
        ylabel('Coherence change', 'FontWeight', 'bold');
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        title(sprintf('%s - %s coherence difference', comparison(comp).condition(2).name,comparison(comp).condition(1).name))
        box off
        
        figpath = 'E:\SetShift\ANALYSES';
        figname = sprintf('%s%s%s_vs_%s%s',rat.name,fig.Name,comparison(comp).condition(1).name,comparison(comp).condition(2).name,datestr(now,30));
        saveas(fig,fullfile(figpath,figname),'png')
        saveas(fig,fullfile(figpath,figname),'fig')
        close(fig)
        
    end % end of for analysis = 1:6
    
    
    
end
