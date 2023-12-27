%% rejectTrialsED
% This function initializes a GUI for rejecting trials based on an
% amplitude cutoff. Rejection is done on channels sequentially.
% Written by Evan Dastin-van Rijn, Sep, 2021
%
% Inputs
% *data* - 3D matrix (trials x samples x channels)
% *times* - vector with length equal to the sample dimension of data
%           indicating the time for each sample
%
% Outputs
% *cleaned* - 3D matrix containing only the artifact free trials
% *badTrials* - indices of trials containing artifacts
% *thresholds* - thresholds used for rejection
function [cleaned, badTrials, thresholds] = rejectTrialsED(data,times)
    thresholds = Inf*ones(size(data,3),1); % Track thresholds for all channels
    rejMat = false(size(data,1),size(data,3)); % Track rejected trials
    fig = figure('Visible','off','SizeChangedFcn',@resizeui,'WindowState','maximized');
    p1 = subplot(1,2,1); % All trials and thresholds
    p2 = subplot(1,2,2); % Clean trials
    pos = get(fig, 'Position');
    width = pos(3);
    height = pos(4);
    p1Bounds = p1.Position;
    p2Bounds = p2.Position;
    index = 1;
    jSlider = javax.swing.JSlider; % JavaX slider is much easier to work with
    [~, hContainer] = javacomponent(jSlider,[50,p1Bounds(2)*height,100,p1Bounds(4)*height], fig);
    set(jSlider, 'Orientation',jSlider.VERTICAL);
    hjSlider = handle(jSlider, 'CallbackProperties');
    hjSlider.MouseReleasedCallback  = @(es,ed) updateThreshold();
    next = uicontrol('Parent',fig,'Style','pushbutton','Position',[p2Bounds(1)*width,20,50,23],...
              'String','Next'); % Go to next channel
    prev = uicontrol('Parent',fig,'Style','pushbutton','Position',[(p1Bounds(1)+p1Bounds(3))*width-50,20,50,23],...
              'String','Prev'); % Go to previous channel
    done = uicontrol('Parent',fig,'Style','pushbutton','Position',[width-75,20,50,23],...
              'String','Done'); % Finish artifact rejection
    next.Callback = @(s,e) changeChannel(1);
    prev.Callback = @(s,e) changeChannel(-1);
    done.Callback = @(s,e) cleanMat();
    lAxis = axes('Color', 'none', 'Position', p1.Position, 'XTick', [], 'YTick', []); 
    thLabel = ylabel(lAxis, 'Amplitude Threshold');
    thLabel.Position(1) = -0.33;
    fig.Visible = 'on';
    changeChannel(0) % Display initial channel
    waitfor(fig) % Only complete function when figure closes
    
    %% cleanMat
    % Remove rejected trials and close figure to finish output.
    function cleanMat()
        keepTrials = ~any(rejMat,2);
        badTrials = find(~keepTrials);
        cleaned = data(keepTrials,:,:);
        close(fig)
    end
    
    %% resizeui
    % Callback for when figure resizes in order to keep elements in roughly
    % the correct locations.
    function resizeui(~,~)
        pos = get(fig, 'Position');
        width = pos(3);
        height = pos(4);
        p1Bounds = p1.Position;
        p2Bounds = p2.Position;
        prev.Position = [(p1Bounds(1)+p1Bounds(3))*width-50,20,50,23];
        next.Position = [p2Bounds(1)*width,20,50,23];
        done.Position = [width-75,20,50,23];
        set(hContainer, 'Position',[50,p1Bounds(2)*height,100,p1Bounds(4)*height]);
    end

    %% changeChannel
    % Move to a new channel, callback for 'previous' and 'next'.
    %
    % Inputs:
    % *inc* - number of channels to increase/decrease by
    function changeChannel(inc)
        if index+inc > 0 && index+inc <= size(data,3)
            index=index+inc;
            maxTh=ceil(max(max(abs(squeeze(data(:,:,index))))));
            set(jSlider, 'PaintLabels',true, 'PaintTicks',true,...
                'MajorTickSpacing', floor(maxTh/5), 'Maximum', maxTh, 'Value', min(maxTh, thresholds(index)))
            updateThreshold()
        end
    end

    %% updateThreshold
    % Update UI for new threshold. Gray trials are rejected. Dashed gray
    % trials were rejected in another channel and will be rejected in the
    % final output. Blue trials are clean.
    function updateThreshold()
        hold(p1, 'off')
        hold(p2, 'off')
        allTrials = squeeze(data(:,:,index));
        thresh=get(jSlider,'Value');
        thresholds(index)=thresh;
        rejCount=0;
        rejVec=false(size(allTrials,1),1);
        for i=1:size(allTrials,1)
            if any(abs(allTrials(i,:))>thresh)
                plot(p1,times, allTrials(i,:),'Color', [0.2,0.2,0.2,0.2])
                rejCount=rejCount+1;
                rejVec(i)=true;
            elseif any(rejMat(i,(1:size(rejMat,2))~=index))
                 plot(p1,times, allTrials(i,:),'--','Color', [0.2,0.2,0.2,0.2])
                 rejCount=rejCount+1;
                 rejVec(i)=false;
            else
                plot(p1,times, allTrials(i,:),'Color', 'b')
                plot(p2,times, allTrials(i,:),'Color', 'b')
                rejVec(i)=false;
                hold(p2, 'on')
            end
            hold(p1, 'on')
        end
        rejMat(:,index)=rejVec;
        plot(p2,times, mean(allTrials(~any(rejMat,2),:)),'Color', 'r')
        plot(p1,[times(1),times(end)],[thresh,thresh],'r')
        plot(p1,[times(1),times(end)],-[thresh,thresh],'r')
        set(p1, 'XLimSpec', 'Tight');
        ylim(p1, ceil(max(max(abs(squeeze(data(:,:,index))))))*[-1,1])
        set(p2, 'XLimSpec', 'Tight');
        set(p2, 'YLimSpec', 'Tight');
        title(p1, strcat("All Trials, Channel (", num2str(index), "/", num2str(size(data,3)), ")"))
        title(p2, strcat("Clean Trials (", num2str(size(allTrials,1)-rejCount),"/",num2str(size(allTrials,1)),")"))
        ylabel(p1, "Amplitude")
        xlabel(p1, "Time")
        xlabel(p2, "Time")
    end
end