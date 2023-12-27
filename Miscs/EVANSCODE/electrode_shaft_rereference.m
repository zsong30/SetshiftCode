%% electrode_shaft_rereference
% This function removes bad channels that are indicated, rereferences all
% trials to the average across all channels, high-pass filters both matrices 
% at 0.1 Hz,calls rejectTrialsED on two input matrices, and removes the 
% union of rejected trials for either input matrix.
% Written by Evan Dastin-van Rijn, Sep, 2021
%
% Inputs
% *startData* - 3D matrix (trials x samples x channels)
% *respData* - 3D matrix (trials x samples x channels)
% *ts* - time vector equal in length to the sample dimension of the input
%        matrices
% *fs* - sampling rate
% *badChannels* - vector with channel indices to ignore
%
% Outputs
% *output* - structure containing rereferenced data with bad channels and
%            trials removed for both matrices as well as indices of trials 
%            that were rejected.
function output = electrode_shaft_rereference(startData,respData,ts,fs, badChannels)
    % Remove bad channels
    startData=startData(:,:,setxor(1:size(startData,3),badChannels))*0.195;
    respData=respData(:,:,setxor(1:size(respData,3),badChannels))*0.195;
    % Rereference to electrode average
    ESR_start=mean(startData,3);
    startData=startData-repmat(ESR_start,[1,1,size(startData,3)]);
    ESR_resp=mean(respData,3);
    respData=respData-repmat(ESR_resp,[1,1,size(respData,3)]);
    % Highpass filter
    for i=1:size(startData,3)
        startData(:,:,i) = ft_preproc_highpassfilter(squeeze(startData(:,:,i)), fs, 0.1,4);
        respData(:,:,i) = ft_preproc_highpassfilter(squeeze(respData(:,:,i)), fs, 0.1,4);
    end
    % Find bad trials
    [~,output.rejStart]=rejectTrialsED(startData,ts);
    [~,output.rejResp]=rejectTrialsED(respData,ts);
    % Remove bad trials
    output.cleanStarts=startData(setxor((1:size(startData,1)),union(output.rejStart,output.rejResp)),:,:);
    output.cleanResps=respData(setxor((1:size(respData,1)),union(output.rejStart,output.rejResp)),:,:);
    output.ESRStart=ESR_start(setxor((1:size(ESR_start,1)),union(output.rejStart,output.rejResp)),:);
    output.ESRResp=ESR_resp(setxor((1:size(ESR_start,1)),union(output.rejStart,output.rejResp)),:);
end

