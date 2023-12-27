
load('E:\SetShift\BEHAVDATA\behav2022\CSF03\CSF03_2021_11_08__14_36_00.mat')
onesessiontable = struct2table(setshift.data);

table_tobeadded = table('Size',[size(onesessiontable,1),3],'VariableTypes', { 'string' , 'string','string'},...
     'VariableNames' , {'ratname', 'date','protocol'});

 for i = 1:size(onesessiontable,1)
  table_tobeadded(i,1).ratname = 'CSF03';
  table_tobeadded(i,2).date = setshift.testdate;
  table_tobeadded(i,3).protocol = setshift.protocolname;   
         
 end
 
 comtable_orig = [table_tobeadded,onesessiontable];
 comtable_orig(2:end,:) = [];
 table_incl = comtable_orig;
 
path='\\TNEL100-TB4\ThunderBay\SetShift\BEHAVDATA\behav2022\'; 
cd(path)
dirrat = dir('CSF*');
for j = 1:length(dirrat)
    cd(dirrat(j).name)
    dirmatfile = dir('CSF*.mat');
    comtable = comtable_orig;
    for k = 1:length(dirmatfile)
        load(dirmatfile(k).name)
        tmponesessiontable = struct2table(setshift.data);
        tmptable_tobeadded = table('Size',[size(tmponesessiontable,1),3],'VariableTypes', { 'string' , 'string','string'},...
            'VariableNames' , {'ratname', 'date','protocol'});
        for i = 1:size(tmponesessiontable,1)
            tmptable_tobeadded(i,1).ratname = dirrat(j).name;
            tmptable_tobeadded(i,2).date = setshift.testdate;
            tmptable_tobeadded(i,3).protocol = setshift.protocolname;
        end
        tmptable = [tmptable_tobeadded,tmponesessiontable];
        comtable = [comtable;tmptable];
        clear setshift
    end
    cd ..
    
    comtable(1,:) = [];
    table_incl = [table_incl; comtable];
    
end
table_incl(1,:) = []; 

RTtable_part1 = table('Size', [1500, 4] , 'VariableTypes', { 'string' , 'string','string', 'string' },...
    'VariableNames' , {'ratname', 'date','protocol','rule'});

RT = nan(1500,100);
rowcounter = 1;trialcounter = 1;
 for e=1:numel(table_incl.RT)
     if e ==1
      RTtable_part1(1,:).ratname = table_incl(e,:).ratname;   
        RTtable_part1(1,:).date = table_incl(e,:).date;  
        RTtable_part1(1,:).protocol = table_incl(e,:).protocol;  
        RT(1,trialcounter) = table_incl(e,:).RT;
        trialcounter = trialcounter + 1;
     else
        
         if strcmp(table_incl(e,:).ratname,table_incl(e-1,:).ratname)&&...
                 strcmp(table_incl(e,:).date,table_incl(e-1,:).date)&&...
                 strcmp(table_incl(e,:).protocol,table_incl(e-1,:).protocol)&&...
                 strcmp(table_incl(e,:).rule,table_incl(e-1,:).rule)
                   
             RTtable_part1(rowcounter,:).ratname = table_incl(e,:).ratname;
             RTtable_part1(rowcounter,:).date = table_incl(e,:).date;
             RTtable_part1(rowcounter,:).protocol = table_incl(e,:).protocol;
             RTtable_part1(rowcounter,:).rule = table_incl(e,:).rule;
             
             RT(rowcounter,trialcounter) = table_incl(e,:).RT;
             trialcounter = trialcounter + 1;
         else
             rowcounter =  rowcounter + 1;trialcounter = 1;
             
             RTtable_part1(rowcounter,:).ratname = table_incl(e,:).ratname;
             RTtable_part1(rowcounter,:).date = table_incl(e,:).date;
             RTtable_part1(rowcounter,:).protocol = table_incl(e,:).protocol;
             RTtable_part1(rowcounter,:).rule = table_incl(e,:).rule;
             
             RT(rowcounter,trialcounter) = table_incl(e,:).RT;
             
             
         end
         
         
         
     end
     
     
     
 end
RTtable_part2 = array2table(RT);
RTtable2 = [RTtable_part1,RTtable_part2];
L2data = RTarray((RTtable.rule == 'L1'|RTtable.rule == 'L2'|RTtable.rule == 'L3'|RTtable.rule == 'L4'),2:10);
L2data(L2data>7)= nan;
trials = 2:10;
figure,plot(trials,L2data','Color',[0,0,0])
ylim([0,5]);
xlim([1.5,10.5])
box off
hold on
plot(trials,mean(L2data,1,'omitnan'),'Color','r','LineWidth',3)
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Reaction time (seconds)','FontSize',20,'FontWeight', 'bold')
xlabel('Trials','FontSize',20,'FontWeight', 'bold')


L2data = RTarray((RTtable.rule == 'F1'|RTtable.rule == 'F2'|RTtable.rule == 'R1'|RTtable.rule == 'R2'),2:10);
L2data(L2data>7)= nan;
trials = 2:10;
figure,plot(trials,L2data','Color',[0,0,0])
ylim([0,5]);
xlim([1.5,10.5])
box off
hold on
plot(trials,mean(L2data,1,'omitnan'),'Color','r','LineWidth',3)
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Reaction time (seconds)','FontSize',20,'FontWeight', 'bold')
xlabel('Trials','FontSize',20,'FontWeight', 'bold')



