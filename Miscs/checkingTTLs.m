

epath =   'F:\CSM01\CSM01_2021-04-30_11-09-47_SS\Record Node 101\experiment1\recording1\structure.oebin';

RawData1=load_open_ephys_binary(epath, 'continuous',1,'mmap');

TSdata = RawData1.Data.Data.mapped(65,(1:30000*120));

TSdata = TSdata';
figure,plot(TSdata)

find((TSdata>20000),1,'last')-find((TSdata>20000),1,'first')


TSdata(1:10)



TSdata = load_open_ephys_binary(epath, 'events',1);
EVtimestamps = double(TSdata.Timestamps); % in samples