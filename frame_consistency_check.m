
logfn = 'Z:\projmon\ericsprojects\py-behav-box-v2\frame_time_test';

M = readmatrix(logfn);
frame_times = M;
frame_time_diff = diff(frame_times);
figure,plot(frame_time_diff(1:end))

slowtimes = frame_time_diff(frame_time_diff>0.133);

figure,plot(slowtimes)

