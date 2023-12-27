%kartikeya singh august 2022
RTtable = table('Size', [100, 7] , 'VariableTypes', { 'string' , 'string','string', 'string','string','string', 'double',},...
    'VariableNames' , {'ratname', 'date','protocol','rule','ruletype', 'ruletypespecific','reactiontimes'});
pat='\\TNEL100-TB4\ThunderBay\SetShift\BEHAVDATA\behav2022\';
parentdirectory = dir(pat);
tblpos = 1;
for i=3:numel(parentdirectory)
    ratname = parentdirectory(i).name;
    path = strcat(pat, ratname);
    fil = fullfile(path, '*.mat');
    childdirectory=dir(fil);

    for k=1:numel(childdirectory)
        sessionnumber = k;
        filename=fullfile(path,childdirectory(k).name);
        load (filename, 'setshift')
%         RTarray = [];
%         trialcounter = 1;
        for e=1:numel(setshift.data)
            % find the correct response expected location and the rule
            if contains(setshift.data(e).rule, 'L')
                ruletype = 'Light';
                ruletypespecific = 'Light';
            elseif contains(setshift.data(e).rule, 'F')
                ruletype = 'Side';
                ruletypespecific = 'Front';
            else
                ruletype = 'Side';
                ruletypespecific = 'Rear';
            end
%             currrule = setshift.data(e).rule;
%             if e == 1
%                 RTarray(1, trialcounter) = setshift.data(e).RT;
%                 trialcounter = trialcounter + 1;
% 
%             else
%                 pastrule = setshift.data(e-1).rule;
%                 while strcmp(currrule{1,1},pastrule{1,1})
%                     RTarray(1, trialcounter) = setshift.data(e).RT;
%                     trialcounter = trialcounter + 1;
%                     if e + 1 <= numel(setshift.data)
%                         e = e + 1;
%                     end
%                     currrule = setshift.data(e).rule;
%                     pastrule = setshift.data(e-1).rule;
% 
%                 end
%                 trialcounter = 1 ;
%                 RTarray(1, trialcounter) = setshift.data(e).RT;
%                 trialcounter = trialcounter + 1;

%             end
           
            RTtable.ratname(tblpos) = ratname;
            RTtable.date(tblpos) = setshift.testdate ;
            RTtable.protocol(tblpos) = setshift.protocolname;
            RTtable.rule(tblpos) = setshift.data(e).rule;
            RTtable.ruletype(tblpos) = ruletype;
            RTtable.ruletypespecific(tblpos) = ruletypespecific;
            RTtable.reactiontimes(tblpos) = setshift.data(e).RT;
            tblpos = tblpos + 1 ;
        end
    end
end


% nztable = RTarray == 0;
% RTarray(nztable) = nan;
% meanRT = mean(RTarray,'omitnan');
% 
% z = ~isnan(RTarray);
% q = nnz(z);
% 
% q1 = RTarray(:,1:25);
% nntable = ~isnan(q1);
% b = nnz(nntable);
% pctq1 = (b/q)*100;
% disp(pctq1)
% 
% q2 = RTarray(:,26:50);
% a = numel(q2);
% nntable = ~isnan(q2);
% b = nnz(nntable);
% pctq2 = (b/q)*100;
% disp(pctq2)
% 
% outlier = RTarray >= 3;
% RTarray(outlier) = nan;
% 
% meanRT = mean(RTarray,'omitnan');
% medianRT = median(RTarray,'omitnan');
% 
% figure
% plot(RTarray','Color','#808080')
% hold on 
% plot(medianRT','LineWidth',3,'Color','#FF0000')
% hold on
% ylim([0 1.5])
% ylabel('Reaction Time(s)')
% xlabel('Trial Number in Rule')
% xlim([0 25])
% 
save('\\TNEL100-TB4\ThunderBay\SetShift\DATA\RTtable.mat', 'RTtable')
% 
