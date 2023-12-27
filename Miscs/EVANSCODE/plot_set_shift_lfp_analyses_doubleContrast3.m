function plot_set_shift_lfp_analyses_doubleContrast3(rat,plotnum)
% plot_set_shift_lfp_analyses_doubleContrast3(rat,1)

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

for r = 1:2
    for d = 1:length(rat(r).day)
    rat(r).day(d).region(1) = rat(r).day(d).region(4);    
    end
end


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
%         rat2incl = 'CSF01CSM01';
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
%         rat2incl = 'CSF01';
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
%         rat2incl = 'CSM01';
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
    data2=region(2).condition(1).data';
    data2b=region(3).condition(1).data';
    [C_1,phi,S12_1,S1_1,S2_1,t,f]=cohgramc(data1,data2,movingwin,params); %#ok<ASGLU>
    S1_1=10*log10(S1_1);
    S2_1=10*log10(S2_1);
      [C_1b,phib,S12_1b,S1_1b,S2_1b,t_b,f_b]=cohgramc(data1,data2b,movingwin,params); %#ok<ASGLU>
      S2_1b=10*log10(S2_1b);
    data3=region(1).condition(2).data';
    data4=region(2).condition(2).data';
    data4b=region(3).condition(2).data';
    [C_2,phi,S12_2,S1_2,S2_2,t,f]=cohgramc(data3,data4,movingwin,params); %#ok<ASGLU>
    S1_2=10*log10(S1_2);
    S2_2=10*log10(S2_2);
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
        
    % the diff
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
    
end % end of for comparison = 4:4

a = NormFactor;  

%%
region = struct; % creat a new region struct to organize data.
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
%         rat2incl = 'CSF01CSM01';
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
%         rat2incl = 'CSF01';
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
%         rat2incl = 'CSM01';
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
    data2=region(2).condition(1).data';
    data2b=region(3).condition(1).data';
    [C_1,phi,S12_1,S1_1,S2_1,t,f]=cohgramc(data1,data2,movingwin,params); %#ok<ASGLU>
    S1_1=10*log10(S1_1);
    S2_1=10*log10(S2_1);

    [C_1b,phib,S12_1b,S1_1b,S2_1b,t_b,f_b]=cohgramc(data1,data2b,movingwin,params); %#ok<ASGLU>
    S2_1b=10*log10(S2_1b);
   
    data3=region(1).condition(2).data';
    data4=region(2).condition(2).data';
    data4b=region(3).condition(2).data';
    [C_2,phi,S12_2,S1_2,S2_2,t,f]=cohgramc(data3,data4,movingwin,params); %#ok<ASGLU>
    S1_2=10*log10(S1_2);
    S2_2=10*log10(S2_2);
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
    
    %     
end % end of for comparison = 5:5

b = NormFactor; 

if a > b
    NormFactor = a;
else
    NormFactor = b;
end
      
       
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
        myleg = {'dPL - MS','vPL - MS'};
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
    figname = 'doubleContrast3.fig';
    figname2 = 'doubleContrast3.png';
    saveas(fig,fullfile(figpath,figname))
    saveas(fig,fullfile(figpath,figname2))
    close(fig)
       
       


