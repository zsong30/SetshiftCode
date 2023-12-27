function plot_set_shift_lfp_analyses_doubleContrast(rat,plotnum)
% plot_set_shift_lfp_analyses_doubleContrast(rat,1)

% set params for Chronux
params.Fs = 1500;  % it is 30000 originally but will be downsampled to 1500.
params.tapers = [3 5];
params.fpass = [1 30];
movingwin = [0.5 .001];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];
%%
region = struct; % creat a new region struct to organize data.

tmp = [];
for comparison = 4:4 % RearRule vs FrontRule
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
        
%     
%     Mn_S1_1= mean(squeeze(mean(S1_1,1)),2)/NormFactor;
%     SEM_S1_1= std(squeeze(mean(S1_1,1)),0,2)./sqrt(size(data1,1))/NormFactor;
%     
%     Mn_S2_1= mean(squeeze(mean(S2_1,1)),2)/NormFactor;
%     SEM_S2_1= std(squeeze(mean(S2_1,1)),0,2)./sqrt(size(data1,1))/NormFactor;
%     
%     Mn_S2_1b= mean(squeeze(mean(S2_1b,1)),2)/NormFactor;
%     SEM_S2_1b= std(squeeze(mean(S2_1b,1)),0,2)./sqrt(size(data1,1))/NormFactor;
%         
%     
%     Mn_C_1=mean(squeeze(mean(C_1,1)),2);
%     SEM_C_1=std(squeeze(mean(C_1,1)),0,2)./sqrt(size(data1,1));
%     
%     Mn_C_1b=mean(squeeze(mean(C_1b,1)),2);
%     SEM_C_1b=std(squeeze(mean(C_1b,1)),0,2)./sqrt(size(data1,1));
%     
%     
%     
%     Mn_S1_2 = mean(squeeze(mean(S1_2,1)),2)/NormFactor;
%     SEM_S1_2 = std(squeeze(mean(S1_2,1)),0,2)./sqrt(size(data3,1))/NormFactor;
%     
%     Mn_S2_2 = mean(squeeze(mean(S2_2,1)),2)/NormFactor;
%     SEM_S2_2 = std(squeeze(mean(S2_2,1)),0,2)./sqrt(size(data3,1))/NormFactor;
%     
%     Mn_S2_2b= mean(squeeze(mean(S2_2b,1)),2)/NormFactor;
%     SEM_S2_2b= std(squeeze(mean(S2_2b,1)),0,2)./sqrt(size(data1,1))/NormFactor;
%     
%     
%     
%     Mn_C_2=mean(squeeze(mean(C_2,1)),2);
%     SEM_C_2=std(squeeze(mean(C_2,1)),0,2)./sqrt(size(data3,1));
%     
%     
%     Mn_C_2b=mean(squeeze(mean(C_2b,1)),2);
%     SEM_C_2b=std(squeeze(mean(C_2b,1)),0,2)./sqrt(size(data1,1));
    
    
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
    
%     subplot(3,2,5)
%     hp5 = plot(f,Mn_S1_d','LineWidth',3,'Color','g');
%     hold on
%     patch([f,fliplr(f)], [(Mn_S1_d-SEM_S1_d)',flipud(Mn_S1_d+SEM_S1_d)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
%     hp6 = plot(f,Mn_S2_d','LineWidth',3,'Color','b');
%     patch([f,fliplr(f)], [(Mn_S2_d-SEM_S2_d)',flipud(Mn_S2_d+SEM_S2_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
%     
%       hp7 = plot(f,Mn_S2_b_d','LineWidth',3,'Color','b','LineStyle',':');
%       patch([f,fliplr(f)], [(Mn_S2_b_d-SEM_S2_b_d)',flipud(Mn_S2_b_d+SEM_S2_b_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
%     
%     myleg = {region(1).name,region(2).name,region(3).name};
%     legend([hp5,hp6,hp7], myleg);
%     legend boxoff
%     
%     xlim(params.fpass);
%     %ylim([-5,15]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Power change', 'FontWeight', 'bold');
%     title(sprintf('%s - %s power difference', region(1).condition(1).name,region(1).condition(2).name))
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     box off
%     
%     subplot(3,2,6)
%     p3 = plot(f,Mn_C_d','LineWidth',3,'Color','r');
%     hold on
%     patch([f,fliplr(f)], [(Mn_C_d-SEM_C_d)',flipud(Mn_C_d+SEM_C_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%         p4 = plot(f,Mn_C_b_d','LineWidth',3,'Color','r','LineStyle',':');
%         patch([f,fliplr(f)], [(Mn_C_b_d-SEM_C_b_d)',flipud(Mn_C_b_d+SEM_C_b_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%         myleg = {'PL - dorsalStr','PL - ventralStr'};
%         legend([p3,p4], myleg);
%         legend boxoff
%     
%     xlim(params.fpass);
%     %ylim([-0.05,0.15]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Coherence change', 'FontWeight', 'bold');
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     title(sprintf('%s - %s coherence difference', region(1).condition(1).name,region(1).condition(2).name))
%     box off
%     
%     figpath = 'G:\My Drive\Setshift\figures2';
%     figname = sprintf('%s%s.fig',rat2incl,fig.Name);
%     figname2 = sprintf('%s%s.png',rat2incl,fig.Name);
%     saveas(fig,fullfile(figpath,figname))
%     saveas(fig,fullfile(figpath,figname2))
%     close(fig)
%     
    
end % end of for analysis = 1:6

a = NormFactor;  

%%
region = struct; % creat a new region struct to organize data.

tmp = [];
for comparison = 5:5 % SideRuleCorrect vs SideRuleIncorrect
    for reg = 1:3 % regions 1, 2, 3
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
    
    
%     fig = figure('name',sprintf('setshift %s vs %s ', region(1).condition(1).name,region(1).condition(2).name));
%     set(gcf, 'Position', get(0, 'Screensize'));
%     subplot(3,2,1)
%     hp1=plot(f,Mn_S1_1','LineWidth',3,'Color','g');
%     hold on
%     hp2=plot(f,Mn_S2_1','LineWidth',3,'Color','b');
%     hp2b=plot(f,Mn_S2_1b','LineWidth',3,'Color','b','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_S1_1-SEM_S1_1)',flipud(Mn_S1_1+SEM_S1_1)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
%     patch([f,fliplr(f)], [(Mn_S2_1-SEM_S2_1)',flipud(Mn_S2_1+SEM_S2_1)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
%     patch([f,fliplr(f)], [(Mn_S2_1b-SEM_S2_1b)',flipud(Mn_S2_1b+SEM_S2_1b)'],'y','EdgeColor','none', 'FaceAlpha',0.2);
% %     myleg = {region(1).name,region(2).name};
% %     legend([hp1,hp2], myleg);
%     
%     myleg = {region(1).name,region(2).name,region(3).name};
%     legend([hp1,hp2,hp2b], myleg);
%     
%     
%     legend boxoff
%     xlim(params.fpass);
%     %ylim([0,1.2]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Percent power', 'FontWeight', 'bold');
%     %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
%     title(sprintf('Percent power during %s',region(1).condition(1).name'))
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     box off
%     
%     subplot(3,2,2)
%     p1 = plot(f,Mn_C_1','LineWidth',3,'Color','r'); %#ok<*NASGU>
%     hold on
%     patch([f,fliplr(f)], [(Mn_C_1-SEM_C_1)',flipud(Mn_C_1+SEM_C_1)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
%    
%     
%     p2 = plot(f,Mn_C_1b','LineWidth',3,'Color','r','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_C_1b-SEM_C_1b)',flipud(Mn_C_1b+SEM_C_1b)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsalStr','PL - ventralStr'};
%     legend([p1,p2], myleg);
%     legend boxoff
%     
%     
%     xlim(params.fpass);
%     %     ylim([0.4,0.8]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Coherence', 'FontWeight', 'bold');
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     title(sprintf('%s - striatum coherence during %s', region(1).name, region(1).condition(1).name))
%     box off
%     
%     subplot(3,2,3)
%     hp1=plot(f,Mn_S1_2','LineWidth',3,'Color','g');
%     hold on
%     hp2=plot(f,Mn_S2_2','LineWidth',3,'Color','b');
%     hp2b=plot(f,Mn_S2_2b','LineWidth',3,'Color','b','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_S1_2-SEM_S1_2)',flipud(Mn_S1_2+SEM_S1_2)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
%     patch([f,fliplr(f)], [(Mn_S2_2-SEM_S2_2)',flipud(Mn_S2_2+SEM_S2_2)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
%     patch([f,fliplr(f)], [(Mn_S2_2b-SEM_S2_2b)',flipud(Mn_S2_2b+SEM_S2_2b)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
% %     myleg = {region(1).name,region(2).name};
% %     legend([hp1,hp2], myleg);
%     
% myleg = {region(1).name,region(2).name,region(3).name};
% legend([hp1,hp2,hp2b], myleg);
%     
%         
%     legend boxoff
%     xlim(params.fpass);
%     %ylim([0,1.2]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Percent power', 'FontWeight', 'bold');
%     %title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
%     title(sprintf('Percent power during %s', region(1).condition(2).name))
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     box off
%     
%     subplot(3,2,4)
%     p1 = plot(f,Mn_C_2','LineWidth',3,'Color','r');
%     hold on
%     patch([f,fliplr(f)], [(Mn_C_2-SEM_C_2)',flipud(Mn_C_2+SEM_C_2)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
%     p2 = plot(f,Mn_C_2b','LineWidth',3,'Color','r','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_C_2b-SEM_C_2b)',flipud(Mn_C_2b+SEM_C_2b)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsalStr','PL - ventralStr'};
%     legend([p1,p2], myleg);
%     legend boxoff
%     xlim(params.fpass);
%     %     ylim([0.4,0.8]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Coherence', 'FontWeight', 'bold');
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     title(sprintf('%s - striatum coherence during %s', region(1).name, region(1).condition(2).name))
%     box off
    
    % Plot the diff
    if size(S1_1,3)> size(S1_2,3)
        numtrials = size(S1_2,3);
    else
        numtrials = size(S1_1,3);
    end
    
    S1_dd=(S1_1(:,:,1:numtrials) - S1_2(:,:,1:numtrials));
    S2_dd=(S2_1(:,:,1:numtrials) - S2_2(:,:,1:numtrials));
    C_dd=(C_1(:,:,1:numtrials) - C_2(:,:,1:numtrials));
    
       S2_b_dd=(S2_1b(:,:,1:numtrials) - S2_2b(:,:,1:numtrials));
       C_b_dd=(C_1b(:,:,1:numtrials) - C_2b(:,:,1:numtrials));
    
    Mn_S1_dd=mean(squeeze(mean(S1_dd,1)),2)/NormFactor;
    SEM_S1_dd=std(squeeze(mean(S1_dd,1)),0,2)./sqrt(numtrials)/NormFactor;
    
    Mn_S2_dd=mean(squeeze(mean(S2_dd,1)),2)/NormFactor;
    SEM_S2_dd=std(squeeze(mean(S2_dd,1)),0,2)./sqrt(numtrials)/NormFactor;
    
    Mn_C_dd=mean(squeeze(mean(C_dd,1)),2);
    SEM_C_dd=std(squeeze(mean(C_dd,1)),0,2)./sqrt(numtrials);
    
       Mn_S2_b_dd=mean(squeeze(mean(S2_b_dd,1)),2)/NormFactor;
       SEM_S2_b_dd=std(squeeze(mean(S2_b_dd,1)),0,2)./sqrt(numtrials)/NormFactor;
    
       Mn_C_b_dd=mean(squeeze(mean(C_b_dd,1)),2);
       SEM_C_b_dd=std(squeeze(mean(C_b_dd,1)),0,2)./sqrt(numtrials);
    
%     subplot(3,2,5)
%     hp5 = plot(f,Mn_S1_d','LineWidth',3,'Color','g');
%     hold on
%     patch([f,fliplr(f)], [(Mn_S1_d-SEM_S1_d)',flipud(Mn_S1_d+SEM_S1_d)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
%     hp6 = plot(f,Mn_S2_d','LineWidth',3,'Color','b');
%     patch([f,fliplr(f)], [(Mn_S2_d-SEM_S2_d)',flipud(Mn_S2_d+SEM_S2_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
%     
%       hp7 = plot(f,Mn_S2_b_d','LineWidth',3,'Color','b','LineStyle',':');
%       patch([f,fliplr(f)], [(Mn_S2_b_d-SEM_S2_b_d)',flipud(Mn_S2_b_d+SEM_S2_b_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
%     
%     myleg = {region(1).name,region(2).name,region(3).name};
%     legend([hp5,hp6,hp7], myleg);
%     legend boxoff
%     
%     xlim(params.fpass);
%     %ylim([-5,15]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Power change', 'FontWeight', 'bold');
%     title(sprintf('%s - %s power difference', region(1).condition(1).name,region(1).condition(2).name))
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     box off
%     
%     subplot(3,2,6)
%     p3 = plot(f,Mn_C_d','LineWidth',3,'Color','r');
%     hold on
%     patch([f,fliplr(f)], [(Mn_C_d-SEM_C_d)',flipud(Mn_C_d+SEM_C_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%         p4 = plot(f,Mn_C_b_d','LineWidth',3,'Color','r','LineStyle',':');
%         patch([f,fliplr(f)], [(Mn_C_b_d-SEM_C_b_d)',flipud(Mn_C_b_d+SEM_C_b_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%         myleg = {'PL - dorsalStr','PL - ventralStr'};
%         legend([p3,p4], myleg);
%         legend boxoff
%     
%     xlim(params.fpass);
%     %ylim([-0.05,0.15]);
%     xlabel('Frequency (Hz)', 'FontWeight', 'bold')
%     ylabel('Coherence change', 'FontWeight', 'bold');
%     set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%     title(sprintf('%s - %s coherence difference', region(1).condition(1).name,region(1).condition(2).name))
%     box off
%     
%     figpath = 'G:\My Drive\Setshift\figures2';
%     figname = sprintf('%s%s.fig',rat2incl,fig.Name);
%     figname2 = sprintf('%s%s.png',rat2incl,fig.Name);
%     saveas(fig,fullfile(figpath,figname))
%     saveas(fig,fullfile(figpath,figname2))
%     close(fig)
%     
end % end of for analysis = 1:6

b = NormFactor; 

if a > b
    NormFactor = a;
else
    NormFactor = b;
end
% 
% S1_dd=(S1_1(:,:,1:numtrials) - S1_2(:,:,1:numtrials));
%     S2_dd=(S2_1(:,:,1:numtrials) - S2_2(:,:,1:numtrials));
%     C_dd=(C_1(:,:,1:numtrials) - C_2(:,:,1:numtrials));
%     
%        S2_b_dd=(S2_1b(:,:,1:numtrials) - S2_2b(:,:,1:numtrials));
%        C_b_dd=(C_1b(:,:,1:numtrials) - C_2b(:,:,1:numtrials));
%     
%     Mn_S1_dd=mean(squeeze(mean(S1_dd,1)),2)/NormFactor;
%     SEM_S1_dd=std(squeeze(mean(S1_dd,1)),0,2)./sqrt(numtrials)/NormFactor;
%     
%     Mn_S2_dd=mean(squeeze(mean(S2_dd,1)),2)/NormFactor;
%     SEM_S2_dd=std(squeeze(mean(S2_dd,1)),0,2)./sqrt(numtrials)/NormFactor;
%     
%     Mn_C_dd=mean(squeeze(mean(C_dd,1)),2);
%     SEM_C_dd=std(squeeze(mean(C_dd,1)),0,2)./sqrt(numtrials);
%     
%        Mn_S2_b_dd=mean(squeeze(mean(S2_b_dd,1)),2)/NormFactor;
%        SEM_S2_b_dd=std(squeeze(mean(S2_b_dd,1)),0,2)./sqrt(numtrials)/NormFactor;
%     
%        Mn_C_b_dd=mean(squeeze(mean(C_b_dd,1)),2);
%        SEM_C_b_dd=std(squeeze(mean(C_b_dd,1)),0,2)./sqrt(numtrials);
%        
       
       
       if size(S1_dd,3)>size(S1_d,3)
       numtrl = size(S1_d,3);
       else 
           numtrl = size(S1_dd,3);
       end
       S1_ddd = S1_dd(:,:,1:numtrl) - S1_d(:,:,1:numtrl);
       S2_ddd = S2_dd(:,:,1:numtrl) - S2_d(:,:,1:numtrl);
       C_ddd = C_dd(:,:,1:numtrl) - C_d(:,:,1:numtrl);
       S2_b_ddd = S2_b_dd(:,:,1:numtrl) - S2_b_d(:,:,1:numtrl);
       C_b_ddd = C_b_dd(:,:,1:numtrl) - C_b_d(:,:,1:numtrl);
       
       Mn_S1_ddd=mean(squeeze(mean(S1_ddd,1)),2)/NormFactor;
    SEM_S1_ddd=std(squeeze(mean(S1_ddd,1)),0,2)./sqrt(numtrl)/NormFactor;
    
    Mn_S2_ddd=mean(squeeze(mean(S2_ddd,1)),2)/NormFactor;
    SEM_S2_ddd=std(squeeze(mean(S2_ddd,1)),0,2)./sqrt(numtrl)/NormFactor;
    
    Mn_C_ddd=mean(squeeze(mean(C_ddd,1)),2);
    SEM_C_ddd=std(squeeze(mean(C_ddd,1)),0,2)./sqrt(numtrl);
    
       Mn_S2_b_ddd=mean(squeeze(mean(S2_b_ddd,1)),2)/NormFactor;
       SEM_S2_b_ddd=std(squeeze(mean(S2_b_ddd,1)),0,2)./sqrt(numtrl)/NormFactor;
    
       Mn_C_b_ddd=mean(squeeze(mean(C_b_ddd,1)),2);
       SEM_C_b_ddd=std(squeeze(mean(C_b_ddd,1)),0,2)./sqrt(numtrl);
       
fig = figure;
 subplot(1,2,1)
    hp5 = plot(f,Mn_S1_ddd','LineWidth',3,'Color','b');
    hold on
    patch([f,fliplr(f)], [(Mn_S1_ddd-SEM_S1_ddd)',flipud(Mn_S1_ddd+SEM_S1_ddd)'],'b','EdgeColor','none', 'FaceAlpha',0.2)
    hp6 = plot(f,Mn_S2_ddd','LineWidth',3,'Color','g');
    patch([f,fliplr(f)], [(Mn_S2_ddd-SEM_S2_ddd)',flipud(Mn_S2_ddd+SEM_S2_ddd)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
    
      hp7 = plot(f,Mn_S2_b_ddd','LineWidth',3,'Color','g','LineStyle',':');
      patch([f,fliplr(f)], [(Mn_S2_b_ddd-SEM_S2_b_ddd)',flipud(Mn_S2_b_ddd+SEM_S2_b_ddd)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
    
    myleg = {region(1).name,region(2).name,region(3).name};
    legend([hp5,hp6,hp7], myleg);
    legend boxoff
    
    xlim(params.fpass);
    %ylim([-5,15]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Power change', 'FontWeight', 'bold');
    title('Power_((SideCorrect-SideIncorrect)-(Rear-Front))','interpreter', 'none')
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    box off
    
    subplot(1,2,2)
    p3 = plot(f,Mn_C_ddd','LineWidth',3,'Color','r');
    hold on
    patch([f,fliplr(f)], [(Mn_C_ddd-SEM_C_ddd)',flipud(Mn_C_ddd+SEM_C_ddd)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
        p4 = plot(f,Mn_C_b_ddd','LineWidth',3,'Color','r','LineStyle',':');
        patch([f,fliplr(f)], [(Mn_C_b_ddd-SEM_C_b_ddd)',flipud(Mn_C_b_ddd+SEM_C_b_ddd)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
        myleg = {'dPL - DS','vPL - DS'};
        legend([p3,p4], myleg);
        legend boxoff
    
    xlim(params.fpass);
    %ylim([-0.05,0.15]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold')
    ylabel('Coherence change', 'FontWeight', 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
title('Coherence_((SideCorrect-SideIncorrect)-(Rear-Front))','interpreter', 'none')
    box off
    
    figpath = 'G:\My Drive\Setshift';
    figname = 'doubleContrast2.fig';
    figname2 = 'doubleContrast2.png';
    saveas(fig,fullfile(figpath,figname))
    saveas(fig,fullfile(figpath,figname2))
    close(fig)
       
       


