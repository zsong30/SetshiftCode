% cd('Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18')
% datadir = dir("CSF02_09232021_lfp_unit_data_avg*");
% tmp_lfp_avg = load(datadir);
figpath = 'Z:\projmon\ericsprojects\Setshift\ANALYSES\representative analyses\spike-field-coupling\plot_setshift_NP_spike_trigered_LFP\CSF02\CSF02_PL_09232021_expanded';
file = load("Z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\CSF02_09232021_lfp_unit_data_avg.mat");
tmp_lfp_avg = file.tmp_lfp_avg;
unit2plot = (1:10);
ratname = 'CSF02';
regionname = 'PL';
datadate = '09232021';


% fig1 = figure('name',sprintf('%s %s %s Filtered Data Power Spectrum Unit',ratname,regionname,datadate));
% for u = 1:length(unit2plot)
% 
% hold on
% subplot(ceil(sqrt(length(unit2plot))),ceil(sqrt(length(unit2plot))),u)
%             Fs = 2500; 
%             x = linspace(-Fs/2,Fs/2,length(tmp_lfp_avg));
%             fc = 100;
%             [b,a] = butter(6,(fc/(Fs/2)),'low');
%             y = filter(b,a,tmp_lfp_avg(u,:));
%             plot(x,20*log10(abs(fft(y))));
%             % plot(x,20*log10(abs(fft(tmp_lfp_avg))));
%             xlim([30 70])
%             xlabel('Frequency (Hz)');
%             ylabel('Power (dB)');
%             title(sprintf('Filtered Data Power Spectrum - Unit %d',u));
% end
% 
% saveas(fig1,fullfile(figpath,fig1.Name),'png')
% saveas(fig1,fullfile(figpath,fig1.Name),'fig')


fig2 = figure('name',sprintf('%s %s %s Unfiltered Data Power Spectrum Unit',ratname,regionname,datadate));
for i = 1:length(unit2plot)

hold on
subplot(ceil(sqrt(length(unit2plot))),ceil(sqrt(length(unit2plot))),i)
x = linspace(-Fs/2,Fs/2,length(tmp_lfp_avg));
 plot(x,20*log10(abs(fft(tmp_lfp_avg(i,:)))));
 
 xlim([0 100]);           
 xlabel('Frequency (Hz)');
            ylabel('Power (dB)');
            title(sprintf('Unfiltered Data Power Spectrum - Unit %d',i))
end

saveas(fig2,fullfile(figpath,fig2.Name),'png')
saveas(fig2,fullfile(figpath,fig2.Name),'fig')


% fig3 = figure('name',sprintf('%s %s %s Spike Triggered LFP Average Unit',ratname,regionname,datadate));
% for j= 1:length(unit2plot)
% 
% hold on
% subplot(ceil(sqrt(length(unit2plot))),ceil(sqrt(length(unit2plot))),j)
%  plot((-1000:1000/1250:1000),tmp_lfp_avg(j,:));
%             xlabel('ms')
%             ylabel('uV')
%             ylim([-85 40])
%             title(sprintf('Spike Triggered LFP Average Unit - %d',j))
% end
% 
% saveas(fig3,fullfile(figpath,fig3.Name),'png')
% saveas(fig3,fullfile(figpath,fig3.Name),'fig')



