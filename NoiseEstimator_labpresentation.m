clear;
% %%
% % simulate data
% clear
% [rdata1,rtime,events,signalchainInfo,chaninfo,filetype] = ...
%     testfile();
% % load('Jo_CLDBS_DT1_060917_Block-4_DBSLFPs.mat')
% % rdata2 = [];
% % for k = [1,2:17]
% % a = data_LFPs.contvars{k, 1}.data;
% % rdata2 = [rdata2,a];
% % end
% % rdata = rdata2;
% cnt = 1;
% for i = 1:2:64-1
% rdata(:,cnt) = rdata1(:,i) - rdata1(:,i+1);
% cnt = cnt +1;
% end

%%
figpath = 'Z:\projmon\ericsprojects\NP_manuscript\Analysis';
data2savepath = 'Z:\projmon\ericsprojects\NP_manuscript\Data';

trange = 2; % in minutes

%new probe
path = 'z:\projmon\ericsprojects\Setshift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
rawdata = load_open_ephys_binary(path,'continuous',2,'mmap');
initdat = rawdata.Data.Data.mapped(220:229,2500*60*trange+1:2500*60*(trange+2));
datatype = 'new_probe';


rdata=initdat';
rdata = downsample(rdata,5);



for i = 1:10
B = rdata(:,i)';
F = 1; % weight of (F)ractal components of the simulated data
O = 10; % weight of (O)scillatory components of the simulated data
t = (1:length(B))/500;%data_LFPs.freq; % time axis
data.trial=[];
data.time= [];

data.trial{1,1} = B;%ft_preproc_bandpassfilter(B,1000,[8 12],[],'firws');;%ft_preproc_bandpassfilter(B,1000,[8 12],[],'firws');
data.time{1,1} = t;
data.label{1}   = 'chan';
%%
% chunk into 2-second segments
cfg               = [];
cfg.length        = 2;
cfg.overlap       = 0.5;
data              = ft_redefinetrial(cfg, data);

%% compute the fractal and original spectra
cfg               = [];
cfg.foilim        = [1 100];
cfg.pad           = 4;
cfg.tapsmofrq     = 2;
cfg.method        = 'mtmfft';
% cfg.taper='dpss';
cfg.output        = 'fooof_aperiodic';
foofoutcome = ft_freqanalysis(cfg, data);
%%
cfg.output        = 'pow';
original = ft_freqanalysis(cfg, data);
%% 

%%
% subtract the fractal component from the power spectrum
cfg               = [];
cfg.parameter     = 'powspctrm';
cfg.operation     = 'x2-x1';
oscillatorysubFromfoof = ft_math(cfg, foofoutcome, original);

% display the spectra on a log-log scale
orig_sig(:,i) = original.powspctrm;
oscsubFrmfoof(:,i) = oscillatorysubFromfoof.powspctrm;
Frmfoof(:,i) = foofoutcome.powspctrm;
snrrec(:,i) = (oscillatorysubFromfoof.powspctrm)./(foofoutcome.powspctrm);

torig_sig(:,i) = original.freq;
toscsubFrmfoof(:,i) = oscillatorysubFromfoof.freq;
tFrmfoof(:,i) = foofoutcome.freq;
tsnrrec(:,i) = oscillatorysubFromfoof.freq;

% 
% subplot(2,2,1)
% hold on;
% title('original signal')
% plot((original.freq), (original.powspctrm),'r','LineWidth',2);
% legend({'original signal'});
% 
% subplot(2,2,2)
% title('foof noise');hold on
% plot((foofoutcome.freq), (foofoutcome.powspctrm),'r','LineWidth',2);
% legend({'foof noise signal'});
% 
% subplot(2,2,3)
% title('subtracted signal');hold on
% plot((foofoutcome.freq), (oscillatorysubFromfoof.powspctrm),'-r','LineWidth',2);
% xlabel('freq'); ylabel('power');
% legend({'noise subtracted signal'});
% 
% 
% % SNR 
% subplot(2,2,4);hold on;
% plot((foofoutcome.freq), 20*log((oscillatorysubFromfoof.powspctrm)./(foofoutcome.powspctrm)),'r','LineWidth',2);
% xlabel('freq'); ylabel('SNR (db)');
% title('Noise subtracte signal / foof noise');
% pause(0.2)
end
%%
figure;
dbsnr = 20*log(snrrec);
%%
A = 1:10;%17:19;
subplot(2,2,1);
boundedline(torig_sig(:,1),mean(orig_sig(:,A)'),std(orig_sig(:,A)'),'-r','LineWidth',2)
title('original signal x(t)');
xlabel('frequency');
ylabel('power');
set(gca,'FontName','Times','fontsize',14)
set(gca,'box','off');
% xline([13],'--m');
% xline([30],'--m');
% xline([4],'--');
% xline([8],'--');
set(gca,'LineWidth',1.5)


subplot(2,2,2);
boundedline(tFrmfoof(:,1),mean(Frmfoof(:,A)'),std(Frmfoof(:,A)'),'-r','LineWidth',2)
title('1/f noise');
xlabel('frequency');
ylabel('power');
set(gca,'FontName','Times','fontsize',14)
set(gca,'box','off');
% xline([13],'--m');
% xline([30],'--m');
% xline([4],'--');
% xline([8],'--');
set(gca,'LineWidth',1.5)

subplot(2,2,3);
boundedline(toscsubFrmfoof(:,1),mean(oscsubFrmfoof(:,A)'),std(oscsubFrmfoof(:,A)'),'-r','LineWidth',2)
title('x(t) - noise');
xlabel('frequency');
ylabel('power');
set(gca,'FontName','Times','fontsize',14)
set(gca,'box','off');
% xline([13],'--m');
% xline([30],'--m');
% xline([4],'--');
% xline([8],'--');
set(gca,'LineWidth',1.5)

subplot(2,2,4);
boundedline(tsnrrec(:,1),mean(dbsnr(:,A)'),std(dbsnr(:,A)'),'-r','LineWidth',2);
title('SNR (db)');
xlabel('frequency');
ylabel('SNR (db)');
set(gca,'FontName','Times','fontsize',14);
set(gca,'box','off');
% xline([13],'--m');
% xline([30],'--m');
% xline([4],'--');
% xline([8],'--');
set(gca,'LineWidth',1.5)
%%
% figure;
% color = 'b';
% for i = 1:10%1%9%25:26%1:2%11:12
% subplot(2,2,1)
% hold on;
% title('original signal')
% plot(torig_sig(:,1), (orig_sig(:,i)),color,'LineWidth',2);
% % legend({'original signal'});
% % xline([4],'--k');
% % xline([8],'--k');
% % xline([13],'--m');
% % xline([30],'--m');
% 
% subplot(2,2,2)
% title('foof noise');hold on
% plot(tFrmfoof(:,1), Frmfoof(:,i),color,'LineWidth',2);
% % legend({'foof noise signal'});
% % xline([4],'--k');
% % xline([8],'--k');
% % xline([13],'--m');
% % xline([30],'--m');
% 
% subplot(2,2,3)
% title('subtracted signal');hold on
% plot(toscsubFrmfoof(:,1), oscsubFrmfoof(:,i),color,'LineWidth',2);
% xlabel('freq'); ylabel('power');
% % legend({'noise subtracted signal'});
% % xline([4],'--k');
% % xline([8],'--k');
% % xline([13],'--m');
% % xline([30],'--m');
% 
% subplot(2,2,4);hold on;
% plot(toscsubFrmfoof(:,1), dbsnr(:,i),color,'LineWidth',2);
% xlabel('freq'); ylabel('SNR (db)');
% title('Noise subtracte signal / foof noise');
% % xline([4],'--k');
% % xline([8],'--k');
% % xline([13],'--m');
% % xline([30],'--m');
% pause(0.1)
%end