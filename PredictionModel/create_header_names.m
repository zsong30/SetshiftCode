

region = {'PL','ST'};
dataType = {'DM','LN'};
frqband = {'theta','beta','gamma'};
clstcounts = 38;
unitcounts_reg1 = 144;
unitcounts_reg2 = 86;


header_names = {};
for reg = 1:2


    if reg == 1
        unitcounts = unitcounts_reg1;
    elseif reg ==2
        unitcounts = unitcounts_reg2;
    end


    for typ = 1:2

        for unt = 1:unitcounts

            % header_names{2*unitcounts*(reg-1)+unitcounts*(typ-1)+unt}= sprintf('%s_%s_SR_unit_%d',region{reg},dataType{typ},unt); %#ok<SAGROW>
            header_names{end+1}= sprintf('%s_%s_SR_unit_%d',region{reg},dataType{typ},unt); %#ok<SAGROW>

        end
    end
end

tmplen= length(header_names);




for reg = 1:2
    for typ = 1:2
        for frb = 1:3
            for cl = 1:clstcounts

                header_names{tmplen+2*3*clstcounts*(reg-1)+3*clstcounts*(typ-1)+clstcounts*(frb-1)+cl}= sprintf('%s_%s_%sP_clust_%d',region{reg},dataType{typ},frqband{frb},cl); %#ok<SAGROW>

            end
        end
    end
end


header_names{end+1} = 'Performance';
header_names{end+1} = 'Response_latency';
save(fullfile('z:\projmon\ericsprojects\Setshift\DATA\PredictionModel','allinclusivetable_header_names'),'header_names','-v7.3')