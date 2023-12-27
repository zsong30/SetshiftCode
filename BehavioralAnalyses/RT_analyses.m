

load('\\TNEL100-TB4\ThunderBay\SetShift\DATA\RTarray.mat', 'RTarray')

earliertrialRT = RTarray(:,4);
earliertrialRT = earliertrialRT(earliertrialRT<1.5);
RT_earlier = earliertrialRT(~isnan(earliertrialRT));
latertrialRT = RTarray(:,14);
latertrialRT = latertrialRT(latertrialRT<1.5);
RT_later = earliertrialRT(~isnan(latertrialRT));

p_value = randomshuffle(RT_earlier',RT_later');
