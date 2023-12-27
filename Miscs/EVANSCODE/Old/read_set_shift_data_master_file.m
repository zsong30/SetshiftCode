function rat = read_set_shift_data_master_file
% this function rat = read_set_shift_data_master_file is to read in
% setshift data in multiple files in multiple folders the way graphic state
% produced using GS4 format. 

count = 0;
tmp = dir('*2021');
for fnm = 1: length(tmp)
foldername = tmp(fnm).name;
cd(foldername)
tmpfn = dir('*.csv');

for fn = 1:length(tmpfn)
logfn = tmpfn(fn).name;
setshift(count + fn) = read_set_shift_data_one_file_only_updated(logfn);  %#ok<*AGROW>
end
count = count + fn;
cd ..

end

sf = 0; sm = 0;
for s = 1:length(setshift)
if sum(strcmp(setshift(s).ratname,{'CSF01','CSFO1'}))
    rat(1).name = 'CSF01';
    sf = sf +1;
    rat(1).setshift(sf) = setshift(s);
    
elseif sum(strcmp(setshift(s).ratname,{'CSM01','CSMO1'}))
        rat(2).name = 'CSM01';
    sm = sm +1;
    rat(2).setshift(sm) = setshift(s);
else
    sprintf('there is another rat tested but not included')
        
end
end
