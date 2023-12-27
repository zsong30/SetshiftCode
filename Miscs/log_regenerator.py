# -*- coding: utf-8 -*-
"""
Created on Wed Jul  6 15:48:53 2022

@author: Eric Hoskins
"""

import os

def regenerate_log(startdate, enddate):
    '''
    Purpose: To recreate entries for the set-shift log by reading the copied .csvs because you forgot to save the Word document and there was a power outage.
    Parameters: Startdate and enddate in the format of 'MMDDYYYY' the '' is important.
    Return Value: None, but prints the missing log entires to console so you can copy and paste the days you need from there.
    '''
    startdate = str(startdate)
    enddate = str(enddate)
    missing_log = ""
    os.chdir(r'C:\Users\Tnel-DATA2\Documents\GS4-raw\Eric - Set-shift\Copied') #edit this line to change the path to wherever the files for the unlogged days are located.
    copied_dir = os.listdir()
    cleaned_dir = []
    for x in range(len(copied_dir)):
        cleaned_dir += copied_dir[x].split(',')
    cleaned_dir2 = []
    for i in range(len(cleaned_dir)):
        if '.' not in cleaned_dir[i]:
            entry = str(cleaned_dir[i])
            cleaned_dir2.append(entry)
    for file in cleaned_dir2:
        if int(file[4 : 9]) <= int(enddate[4 : 9]) and int(startdate[4 : 9]) <= int(file[4 : 9]) and int(file[0 : 2]) <= int(enddate[0 : 2]) and int(startdate[0 : 2]) <= int(file[0 : 2]):
            missing_log += '(' + file[0 : 2] + '/' + file[2 : 4] + '/' + file[4 : 9] + ')' + '\n'
            os.chdir(r'C:\Users\Tnel-DATA2\Documents\GS4-raw\Eric - Set-shift\Copied' + '\\' + file) #edit this line to change the path to wherever the files for the unlogged days are located.
            sub_dir = os.listdir()
            sub_csvs = []
            for x in range(len(sub_dir)):
                if '.csv' in sub_dir[x]:
                    sub_csvs.append(sub_dir[x])
            for csv in sub_csvs:
                fp = open(csv)
                data = fp.readlines()
                for line in range(len(data)):
                    data[line] = data[line].strip()
                    data[line] = data[line].split(',')
                rat_name = data[0][5]
                protocol = data[1][5]
                protocol = 'P' + protocol[8 :]
                raw_time = float(data[-1][1])
                hours = int(raw_time // 3600)
                minutes = int((raw_time % 3600) // 60)
                seconds = int(raw_time % 60)
                if raw_time > 5399:
                    missing_log += rat_name + ": " + protocol + ': Did not finish.\n'
                elif hours != 0:
                    missing_log += rat_name + ': ' + protocol + ': Completed in ' + str(hours) + ' hours, ' + str(minutes) + ' minutes, and ' + str(seconds) + ' seconds.\n'
                else:
                    missing_log += rat_name + ': ' + protocol + ': Completed in ' + str(minutes) + ' minutes and ' + str(seconds) + ' seconds.\n'
            missing_log += '\n'
    print(missing_log)        
    return
