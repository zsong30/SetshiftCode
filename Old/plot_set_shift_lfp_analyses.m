function plot_set_shift_lfp_analyses(rat,plotnum)
% plot_set_shift_lfp_analyses(rat,1)
% set params
params.Fs = 1500;  % it is 30000 originally but will be downsampled to 1500.
params.tapers = [3 5];
params.fpass = [1 30];
movingwin = [0.5 .001];
params.trialave = 0;
params.pad=1; % pad factor for fft
params.err=[2 0.05];

region = struct; tmp = [];

for analysis = 1:6


for reg = 1:2
    region(reg).name = rat(reg).day(1).region(reg).name;
    for c = 1:2
        region(reg).condition(c).name = ...
            rat(1).day(1).region(reg).condition(analysis*2-2+c).name;
        region(reg).condition(c).data = [];
    end
end

if plotnum == 1

for rt = 1:length(rat)
    
    for dy = 1:length(rat(rt).day)
        for reg = 1:2
            for c = 1:2
                tmp = rat(rt).day(dy).region(reg).condition(analysis*2-2+c).data; 
   region(reg).condition(c).data = ...
       [region(reg).condition(c).data;tmp];
            end
        end
    end
    
end

elseif plotnum == 2
    rt = 1;
    for dy = 1:length(rat(rt).day)
        for reg = 1:2
            for c = 1:2
                tmp = rat(rt).day(dy).region(reg).condition(analysis*2-2+c).data;
                region(reg).condition(c).data = ...
                    [region(reg).condition(c).data;tmp];
            end
        end
    end
elseif plotnum == 3
    rt =2;
    for dy = 1:length(rat(rt).day)
        for reg = 1:2
            for c = 1:2
                tmp = rat(rt).day(dy).region(reg).condition(analysis*2-2+c).data;
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
[C_1,phi,S12_1,S1_1,S2_1,t,f]=cohgramc(data1,data2,movingwin,params); %#ok<ASGLU>
S1_1=10*log10(S1_1);
S2_1=10*log10(S2_1);
% C S1, S2 are structured as times x frequencies x trials.
%
%     [C_ven,phi,S12,S1,S2_ven,t,f]=cohgramc(data1,data3,movingwin,params); %#ok<ASGLU>
%     S1=10*log10(S1);
%     S2_ven=10*log10(S2_ven);

data3=region(1).condition(2).data';
%     cdata1=rmlinesmovingwinc(data1,[2 .05],50,params,.005,'n', 60);
%     data1=cdata1;
data4=region(2).condition(2).data';
%     cdata2=rmlinesmovingwinc(data2,[2 .05],100,params,.005,'n', 60);
%     data2=cdata2;
%     cdata2=rmlinesmovingwinc(data2,[2 .05],100,params,.005,'n', 60);
%     data2=cdata2;
[C_2,phi,S12_2,S1_2,S2_2,t,f]=cohgramc(data3,data4,movingwin,params); %#ok<ASGLU>
S1_2=10*log10(S1_2);
S2_2=10*log10(S2_2);
% C S1_side, S2 are structured as times x frequencies x trials.
%     [C_side_ven,phi,S1_side2,S1_side,S2_side_ven,t,f]=cohgramc(data1,data3,movingwin,params); %#ok<ASGLU>
%     S1_side=10*log10(S1_side);
%     S2_side_ven=10*log10(S2_side_ven);


if max(mean(squeeze(mean(S1_1,1)),2)) > max(mean(squeeze(mean(S1_2,1)),2))
NormFactor1 = max(mean(squeeze(mean(S2_1,1)),2));
else
    NormFactor1 = max(mean(squeeze(mean(S2_2,1)),2));
end
if max(mean(squeeze(mean(S2_1,1)),2)) > max(mean(squeeze(mean(S2_2,1)),2))
NormFactor2 = max(mean(squeeze(mean(S2_1,1)),2));
else
    NormFactor2 = max(mean(squeeze(mean(S2_2,1)),2));
end
if NormFactor1 > NormFactor2
NormFactor = NormFactor1;
else 
NormFactor = NormFactor2;


Mn_S1_1=(mean(squeeze(mean(S1_1,1)),2)/NormFactor);
SEM_S1_1=(std(squeeze(mean(S1_1,1)),0,2)./sqrt(size(data1,1))/NormFactor);

Mn_S2_1=(mean(squeeze(mean(S2_1,1)),2)/NormFactor);
SEM_S2_1=(std(squeeze(mean(S2_1,1)),0,2)./sqrt(size(data1,1))/NormFactor);

Mn_C_1=mean(squeeze(mean(C_1,1)),2);
SEM_C_1=std(squeeze(mean(C_1,1)),0,2)./sqrt(size(data1,1));


Mn_S1_2=(mean(squeeze(mean(S1_2,1)),2)/NormFactor);
SEM_S1_2=(std(squeeze(mean(S1_2,1)),0,2)./sqrt(size(data3,1))/NormFactor);

Mn_S2_2=(mean(squeeze(mean(S2_2,1)),2)/NormFactor);
SEM_S2_2=(std(squeeze(mean(S2_2,1)),0,2)./sqrt(size(data3,1))/NormFactor);

Mn_C_2=mean(squeeze(mean(C_2,1)),2);
SEM_C_2=std(squeeze(mean(C_2,1)),0,2)./sqrt(size(data3,1));


figure('name',sprintf('setshift %s vs %s ', region(1).condition(1).name,region(1).condition(2).name))
subplot(3,2,1)
hp1=plot(f,Mn_S1_1','LineWidth',3,'Color','g');
hold on
hp2=plot(f,Mn_S2_1','LineWidth',3,'Color','b');
%hp2_2=plot(f,Mn_S2_ven','LineWidth',3,'Color','b','LineStyle',':');
patch([f,fliplr(f)], [(Mn_S1_1-SEM_S1_1)',flipud(Mn_S1_1+SEM_S1_1)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
patch([f,fliplr(f)], [(Mn_S2_1-SEM_S2_1)',flipud(Mn_S2_1+SEM_S2_1)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
%patch([f,fliplr(f)], [(Mn_S2_ven-SEM_S2_ven)',flipud(Mn_S2_ven+SEM_S2_ven)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
myleg = {region(1).name,region(2).name};
legend([hp1,hp2], myleg);
legend boxoff
xlim(params.fpass);
%ylim([0,1.2]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Percent Power', 'FontWeight', 'bold');
%title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
title(sprintf('Power during %s',region(1).condition(1).name'))
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
box off

subplot(3,2,2)
p1 = plot(f,Mn_C_1','LineWidth',3,'Color','r'); %#ok<*NASGU>
hold on
patch([f,fliplr(f)], [(Mn_C_1-SEM_C_1)',flipud(Mn_C_1+SEM_C_1)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
%     p2 = plot(f,Mn_C_ven','LineWidth',3,'Color','r','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_C_ven-SEM_C_ven)',flipud(Mn_C_ven+SEM_C_ven)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsal Str','PL - ventral Str'};
%     legend([p1,p2], myleg);
%     legend boxoff
xlim(params.fpass);
%     ylim([0.4,0.8]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Coherence', 'FontWeight', 'bold');
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
title(sprintf('%s - %s coherence during %s', region(1).name,region(2).name, region(1).condition(1).name))
box off

subplot(3,2,3)
hp1=plot(f,Mn_S1_2','LineWidth',3,'Color','g');
hold on
hp2=plot(f,Mn_S2_2','LineWidth',3,'Color','b');
%     hp2_2=plot(f,Mn_S2_side_ven','LineWidth',3,'Color','b','LineStyle',':');
patch([f,fliplr(f)], [(Mn_S1_2-SEM_S1_2)',flipud(Mn_S1_2+SEM_S1_2)'],'g','EdgeColor','none', 'FaceAlpha',0.2);
patch([f,fliplr(f)], [(Mn_S2_2-SEM_S2_2)',flipud(Mn_S2_2+SEM_S2_2)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
%     patch([f,fliplr(f)], [(Mn_S2_side_ven-SEM_S2_side_ven)',flipud(Mn_S2_side_ven+SEM_S2_side_ven)'],'b','EdgeColor','none', 'FaceAlpha',0.2);
myleg = {region(1).name,region(2).name};
legend([hp1,hp2], myleg);
legend boxoff
xlim(params.fpass);
%ylim([0,1.2]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Percent Power', 'FontWeight', 'bold');
%title(sprintf('PL and Striatum power_interval'),'Interpreter', 'none')
title(sprintf('Power during %s', region(1).condition(2).name))
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
box off

subplot(3,2,4)
p1 = plot(f,Mn_C_2','LineWidth',3,'Color','r');
hold on
patch([f,fliplr(f)], [(Mn_C_2-SEM_C_2)',flipud(Mn_C_2+SEM_C_2)'],'r','EdgeColor','none', 'FaceAlpha',0.2);
%     p2 = plot(f,Mn_C_side_ven','LineWidth',3,'Color','r','LineStyle',':');
%     patch([f,fliplr(f)], [(Mn_C_side_ven-SEM_C_side_ven)',flipud(Mn_C_side_ven+SEM_C_side_ven)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsal Str','PL - ventral Str'};
%     legend([p1,p2], myleg);
%     legend boxoff
xlim(params.fpass);
%     ylim([0.4,0.8]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Coherence', 'FontWeight', 'bold');
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
title(sprintf('%s - %s coherence during %s', region(1).name,region(2).name, region(1).condition(2).name))
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
%     S2_ven_d=(S2_side_ven(:,:,1:numtrials) - S2_ven(:,:,1:numtrials));
%     C_ven_d=(C_side_ven(:,:,1:numtrials) - C_ven(:,:,1:numtrials));

Mn_S1_d=mean(squeeze(mean(S1_d,1)),2);
SEM_S1_d=std(squeeze(mean(S1_d,1)),0,2)./sqrt(numtrials);

Mn_S2_d=mean(squeeze(mean(S2_d,1)),2);
SEM_S2_d=std(squeeze(mean(S2_d,1)),0,2)./sqrt(numtrials);

Mn_C_d=mean(squeeze(mean(C_d,1)),2);
SEM_C_d=std(squeeze(mean(C_d,1)),0,2)./sqrt(numtrials);
%     Mn_S2_ven_d=mean(squeeze(mean(S2_ven_d,1)),2)/max(mean(squeeze(mean(S2_2,1)),2));
%     SEM_S2_ven_d=std(squeeze(mean(S2_ven_d,1)),0,2)./sqrt(size(plData_side,1))/max(mean(squeeze(mean(S2_2,1)),2));
%
%     Mn_C_ven_d=mean(squeeze(mean(C_ven_d,1)),2);
%     SEM_C_ven_d=std(squeeze(mean(C_ven_d,1)),0,2)./sqrt(size(plData_side,1));

subplot(3,2,5)
hp5 = plot(f,Mn_S1_d','LineWidth',3,'Color','g');
hold on
patch([f,fliplr(f)], [(Mn_S1_d-SEM_S1_d)',flipud(Mn_S1_d+SEM_S1_d)'],'g','EdgeColor','none', 'FaceAlpha',0.2)
hp6 = plot(f,Mn_S2_d','LineWidth',3,'Color','b');
patch([f,fliplr(f)], [(Mn_S2_d-SEM_S2_d)',flipud(Mn_S2_d+SEM_S2_d)'],'b','EdgeColor','none', 'FaceAlpha',0.2)

% hp7 = plot(f,Mn_S2_ven_d','LineWidth',3,'Color','r');
% patch([f,fliplr(f)], [(Mn_S2_ven_d-SEM_S2_ven_d)',flipud(Mn_S2_ven_d+SEM_S2_ven_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
myleg = {region(1).name,region(2).name};
legend([hp5,hp6], myleg);
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
%     p4 = plot(f,Mn_C_ven_d','LineWidth',3,'Color','r');
%     patch([f,fliplr(f)], [(Mn_C_ven_d-SEM_C_ven_d)',flipud(Mn_C_ven_d+SEM_C_ven_d)'],'r','EdgeColor','none', 'FaceAlpha',0.2)
%     myleg = {'PL - dorsal Str','PL - ventral Str'};
%     legend([p3,p4], myleg);
%     legend boxoff

xlim(params.fpass);
%ylim([-0.05,0.15]);
xlabel('Frequency (Hz)', 'FontWeight', 'bold')
ylabel('Coherence change', 'FontWeight', 'bold');
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
title(sprintf('%s - %s coherence difference', region(1).condition(1).name,region(1).condition(2).name))
box off

end % end of for analysis = 1:6