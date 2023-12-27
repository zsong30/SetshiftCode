
unitIDs = [floor(length(trial.units)/2),length(trial.units),10];
ISIsLimits = [0, 250; 150,250;0,inf];
plotnum = [1, 2];





for k = 1:length(plotnum)
for i = 1: length(unitIDs)
for j = 1:size(ISIsLimits,1)
   plot_set_shift_neuropixel_spike_field_coupling(trial,unitIDs(i),ISIsLimits(j,:),plotnum(k))
   close all
end
end
end



unitIDs = [111, 124];
ISIsLimits = [0,inf];
plotnum = 1;
plot_set_shift_neuropixel_spike_field_coupling(trial,unitIDs,ISIsLimits,plotnum)