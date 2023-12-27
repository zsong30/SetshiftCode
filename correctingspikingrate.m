

trial.units(u) = rmfield(trial.units(u),'spike_frequency_estimated');
for u = 1:length(trial.units)

trial.units(u).spike_frequency = 1000*length(trial.units(u).ts)/(trial.units(u).ts(end)...
    -trial.units(u).ts(1));

end