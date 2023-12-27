   %%Time specifications:
   Fs = 400;                   % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = 5;             % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %%Sine wave:
   Fc = .6*10;                     % hertz
   x = cos(2*pi*Fc*t);
   % Plot the signal versus time:
   figure;
   plot(t,x,'LineWidth',2,'Color','m');
   box off
xticklabels('')
xlabel('')
axis off


%    xlabel('time (in seconds)');
%    title('Signal versus Time');
%    zoom xon;