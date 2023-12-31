
load('Z:\projmon\ericsprojects\Setshift\DATA\csf02spikefieldcoupling_092321data.mat','csf02spikefieldcoupling');

%figpath = 'Z:\projmon\ericsprojects\NP_manuscript\FiguresForPaper';

params.Fs = 2500;  
params.tapers = [3 5];
params.tapers = [2 3];
params.fpass = [1 100];
params.trialave = 0;
movingwin = [0.5,0.1];


lfp = csf02spikefieldcoupling.unit(1).lfp;

[S,t,f]=mtspecgramc(lfp(1:250*2500),movingwin,params);
S = 10*log10(S);
figure, 
imagesc(t,f,S)
colorbar
clim([10,25])

[S,t,f]=mtspecgramc(lfp(60*35*2500:end),movingwin,params);
S = 10*log10(S);
figure, 
imagesc(t,f,S)
colorbar
clim([10,25])

%numseg = 30;
numseg = floor(length(lfp)/(6*2500))-30;
    segmentedData = nan(6*2500,numseg);
for i = 1:numseg
    segmentedData(:,i) = lfp((numseg-1)*6*2500+1:numseg*6*2500);

end

[S,f] = mtspectrumc(segmentedData,params);

S = median(10*log10(S),2);
%S = mean(10*log10(S),2);
figure,plot(f,S)

lfp = csf02spikefieldcoupling.unit(1).frequency(6).filteredLfp;