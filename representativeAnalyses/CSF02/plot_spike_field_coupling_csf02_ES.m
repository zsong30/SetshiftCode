

load('Z:\projmon\ericsprojects\Setshift\DATA\csf02spikefieldcoupling_092321data.mat','csf02spikefieldcoupling');

numspikes = 3000;
spikephases = [csf02spikefieldcoupling.unit(2).frequency(1).spikephases(1:numspikes);csf02spikefieldcoupling.unit(2).frequency(2).spikephases(1:numspikes);...
    csf02spikefieldcoupling.unit(2).frequency(3).spikephases(1:numspikes);csf02spikefieldcoupling.unit(2).frequency(4).spikephases(1:numspikes);...
    csf02spikefieldcoupling.unit(2).frequency(5).spikephases(1:numspikes);csf02spikefieldcoupling.unit(2).frequency(6).spikephases(1:numspikes);csf02spikefieldcoupling.unit(2).frequency(7).spikephases(1:numspikes)];

tmpphases = repmat(spikephases(7,:),7,1);

spikephases_dist = circ_dist(spikephases,tmpphases);

figure,plot(spikephases_dist)

figure,imagesc(1:10,1:7,spikephases_dist)
colorbar