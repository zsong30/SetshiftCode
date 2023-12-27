
rat = struct;
rat(1).name = 'CSF01';
%rat(2).name = 'CSM01';



% assuming you are in the BEHAVDATA folder

csf01setshift=struct;
tmpdir = dir; count = 0;
for i = 3:length(tmpdir)
    if tmpdir(i).isdir
        cd(tmpdir(i).name)
        csf01fn = cat(1,dir('CSF01*.csv'),dir('CSFO1*.csv'));
        %csf02fn = cat(1,dir('CSF02*.csv'),dir('CSFO2*.csv'));
        if ~isempty(csf01fn)
            logfn = csf01fn(1).name;
            csf01thissetshift = read_set_shift_data_one_file_only(logfn);
            if length(csf01fn) >1
                sprintf('warning, there are more than one session for csf01 on day %s',tmpdir(i).name)
            end
        end
        cd ..
    else
        
    end
    
%     if ~isfield(csf01setshift,'protocolname')
%         csf01setshift = csf01thissetshift;
    if contains(csf01thissetshift.protocolname,'protocol')
        if count == 0
            csf01setshift = csf01thissetshift;
            count = count +1;
        else
        csf01setshift = cat(1,csf01setshift,csf01thissetshift);
        count = count + 1;
        end
        
    end
tprintf('days included so far %d',count)
end

rat(1).setshift = csf01setshift;



