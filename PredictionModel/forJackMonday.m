

load("CSF02_lfp_predictionmodel_09242023.mat")

frqband = [4,12;13,30;31,50];

for frqb = 1:3

    pl_dm_power_correct = squeeze(median(median(lfpdata.prelimbic.correcttrialpower(lfpdata.t<1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));
    st_dm_power_correct = squeeze(median(median(lfpdata.striatum.correcttrialpower(lfpdata.t<1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));
    pl_ln_power_correct = squeeze(median(median(lfpdata.prelimbic.correcttrialpower(lfpdata.t>1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));
    st_ln_power_correct = squeeze(median(median(lfpdata.striatum.correcttrialpower(lfpdata.t>1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));
    pl_dm_power_incorrect = squeeze(median(median(lfpdata.prelimbic.incorrecttrialpower(lfpdata.t<1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));
    st_dm_power_incorrect = squeeze(median(median(lfpdata.striatum.incorrecttrialpower(lfpdata.t<1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));
    pl_ln_power_incorrect = squeeze(median(median(lfpdata.prelimbic.incorrecttrialpower(lfpdata.t>1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));
    st_ln_power_incorrect = squeeze(median(median(lfpdata.striatum.incorrecttrialpower(lfpdata.t>1,lfpdata.f>frqband(frqb,1)&lfpdata.f<frqband(frqb,2),:,:),1),2));



    for cl = 1:floor(size(pl_dm_power_correct,2)/10)

        pl_dm_power_correct_cluster(:,cl,frqb) =  median(pl_dm_power_correct(:,1+10*(cl-1):10*cl),2);
        st_dm_power_correct_cluster(:,cl,frqb) =  median(st_dm_power_correct(:,1+10*(cl-1):10*cl),2);
        pl_ln_power_correct_cluster(:,cl,frqb) =  median(pl_ln_power_correct(:,1+10*(cl-1):10*cl),2);
        st_ln_power_correct_cluster(:,cl,frqb) =  median(st_ln_power_correct(:,1+10*(cl-1):10*cl),2);
        pl_dm_power_incorrect_cluster(:,cl,frqb) =  median(pl_dm_power_incorrect(:,1+10*(cl-1):10*cl),2);
        st_dm_power_incorrect_cluster(:,cl,frqb) =  median(st_dm_power_incorrect(:,1+10*(cl-1):10*cl),2);
        pl_ln_power_incorrect_cluster(:,cl,frqb) =  median(pl_ln_power_incorrect(:,1+10*(cl-1):10*cl),2);
        st_ln_power_incorrect_cluster(:,cl,frqb) =  median(st_ln_power_incorrect(:,1+10*(cl-1):10*cl),2);




    end



    
end

allinclusiveT_corr = [squeeze(pl_dm_power_correct_cluster(:,:,1)),squeeze(pl_dm_power_correct_cluster(:,:,2)),squeeze(pl_dm_power_correct_cluster(:,:,3)),...
    squeeze(pl_ln_power_correct_cluster(:,:,1)),squeeze(pl_ln_power_correct_cluster(:,:,2)),squeeze(pl_ln_power_correct_cluster(:,:,3)),...
    squeeze(st_dm_power_correct_cluster(:,:,1)),squeeze(st_dm_power_correct_cluster(:,:,2)),squeeze(st_dm_power_correct_cluster(:,:,3)),...
    squeeze(st_ln_power_correct_cluster(:,:,1)),squeeze(st_ln_power_correct_cluster(:,:,2)),squeeze(st_ln_power_correct_cluster(:,:,3))];
allinclusiveT_incorr = [squeeze(pl_dm_power_incorrect_cluster(:,:,1)),squeeze(pl_dm_power_incorrect_cluster(:,:,2)),squeeze(pl_dm_power_incorrect_cluster(:,:,3)),...
    squeeze(pl_ln_power_incorrect_cluster(:,:,1)),squeeze(pl_ln_power_incorrect_cluster(:,:,2)),squeeze(pl_ln_power_incorrect_cluster(:,:,3)),...
    squeeze(st_dm_power_incorrect_cluster(:,:,1)),squeeze(st_dm_power_incorrect_cluster(:,:,2)),squeeze(st_dm_power_incorrect_cluster(:,:,3)),...
    squeeze(st_ln_power_incorrect_cluster(:,:,1)),squeeze(st_ln_power_incorrect_cluster(:,:,2)),squeeze(st_ln_power_incorrect_cluster(:,:,3))];
allinclusiveT = [allinclusiveT_corr;allinclusiveT_incorr];

tmptable = []; %#ok<NASGU>
load('CSF02_unit_predictionmodel_correcttrls_pl_bef_09242023','spikerate_correct')
tmptable = spikerate_correct;
clear spikerate_correct
load('CSF02_unit_predictionmodel_correcttrls_pl_aft_09242023','spikerate_correct')
tmptable = [tmptable,spikerate_correct];
clear spikerate_correct

load('CSF02_unit_predictionmodel_correcttrls_st_bef_09242023','spikerate_correct')
tmptable = [tmptable,spikerate_correct];
clear spikerate_correct
load('CSF02_unit_predictionmodel_correcttrls_st_aft_09242023','spikerate_correct')
tmptable = [tmptable,spikerate_correct];
clear spikerate_correct

tmptable2 = []; %#ok<NASGU>
load('CSF02_unit_predictionmodel_incorrecttrls_pl_bef_09242023','spikerate_incorrect')
tmptable2 = spikerate_incorrect;
clear spikerate_incorrect
load('CSF02_unit_predictionmodel_incorrecttrls_pl_aft_09242023','spikerate_incorrect')
tmptable2 = [tmptable2,spikerate_incorrect];
clear spikerate_incorrect

load('CSF02_unit_predictionmodel_incorrecttrls_st_bef_09242023','spikerate_incorrect')
tmptable2 = [tmptable2,spikerate_incorrect];
clear spikerate_incorrect
load('CSF02_unit_predictionmodel_incorrecttrls_st_aft_09242023','spikerate_incorrect')
tmptable2 = [tmptable2,spikerate_incorrect];
clear spikerate_incorrect
tmptable = [tmptable;tmptable2];


allinclusiveTable = [tmptable,allinclusiveT];

load('CSF02_behav_predictionmodel_correcttrials_09242023.mat','table_correct')
table_correct = [ones(length(table_correct{:,2}),1),table_correct{:,2}];
load('CSF02_behav_predictionmodel_incorrecttrials_09242023.mat','table_incorrect')
table_incorrect = [zeros(length(table_incorrect{:,2}),1),table_incorrect{:,2}];

allinclusiveTable = [allinclusiveTable,[table_correct;table_incorrect]];

save(fullfile('z:\projmon\ericsprojects\Setshift\DATA\PredictionModel','allinclusivetable_09242023'),'allinclusiveTable','-v7.3')
