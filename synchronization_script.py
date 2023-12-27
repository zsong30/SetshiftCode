def adjust_oe_ts(oe_data_file = 'text.npy',pyb_data_file = 'poke_timestamps.txt'):
    fp1 = open(oe_data_file,'r')
    fp2 = open(pyb_data_file,'r')
    oe_comp = fp1.readlines()
    behav_comp = fp2.readlines()
    oe_ts = []
    behav_ts = []
    for i in range(len(oe_comp)):
        oe_ts.append(float(oe_comp[i]))
    for j in range(len(behav_comp)):
        behav_ts.append(float(behav_comp[j]))
    differences = []
    if len(oe_ts) == len(behav_ts):
        print("Same number of timestamps")
        for o in range(len(oe_comp)):
            differences.append(behav_ts[o] - oe_ts[o])
        #print(differences)
    adjusted_oe_ts = []
    for p in range(len(oe_ts)):
        adjusted_oe_ts.append(oe_ts[p] - differences[p])
    return adjusted_oe_ts
