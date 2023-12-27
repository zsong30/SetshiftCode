%% plot_set_shift_lfp_analyses_erp
% This function outputs various plots related to preprocessed set-shift
% data.
% Written by Evan Dastin-van Rijn, Sep, 2021
%
% Inputs
% *input* - structure containing data/metadata necessary for developing the
%           desired plot
% *plotNum* - number indicated the type of plot to create
%
% Outputs
% *output* - any preprocesing data that may be worth saving after plot
%            creation
function output = plot_set_shift_lfp_analyses_erp(input, plotNum)
    % plotNum = 1: ERP of shaft grand average
    % plotNum = 2: ERP of all channels for ESR
    % plotNum = 3: ERSP of all channels for ESR
    % plotNum = 4: ERSP for incorrect vs. correct (not finished)
    % plotNum = 5: ERP for all channels, all days, one rat
    % plotNum = 6: ERSP for all channels, all days, one rat
    % plotNum = 7: ERP for incorrect vs. correct, all days, one rat
    % plotNum = 8: ERSP for incorrect vs. correct, all days, one rat
    % plotNum = 9: plots 5-8 for grand average, one rat
    ft_defaults;
    fs = 1500;
    ts = linspace(-1.5,1.5,fs*3+1);
    % set params for Chronux
    params.Fs = 1500;  % it is 30000 originally but will be downsampled to 1500.
    params.tapers = [3 5];
    params.fpass = [1 30];
    movingwin = [0.5 .001];
    params.trialave = 0;
    params.pad=1; % pad factor for fft
    params.err=[2 0.05];
    
    % paths to all rat data
    rat(1).day(1).epath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-02-25_10-43-03_SS\experiment1\recording1\structure.oebin';
    rat(1).day(1).bpath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-02-25_10-43-03_SS';
    rat(1).day(1).logfn = ...
        'CSF01_2021_02_25__10_43_02.csv';

    rat(1).day(2).epath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-02-26_14-46-57_SS\experiment1\recording1\structure.oebin';
    rat(1).day(2).bpath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-02-26_14-46-57_SS';
    rat(1).day(2).logfn = ...
        'CSF01_2021_02_26__14_47_02.csv';

    rat(1).day(3).epath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-01_14-50-32_SS\experiment1\recording2\structure.oebin';
    rat(1).day(3).bpath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-01_14-50-32_SS';
    rat(1).day(3).logfn = ...
        'CSF01_2021_03_01__14_51_02.csv';

    rat(1).day(4).epath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-16_13-44-00_SS\experiment1\recording2\structure.oebin';
    rat(1).day(4).bpath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-16_13-44-00_SS';
    rat(1).day(4).logfn = ...
        'CSF01_2021_03_16__13_44_02.csv';

    rat(1).day(5).epath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-17_13-25-40_SS\experiment1\recording1\structure.oebin';
    rat(1).day(5).bpath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-17_13-25-40_SS';
    rat(1).day(5).logfn = ...
        'CSF01_2021_03_17__13_26_02.csv';

    rat(1).day(6).epath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-18_12-32-12_SS\experiment1\recording1\structure.oebin';
    rat(1).day(6).bpath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-03-18_12-32-12_SS';
    rat(1).day(6).logfn = ...
        'CSF01_2021_03_18__12_32_02.csv';

    rat(1).day(7).epath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-04-27_13-51-15_SS\experiment1\recording1\structure.oebin';
    rat(1).day(7).bpath = ...
        'E:\SetShift\EPHYSDATA\CSF01\CSF01_2021-04-27_13-51-15_SS';
    rat(1).day(7).logfn = ...
        'CSF01_2021_04_27__13_51_02.csv';
    rat(2).day(1).epath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-03-24_14-33-37_SS\experiment1\recording1\structure.oebin';
    rat(2).day(1).bpath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-03-24_14-33-37_SS';
    rat(2).day(1).logfn = ...
        'CSM01_2021_03_24__14_34_02.csv';

    rat(2).day(2).epath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-04-26_11-35-06\experiment1\recording1\structure.oebin';
    rat(2).day(2).bpath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-04-26_11-35-06';
    rat(2).day(2).logfn = ...
        'CSM01_2021_04_26__11_35_02.csv';

    rat(2).day(3).epath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-04-29_11-32-28_SS\Record Node 101\experiment1\recording1\structure.oebin';
    rat(2).day(3).bpath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-04-29_11-32-28_SS';
    rat(2).day(3).logfn = ...
        'CSM01_2021_04_29__11_32_02.csv';

    rat(2).day(4).epath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-04-30_11-09-47_SS\Record Node 101\experiment1\recording1\structure.oebin';
    rat(2).day(4).bpath = ...
        'E:\SetShift\EPHYSDATA\CSM01\CSM01_2021-04-30_11-09-47_SS';
    rat(2).day(4).logfn = ...
        'CSM01_2021_04_30__11_09_02.csv';
    
    % Plots the cue-locked and response-locked ERPs for the grand average
    % of all channels on an electrode. Input structure is identical to the
    % output of electrode_shaft_rereference.
    % Procedure:
    % 1. Low-pass filter both matrices at 10 Hz
    % 2. Baseline corrects the matrices from -0.5-0s pre-cue
    % 3. Average matrices to compute ERP
    % 4. Compute t-test to indicate significance (no multiple comparisons
    %    correction
    % 5. Plot ERP timeseries
    if plotNum == 1
        lpStart=ft_preproc_lowpassfilter(input.ESRStart, fs, 10);
        lpResp=ft_preproc_lowpassfilter(input.ESRResp, fs, 10);
        [erpMatStarts, erpMatResps] = compute_erp_mat(lpStart,lpResp,ts);
        figure
        subplot(1,2,1)
        plot(ts,mean(erpMatStarts))
        hold on
        sigStarts=nan(size(ts));
        sigStarts(logical(ttest(erpMatStarts)))=1;
        plot(ts,sigStarts*0.9*max(mean(erpMatStarts)),'k','LineWidth',2)
        title('Grand Average Cue Locked ERP')
        ylabel('Amplitude \muV')
        xlabel('Time (s)')
        xlim([-0.5,1.5])
        subplot(1,2,2)
        plot(ts,mean(erpMatResps))
        hold on
        sigResps=nan(size(ts));
        sigResps(logical(ttest(erpMatResps)))=1;
        plot(ts,sigResps*0.9*max(mean(erpMatResps)),'k','LineWidth',2)
        title('Grand Average Response Locked ERP')
        xlabel('Time (s)')
        axis tight
    % Plots the cue-locked and response-locked ERPs for all channels on an
    % electrode after rereferencing. Input structure is identical to the
    % output of electrode_shaft_rereference.
    % Procedure:
    % 1. Low-pass filter both matrices at 10 Hz
    % 2. Baseline corrects the matrices from -0.5-0s pre-cue
    % 3. Average matrices to compute ERP
    % 4. Plot ERPs as colormap (time x depth x amplitude)
    elseif plotNum == 2
        lpDataStarts=input.cleanStarts;
        lpDataResps=input.cleanResps;
        for i=1:size(lpDataStarts,3)
            lpDataStarts(:,:,i) = ft_preproc_lowpassfilter(squeeze(lpDataStarts(:,:,i)), fs, 10);
            lpDataResps(:,:,i) = ft_preproc_lowpassfilter(squeeze(lpDataResps(:,:,i)), fs, 10);
        end
        depths=linspace(1.6,0,32);
        [erpMatStarts, erpMatResps] = compute_erp_mat(lpDataStarts,lpDataResps,ts);
        figure
        subplot(1,2,1)
        pcolor(ts(ts>-0.5),depths(2:end),squeeze(mean(erpMatStarts(:,ts>-0.5,:)))')
        shading interp
        cb=colorbar;
        ylabel(cb, 'Amplitude (\muV)')
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        set(gca, 'YDir','reverse')
        title('Cue Locked')
        colormap(redblue)
        caxis(max(max(abs(squeeze(mean(erpMatStarts)))))*[-1,1])
        subplot(1,2,2)
        pcolor(ts,depths(2:end),squeeze(mean(erpMatResps(:,:,:)))')
        colormap(redblue)
        caxis(max(max(abs(squeeze(mean(erpMatResps)))))*[-1,1])
        shading interp
        cb=colorbar;
        ylabel(cb, 'Amplitude (\muV)')
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        set(gca, 'YDir','reverse')
        title('Response Locked')
    % Computes the cue-locked and response-locked ERSPs for all channels on an
    % electrode after rereferencing. Makes plots for delta, theta, alpha, and 
    % beta bands. Input structure is identical to the output of electrode_shaft_rereference.
    % Procedure:
    % 1. Low-pass filter both matrices at 10 Hz
    % 4. Average matrices to compute ERSP
    % 5. Baseline corrects the matrices from -0.5--0.2s pre-cue
    % 6. Plot ERSPs as colormap (time x depth x amplitude)
    elseif plotNum == 3
        dataStarts=input.cleanStarts;
        dataResps=input.cleanResps;
        erspMatStarts=zeros(1876,39,size(dataStarts,1),size(dataStarts,3));
        erspMatResps=zeros(1876,39,size(dataResps,1),size(dataResps,3));
        [erspMatStarts(:,:,:,1),t,f]=mtspecgramc(squeeze(dataStarts(:,:,1))',movingwin,params);
        erspMatResps(:,:,:,1)=mtspecgramc(squeeze(dataResps(:,:,1))',movingwin,params);
        p=parpool(14);
        parfor i=2:31
            erspMatStarts(:,:,:,i)=mtspecgramc(squeeze(dataStarts(:,:,i))',movingwin,params);
            erspMatResps(:,:,:,i)=mtspecgramc(squeeze(dataResps(:,:,i))',movingwin,params);
            disp(i)
        end
        delete(p)
        fRanges=[1,4;4,7;7,14;14,30];
        depths=linspace(1.6,0,32);
        bands=["Delta","Theta","Alpha","Beta"];
        t=t-1.5;
        figure
        for i=1:size(fRanges,1)
            subplot(size(fRanges,1),2,2*i-1)
            allBaselines=squeeze(repmat(mean(mean(erspMatStarts(t>-0.5&t<-0.2,:,:,:),1),3),[size(erspMatStarts,1),1,1,1]));
            foi=f>fRanges(i,1)&f<fRanges(i,2);
            freqMat=squeeze(mean(erspMatStarts(t>-0.5,:,:,:),3));
            freqMat=squeeze(mean(20*log10(freqMat(:,foi,:)./allBaselines(t>-0.5,foi,:)),2));
            pcolor(t(t>-0.5),depths(2:end),freqMat')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Cue Locked Change in ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(freqMat)))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)

            subplot(size(fRanges,1),2,2*i)
            foi=f>fRanges(i,1)&f<fRanges(i,2);
            freqMat=squeeze(mean(erspMatResps,3));
            freqMat=squeeze(mean(20*log10(freqMat(:,foi,:)./allBaselines(:,foi,:)),2));
            pcolor(t,depths(2:end),freqMat')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Response Locked Change in ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(freqMat)))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)
        end
        output.erspMatStarts=erspMatStarts;
        output.erspMatResps=erspMatResps;
        output.f=f;
        output.t=t;
    % Computes the cue-locked and response-locked accuracy (I-C) ERSPs for all channels on an
    % electrode after rereferencing. Makes plots for delta, theta, alpha, and 
    % beta bands.Input structure is identical to the output of electrode_shaft_rereference.
    % Currently not implemented fully
    elseif plotNum == 4
        cd(input.bpath)
        setshift = read_set_shift_data_one_file_only_updated(input.logfn);
        performance=zeros(size(input.cleanStarts,1),1);
        index=1;
        for i=1:length(setshift.rules)
            performance(index:index+length(setshift.rules(i).performance)-1)=setshift.rules(i).performance;
            index=index+length(setshift.rules(i).performance);
        end
        dataStarts=input.cleanStarts;
        dataResps=input.cleanResps;
        erspMatStarts=zeros(1876,39,size(dataStarts,1),size(dataStarts,3));
        erspMatResps=zeros(1876,39,size(dataResps,1),size(dataResps,3));
        [erspMatStarts(:,:,:,1),t,f]=mtspecgramc(squeeze(dataStarts(:,:,i))',movingwin,params);
        erspMatResps(:,:,:,1)=mtspecgramc(squeeze(dataResps(:,:,i))',movingwin,params);
        p=parpool(14);
        parfor i=2:31
            erspMatStarts(:,:,:,i)=mtspecgramc(squeeze(dataStarts(:,:,i))',movingwin,params);
            erspMatResps(:,:,:,i)=mtspecgramc(squeeze(dataResps(:,:,i))',movingwin,params);
            disp(i)
        end
        delete(p)
        erspMatStartsCorr=erspMatStarts(:,:,performance,:);
        erspMatStartsIcorr=erspMatStarts(:,:,~performance,:);
        erspMatRespsCorr=erspMatResps(:,:,performance,:);
        erspMatRespsIcorr=erspMatResps(:,:,~performance,:);
        fRanges=[1,4;4,7;7,14;14,30];
        depths=linspace(1.6,0,32);
        bands=["Delta","Theta","Alpha","Beta"];
        t=t-1.5;
        figure
        for i=1:size(fRanges,1)
            subplot(size(fRanges,1),2,2*i-1)
            allBaselinesCorr=squeeze(repmat(mean(mean(erspMatStarts(t>-0.5&t<-0.2,:,:,:),1),3),[size(erspMatStartsCorr,1),1,1,1]));
            allBaselinesIcorr=squeeze(repmat(mean(mean(erspMatStarts(t>-0.5&t<-0.2,:,:,:),1),3),[size(erspMatStartsIcorr,1),1,1,1]));
            foi=f>fRanges(i,1)&f<fRanges(i,2);
            freqMatCorr=squeeze(mean(erspMatStartsCorr(t>-0.5,:,:,:),3));
            freqMatCorr=squeeze(mean(20*log10(freqMatCorr(:,foi,:)./allBaselinesCorr(t>-0.5,foi,:)),2));
            freqMatIcorr=squeeze(mean(erspMatStartsIcorr(t>-0.5,:,:,:),3));
            freqMatIcorr=squeeze(mean(20*log10(freqMatIcorr(:,foi,:)./allBaselinesIcorr(t>-0.5,foi,:)),2));
            pcolor(t(t>-0.5),depths(2:end),(freqMatIcorr-freqMatCorr)')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Cue Locked I-C ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(squeeze(mean(freqMatIcorr-freqMatCorr,2)))))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)

            subplot(size(fRanges,1),2,2*i)
            foi=f>fRanges(i,1)&f<fRanges(i,2);
            freqMatCorr=squeeze(mean(erspMatRespsCorr(t>-0.5,:,:,:),3));
            freqMatCorr=squeeze(mean(20*log10(freqMatCorr(:,foi,:)./allBaselinesCorr(t>-0.5,foi,:)),2));
            freqMatIcorr=squeeze(mean(erspMatRespsIcorr(t>-0.5,:,:,:),3));
            freqMatIcorr=squeeze(mean(20*log10(freqMatIcorr(:,foi,:)./allBaselinesIcorr(t>-0.5,foi,:)),2));
            pcolor(t(t>-0.5),depths(2:end),(freqMatIcorr-freqMatCorr)')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Response Locked I-C ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(squeeze(mean(freqMatIcorr-freqMatCorr,2)))))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)
        end
        output.erspMatStartsCorr=erspMatStartsCorr;
        output.erspMatStartsIcorr=erspMatStartsIcorr;
        output.erspMatRespsCorr=erspMatRespsCorr;
        output.erspMatRespsIcorr=erspMatRespsIcorr;
    % Computes the cue-locked and response-locked ERPs for all channels on an
    % electrode after rereferencing for all days, for one region, for one
    % animal. Input structure should indicate the number of recordings
    % (nRecs), the region, the rereferencing scheme and the animal id.
    % Procedure:
    % 1. Loads output of electrode_shaft_rereference for each animal
    % 2. Low-pass filters data for each animal
    % 3. Baseline corrects the matrices from -0.5-0s pre-cue
    % 4. Combines data from all days in a single matrix for each condition
    % 5. Average matrices to compute ERP
    % 6. Plot ERPs as colormap (time x depth x amplitude)
    elseif plotNum == 5
        depths=linspace(1.6,0,32);
        allERPStarts=cell(input.nRecs,1);
        allERPResps=cell(input.nRecs,1);
        nTrials=0;
        for p=1:input.nRecs
            if ~ismember(input.badDays,p)
                load(strcat(input.path, input.id, '-', num2str(p), '-', input.region, '-', input.reref));
                lpDataStarts=output.cleanStarts;
                lpDataResps=output.cleanResps;
                nTrials=nTrials+size(lpDataStarts,3);
                for i=1:size(lpDataStarts,3)
                    lpDataStarts(:,:,i) = ft_preproc_lowpassfilter(squeeze(lpDataStarts(:,:,i)), fs, 10);
                    lpDataResps(:,:,i) = ft_preproc_lowpassfilter(squeeze(lpDataResps(:,:,i)), fs, 10);
                end
                [erpMatStarts, erpMatResps] = compute_erp_mat(lpDataStarts,lpDataResps,ts);
                allERPStarts{p}=erpMatStarts;
                allERPResps{p}=erpMatResps;
            end
        end
        erpMatStarts=cell2mat(allERPStarts);
        erpMatResps=cell2mat(allERPResps);
        figure
        subplot(1,2,1)
        pcolor(ts(ts>-0.5),depths(2:end),squeeze(mean(erpMatStarts(:,ts>-0.5,:)))')
        shading interp
        cb=colorbar;
        ylabel(cb, 'Amplitude (\muV)')
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        set(gca, 'YDir','reverse')
        title('Cue Locked')
        colormap(redblue)
        caxis(max(max(abs(squeeze(mean(erpMatStarts)))))*[-1,1])
        %caxis([-10,10])
        subplot(1,2,2)
        pcolor(ts,depths(2:end),squeeze(mean(erpMatResps(:,:,:)))')
        colormap(redblue)
        caxis(max(max(abs(squeeze(mean(erpMatResps)))))*[-1,1])
        shading interp
        cb=colorbar;
        ylabel(cb, 'Amplitude (\muV)')
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        set(gca, 'YDir','reverse')
        title('Response Locked')
        %caxis([-10,10])
    % Computes the cue-locked and response-locked ERSPs for all channels and 
    % all dayson an electrode after rereferencing. Makes plots for delta, 
    % theta, alpha, and beta bands. Input structure should indicate the 
    % number of recordings(nRecs), the region, the rereferencing scheme and 
    % the animal id. Additionally, the input should contain vectors
    % indicating the time and frequency dimensions of the spectrograms from
    % plotNum=3 (included in Data/reref/tf.mat).
    % Procedure:
    % 1. Loads output of plotNum=3 for each animal
    % 2. Splits data from each day by frequency band
    % 3. Combines data from all days in a single matrix for each frequency
    %    band and condition
    % 4. Average matrices to compute ERSP
    % 5. Baseline corrects the matrices from -0.5--0.2s pre-cue
    % 6. Plot ERSPs as colormap (time x depth x amplitude)
    elseif plotNum == 6
        depths=linspace(1.6,0,32);
        fRanges=[1,4;4,7;7,14;14,30];
        bands=["Delta","Theta","Alpha","Beta"];
        bandsStarts=cell(input.nRecs,size(fRanges,1));
        bandsResps=cell(input.nRecs,size(fRanges,1));
        nTrials=0;
        for i=1:input.nRecs
            if ~ismember(input.badDays,i)
                load(strcat(input.path, input.id, '-', num2str(i), '-', input.region, '-', input.reref, '-ersp'));
                nTrials=nTrials+size(output2.erspMatStarts,3);
                for f=1:size(fRanges,1)
                    foi=input.f>fRanges(f,1)&input.f<fRanges(f,2);
                    bandsStarts{i,f}=output2.erspMatStarts(:,foi,:,:);
                    bandsResps{i,f}=output2.erspMatResps(:,foi,:,:);
                end
            end
        end
        figure
        for i=1:length(bands)
            freqMat=zeros(size(bandsStarts{1,i},1),size(bandsStarts{1,i},2),nTrials,size(bandsStarts{1,i},4));
            index=1;
            for j=1:input.nRecs
                if ~ismember(input.badDays,j)
                    freqMat(:,:,index:index+size(bandsStarts{j,i},3)-1,:)=bandsStarts{j,i};
                    index=index+size(bandsStarts{j,i},3);
                end
            end
            subplot(size(fRanges,1),2,2*i-1)
            allBaselines=squeeze(repmat(mean(mean(freqMat(input.t>-0.5&input.t<-0.2,:,:,:),1),3),[size(freqMat,1),1,1,1]));
            freqMat=squeeze(mean(freqMat(input.t>-0.5,:,:,:),3));
            freqMat=squeeze(mean(20*log10(freqMat(:,:,:)./allBaselines(input.t>-0.5,:,:)),2));
            pcolor(input.t(input.t>-0.5),depths(2:end),freqMat')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Cue Locked Change in ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(freqMat)))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)

            subplot(size(fRanges,1),2,2*i)
            freqMat=zeros(size(bandsResps{1,i},1),size(bandsResps{1,i},2),nTrials,size(bandsResps{1,i},4));
            index=1;
            for j=1:input.nRecs
                if ~ismember(input.badDays,j)
                    freqMat(:,:,index:index+size(bandsResps{j,i},3)-1,:)=bandsResps{j,i};
                    index=index+size(bandsResps{j,i},3);
                end
            end
            freqMat=squeeze(mean(freqMat,3));
            freqMat=squeeze(mean(20*log10(freqMat(:,:,:)./allBaselines(:,:,:)),2));
            pcolor(input.t,depths(2:end),freqMat')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Response Locked Change in ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(freqMat)))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)
        end
    % Computes the cue-locked and response-locked accuracy (I-C) ERPs for all 
    % channels on an electrode after rereferencing for all days, for one region, 
    % for one animal. Input structure should indicate the number of recordings
    % (nRecs), the region, the rereferencing scheme and the animal id.
    % Procedure:
    % 1. Loads output of electrode_shaft_rereference for each animal
    % 2. Loads behavior structure using read_set_shift_data_one_file_only
    %    for each animal
    % 3. Low-pass filters data for each animal
    % 4. Creates a vector for each data indicating the performance on every
    %    trial included in the LFP structure
    % 5. Baseline corrects the matrices from -0.5-0s pre-cue
    % 6. Combines data from all days in a single matrix for each condition
    % 7. Average matrices to compute ERP
    % 4. Plot ERPs (I-C) as colormap (time x depth x amplitude)
    elseif plotNum == 7
        depths=linspace(1.6,0,32);
        allERPStartsC=cell(input.nRecs,1);
        allERPStartsI=cell(input.nRecs,1);
        allERPRespsC=cell(input.nRecs,1);
        allERPRespsI=cell(input.nRecs,1);
        nTrials=0;
        if strcmp(input.id, 'csf01')
            id = 1;
        else
            id = 2;
        end
        for p=1:input.nRecs
            performance = compute_performance(strcat(rat(id).day(p).bpath,'\',rat(id).day(p).logfn));
            load(strcat(input.path, input.id, '-', num2str(p), '-', input.region, '-', input.reref));
            lpDataStarts=output.cleanStarts;
            lpDataResps=output.cleanResps;
            performance(union(output.rejStart,output.rejResp))=[];
            nTrials=nTrials+size(lpDataStarts,3);
            for i=1:size(lpDataStarts,3)
                lpDataStarts(:,:,i) = ft_preproc_lowpassfilter(squeeze(lpDataStarts(:,:,i)), fs, 10);
                lpDataResps(:,:,i) = ft_preproc_lowpassfilter(squeeze(lpDataResps(:,:,i)), fs, 10);
            end
            [erpMatStarts, erpMatResps] = compute_erp_mat(lpDataStarts,lpDataResps,ts);
            allERPStartsC{p}=erpMatStarts(performance,:,:);
            allERPStartsI{p}=erpMatStarts(~performance,:,:);
            allERPRespsC{p}=erpMatResps(performance,:,:);
            allERPRespsI{p}=erpMatResps(~performance,:,:);
        end
        erpMatStartsC=cell2mat(allERPStartsC);
        erpMatRespsC=cell2mat(allERPRespsC);
        erpMatStartsI=cell2mat(allERPStartsI);
        erpMatRespsI=cell2mat(allERPRespsI);
        figure
        subplot(1,2,1)
        pcolor(ts(ts>-0.5),depths(2:end),squeeze(mean(erpMatStartsI(:,ts>-0.5,:)))'-squeeze(mean(erpMatStartsC(:,ts>-0.5,:)))')
        shading interp
        cb=colorbar;
        ylabel(cb, 'Amplitude (\muV)')
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        set(gca, 'YDir','reverse')
        title('Cue Locked')
        colormap(redblue)
        caxis(max(max(abs(squeeze(mean(erpMatStartsI(:,ts>-0.5,:)))'-squeeze(mean(erpMatStartsC(:,ts>-0.5,:)))')))*[-1,1])
        %caxis([-15,15])
        subplot(1,2,2)
        pcolor(ts(ts>-0.5),depths(2:end),squeeze(mean(erpMatRespsI(:,ts>-0.5,:)))'-squeeze(mean(erpMatRespsC(:,ts>-0.5,:)))')
        colormap(redblue)
        caxis(max(max(abs(squeeze(mean(erpMatRespsI(:,ts>-0.5,:)))'-squeeze(mean(erpMatRespsC(:,ts>-0.5,:)))')))*[-1,1])
        shading interp
        cb=colorbar;
        ylabel(cb, 'Amplitude (\muV)')
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        set(gca, 'YDir','reverse')
        title('Response Locked')
        %caxis([-15,15])
    % Computes the cue-locked and response-locked accuracy ERSPs for all channels and 
    % all days on an electrode after rereferencing. Makes plots for delta, 
    % theta, alpha, and beta bands. Input structure should indicate the 
    % number of recordings(nRecs), the region, the rereferencing scheme and 
    % the animal id. Additionally, the input should contain vectors
    % indicating the time and frequency dimensions of the spectrograms from
    % plotNum=3.
    % Procedure:
    % 1. Loads output of plotNum=3 for each animal
    % 2. Loads output of electrode_shaft_rereference for each animal
    % 3. Loads behavior structure using read_set_shift_data_one_file_only
    %    for each animal
    % 4. Splits data from each day by frequency band
    % 5. Creates a vector for each data indicating the performance on every
    %    trial included in the LFP structure
    % 6. Combines data from all days in a single matrix for each frequency
    %    band and condition
    % 7. Average matrices to compute ERSP
    % 8. Baseline corrects the matrices from -0.5--0.2s pre-cue
    % 9. Plot ERSPs as colormap (time x depth x amplitude)
    elseif plotNum == 8
        depths=linspace(1.6,0,32);
        fRanges=[1,4;4,7;7,14;14,30];
        bands=["Delta","Theta","Alpha","Beta"];
        bandsStartsC=cell(input.nRecs,size(fRanges,1));
        bandsRespsC=cell(input.nRecs,size(fRanges,1));
        bandsStartsI=cell(input.nRecs,size(fRanges,1));
        bandsRespsI=cell(input.nRecs,size(fRanges,1));
        nTrials=0;
        if strcmp(input.id, 'csf01')
            id = 1;
        else
            id = 2;
        end
        for p=1:input.nRecs
            performance = compute_performance(strcat(rat(id).day(p).bpath,'\',rat(id).day(p).logfn));
            load(strcat(input.path, input.id, '-', num2str(p), '-', input.region, '-', input.reref));
            performance(union(output.rejStart,output.rejResp))=[];
            load(strcat(input.path, input.id, '-', num2str(p), '-', input.region, '-', input.reref, '-ersp'));
            nTrials=nTrials+size(output2.erspMatStarts,3);
            for f=1:size(fRanges,1)
                foi=input.f>fRanges(f,1)&input.f<fRanges(f,2);
                bandsStartsC{p,f}=output2.erspMatStarts(:,foi,performance,:);
                bandsRespsC{p,f}=output2.erspMatResps(:,foi,performance,:);
                bandsStartsI{p,f}=output2.erspMatStarts(:,foi,~performance,:);
                bandsRespsI{p,f}=output2.erspMatResps(:,foi,~performance,:);
            end
        end
        figure
        for i=1:length(bands)
            freqMat1=zeros(size(bandsStartsC{1,i},1),size(bandsStartsC{1,i},2),nTrials,size(bandsStartsC{1,i},4));
            freqMat2=zeros(size(bandsStartsI{1,i},1),size(bandsStartsI{1,i},2),nTrials,size(bandsStartsI{1,i},4));
            index1=1;
            index2=1;
            for j=1:input.nRecs
                freqMat1(:,:,index1:index1+size(bandsStartsC{j,i},3)-1,:)=bandsStartsC{j,i};
                index1=index1+size(bandsStartsC{j,i},3);
                freqMat2(:,:,index2:index2+size(bandsStartsI{j,i},3)-1,:)=bandsStartsI{j,i};
                index2=index2+size(bandsStartsI{j,i},3);
            end
            subplot(size(fRanges,1),2,2*i-1)
            freqMat=cat(3,freqMat1,freqMat2);
            allBaselines=squeeze(repmat(mean(mean(freqMat(input.t>-0.5&input.t<-0.2,:,:,:),1),3),[size(freqMat,1),1,1,1]));
            freqMat1=squeeze(mean(freqMat1(input.t>-0.5,:,:,:),3));
            freqMat1=squeeze(mean(20*log10(freqMat1(:,:,:)./allBaselines(input.t>-0.5,:,:)),2));
            freqMat2=squeeze(mean(freqMat2(input.t>-0.5,:,:,:),3));
            freqMat2=squeeze(mean(20*log10(freqMat2(:,:,:)./allBaselines(input.t>-0.5,:,:)),2));
            pcolor(input.t(input.t>-0.5),depths(2:end),freqMat2'-freqMat1')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Cue Locked Change in ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(freqMat2-freqMat1)))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)

            subplot(size(fRanges,1),2,2*i)
            freqMat1=zeros(size(bandsRespsC{1,i},1),size(bandsRespsC{1,i},2),nTrials,size(bandsRespsC{1,i},4));
            freqMat2=zeros(size(bandsRespsI{1,i},1),size(bandsRespsI{1,i},2),nTrials,size(bandsRespsI{1,i},4));
            index1=1;
            index2=1;
            for j=1:input.nRecs
                freqMat1(:,:,index1:index1+size(bandsRespsC{j,i},3)-1,:)=bandsRespsC{j,i};
                index1=index1+size(bandsRespsC{j,i},3);
                freqMat2(:,:,index2:index2+size(bandsRespsI{j,i},3)-1,:)=bandsRespsI{j,i};
                index2=index2+size(bandsRespsI{j,i},3);
            end
            freqMat1=squeeze(mean(freqMat1(input.t>-0.5,:,:,:),3));
            freqMat1=squeeze(mean(20*log10(freqMat1(:,:,:)./allBaselines(input.t>-0.5,:,:)),2));
            freqMat2=squeeze(mean(freqMat2(input.t>-0.5,:,:,:),3));
            freqMat2=squeeze(mean(20*log10(freqMat2(:,:,:)./allBaselines(input.t>-0.5,:,:)),2));
            pcolor(input.t(input.t>-0.5),depths(2:end),freqMat2'-freqMat1')
            shading interp
            xlabel('Time (s)')
            ylabel('Depth (mm)')
            title(strcat("Response Locked Change in ", bands(i), " Power"))
            cb=colorbar;
            caxis(max(max(abs(freqMat2-freqMat1)))*[-1 1])
            ylabel(cb,'Power Change (dB)')
            set(gca, 'YDir','reverse')
            colormap(redblue)
        end
    % Compute analyses 5-8 using the grand average of all channels on a
    % single electrode. input structure will be identical to plots 6/8.
    elseif plotNum == 9
        performances=cell(input.nRecs,1);
        allERPStarts=cell(input.nRecs,1);
        allERPResps=cell(input.nRecs,1);
        allERSPStarts=cell(input.nRecs,1);
        allERSPResps=cell(input.nRecs,1);
        nTrials=0;
        if strcmp(input.id, 'csf01')
            id = 1;
        else
            id = 2;
        end
        for p=1:input.nRecs
            performance = compute_performance(strcat(rat(id).day(p).bpath,'\',rat(id).day(p).logfn));
            load(strcat(input.path, input.id, '-', num2str(p), '-', input.region, '-', input.reref));
            performances{p}=performance;
            performances{p}(union(output.rejStart,output.rejResp))=[];
            allERPStarts{p}=ft_preproc_lowpassfilter(output.ESRStart, fs, 10);
            allERPResps{p}=ft_preproc_lowpassfilter(output.ESRResp, fs, 10);
            allERSPStarts{p}=mtspecgramc(squeeze(output.ESRStart(:,:))',movingwin,params);
            allERSPResps{p}=mtspecgramc(squeeze(output.ESRResp(:,:))',movingwin,params);
            nTrials=nTrials+size(allERPStarts{p},1);
        end
        erpMatStarts=zeros(nTrials,size(allERPStarts{1},2));
        erpMatResps=zeros(nTrials,size(allERPStarts{1},2));
        performance=false(nTrials,1);
        index=1;
        for i=1:input.nRecs
            erpMatStarts(index:index+size(allERPStarts{i},1)-1,:)=allERPStarts{i};
            erpMatResps(index:index+size(allERPResps{i},1)-1,:)=allERPResps{i};
            performance(index:index+length(performances{i})-1)=performances{i};
            index=index+size(allERPStarts{i},1);
        end
        [erpMatStarts, erpMatResps] = compute_erp_mat(erpMatStarts,erpMatResps,ts);
        figure
        subplot(1,2,1)
        plot(ts,mean(erpMatStarts))
        hold on
        title('Grand Average Cue Locked ERP')
        ylabel('Amplitude \muV')
        xlabel('Time (s)')
        xlim([-0.5,1.5])
        subplot(1,2,2)
        plot(ts,mean(erpMatResps))
        hold on
        title('Grand Average Response Locked ERP')
        xlabel('Time (s)')
        axis tight
        
        figure
        subplot(1,2,1)
        plot(ts,mean(erpMatStarts(~performance,:))-mean(erpMatStarts(performance,:)))
        title('Grand Average Cue Locked ERP')
        ylabel('Amplitude \muV')
        xlabel('Time (s)')
        xlim([-0.5,1.5])
        subplot(1,2,2)
        plot(ts,mean(erpMatResps(~performance,:))-mean(erpMatResps(performance,:)))
        title('Grand Average Response Locked ERP')
        xlabel('Time (s)')
        axis tight
        
        figure
        freqMat1=zeros(size(allERSPStarts{i},1),size(allERSPStarts{i},2),nTrials);
        index=1;
        for i=1:input.nRecs
            freqMat1(:,:,index:(index+size(allERSPStarts{i},3)-1))=allERSPStarts{i};
            index=index+size(allERSPStarts{i},3);
        end
        badInds1=squeeze(any(freqMat1(:,20,:)>300,1));
        allBaselines=squeeze(repmat(mean(mean(freqMat1(input.t>-0.5&input.t<-0.2,:,~badInds1),1),3),[size(freqMat1,1),1,1]));
        freqMat=squeeze(mean(freqMat1(input.t>-0.5,:,~badInds1),3));
        freqMatAll=20*log10(freqMat(:,:)./allBaselines(input.t>-0.5,:));
        subplot(1,2,1)
        pcolor(input.t(input.t>-0.5),input.f,freqMatAll')
        shading interp
        xlabel('Time (s)')
        ylabel('Frequency (Hz)')
        title(strcat("Cue Locked Change in Power"))
        cb=colorbar;
        caxis(max(max(abs(freqMatAll)))*[-1 1])
        ylabel(cb,'Power Change (dB)')
        colormap(redblue)
        
        subplot(1,2,2)
        freqMat2=zeros(size(allERSPResps{i},1),size(allERSPResps{i},2),nTrials,size(allERSPResps{i},4));
        index=1;
        for i=1:input.nRecs
            freqMat2(:,:,index:index+size(allERSPResps{i},3)-1,:)=allERSPResps{i};
            index=index+size(allERSPResps{i},3);
        end
        badInds2=squeeze(any(freqMat2(:,20,:)>300,1));
        freqMat=squeeze(mean(freqMat2(:,:,~badInds2),3));
        freqMatAll=20*log10(freqMat(:,:)./allBaselines(:,:));
        pcolor(input.t,input.f,freqMatAll')
        shading interp
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        title(strcat("Response Locked Change in Power"))
        cb=colorbar;
        caxis(max(max(abs(freqMatAll)))*[-1 1])
        ylabel(cb,'Power Change (dB)')
        colormap(redblue)
        
        figure
        freqMat=squeeze(mean(freqMat1(input.t>-0.5,:,~badInds1&performance),3));
        freqMatAllC=20*log10(freqMat(:,:)./allBaselines(input.t>-0.5,:));
        freqMat=squeeze(mean(freqMat1(input.t>-0.5,:,~badInds1&~performance),3));
        freqMatAllI=20*log10(freqMat(:,:)./allBaselines(input.t>-0.5,:));
        subplot(1,2,1)
        pcolor(input.t(input.t>-0.5),input.f,(freqMatAllI-freqMatAllC)')
        shading interp
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        title(strcat("Cue Locked Change in Power"))
        cb=colorbar;
        caxis(max(max(abs(freqMatAllI-freqMatAllC)))*[-1 1])
        ylabel(cb,'Power Change (dB)')
        colormap(redblue)
        freqMat=squeeze(mean(freqMat2(:,:,~badInds2&performance),3));
        freqMatAllC=20*log10(freqMat(:,:)./allBaselines(:,:));
        freqMat=squeeze(mean(freqMat2(:,:,~badInds2&~performance),3));
        freqMatAllI=20*log10(freqMat(:,:)./allBaselines(:,:));
        subplot(1,2,2)
        pcolor(input.t,input.f,(freqMatAllI-freqMatAllC)')
        shading interp
        xlabel('Time (s)')
        ylabel('Depth (mm)')
        title(strcat("Cue Locked Change in Power"))
        cb=colorbar;
        caxis(max(max(abs(freqMatAllI-freqMatAllC)))*[-1 1])
        ylabel(cb,'Power Change (dB)')
        colormap(redblue)
    end
end

%% compute_erp_mat
% Baseline corrects the two input matrices using the baseline period
% between -0.5-0s pre stimulus for the first matrix.
%
% Inputs:
% *startData* - first matrix (trials x time x channels)
% *respData* - second matrix (trials x time x channels)
% *ts* - vector of times equal in length to the time dimension of both matrices
%
% Outputs:
% *erpMatStarts* - baseline corrected first matrix
% *erpMatResps* - baseline corrected second matrix
function [erpMatStarts, erpMatResps] = compute_erp_mat(startData,respData,ts)
    baseline = ts > -0.5 & ts < 0;
    erpMatStarts=startData-repmat(mean(startData(:,baseline,:),2),[1,length(baseline),1]);
    erpMatResps=respData-repmat(mean(startData(:,baseline,:),2),[1,length(baseline),1]);
end

%% compute_performance
% Computes a vector indicating performance on each trial in a task in the
% following order [LRc,LRi,RRc,RRi,FRc,FRi]. This matches the order of the
% task condition in the behavior
%
% Inputs:
% *path* - path to behavior file
%
% Outputs:
% *performance* - vector of performance (1/0) on each trial
function performance = compute_performance(path)
    setshift = read_set_shift_data_one_file_only_updated(path);
    performances=zeros(6,1);
    index=1;
    for rl = 1:length(setshift.rules)
        for bl = 1:length(setshift.rules(rl).blocks)
            for trl = 1:length(setshift.rules(rl).blocks(bl).trials)
                if setshift.rules(rl).blocks(bl).performEval(trl,1) == 1
                    performances(2*index-1)=performances(2*index-1)+1;
                else
                    performances(2*index)=performances(2*index)+1;
                end
            end
        end
        if rl==4 || rl == 6
            index = index+1;
        end
    end
    performance=false(sum(performances),1);
    index=1;
    for i=1:length(performances)
        performance(index:performances(i)+index-1)=mod(i,2);
        index=index+performances(i);
    end
%     blockTimes = zeros(length(setshift.rules),1);
%     nT=0;
%     for i=1:length(setshift.rules)
%         blockTimes(i)=setshift.rules(i).blocks(1).performEval(1,2);
%         nT=nT+length(setshift.rules(i).performance);
%     end
%     [~,blockOrder]=sort(blockTimes);
%     performance=false(nT,1);
%     index=1;
%     for i=1:length(blockOrder)
%         performance(index:index+length(setshift.rules(blockOrder(i)).performance)-1)=setshift.rules(blockOrder(i)).performance;
%         index=index+length(setshift.rules(blockOrder(i)).performance);
%     end
end