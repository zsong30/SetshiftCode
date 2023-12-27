function stats = plot_set_shift_NP_lfp(rat)
% plot_set_shift_NP_lfp(rat,2)

% Author: Eric Song
% Updated by Eric S 12/02/2021.

figpath = 'E:\SetShift\ANALYSES';
Rat = struct;
for i = 1:length(rat)
Rat(i).Prelimbic.name = 'PL';
Rat(i).Prelimbic.subregion(1).name = 'dorsalPL';
Rat(i).Prelimbic.subregion(2).name = 'ventralPL';
Rat(i).Striatum.name = 'ST';
Rat(i).Striatum.subregion(1).name = 'dorsalST';
Rat(i).Striatum.subregion(2).name = 'ventralST';
end

Rat(1).Prelimbic.subregion(1).channels = (374:383);
Rat(1).Prelimbic.subregion(2).channels = (22:31);
Rat(1).Striatum.subregion(1).channels = (374:383)+384;
Rat(1).Striatum.subregion(2).channels = (22:31)+384;

Rat(2).Prelimbic.subregion(1).channels = (374:383);
Rat(2).Prelimbic.subregion(2).channels = (22:31);
Rat(2).Striatum.subregion(1).channels = (374:383)+384;
Rat(2).Striatum.subregion(2).channels = (22:31)+384;


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
            if isempty(rl_baseline_lfp)
                rl_baseline_lfp = bl_baseline_lfp;
            else
            rl_baseline_lfp = cat(3,rl_baseline_lfp,bl_baseline_lfp);    
            end
            
            if isempty(rl_task_lfp)
                rl_task_lfp = bl_task_lfp;
            else
            rl_task_lfp = cat(3,rl_task_lfp,bl_task_lfp);    
            end
                        
        end
        s_lfpindices = [s_lfpindices;rl_lfpindices];
        s_baseline_lfp = cat(3,s_baseline_lfp,rl_baseline_lfp);
        s_task_lfp = cat(3,s_task_lfp,rl_task_lfp);
        
    end
    Rat(rt).lfpindices = s_lfpindices;
    Rat(rt).baseline_lfp = s_baseline_lfp;
    Rat(rt).task_lfp = s_task_lfp;
    
end


% set params for Chronux
params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [2 3];
params.fpass = [0 30];
movingwin = [0.5 0.1];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];

for rt = 1:length(Rat)

% r_lfpindices: rt,s,rl,bl,tr,performance
interval = find(Rat(rt).lfpindices(:,1) > 0); % all points
task = find(Rat(rt).lfpindices(:,1) > 0); % all points

correct = find(Rat(rt).lfpindices(:,6) == 1);
incorrect = find(Rat(rt).lfpindices(:,6) == 0);
side = find(Rat(rt).lfpindices(:,3) >4);
light = find(Rat(rt).lfpindices(:,3) < 5);
side_correct = find(Rat(rt).lfpindices(:,3)>4&Rat(rt).lfpindices(:,6) == 1);
side_incorrect = find(Rat(rt).lfpindices(:,3)>4&Rat(rt).lfpindices(:,6) == 0);

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

comparison(4).condition(1).index = side_incorrect;
comparison(4).condition(1).name = 'Side Incorrect';
comparison(4).condition(2).index = side_correct;
comparison(4).condition(2).name = 'Side Correct';

channel = struct;

for comp = 1:4 % loop in all comparisons; 6 is hard coded, but can be any number.
        
        fig = figure('name',sprintf('%s setshift %s vs %s ', rat(rt).name, Rat(rt).Prelimbic.name,Rat(rt).Striatum.name));
    fig.WindowStyle = 'normal';
    set(gcf, 'Position', get(0, 'Screensize'));
        
    for ch = 1:length(Rat(1).Prelimbic.subregion(1).channels)
    
    reg = 1; %  dorsal subregions for both PL and ST
    % 768 chan x timestamps x trial for r_task_lfp
    if comp == 1
        data1 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).baseline_lfp);
        data1 = data1(:,comparison(comp).condition(1).index);
        
        data2 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).baseline_lfp);
        data2 = data2(:,comparison(comp).condition(1).index);
        
        
        data3 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data3 = data3(:,comparison(comp).condition(2).index);
        
        data4 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data4 = data4(:,comparison(comp).condition(2).index);

    else
        
        data1 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data1 = data1(:,comparison(comp).condition(1).index);
        
        data2 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data2 = data2(:,comparison(comp).condition(1).index);
        
        
        data3 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data3 = data3(:,comparison(comp).condition(2).index);
        
        data4 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data4 = data4(:,comparison(comp).condition(2).index);
        
                
    end
    
    [C_1,phi1,S12_1,S1_1,S2_1,f1,~,~,~] = coherencyc(data1,data2,params); %#ok<ASGLU>
    
    % C: frqs x trials.
    S1_1=10*log10(S1_1);
    S2_1=10*log10(S2_1);
    
    channel(ch).C_1= C_1;
    channel(ch).S1_1 = S1_1;
    channel(ch).S2_1 = S2_1;
    
    [C_2,phi2,S12_2,S1_2,S2_2,f2,~,~,~]=coherencyc(data3,data4,params); %#ok<ASGLU>
    S1_2=10*log10(S1_2);
    S2_2=10*log10(S2_2);
    
    channel(ch).C_2 = C_2;
    channel(ch).S1_2 = S1_2;
    channel(ch).S2_2 = S2_2;

    reg = 2; %  ventral subregions for both PL and ST
    
     if comp == 1
        data5 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).baseline_lfp);
        data5 = data5(:,comparison(comp).condition(1).index);
        
        data6 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).baseline_lfp);
        data6 = data6(:,comparison(comp).condition(1).index);
        
        
        data7 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data7 = data7(:,comparison(comp).condition(2).index);
        
        data8 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data8 = data8(:,comparison(comp).condition(2).index);

    else
        
        data5 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data5 = data5(:,comparison(comp).condition(1).index);
        
        data6 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data6 = data6(:,comparison(comp).condition(1).index);
        
        
        data7 = neuropixel_REreference(Rat(rt).Prelimbic.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data7 = data7(:,comparison(comp).condition(2).index);
        
        data8 = neuropixel_REreference(Rat(rt).Striatum.subregion(reg).channels(ch),Rat(rt).task_lfp);
        data8 = data8(:,comparison(comp).condition(2).index);
              
    end
    
    [C_3,phi3,S12_3,S1_3,S2_3,f3,~,~,~] = coherencyc(data5,data6,params); %#ok<ASGLU>
    
    % C: frqs x trials.
    
    S1_3=10*log10(S1_3);
    S2_3=10*log10(S2_3);
    
    channel(ch).C_3 = C_3;
    channel(ch).S1_3 = S1_3;
    channel(ch).S2_3 = S2_3;
    
    
    [C_4,phi4,S12_4,S1_4,S2_4,f4,~,~,~]=coherencyc(data7,data8,params); %#ok<ASGLU>
    S1_4=10*log10(S1_4);
    S2_4=10*log10(S2_4);
    
    channel(ch).C_4 = C_4;
    channel(ch).S1_4 = S1_4;
    channel(ch).S2_4 = S2_4;
    
     end % end of for ch = 1:length(channel) 
     
     
     S1_1 = [];
     S1_2 = [];
     S1_3 = [];
     S1_4 = [];
    
     S2_1 = [];
     S2_2 = [];
     S2_3 = [];
     S2_4 = [];
     
     C_1 = [];
     C_2 = [];
     C_3 = [];
     C_4 = [];
     
     
     for ch = 1:length(channel)
       
       S1_1 = cat(3,channel(ch).S1_1,S1_1); % frq x trial x channel
       S1_2 = cat(3,channel(ch).S1_2,S1_2);
       S1_3 = cat(3,channel(ch).S1_3,S1_3);
       S1_4 = cat(3,channel(ch).S1_4,S1_4);
       
       S2_1 = cat(3,channel(ch).S2_1,S2_1);
       S2_2 = cat(3,channel(ch).S2_2,S2_2);
       S2_3 = cat(3,channel(ch).S2_3,S2_3);
       S2_4 = cat(3,channel(ch).S2_4,S2_4);
       
       C_1 = cat(3,channel(ch).C_1,C_1);
       C_2 = cat(3,channel(ch).C_2,C_2);
       C_3 = cat(3,channel(ch).C_3,C_3);
       C_4 = cat(3,channel(ch).C_4,C_4);
        
    end
    
    
    S1_1 = median(S1_1,3);   S1_1 = S1_1(:,~any(isnan(S1_1),1));
    
    S1_2 = median(S1_2,3);   S1_2 = S1_2(:,~any(isnan(S1_2),1));
    
    S1_3 = median(S1_3,3);   S1_3 = S1_3(:,~any(isnan(S1_3),1));
    
    S1_4 = median(S1_4,3);  S1_4 = S1_4(:,~any(isnan(S1_4),1));
    
    S2_1 = median(S2_1,3);  S2_1 = S2_1(:,~any(isnan(S2_1),1));
    S2_2 = median(S2_2,3);  S2_2 = S2_2(:,~any(isnan(S2_2),1)); 
    S2_3 = median(S2_3,3);  S2_3 = S2_3(:,~any(isnan(S2_3),1));
    S2_4 = median(S2_4,3);  S2_4 = S2_4(:,~any(isnan(S2_4),1));
    
    C_1 = median(C_1,3);  C_1 = C_1(:,~any(isnan(C_1),1));
    C_2 = median(C_2,3);  C_2 = C_2(:,~any(isnan(C_2),1));
    C_3 = median(C_3,3);  C_3 = C_3(:,~any(isnan(C_3),1));
    C_4 = median(C_4,3);  C_4 = C_4(:,~any(isnan(C_4),1));
    
     
       
    NormFactor = max([max(median(S1_1,2)),max(median(S1_2,2)),max(median(S1_3,2)),max(median(S1_4,2))...
        max(median(S2_1,2)),max(median(S2_2,2)),max(median(S2_3,2)),max(median(S2_4,2))]);
    % Using max is because we want to normalize to 0-1 scale.
    
    Mn_S1_1= median(S1_1,2)/NormFactor;
    SEM_S1_1= std(S1_1,0,2,'omitnan')./sqrt(size(data1,1))/NormFactor;
    
    Mn_S2_1= median(S2_1,2)/NormFactor;
    SEM_S2_1= std(S2_1,0,2,'omitnan')./sqrt(size(data1,1))/NormFactor;
    
    Mn_C_1= median(C_1,2);
    SEM_C_1= std(C_1,0,2,'omitnan')./sqrt(size(data1,1));
        
    
    Mn_S1_2= median(S1_2,2)/NormFactor;
    SEM_S1_2= std(S1_2,0,2,'omitnan')./sqrt(size(data1,1))/NormFactor;
    
    Mn_S2_2= median(S2_2,2)/NormFactor;
    SEM_S2_2= std(S2_2,0,2,'omitnan')./sqrt(size(data1,1))/NormFactor;
    
    Mn_C_2= median(C_2,2);
    SEM_C_2= std(C_2,0,2,'omitnan')./sqrt(size(data1,1));
    
    
        
    Mn_S1_3= median(S1_3,2)/NormFactor;
    SEM_S1_3= std(S1_3,0,2,'omitnan')./sqrt(size(data5,1))/NormFactor;
    
    Mn_S2_3= median(S2_3,2)/NormFactor;
    SEM_S2_3= std(S2_3,0,2,'omitnan')./sqrt(size(data5,1))/NormFactor;
    
    Mn_C_3= median(C_3,2);
    SEM_C_3= std(C_3,0,2,'omitnan')./sqrt(size(data5,1));
        
    
    Mn_S1_4= median(S1_4,2)/NormFactor;
    SEM_S1_4= std(S1_4,0,2,'omitnan')./sqrt(size(data5,1))/NormFactor;
    
    Mn_S2_4= median(S2_4,2)/NormFactor;
    SEM_S2_4= std(S2_4,0,2,'omitnan')./sqrt(size(data5,1))/NormFactor;
    
    Mn_C_4= median(C_4,2);
    SEM_C_4= std(C_4,0,2,'omitnan')./sqrt(size(data5,1));
    
      
    

    % start plotting
    subplot(3,2,1)
    hp1=plot(f1,Mn_S1_1','LineWidth',3,'Color','g');
    hold on
    hp2=plot(f1,Mn_S2_1','LineWidth',3,'Color','b');
    hp3=plot(f3,Mn_S1_3','LineWidth',3,'Color','y');
    hp4=plot(f3,Mn_S2_3','LineWidth',3,'Color','m');
    
    patch([f1,fliplr(f1)], [(Mn_S1_1-SEM_S1_1)',flipud(Mn_S1_1+SEM_S1_1)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f1,fliplr(f1)], [(Mn_S2_1-SEM_S2_1)',flipud(Mn_S2_1+SEM_S2_1)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f3,fliplr(f3)], [(Mn_S1_3-SEM_S1_3)',flipud(Mn_S1_3+SEM_S1_3)'],'y','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f3,fliplr(f3)], [(Mn_S2_3-SEM_S2_3)',flipud(Mn_S2_3+SEM_S2_3)'],'m','EdgeColor','none', 'FaceAlpha',0.2);
    
    myleg = {Rat(rt).Prelimbic.subregion(1).name,Rat(rt).Striatum.subregion(1).name,...
        Rat(rt).Prelimbic.subregion(2).name,Rat(rt).Striatum.subregion(2).name};
    legend([hp1,hp2,hp3,hp4], myleg);
    
    legend boxoff
    xlim(params.fpass);
    ylim([0,1]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Percent power', 'FontWeight', 'bold');
    %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
    title(sprintf('Percent power during %s',comparison(comp).condition(1).name'))
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    box off
    
    subplot(3,2,2)
    p1 = plot(f1,Mn_C_1','LineWidth',3,'Color','r'); %#ok<*NASGU>
    hold on
    p2 = plot(f3,Mn_C_3','LineWidth',3,'Color','c'); %#ok<*NASGU>
    
    patch([f1,fliplr(f1)], [(Mn_C_1-SEM_C_1)',flipud(Mn_C_1+SEM_C_1)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f3,fliplr(f3)], [(Mn_C_3-SEM_C_3)',flipud(Mn_C_3+SEM_C_3)'],'c','EdgeColor','none', 'FaceAlpha',0.2);
    
    
    myleg = {sprintf('%s - %s',Rat(rt).Prelimbic.subregion(1).name,Rat(rt).Striatum.subregion(1).name),...
        sprintf('%s - %s',Rat(rt).Prelimbic.subregion(2).name,Rat(rt).Striatum.subregion(2).name)};
    legend([p1,p2], myleg);
    legend boxoff
    
    xlim(params.fpass);
    ylim([0.3,1]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Coherence', 'FontWeight', 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    title(sprintf('%s - %s coherence during %s', Rat(rt).Prelimbic.name, Rat(rt).Striatum.name, comparison(comp).condition(1).name))
    box off
    
    
    
    subplot(3,2,3)
    hp1=plot(f1,Mn_S1_2','LineWidth',3,'Color','g');
    hold on
    hp2=plot(f1,Mn_S2_2','LineWidth',3,'Color','b');
    hp3=plot(f3,Mn_S1_4','LineWidth',3,'Color','y');
    hp4=plot(f3,Mn_S2_4','LineWidth',3,'Color','m');
    
    patch([f1,fliplr(f1)], [(Mn_S1_2-SEM_S1_2)',flipud(Mn_S1_2+SEM_S1_2)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f1,fliplr(f1)], [(Mn_S2_2-SEM_S2_2)',flipud(Mn_S2_2+SEM_S2_2)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f3,fliplr(f3)], [(Mn_S1_4-SEM_S1_4)',flipud(Mn_S1_4+SEM_S1_4)'],'y','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f3,fliplr(f3)], [(Mn_S2_4-SEM_S2_4)',flipud(Mn_S2_4+SEM_S2_4)'],'m','EdgeColor','none', 'FaceAlpha',0.2);
    
    %     myleg = {region(1).name,region(2).name};
    %     legend([hp1,hp2], myleg);
    
    myleg = {Rat(rt).Prelimbic.subregion(1).name,Rat(rt).Striatum.subregion(1).name,...
        Rat(rt).Prelimbic.subregion(2).name,Rat(rt).Striatum.subregion(2).name};
    legend([hp1,hp2,hp3,hp4], myleg);
    
    legend boxoff
    xlim(params.fpass);
    ylim([0,1]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Percent power', 'FontWeight', 'bold');
    %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
    title(sprintf('Percent power during %s',comparison(comp).condition(2).name'))
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    box off
    
    subplot(3,2,4)
    p1 = plot(f1,Mn_C_2','LineWidth',3,'Color','r'); %#ok<*NASGU>
    hold on
    p2 = plot(f3,Mn_C_4','LineWidth',3,'Color','c'); %#ok<*NASGU>
    
    patch([f2,fliplr(f2)], [(Mn_C_2-SEM_C_2)',flipud(Mn_C_2+SEM_C_2)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
    patch([f4,fliplr(f4)], [(Mn_C_4-SEM_C_4)',flipud(Mn_C_4+SEM_C_4)'],'c','EdgeColor','none', 'FaceAlpha',0.2);
    
    %     p2 = plot(f1,Mn_C_1b','LineWidth',3,'Color','r','LineStyle',':');
    %     patch([f1,fliplr(f)], [(Mn_C_1b-SEM_C_1b)',flipud(Mn_C_1b+SEM_C_1b)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
    %     myleg = {'PL - dorsalStr','PL - ventralStr'};
    %     legend([p1,p2], myleg);
    %     legend boxoff
    
     myleg = {sprintf('%s - %s',Rat(rt).Prelimbic.subregion(1).name,Rat(rt).Striatum.subregion(1).name),...
        sprintf('%s - %s',Rat(rt).Prelimbic.subregion(2).name,Rat(rt).Striatum.subregion(2).name)};
    legend([p1,p2], myleg);
    legend boxoff
    
    xlim(params.fpass);
    ylim([0.3,1]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Coherence', 'FontWeight', 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    title(sprintf('%s - %s coherence during %s', Rat(rt).Prelimbic.name, Rat(rt).Striatum.name, comparison(comp).condition(2).name))
    box off
       
    
    
    % Plot the diff

    if size(C_1,2)> size(C_2,2)
        numtrials = size(C_2,2);
    else
        numtrials = size(C_1,2);
    end

    
    S1_d=(S1_2(:,1:numtrials) - S1_1(:,1:numtrials));
    S2_d=(S2_2(:,1:numtrials) - S2_1(:,1:numtrials));
    C_d=(C_2(:,1:numtrials) - C_1(:,1:numtrials));
    
    
    
    Mn_S1_d= median(S1_d,2)/NormFactor;
    SEM_S1_d= std(S1_d,0,2,'omitnan')./sqrt(numtrials)/NormFactor;
    
    Mn_S2_d= median(S2_d,2)/NormFactor;
    SEM_S2_d= std(S2_d,0,2,'omitnan')./sqrt(numtrials)/NormFactor;
    
    Mn_C_d= median(C_d,2);
    SEM_C_d= std(C_d,0,2,'omitnan')./sqrt(numtrials);
    
    
    
    
    S1_d2=(S1_4(:,1:numtrials) - S1_3(:,1:numtrials));
    S2_d2=(S2_4(:,1:numtrials) - S2_3(:,1:numtrials));
    C_d2=(C_4(:,1:numtrials) - C_3(:,1:numtrials));
    
    
    
    Mn_S1_d2= median(S1_d2,2)/NormFactor;
    SEM_S1_d2= std(S1_d2,0,2,'omitnan')./sqrt(numtrials)/NormFactor;
    
    Mn_S2_d2= median(S2_d2,2)/NormFactor;
    SEM_S2_d2= std(S2_d2,0,2,'omitnan')./sqrt(numtrials)/NormFactor;
    
    Mn_C_d2= median(C_d2,2);
    SEM_C_d2= std(C_d2,0,2,'omitnan')./sqrt(numtrials);
    
   
    [clusters, p_values, t_sums, permutation_distribution] = permutest( C_d, C_d2, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffDoVenC.frequency = f1;
    comparison(comp).stateDiffDoVenC.clusters = clusters;
    comparison(comp).stateDiffDoVenC.p_values = p_values;
    comparison(comp).stateDiffDoVenC.t_sums = t_sums;
    comparison(comp).stateDiffDoVenC.permutation_distribution = permutation_distribution;
    
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( S1_d, S1_d2, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffDoVenPL.frequency = f1;
    comparison(comp).stateDiffDoVenPL.clusters = clusters;
    comparison(comp).stateDiffDoVenPL.p_values = p_values;
    comparison(comp).stateDiffDoVenPL.t_sums = t_sums;
    comparison(comp).stateDiffDoVenPL.permutation_distribution = permutation_distribution;
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( S2_d, S2_d2, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffDoVenST.frequency = f1;
    comparison(comp).stateDiffDoVenST.clusters = clusters;
    comparison(comp).stateDiffDoVenST.p_values = p_values;
    comparison(comp).stateDiffDoVenST.t_sums = t_sums;
    comparison(comp).stateDiffDoVenST.permutation_distribution = permutation_distribution;
    
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( C_1, C_2, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffDorC.frequency = f1;
    comparison(comp).stateDiffDorC.clusters = clusters;
    comparison(comp).stateDiffDorC.p_values = p_values;
    comparison(comp).stateDiffDorC.t_sums = t_sums;
    comparison(comp).stateDiffDorC.permutation_distribution = permutation_distribution;
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( C_3, C_4, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffVenC.frequency = f1;
    comparison(comp).stateDiffVenC.clusters = clusters;
    comparison(comp).stateDiffVenC.p_values = p_values;
    comparison(comp).stateDiffVenC.t_sums = t_sums;
    comparison(comp).stateDiffVenC.permutation_distribution = permutation_distribution;
    
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( S1_1, S1_2, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffDorPL.frequency = f1;
    comparison(comp).stateDiffDorPL.clusters = clusters;
    comparison(comp).stateDiffDorPL.p_values = p_values;
    comparison(comp).stateDiffDorPL.t_sums = t_sums;
    comparison(comp).stateDiffDorPL.permutation_distribution = permutation_distribution;
    
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( S2_1, S2_2, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffDorST.frequency = f1;
    comparison(comp).stateDiffDorST.clusters = clusters;
    comparison(comp).stateDiffDorST.p_values = p_values;
    comparison(comp).stateDiffDorST.t_sums = t_sums;
    comparison(comp).stateDiffDorST.permutation_distribution = permutation_distribution;
    
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( S1_3, S1_4, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffVenPL.frequency = f1;
    comparison(comp).stateDiffVenPL.clusters = clusters;
    comparison(comp).stateDiffVenPL.p_values = p_values;
    comparison(comp).stateDiffVenPL.t_sums = t_sums;
    comparison(comp).stateDiffVenPL.permutation_distribution = permutation_distribution;
    
    
    [clusters, p_values, t_sums, permutation_distribution] = permutest( S2_3, S2_4, false, ...
        0.05, 1000, true, 4);
    comparison(comp).stateDiffVenST.frequency = f1;
    comparison(comp).stateDiffVenST.clusters = clusters;
    comparison(comp).stateDiffVenST.p_values = p_values;
    comparison(comp).stateDiffVenST.t_sums = t_sums;
    comparison(comp).stateDiffVenST.permutation_distribution = permutation_distribution;
    
    
    subplot(3,2,5)
    hp5 = plot(f1,Mn_S1_d','LineWidth',3,'Color','g');
    hold on
    patch([f1,fliplr(f1)], [(Mn_S1_d-SEM_S1_d)',flipud(Mn_S1_d+SEM_S1_d)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
    hp6 = plot(f1,Mn_S2_d','LineWidth',3,'Color','b');
    patch([f1,fliplr(f1)], [(Mn_S2_d-SEM_S2_d)',flipud(Mn_S2_d+SEM_S2_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
    hp7 = plot(f3,Mn_S1_d2','LineWidth',3,'Color','y');
    patch([f3,fliplr(f3)], [(Mn_S1_d2-SEM_S1_d2)',flipud(Mn_S1_d2+SEM_S1_d2)'],'y','EdgeColor','none', 'FaceAlpha',0.2)
    hp8 = plot(f3,Mn_S2_d2','LineWidth',3,'Color','m');
    patch([f3,fliplr(f3)], [(Mn_S2_d2-SEM_S2_d2)',flipud(Mn_S2_d2+SEM_S2_d2)'],'m','EdgeColor','none', 'FaceAlpha',0.2)
    
    %     hp7 = plot(f1,Mn_S2_b_d','LineWidth',3,'Color','b','LineStyle',':');
    %     patch([f1,fliplr(f)], [(Mn_S2_b_d-SEM_S2_b_d)',flipud(Mn_S2_b_d+SEM_S2_b_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
    
    myleg = {Rat(rt).Prelimbic.subregion(1).name,Rat(rt).Striatum.subregion(1).name,...
        Rat(rt).Prelimbic.subregion(2).name,Rat(rt).Striatum.subregion(2).name};
    legend([hp5,hp6,hp7,hp8], myleg);
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
    p4 = plot(f3,Mn_C_d2','LineWidth',3,'Color','c');
    patch([f3,fliplr(f3)], [(Mn_C_d2-SEM_C_d2)',flipud(Mn_C_d2+SEM_C_d2)'],'c','EdgeColor','none', 'FaceAlpha',0.2)
    
    %     p4 = plot(f1,Mn_C_b_d','LineWidth',3,'Color','r','LineStyle',':');
    %     patch([f1,fliplr(f)], [(Mn_C_b_d-SEM_C_b_d)',flipud(Mn_C_b_d+SEM_C_b_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
    %     myleg = {'PL - dorsalStr','PL - ventralStr'};
    %     legend([p3,p4], myleg);
    %     legend boxoff
    myleg = {sprintf('%s - %s',Rat(rt).Prelimbic.subregion(1).name,Rat(rt).Striatum.subregion(1).name),...
        sprintf('%s - %s',Rat(rt).Prelimbic.subregion(2).name,Rat(rt).Striatum.subregion(2).name)};
    legend([p3,p4], myleg);
    legend boxoff
    
    xlim(params.fpass);
    ylim([-0.15,0.15]);
        
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Coherence change', 'FontWeight', 'bold');

    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    title(sprintf('%s - %s coherence difference', comparison(comp).condition(2).name,comparison(comp).condition(1).name))
    box off
       
   
    figname = sprintf('%s%s_vs_%s%s',fig.Name,comparison(comp).condition(2).name,comparison(comp).condition(1).name,datestr(now,30));
    saveas(fig,fullfile(figpath,figname),'png')
    saveas(fig,fullfile(figpath,figname),'fig')
    close(fig)

end % end of for comparisons = 1:4
stats(rt).comparison = comparison;
clear comparison












end % end of Rat.
