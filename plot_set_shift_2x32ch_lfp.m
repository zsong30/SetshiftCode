function plot_set_shift_2x32ch_lfp(rat)
% plot_set_shift_2x32ch_lfp(rat,2)

% Author: Eric Song
% Updated by Eric S 12/02/2021.

% read in setshift behavior data
%logfn = 'CSF01_2021_02_25__10_43_02.csv';
% minsec = 2; minimal seconds for lfp

r_lfpindices = [];
r_interval_lfp = [];
r_task_lfp = [];

for rt = 1:length(rat)
    s_lfpindices = [];
    s_interval_lfp = [];
    s_task_lfp = [];
    
    for s = 1:length(rat(rt).setshift)
              
        rl_lfpindices = []; rl_interval_lfp = []; rl_task_lfp = []; 
        for rl = 1:length(rat(rt).setshift(s).rules)
            bl_lfpindices = []; bl_interval_lfp = []; bl_task_lfp = []; 
            for bl = 1:length(rat(rt).setshift(s).rules(rl).blocks)
                lfpindices = []; interval_lfp = [];task_lfp = []; 
                for tr = 1:length(rat(rt).setshift(s).rules(rl).blocks(bl).trials)
                    %             if rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).end - ...
                    %                     rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).start > minsec
                    if isfield(rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr),'region') ...
                            && ~isempty(rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region)
                        
                        lfpindices(end+1,:) = [rt,s,rl,bl,tr,rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).performance];
                        interval_lfp = ... % 64 chan x timestamps x trials
                            cat(3,interval_lfp,[rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(1).baselinelfp; ...
                            rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(2).baselinelfp]);
                        task_lfp = ... % 64 chan x timestamps x trials
                            cat(3,task_lfp, [rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(1).tasklfp; ...
                            rat(rt).setshift(s).rules(rl).blocks(bl).trials(tr).region(2).tasklfp]); %#ok<*AGROW>
                    end
                end
                bl_lfpindices = [bl_lfpindices;lfpindices];
                
                if size(bl_interval_lfp,1) == 0
                    bl_interval_lfp = [];
                end
                bl_interval_lfp = cat(3,bl_interval_lfp, task_lfp);
                
                if size(bl_task_lfp,1) == 0 
                bl_task_lfp = [];
                end
                bl_task_lfp = cat(3,bl_task_lfp, task_lfp);
                               
            end
            rl_lfpindices = [rl_lfpindices;bl_lfpindices];
            rl_interval_lfp = cat(3,rl_interval_lfp,bl_interval_lfp);
            rl_task_lfp = cat(3,rl_task_lfp,bl_task_lfp);
                                   
        end
        s_lfpindices = [s_lfpindices;rl_lfpindices];
        s_interval_lfp = cat(3,s_interval_lfp,rl_interval_lfp);
        s_task_lfp = cat(3,s_task_lfp,rl_task_lfp);
        
    end
    r_lfpindices = [r_lfpindices;s_lfpindices];
    r_interval_lfp = cat(3,r_interval_lfp,s_interval_lfp);
    r_task_lfp = cat(3,r_task_lfp,s_task_lfp);
    
end



% set params for Chronux
params.Fs = 1500;  % it is 30000 originally but will be downsampled to 1500.
params.tapers = [3 5];
params.fpass = [0 30];
movingwin = [0.5 0.1];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];



region = struct; % creat a new region struct to organize data.

for i = 1:2
    region(i).name = rat(1).setshift(1).rules(1).blocks(1).trials(1).region(i).name;
    for j = 1:3
        region(i).rules(j).condition(1).name = 'baseline';
        region(i).rules(j).condition(2).name = 'task';
        region(i).rules(j).name = tmprat(1).setshift(1).rules(j).name;
        region(i).rules(j).condition(1).correctlfp = [];
        region(i).rules(j).condition(1).incorrectlfp = [];
        
    end
end

correct = find(r_lfpindices(:,6) == 1);
incorrect = find(r_lfpindices(:,6) == 0);









tmp = [];
for comparison = 1:6 % loop in all comparisons; 6 is hard coded, but can be any number.
    for reg = 1:3 % regions 1 and 2
        region(reg).name = rat(1).day(1).region(reg).name;
        for c = 1:2 % conditions 1 and 2
            region(reg).condition(c).name = ...
                rat(1).day(1).region(reg).condition(comparison*2-2+c).name;
            region(reg).condition(c).data = [];
        end
    end
    
    if plotnum == 1 % include all rats
        rat2incl = 'CSF01CSM01';
        for rt = 1:length(rat)
            for dy = 1:length(rat(rt).day)
                for reg = 1:3
                    for c = 1:2
                        tmp = rat(rt).day(dy).region(reg).condition(comparison*2-2+c).data;
                        region(reg).condition(c).data = ...
                            [region(reg).condition(c).data;tmp];
                    end
                end
            end
            
        end
        
    elseif plotnum == 2 % one rat, that is CSF01
        rat2incl = 'CSF01';
        rt = 1;
        for dy = 1:length(rat(rt).day)
            for reg = 1:3
                for c = 1:2
                    tmp = rat(rt).day(dy).region(reg).condition(comparison*2-2+c).data;
                    region(reg).condition(c).data = ...
                        [region(reg).condition(c).data;tmp];
                end
            end
        end
        
    elseif plotnum == 3 % one rat, that is CSM01
        rat2incl = 'CSM01';
        rt =2;
        for dy = 1:length(rat(rt).day)
            for reg = 1:3
                for c = 1:2
                    tmp = rat(rt).day(dy).region(reg).condition(comparison*2-2+c).data;
                    region(reg).condition(c).data = ...
                        [region(reg).condition(c).data;tmp];
                end
            end
        end
    end
    
    data1=region(1).condition(1).data';
    %     cdata1=rmlinesmovingwinc(data1,[2 .05],50,params,.005,'n', 60);
    %     data1=cdata1;
    data2=region(2).condition(1).data';
    %     cdata2=rmlinesmovingwinc(data2,[2 .05],100,params,.005,'n', 60);
    %     data2=cdata2;
    
    data2b=region(3).condition(1).data';
    
    
    [C_1,phi,S12_1,S1_1,S2_1,t,f]=cohgramc(data1,data2,movingwin,params); %#ok<ASGLU>
    S1_1=10*log10(S1_1);
    S2_1=10*log10(S2_1);
    % C S1, S2 are structured as times x frequencies x trials.
    %     [C_ven,phi,S12,S1,S2_ven,t,f]=cohgramc(data1,data3,movingwin,params); %#ok<ASGLU>
    %     S1=10*log10(S1);
    %     S2_ven=10*log10(S2_ven);
    
    
    
    [C_1b,phib,S12_1b,S1_1b,S2_1b,t_b,f_b]=cohgramc(data1,data2b,movingwin,params); %#ok<ASGLU>
    S2_1b=10*log10(S2_1b);
    
    
    
    
    
    data3=region(1).condition(2).data';
    %     cdata1=rmlinesmovingwinc(data1,[2 .05],50,params,.005,'n', 60);
    %     data1=cdata1;
    data4=region(2).condition(2).data';
    %     cdata2=rmlinesmovingwinc(data2,[2 .05],100,params,.005,'n', 60);
    %     data2=cdata2;
    
    
    data4b=region(3).condition(2).data';
    
    
    
    [C_2,phi,S12_2,S1_2,S2_2,t,f]=cohgramc(data3,data4,movingwin,params); %#ok<ASGLU>
    S1_2=10*log10(S1_2);
    S2_2=10*log10(S2_2);
    % C S1_side, S2 are structured as times x frequencies x trials.
    %     [C_side_ven,phi,S1_side2,S1_side,S2_side_ven,t,f]=cohgramc(data1,data3,movingwin,params); %#ok<ASGLU>
    %     S1_side=10*log10(S1_side);
    %     S2_side_ven=10*log10(S2_side_ven);
    
    
    [C_2b,phib,S12_2b,S1_2b,S2_2b,tb,fb]=cohgramc(data3,data4b,movingwin,params); %#ok<ASGLU>
    S2_2b=10*log10(S2_2b);
    
    
    
    if max(mean(squeeze(mean(S1_1,1)),2)) > max(mean(squeeze(mean(S2_1,1)),2))
        NormFactor1 = max(mean(squeeze(mean(S1_1,1)),2));
    else
        NormFactor1 = max(mean(squeeze(mean(S2_1,1)),2));
    end
    
    if NormFactor1 < max(mean(squeeze(mean(S2_1b,1)),2))
        NormFactor1 = max(mean(squeeze(mean(S2_1b,1)),2));
    end
    
    
    if max(mean(squeeze(mean(S1_2,1)),2)) > max(mean(squeeze(mean(S2_2,1)),2))
        NormFactor2 = max(mean(squeeze(mean(S1_2,1)),2));
    else
        NormFactor2 = max(mean(squeeze(mean(S2_2,1)),2));
    end
    
    
    if NormFactor2 < max(mean(squeeze(mean(S2_2b,1)),2))
        NormFactor2 = max(mean(squeeze(mean(S2_2b,1)),2));
    end
    
    
    if NormFactor1 > NormFactor2
        NormFactor = NormFactor1;
    else
        NormFactor = NormFactor2;
    end
    
    
    Mn_S1_1= mean(squeeze(mean(S1_1,1)),2)/NormFactor;
    SEM_S1_1= std(squeeze(mean(S1_1,1)),0,2)./sqrt(size(data1,1))/NormFactor;
    
    Mn_S2_1= mean(squeeze(mean(S2_1,1)),2)/NormFactor;
    SEM_S2_1= std(squeeze(mean(S2_1,1)),0,2)./sqrt(size(data1,1))/NormFactor;
    
    Mn_S2_1b= mean(squeeze(mean(S2_1b,1)),2)/NormFactor;
    SEM_S2_1b= std(squeeze(mean(S2_1b,1)),0,2)./sqrt(size(data1,1))/NormFactor;
    
    
    Mn_C_1=mean(squeeze(mean(C_1,1)),2);
    SEM_C_1=std(squeeze(mean(C_1,1)),0,2)./sqrt(size(data1,1));
    
    Mn_C_1b=mean(squeeze(mean(C_1b,1)),2);
    SEM_C_1b=std(squeeze(mean(C_1b,1)),0,2)./sqrt(size(data1,1));
    
    
    
    Mn_S1_2 = mean(squeeze(mean(S1_2,1)),2)/NormFactor;
    SEM_S1_2 = std(squeeze(mean(S1_2,1)),0,2)./sqrt(size(data3,1))/NormFactor;
    
    Mn_S2_2 = mean(squeeze(mean(S2_2,1)),2)/NormFactor;
    SEM_S2_2 = std(squeeze(mean(S2_2,1)),0,2)./sqrt(size(data3,1))/NormFactor;
    
    Mn_S2_2b= mean(squeeze(mean(S2_2b,1)),2)/NormFactor;
    SEM_S2_2b= std(squeeze(mean(S2_2b,1)),0,2)./sqrt(size(data1,1))/NormFactor;
    
    
    
    Mn_C_2=mean(squeeze(mean(C_2,1)),2);
    SEM_C_2=std(squeeze(mean(C_2,1)),0,2)./sqrt(size(data3,1));
    
    
    Mn_C_2b=mean(squeeze(mean(C_2b,1)),2);
    SEM_C_2b=std(squeeze(mean(C_2b,1)),0,2)./sqrt(size(data1,1));
    
    
    fig = figure('name',sprintf('setshift %s vs %s ', region(1).condition(1).name,region(1).condition(2).name));
    set(gcf, 'Position', get(0, 'Screensize'));
    subplot(3,2,1)
    hp1=plot(f,Mn_S1_1','LineWidth',3,'Color','g');
    hold on
    hp2=plot(f,Mn_S2_1','LineWidth',3,'Color','b');
    hp2b=plot(f,Mn_S2_1b','LineWidth',3,'Color','b','LineStyle',':');
    patch([f,fliplr(f)], [(Mn_S1_1-SEM_S1_1)',flipud(Mn_S1_1+SEM_S1_1)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f,fliplr(f)], [(Mn_S2_1-SEM_S2_1)',flipud(Mn_S2_1+SEM_S2_1)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f,fliplr(f)], [(Mn_S2_1b-SEM_S2_1b)',flipud(Mn_S2_1b+SEM_S2_1b)'],'y','EdgeColor','none', 'FaceAlpha',0.2);
    %     myleg = {region(1).name,region(2).name};
    %     legend([hp1,hp2], myleg);
    
    myleg = {region(1).name,region(2).name,region(3).name};
    legend([hp1,hp2,hp2b], myleg);
    
    
    legend boxoff
    xlim(params.fpass);
    %ylim([0,1.2]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Percent power', 'FontWeight', 'bold');
    %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
    title(sprintf('Percent power during %s',region(1).condition(1).name'))
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    box off
    
    subplot(3,2,2)
    p1 = plot(f,Mn_C_1','LineWidth',3,'Color','r'); %#ok<*NASGU>
    hold on
    patch([f,fliplr(f)], [(Mn_C_1-SEM_C_1)',flipud(Mn_C_1+SEM_C_1)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
    
    
    p2 = plot(f,Mn_C_1b','LineWidth',3,'Color','r','LineStyle',':');
    patch([f,fliplr(f)], [(Mn_C_1b-SEM_C_1b)',flipud(Mn_C_1b+SEM_C_1b)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
    myleg = {'PL - dorsalStr','PL - ventralStr'};
    legend([p1,p2], myleg);
    legend boxoff
    
    
    xlim(params.fpass);
    %     ylim([0.4,0.8]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Coherence', 'FontWeight', 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    title(sprintf('%s - striatum coherence during %s', region(1).name, region(1).condition(1).name))
    box off
    
    subplot(3,2,3)
    hp1=plot(f,Mn_S1_2','LineWidth',3,'Color','g');
    hold on
    hp2=plot(f,Mn_S2_2','LineWidth',3,'Color','b');
    hp2b=plot(f,Mn_S2_2b','LineWidth',3,'Color','b','LineStyle',':');
    patch([f,fliplr(f)], [(Mn_S1_2-SEM_S1_2)',flipud(Mn_S1_2+SEM_S1_2)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f,fliplr(f)], [(Mn_S2_2-SEM_S2_2)',flipud(Mn_S2_2+SEM_S2_2)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f,fliplr(f)], [(Mn_S2_2b-SEM_S2_2b)',flipud(Mn_S2_2b+SEM_S2_2b)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
    %     myleg = {region(1).name,region(2).name};
    %     legend([hp1,hp2], myleg);
    
    myleg = {region(1).name,region(2).name,region(3).name};
    legend([hp1,hp2,hp2b], myleg);
    
    
    legend boxoff
    xlim(params.fpass);
    %ylim([0,1.2]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Percent power', 'FontWeight', 'bold');
    %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
    title(sprintf('Percent power during %s', region(1).condition(2).name))
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    box off
    
    subplot(3,2,4)
    p1 = plot(f,Mn_C_2','LineWidth',3,'Color','r');
    hold on
    patch([f,fliplr(f)], [(Mn_C_2-SEM_C_2)',flipud(Mn_C_2+SEM_C_2)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
    p2 = plot(f,Mn_C_2b','LineWidth',3,'Color','r','LineStyle',':');
    patch([f,fliplr(f)], [(Mn_C_2b-SEM_C_2b)',flipud(Mn_C_2b+SEM_C_2b)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
    myleg = {'PL - dorsalStr','PL - ventralStr'};
    legend([p1,p2], myleg);
    legend boxoff
    xlim(params.fpass);
    %     ylim([0.4,0.8]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Coherence', 'FontWeight', 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    title(sprintf('%s - striatum coherence during %s', region(1).name, region(1).condition(2).name))
    box off
    
    % Plot the diff
    if size(S1_1,3)> size(S1_2,3)
        numtrials = size(S1_2,3);
    else
        numtrials = size(S1_1,3);
    end
    
    S1_d=(S1_1(:,:,1:numtrials) - S1_2(:,:,1:numtrials));
    S2_d=(S2_1(:,:,1:numtrials) - S2_2(:,:,1:numtrials));
    C_d=(C_1(:,:,1:numtrials) - C_2(:,:,1:numtrials));
    
    S2_b_d=(S2_1b(:,:,1:numtrials) - S2_2b(:,:,1:numtrials));
    C_b_d=(C_1b(:,:,1:numtrials) - C_2b(:,:,1:numtrials));
    
    Mn_S1_d=mean(squeeze(mean(S1_d,1)),2)/NormFactor;
    SEM_S1_d=std(squeeze(mean(S1_d,1)),0,2)./sqrt(numtrials)/NormFactor;
    
    Mn_S2_d=mean(squeeze(mean(S2_d,1)),2)/NormFactor;
    SEM_S2_d=std(squeeze(mean(S2_d,1)),0,2)./sqrt(numtrials)/NormFactor;
    
    Mn_C_d=mean(squeeze(mean(C_d,1)),2);
    SEM_C_d=std(squeeze(mean(C_d,1)),0,2)./sqrt(numtrials);
    
    Mn_S2_b_d=mean(squeeze(mean(S2_b_d,1)),2)/NormFactor;
    SEM_S2_b_d=std(squeeze(mean(S2_b_d,1)),0,2)./sqrt(numtrials)/NormFactor;
    
    Mn_C_b_d=mean(squeeze(mean(C_b_d,1)),2);
    SEM_C_b_d=std(squeeze(mean(C_b_d,1)),0,2)./sqrt(numtrials);
    
    subplot(3,2,5)
    hp5 = plot(f,Mn_S1_d','LineWidth',3,'Color','g');
    hold on
    patch([f,fliplr(f)], [(Mn_S1_d-SEM_S1_d)',flipud(Mn_S1_d+SEM_S1_d)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
    hp6 = plot(f,Mn_S2_d','LineWidth',3,'Color','b');
    patch([f,fliplr(f)], [(Mn_S2_d-SEM_S2_d)',flipud(Mn_S2_d+SEM_S2_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
    
    hp7 = plot(f,Mn_S2_b_d','LineWidth',3,'Color','b','LineStyle',':');
    patch([f,fliplr(f)], [(Mn_S2_b_d-SEM_S2_b_d)',flipud(Mn_S2_b_d+SEM_S2_b_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
    
    myleg = {region(1).name,region(2).name,region(3).name};
    legend([hp5,hp6,hp7], myleg);
    legend boxoff
    
    xlim(params.fpass);
    %ylim([-5,15]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Power change', 'FontWeight', 'bold');
    title(sprintf('%s - %s power difference', region(1).condition(1).name,region(1).condition(2).name))
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    box off
    
    subplot(3,2,6)
    p3 = plot(f,Mn_C_d','LineWidth',3,'Color','r');
    hold on
    patch([f,fliplr(f)], [(Mn_C_d-SEM_C_d)',flipud(Mn_C_d+SEM_C_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
    p4 = plot(f,Mn_C_b_d','LineWidth',3,'Color','r','LineStyle',':');
    patch([f,fliplr(f)], [(Mn_C_b_d-SEM_C_b_d)',flipud(Mn_C_b_d+SEM_C_b_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
    myleg = {'PL - dorsalStr','PL - ventralStr'};
    legend([p3,p4], myleg);
    legend boxoff
    
    xlim(params.fpass);
    %ylim([-0.05,0.15]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Coherence change', 'FontWeight', 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    title(sprintf('%s - %s coherence difference', region(1).condition(1).name,region(1).condition(2).name))
    box off
    
    figpath = 'E:\SetShift\ANALYSES';
    figname = sprintf('%s%s.fig',rat2incl,fig.Name);
    figname2 = sprintf('%s%s.png',rat2incl,fig.Name);
    saveas(fig,fullfile(figpath,figname))
    saveas(fig,fullfile(figpath,figname2))
    close(fig)
    
end % end of for analysis = 1:6