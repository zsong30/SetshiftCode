
rat = struct;
rat(1).name = 'CSF01'; tmprat(1).name = 'CSFO1'; rat(1).sex = 'female';
rat(2).name = 'CSM01'; tmprat(2).name = 'CSMO1'; rat(2).sex = 'male';

rat(3).name = 'CSF02'; tmprat(3).name = 'CSFO2'; rat(3).sex = 'female';
rat(4).name = 'CSF03'; tmprat(4).name = 'CSFO3'; rat(4).sex = 'female';
rat(5).name = 'CSF04'; tmprat(5).name = 'CSFO4'; rat(5).sex = 'female';

% assuming you are in the BEHAVDATA folder
for rt = 1:length(rat)
    fprintf('Working on rat %s\n',rat(rt).name)
    tmpsetshift=struct;tmpthissetshift=struct;
    tmpdir = dir; count = 0;
    for i = 3:length(tmpdir) % to run from beginning, change i to 3;
        
        if tmpdir(i).isdir
            cd(tmpdir(i).name) % cd into a specific date folder
            if isempty(tmprat(rt).name) % if the rat does not have 'other' names
                tmpsetshiftfn = dir(append(rat(rt).name,'*.csv'));
            else
                tmpsetshiftfn = cat(1,dir(append(rat(rt).name,'*.csv')),dir(append(tmprat(rt).name,'*.csv')));
            end
            if ~isempty(tmpsetshiftfn)
                logfn = tmpsetshiftfn(end).name;
                tmpthissetshift = read_set_shift_behavior_one_file_only(logfn);
                if length(tmpsetshiftfn) >1
                    fprintf('\twarning, there are more than one session for rat %s on day %s\n',rat(rt).name,tmpdir(i).name)
                end
            end
            
            cd ..
        end
        
        if isfield(tmpthissetshift,'rules')
            if count == 0
                tmpsetshift = tmpthissetshift;
                count = count +1;
                fprintf('\tdays included so far: %d\n',count)
            else
                if ~strcmp(tmpsetshift(end).testdate,tmpthissetshift.testdate)
                    tmpsetshift = cat(1,tmpsetshift,tmpthissetshift);
                    count = count + 1;
                    fprintf('\tdays included so far: %d\n',count)
                end
            end
            
        end
        
    end
    rat(rt).setshift = tmpsetshift;
end

