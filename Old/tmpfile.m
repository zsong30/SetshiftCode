function tmpfile(table_incl)

RTtable = table('Size', [100, 7] , 'VariableTypes', { 'string' , 'string','string', 'string','string','string', 'double',},...
    'VariableNames' , {'ratname', 'date','protocol','rule','ruletype', 'ruletypespecific','reactiontimes'});


tblpos = 1;

        trialcounter = 1;
        for e=1:numel(table_incl.RT)
            % find the correct response expected location and the rule
            if contains(table_incl(e,:).rule, 'L')
                ruletype = 'Light';
                ruletypespecific = 'Light';
            elseif contains(table_incl(e,:).rule, 'F')
                ruletype = 'Side';
                ruletypespecific = 'Front';
            else
                ruletype = 'Side';
                ruletypespecific = 'Rear';
            end
            currrule = table_incl(e,:).rule;
            if e == 1
                RTarray(1, trialcounter) = table_incl(e,:).RT;
                trialcounter = trialcounter + 1;

            else
                pastrule = table_incl(e-1,:).rule;
                while strcmp(currrule{1,1},pastrule{1,1})
                    RTarray(1, trialcounter) = table_incl(e,:).RT;
                    trialcounter = trialcounter + 1;
                    if e + 1 <= numel(table_incl.RT)
                        e = e + 1;
                    end
                    currrule = table_incl(e,:).rule;
                    pastrule = table_incl(e-1,:).rule;

                end
                trialcounter = 1 ;
                RTarray(1, trialcounter) = table_incl(e,:).RT;
                trialcounter = trialcounter + 1;

            end
            
%             RTtable.ratname(tblpos) = table_incl(e,:).ratname;
%             RTtable.date(tblpos) = table_incl(e,:).date ;
%             RTtable.protocol(tblpos) = table_incl(e,:).protocol;
%             RTtable.rule(tblpos) = table_incl(e,:).rule;
%             RTtable.ruletype(tblpos) = ruletype;
%             RTtable.ruletypespecific(tblpos) = ruletypespecific;
%             RTtable.reactiontimes(tblpos) = table_incl(e,:).RT;
%             tblpos = tblpos + 1 ;
            
                       
            
            
        end
