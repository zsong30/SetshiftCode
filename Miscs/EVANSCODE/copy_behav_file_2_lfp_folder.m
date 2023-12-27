function copy_behav_file_2_lfp_folder
% copy_behav_file_2_lfp_folder
% written by Eric Song 04/07/2021

% assuming in the EPHYSDATA folder
rat(1).name = 'CSF01';
rat(2).name = 'CSM01';
for r = 1:length(rat)
    
tmp = dir(append(rat(r).name,'*'));

for i = 1:length(tmp)
    fname = tmp(i).name(1:end-5);
    destination = tmp(i).name;
D_path = GetFullPath(destination,'auto');

        New_name=split(fname,'_');
        New_name=char(New_name(2));
tmpname = split(New_name,'-');
foldername = append(tmpname(2),tmpname(3),tmpname(1));
cd ..
cd('BEHAVDATA')
if isfolder(foldername)
    cd(char(foldername))
    tmpdir = dir(append(rat(r).name(1:3),'*.csv'));
    S_path = GetFullPath(tmpdir(1).name,'auto');
    tmpdir(1).name(4)='0';
    revised_name = tmpdir(1).name;
    D_path = append(D_path,'\',revised_name);
    copyfile(S_path,D_path)
    clear D_path
end
cd .. % to BEHAVDATA level
cd ..
cd('EPHYSDATA')
end
end