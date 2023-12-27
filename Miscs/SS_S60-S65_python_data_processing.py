
import csv
import glob
import os
import pandas as pd
import numpy as np
os.chdir("Z:\My Drive\Data and analysis\Raw\S60-S65\Pre_processed")
#Set_shifting = pd.read_csv("A_umn6_2.txt", delimiter="\t")
Set_shifting = pd.read_csv("S60-S65_Session16.csv")
subjects_list = Set_shifting.Subject.unique()
number_subjects = len(subjects_list)
#Set_shifting["Session"] = 7
cols = list(Set_shifting.columns.values)
Set_shifting.Subject.unique()

Set_shifting = Set_shifting[['Project',
 'UserID',
 'Protocol',
 'Session',
 'Station',
 'Run',
 'Subject',
 'Time',
 'Current State',
 'Transition State',
 'Transition Event',
 'A1 - Rear NP',
 'A2 - Front NP',
 'A3 - MIddle NP',
 'A4 - ',
 'A[1] Rear',
 'A[2] Front',
 'A[3] MIddle NP',
 'A[4] ']]


Set_shifting["Time_in_sec"] = Set_shifting["Time"]  # new column transforming graphicstate unities in seconds
Set_shifting["RTmask"] = Set_shifting["Time_in_sec"].diff() # new column which subtract rows values from previous row

Set_shifting["Protocol"] = Set_shifting["Protocol"].astype("category")
Set_shifting["Session"] = Set_shifting["Session"].astype("category")
Set_shifting["Station"] = Set_shifting["Station"].astype("category")
Set_shifting["Run"] = Set_shifting["Run"].astype("category")
Set_shifting["Project"] = Set_shifting["Project"].astype("category")
Set_shifting["UserID"] = Set_shifting["UserID"].astype("category")
Set_shifting["Subject"] = Set_shifting["Subject"].astype("category")
# Set_shifting["Current State"] = Set_shifting["Current State"].astype("category")
# Set_shifting["A1 - Rear NP"] = Set_shifting["A1 - Rear NP"].astype("category") # IF going to sum, average, etc, do not change to category
# Set_shifting["A2 - Front NP"] = Set_shifting["A2 - Front NP"].astype("category")
# Set_shifting["A3 - MIddle NP"] = Set_shifting["A3 - MIddle NP"].astype("category")
# Set_shifting["A4 - "] = Set_shifting["A4 - "].astype("category")
Set_shifting["A[1] Rear"] = Set_shifting["A[1] Rear"].astype("category")
Set_shifting["A[2] Front"] = Set_shifting["A[2] Front"].astype("category")
Set_shifting["A[3] MIddle NP"] = Set_shifting["A[3] MIddle NP"].astype("category")
Set_shifting["A[4] "] = Set_shifting["A[4] "].astype("category")

ProtocolN = Set_shifting["Protocol"].iloc[0] # define that the first value on the Protocol column will be the variable ProtocolN
if ProtocolN == 44: #check if the protocol number is 82 or 83 and classify the tasks accordinly
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(51, 82)),
        (Set_shifting["Current State"].between(83, 113)),
        (Set_shifting["Current State"].between(114, 144)),
        (Set_shifting["Current State"].between(145, 175)),
        (Set_shifting["Current State"].between(176, 206)),
        (Set_shifting["Current State"].between(207, 237)),
        (Set_shifting["Current State"].between(238, 268)),
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = ["Rand1", "Side1", "Light1", "Side2", "Light2", "Side3", "Light3", "Side4", "Light4", "Rand2"]
    Set_shifting["TaskID"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
elif ProtocolN == 45:
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(51, 82)), #Side3
        (Set_shifting["Current State"].between(83, 113)), #Light4
        (Set_shifting["Current State"].between(114, 144)), #Side4
        (Set_shifting["Current State"].between(145, 175)),#Light
        (Set_shifting["Current State"].between(176, 206)), #Side1
        (Set_shifting["Current State"].between(207, 237)), #Light2
        (Set_shifting["Current State"].between(238, 268)), #Side2
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = ["Rand1", "Side3", "Light4", "Side4", "Light1", "Side1", "Light2", "Side2", "Light3", "Rand2"]
    Set_shifting["TaskID"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
elif ProtocolN == 46:
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(51, 82)), #Side2
        (Set_shifting["Current State"].between(83, 113)), #Light2
        (Set_shifting["Current State"].between(114, 144)), #Side3
        (Set_shifting["Current State"].between(145, 175)), #Light3
        (Set_shifting["Current State"].between(176, 206)), #Side4
        (Set_shifting["Current State"].between(207, 237)), #Light4
        (Set_shifting["Current State"].between(238, 268)), #Side1
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = ["Rand1", "Side2", "Light2", "Side3", "Light3", "Side4", "Light4", "Side1", "Light1", "Rand2"]
    Set_shifting["TaskID"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
else:
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(51, 82)), #Side4
        (Set_shifting["Current State"].between(83, 113)), #Light1
        (Set_shifting["Current State"].between(114, 144)), #Side1
        (Set_shifting["Current State"].between(145, 175)), #Light2
        (Set_shifting["Current State"].between(176, 206)), #Side2
        (Set_shifting["Current State"].between(207, 237)), #Light3
        (Set_shifting["Current State"].between(238, 268)), #Side3
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = ["Rand1", "Side4", "Light1", "Side1", "Light2", "Side2", "Light3", "Side3", "Light4", "Rand2"]
    Set_shifting["TaskID"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
    
conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(51, 82)),
        (Set_shifting["Current State"].between(83, 113)),
        (Set_shifting["Current State"].between(114, 144)),
        (Set_shifting["Current State"].between(145, 175)),
        (Set_shifting["Current State"].between(176, 206)),
        (Set_shifting["Current State"].between(207, 237)),
        (Set_shifting["Current State"].between(238, 268)),
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
choices = ["Random", "Side", "Light", "Side", "Light", "Side", "Light", "Side", "Light", "Random"]
Set_shifting["Task_Type"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
 
    
if ProtocolN == 44: #check if the protocol number is 44,45,46,47 and classify the tasks accordinly
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(51, 82)),
        (Set_shifting["Current State"].between(83, 113)),
        (Set_shifting["Current State"].between(114, 144)),
        (Set_shifting["Current State"].between(145, 175)),
        (Set_shifting["Current State"].between(176, 206)),
        (Set_shifting["Current State"].between(207, 237)),
        (Set_shifting["Current State"].between(238, 268)),
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    Set_shifting["Task_Order"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
elif ProtocolN == 45:
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(145, 175)),#Light
        (Set_shifting["Current State"].between(176, 206)), #Side1
        (Set_shifting["Current State"].between(207, 237)), #Light2
        (Set_shifting["Current State"].between(238, 268)), #Side2
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(51, 82)), #Side3
        (Set_shifting["Current State"].between(83, 113)), #Light4
        (Set_shifting["Current State"].between(114, 144)), #Side4
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    Set_shifting["Task_Order"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
elif ProtocolN == 46:
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(238, 268)), #Side1
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(51, 82)), #Side2
        (Set_shifting["Current State"].between(83, 113)), #Light2
        (Set_shifting["Current State"].between(114, 144)), #Side3
        (Set_shifting["Current State"].between(145, 175)), #Light3
        (Set_shifting["Current State"].between(176, 206)), #Side4
        (Set_shifting["Current State"].between(207, 237)), #Light4
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    Set_shifting["Task_Order"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
else:
    conditions = [
        (Set_shifting["Current State"] < 51),
        (Set_shifting["Current State"].between(51, 82)), #Side4
        (Set_shifting["Current State"].between(83, 113)), #Light1
        (Set_shifting["Current State"].between(114, 144)), #Side1
        (Set_shifting["Current State"].between(145, 175)), #Light2
        (Set_shifting["Current State"].between(176, 206)), #Side2
        (Set_shifting["Current State"].between(207, 237)), #Light3
        (Set_shifting["Current State"].between(238, 268)), #Side3
        (Set_shifting["Current State"].between(295, 324)) | (Set_shifting["Current State"] == 269),
        (Set_shifting["Current State"].between(270, 295)) | (Set_shifting["Current State"] == 325)]
    choices = [1, 9, 2, 3, 4, 5, 6, 7, 8, 10]
    Set_shifting["Task_Order"] = np.select(conditions, choices, default = "black") # the np.,select function allows conditional formating
  
    
trial1 = [54, 86, 117, 148, 179, 210, 241, 297]
trial2 = [61, 92, 123, 154, 185, 216, 247, 303]
trial3 = [67, 98, 129, 160, 191, 222, 253, 309]
trial4 = [73, 104, 135, 166, 197, 228, 259, 315]
trial5 = [79 , 110, 141, 172, 203, 234, 265, 321]

def trial_number(row):
    ID = row["Current State"]
    
    if ID in trial1:
        return 1
    elif ID in trial2:
        return 2
    elif ID in trial3:
        return 3
    elif ID in trial4:
        return 4
    elif ID in trial5:
        return 5
    else:
        return 0
    
Set_shifting["Trial_ID"] = Set_shifting.apply(trial_number, axis = "columns")
Set_shifting.apply(trial_number, axis = "columns")

np_regressive = [79, 110, 141, 172, 203, 234, 265, 321]
np_perseverative = [54, 86, 117, 148, 179, 210, 241, 297]
np_other = [61, 92, 123, 154, 185, 216, 247, 303, 67, 98, 129, 160, 191, 222, 253, 309, 73, 104, 135, 166, 197, 228, 259, 315]
 
def trial_perse(row):
     ID = row["Current State"]
     
     if ID in np_regressive:
         return 10000
     elif ID in np_perseverative:
         return 1
     elif ID in np_other:
         return 100
     else:
         return 0
    
Set_shifting["perseverative_or_regressive"] = Set_shifting.apply(trial_perse, axis = "columns")
Set_shifting.apply(trial_perse, axis = "columns")


#light position
if ProtocolN == 44:
    rear = [61, 73, 79, 92, 110, 117, 129, 141, 148, 166, 172, 191, 197, 222, 234, 241, 253, 297, 315, 321]
    front = [54, 67, 86, 98, 104, 123, 135, 154, 160, 179, 185, 203, 210, 216, 228, 247, 259, 265, 303, 309]

if ProtocolN == 45:
    rear = [148, 166, 172, 191, 197, 222, 234, 241, 253, 297, 315, 321, 61, 73, 79, 92, 110, 117, 129, 141]
    front = [154, 160, 179, 185, 203, 210, 216, 228, 247, 259, 265, 303, 309, 54, 67, 86, 98, 104, 123, 135]
    
if ProtocolN == 46:
    rear = [241, 253, 297, 315, 321, 61, 73, 79, 92, 110, 117, 129, 141, 148, 166, 172, 191, 197, 222, 234]
    front = [247, 259, 265, 303, 309, 54, 67, 86, 98, 104, 123, 135, 154, 160, 179, 185, 203, 210, 216, 228]
    
if ProtocolN == 47:
    rear = [92, 110, 117, 129, 141, 148, 166, 172, 191, 197, 222, 234, 241, 253, 297, 315, 321, 61, 73, 79]
    front = [86, 98, 104, 123, 135, 154, 160, 179, 185, 203, 210, 216, 228, 247, 259, 265, 303, 309, 54, 67]    


def light_position(row):
    ID = row["Transition State"]
    ID_for_omission = row["Current State"]
    
    if ID in rear:
        return "rear"
    elif ID in front: 
        return  "front"
    else:
        return ""
    
    
Set_shifting["Light_Position"] = Set_shifting.apply(light_position, axis = "columns")    
Set_shifting.apply(light_position, axis = "columns")

#Sequence of trials
if ProtocolN == 44:
    sequence_of_trial = [54, 61, 67, 73, 79, 86, 92, 98, 104, 110, 117, 123, 129, 135, 141, 148, 154, 
                         160, 166, 172, 179, 185, 191, 197, 203, 210, 216, 222, 228, 234, 241, 247, 253, 
                         259, 265, 297, 303, 309, 315, 321]
if ProtocolN == 45:
    sequence_of_trial = [148, 154, 160, 166, 172, 179, 185, 191, 197, 203, 210, 216, 222, 228, 234,
                         241, 247, 253, 259, 265, 297, 303, 309, 315, 321, 54, 61, 67, 73, 79, 86, 92, 98,
                         104, 110, 117, 123, 129, 135, 141]
if ProtocolN == 46:
    sequence_of_trial = [241, 247, 253, 259, 265, 297, 303, 309, 315, 321, 54, 61, 67, 73, 79, 86,
                         92, 98, 104, 110, 117, 123, 129, 135, 141, 148, 154, 160, 166, 172, 179, 185, 191,
                         197, 203, 210, 216, 222, 228, 234]

if ProtocolN == 47:
    sequence_of_trial = [86, 92, 98, 104, 110, 117, 123, 129, 135, 141, 148, 154, 160, 166, 172, 179,
                         185, 191, 197, 203, 210, 216, 222, 228, 234, 241, 247, 253, 259, 265, 297, 303,
                         309, 315, 321, 54, 61, 67, 73, 79]
      
    
    
    
    
def sequence(row):
    ID = row["Transition State"]
    ID_for_omission = row["Current State"]
    
    if ID in sequence_of_trial:
        return (sequence_of_trial.index(ID)+1)
    else:
        return ""
    
    
Set_shifting["Sequence"] = Set_shifting.apply(sequence, axis = "columns")    
Set_shifting.apply(sequence, axis = "columns")
    











if "S60" in Set_shifting["Subject"].values:
    S60 = Set_shifting[Set_shifting["Subject"] == "S60"]
    S60.iat[0,20] = 0
    Subject_S60 = Set_shifting["Subject"] == "S60"

if "S61" in Set_shifting["Subject"].values:
    S61 = Set_shifting[Set_shifting["Subject"] == "S61"]
    S61.iat[0,20] = 0
    Subject_S61 = Set_shifting["Subject"] == "S61"

if "S62" in Set_shifting["Subject"].values:
    S62 = Set_shifting[Set_shifting["Subject"] == "S62"]
    S62.iat[0,20] = 0
    Subject_S62 = Set_shifting["Subject"] == "S62"

if "S63" in Set_shifting["Subject"].values:
    S63 = Set_shifting[Set_shifting["Subject"] == "S63"]
    S63.iat[0,20] = 0
    Subject_S63 = Set_shifting["Subject"] == "S63"

if "S64" in Set_shifting["Subject"].values:
    S64 = Set_shifting[Set_shifting["Subject"] == "S64"]
    S64.iat[0,20] = 0
    Subject_S64 = Set_shifting["Subject"] == "S64"

if "S65" in Set_shifting["Subject"].values:
    S65 = Set_shifting[Set_shifting["Subject"] == "S65"]
    S65.iat[0,20] = 0
    Subject_S65 = Set_shifting["Subject"] == "S65"

if "S58" in Set_shifting["Subject"].values:
    S58 = Set_shifting[Set_shifting["Subject"] == "S58"]
    S58.iat[0,20] = 0
    Subject_S58 = Set_shifting["Subject"] == "S58"
    
if "S59" in Set_shifting["Subject"].values:
    S59 = Set_shifting[Set_shifting["Subject"] == "S59"]
    S59.iat[0,20] = 0
    Subject_S59 = Set_shifting["Subject"] == "S59"
    
if "GR22" in Set_shifting["Subject"].values:
    GR22 = Set_shifting[Set_shifting["Subject"] == "GR22"]
    GR22.iat[0,20] = 0
    Subject_GR22 = Set_shifting["Subject"] == "GR22"
    
if "GR23" in Set_shifting["Subject"].values:
    GR23 = Set_shifting[Set_shifting["Subject"] == "GR23"]
    GR23.iat[0,20] = 0
    Subject_GR23 = Set_shifting["Subject"] == "GR23"

if "GR24" in Set_shifting["Subject"].values:
    GR24 = Set_shifting[Set_shifting["Subject"] == "GR24"]
    GR24.iat[0,20] = 0
    Subject_GR24 = Set_shifting["Subject"] == "GR24"

if "GR25" in Set_shifting["Subject"].values:
    GR25 = Set_shifting[Set_shifting["Subject"] == "GR25"]
    GR25.iat[0,20] = 0
    Subject_GR25 = Set_shifting["Subject"] == "GR25"
    
if ProtocolN == 44:
    Task1 = Set_shifting["Current State"] < 51
    Task2 = Set_shifting["Current State"].between(51, 82)
    Task3 = Set_shifting["Current State"].between(83, 113)
    Task4 = Set_shifting["Current State"].between(114, 144)
    Task5 = Set_shifting["Current State"].between(145, 175)
    Task6 = Set_shifting["Current State"].between(176, 206)
    Task7 = Set_shifting["Current State"].between(207, 237)
    Task8 = Set_shifting["Current State"].between(238, 268) 
    Task9 = Set_shifting["Current State"].between(295, 324) & (Set_shifting["Current State"] == 269)
    Task10 = Set_shifting["Current State"].between(270, 295) & (Set_shifting["Current State"] == 270)
elif ProtocolN == 45:
    Task1 = Set_shifting["Current State"] < 51
    Task5 = Set_shifting["Current State"].between(51, 82)
    Task6 = Set_shifting["Current State"].between(83, 113)
    Task7 = Set_shifting["Current State"].between(114, 144)
    Task8 = Set_shifting["Current State"].between(145, 175)
    Task9 = Set_shifting["Current State"].between(176, 206)
    Task2 = Set_shifting["Current State"].between(207, 237)
    Task3 = Set_shifting["Current State"].between(238, 268) 
    Task4 = Set_shifting["Current State"].between(295, 324) & (Set_shifting["Current State"] == 269)
    Task10 = Set_shifting["Current State"].between(270, 295) & (Set_shifting["Current State"] == 270)
elif ProtocolN == 46:
    Task1 = Set_shifting["Current State"] < 51
    Task8 = Set_shifting["Current State"].between(51, 82)
    Task9 = Set_shifting["Current State"].between(83, 113)
    Task2 = Set_shifting["Current State"].between(114, 144)
    Task3 = Set_shifting["Current State"].between(145, 175)
    Task4 = Set_shifting["Current State"].between(176, 206)
    Task5 = Set_shifting["Current State"].between(207, 237)
    Task6 = Set_shifting["Current State"].between(238, 268) 
    Task7 = Set_shifting["Current State"].between(295, 324) & (Set_shifting["Current State"] == 269)
    Task10 = Set_shifting["Current State"].between(270, 295) & (Set_shifting["Current State"] == 270)
elif ProtocolN == 47:
    Task1 = Set_shifting["Current State"] < 51
    Task3 = Set_shifting["Current State"].between(51, 82)
    Task4 = Set_shifting["Current State"].between(83, 113)
    Task5 = Set_shifting["Current State"].between(114, 144)
    Task6 = Set_shifting["Current State"].between(145, 175)
    Task7 = Set_shifting["Current State"].between(176, 206)
    Task8 = Set_shifting["Current State"].between(207, 237)
    Task9 = Set_shifting["Current State"].between(238, 268) 
    Task2 = Set_shifting["Current State"].between(295, 324) & (Set_shifting["Current State"] == 269)
    Task10 = Set_shifting["Current State"].between(270, 295) & (Set_shifting["Current State"] == 270)
    

#Definir os estates
npchoice = [54, 61, 67, 73, 79, 86, 92, 98, 104, 110, 117, 123, 129, 135, 141, 148, 154, 160, 166, 172, 179, 185, 191, 197, 203, 210, 216, 222, 228, 234, 241, 247, 253, 259, 265, 297, 303, 309, 315, 321]
right_choice = [55, 62, 68, 74, 80, 87, 93, 99, 105, 111, 118, 124, 130, 136, 142, 149, 155, 161, 167, 173, 180, 186, 192, 198, 204, 211, 217, 223, 229, 235, 242, 248, 254, 260, 266, 298, 304, 310, 316, 322]
error = [57, 64, 70, 76, 82, 89, 95, 101, 107, 113, 120, 126, 132, 138, 144, 151, 157, 163, 169, 175, 182, 188, 194, 200, 206, 213, 219, 225, 231, 237, 244, 250, 256, 262, 268, 300, 306, 312, 318, 324]
omission = [52, 84, 115, 146, 177, 208, 239, 295]

random1_npchoice = [3, 8, 13, 18, 23, 28, 33, 38, 43, 48]
random1_response = [4, 9, 14, 19, 24, 29, 34, 39, 44, 49]
random2_npchoice = [271, 276, 281, 286, 291]
random2_response = [272, 277, 282, 287, 292]

if ProtocolN == 44:
    npchoice_conflict = [86, 98, 104, 117, 129, 141, 148, 166, 172, 179, 185, 203, 210, 216, 228, 241, 253, 297, 315, 321]
    npchoice_NONconflict = [92, 110, 123, 135, 154, 160, 191, 197, 222, 234, 247, 259, 265, 303, 309]
    npchoice_set = [54, 61, 67, 73, 79]
elif ProtocolN == 45:
    npchoice_conflict = [54, 67, 86, 98, 104, 117, 129, 141, 179, 185, 203, 210, 216, 228, 241, 253, 297, 315, 321]
    npchoice_NONconflict = [61, 73, 79, 92, 110, 123, 135, 191, 197, 222, 234, 247, 259, 265, 303, 309]
    npchoice_set = [148, 154, 160, 166, 172]
elif ProtocolN == 46:
    npchoice_conflict = [54, 67, 86, 98, 104, 117, 129, 141, 148, 166, 172, 179, 185, 203, 210, 216, 228, 297, 315, 321]
    npchoice_NONconflict = [61, 73, 79, 92, 110, 123, 135, 154, 160, 191, 197, 222, 234, 303, 309]
    npchoice_set = [241, 247, 253, 259, 265]
elif ProtocolN == 47:
    npchoice_conflict = [54, 67, 117, 129, 141, 148, 166, 172, 179, 185, 203, 210, 216, 228, 241, 253, 297, 315, 321]
    npchoice_NONconflict = [61, 73, 79, 123, 135, 154, 160, 191, 197, 222, 234, 247, 259, 265, 303, 309]
    npchoice_set = [86, 92, 98, 104, 110]



def trial(row):
    ID = row["Transition State"]
    ID_for_omission = row["Current State"]
    
    if ID in npchoice:
        return "trial_start"
    elif ID in right_choice:
        return "correct"
    elif ID in error:
        return "incorrect"
    elif ID in omission and ID_for_omission in npchoice:
        return "omission"
    elif ID in random1_npchoice:
        return "trial_start"
    elif ID in random1_response:
        return "correct_random1"
    elif ID in random2_npchoice:
        return "trial_start"
    elif ID in random2_response:
        return "correct_random2"
    else:
        return ""
    
if "S60" in Set_shifting["Subject"].values:
    S60["Trial"] = S60.apply(trial, axis = "columns")    
    S60.apply(trial, axis = "columns")

if "S61" in Set_shifting["Subject"].values:
    S61["Trial"] = S61.apply(trial, axis = "columns")    
    S61.apply(trial, axis = "columns")

if "S62" in Set_shifting["Subject"].values:
    S62["Trial"] = S62.apply(trial, axis = "columns")    
    S62.apply(trial, axis = "columns")

if "S63" in Set_shifting["Subject"].values:
    S63["Trial"] = S63.apply(trial, axis = "columns")    
    S63.apply(trial, axis = "columns")

if "S64" in Set_shifting["Subject"].values:
    S64["Trial"] = S64.apply(trial, axis = "columns")    
    S64.apply(trial, axis = "columns")

if "S65" in Set_shifting["Subject"].values:
    S65["Trial"] = S65.apply(trial, axis = "columns")    
    S65.apply(trial, axis = "columns")

if "S58" in Set_shifting["Subject"].values:
    S58["Trial"] = S58.apply(trial, axis = "columns")    
    S58.apply(trial, axis = "columns")

if "S59" in Set_shifting["Subject"].values:
    S59["Trial"] = S59.apply(trial, axis = "columns")    
    S59.apply(trial, axis = "columns")

if "GR22" in Set_shifting["Subject"].values:
    GR22["Trial"] = GR22.apply(trial, axis = "columns")    
    GR22.apply(trial, axis = "columns")

if "GR23" in Set_shifting["Subject"].values:
    GR23["Trial"] = GR23.apply(trial, axis = "columns")    
    GR23.apply(trial, axis = "columns")

if "GR24" in Set_shifting["Subject"].values:
    GR24["Trial"] = GR24.apply(trial, axis = "columns")    
    GR24.apply(trial, axis = "columns")

if "GR25" in Set_shifting["Subject"].values:
    GR25["Trial"] = GR25.apply(trial, axis = "columns")    
    GR25.apply(trial, axis = "columns")
    
def changingpoint01(row):
    correctness = row["Trial"]
    
    
    if correctness == "correct":
        return 1
    else:
        return 0

if "S60" in Set_shifting["Subject"].values:
    S60["Changing_Point"] = S60.apply(changingpoint01, axis = "columns")    
    S60.apply(changingpoint01, axis = "columns")
    S60["Changing_Point_Cumulative"] = S60["Changing_Point"].cumsum()

if "S61" in Set_shifting["Subject"].values:
    S61["Changing_Point"] = S61.apply(changingpoint01, axis = "columns")    
    S61.apply(changingpoint01, axis = "columns")
    S61["Changing_Point_Cumulative"] = S61["Changing_Point"].cumsum()

if "S62" in Set_shifting["Subject"].values:
    S62["Changing_Point"] = S62.apply(changingpoint01, axis = "columns")    
    S62.apply(changingpoint01, axis = "columns")
    S62["Changing_Point_Cumulative"] = S62["Changing_Point"].cumsum()

if "S63" in Set_shifting["Subject"].values:
    S63["Changing_Point"] = S63.apply(changingpoint01, axis = "columns")    
    S63.apply(changingpoint01, axis = "columns")
    S63["Changing_Point_Cumulative"] = S63["Changing_Point"].cumsum()

if "S64" in Set_shifting["Subject"].values:
    S64["Changing_Point"] = S64.apply(changingpoint01, axis = "columns")    
    S64.apply(changingpoint01, axis = "columns")
    S64["Changing_Point_Cumulative"] = S64["Changing_Point"].cumsum()

if "S65" in Set_shifting["Subject"].values:
    S65["Changing_Point"] = S65.apply(changingpoint01, axis = "columns")    
    S65.apply(changingpoint01, axis = "columns")
    S65["Changing_Point_Cumulative"] = S65["Changing_Point"].cumsum()

if "S58" in Set_shifting["Subject"].values:
    S58["Changing_Point"] = S58.apply(changingpoint01, axis = "columns")    
    S58.apply(changingpoint01, axis = "columns")
    S58["Changing_Point_Cumulative"] = S58["Changing_Point"].cumsum()
    
if "S59" in Set_shifting["Subject"].values:
    S59["Changing_Point"] = S59.apply(changingpoint01, axis = "columns")    
    S59.apply(changingpoint01, axis = "columns")
    S59["Changing_Point_Cumulative"] = S59["Changing_Point"].cumsum()

if "GR22" in Set_shifting["Subject"].values:
    GR22["Changing_Point"] = GR22.apply(changingpoint01, axis = "columns")    
    GR22.apply(changingpoint01, axis = "columns")
    GR22["Changing_Point_Cumulative"] = GR22["Changing_Point"].cumsum()

if "GR23" in Set_shifting["Subject"].values:
    GR23["Changing_Point"] = GR23.apply(changingpoint01, axis = "columns")    
    GR23.apply(changingpoint01, axis = "columns")
    GR23["Changing_Point_Cumulative"] = GR23["Changing_Point"].cumsum()

if "GR24" in Set_shifting["Subject"].values:
    GR24["Changing_Point"] = GR24.apply(changingpoint01, axis = "columns")    
    GR24.apply(changingpoint01, axis = "columns")
    GR24["Changing_Point_Cumulative"] = GR24["Changing_Point"].cumsum()

if "GR25" in Set_shifting["Subject"].values:
    GR25["Changing_Point"] = GR25.apply(changingpoint01, axis = "columns")    
    GR25.apply(changingpoint01, axis = "columns")
    GR25["Changing_Point_Cumulative"] = GR25["Changing_Point"].cumsum()


def conf(row):
    ID = row["Current State"]
     
    if ID in npchoice_conflict:
         return "conf"
    elif ID in npchoice_NONconflict:
         return "non_conf"
    elif ID in npchoice_set:
         return "set"
    elif ID in random1_npchoice:
         return "random1"
    elif ID in random2_npchoice:
         return "random2"
    else:
         return ""

if "S60" in Set_shifting["Subject"].values:
    S60["Conf"] = S60.apply(conf, axis = "columns")
    S60.apply(conf, axis = "columns")
    S60["Trial"].replace("", np.nan, inplace = True)
    S60.dropna(subset = ["Trial"], inplace = True)
    S60 = S60.reset_index(drop=True)
    S60["RT"] = S60["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S60RT = S60[S60["Trial"] != "trial_start"]
    S60I = S60[S60["Trial"] == "trial_start"]
    S60I["RT"] = S60["RT"] - 7
    S60I = S60I.reset_index(drop=True)
    S60I["Trial_Number"]= range(1, len(S60I) +1)
    S60I.iloc[0,32] = S60I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S60I["Trial_ID"] = S60I["Trial_ID"].replace(0, np.nan, inplace=True)
    S60I['RT_lag'] = S60I['RT'].shift(-1)
    S60RT = S60RT.reset_index(drop=True)
    S60RT["Trial_Number"]= range(1, len(S60RT) +1)
    S60RT["cumsum"] = S60RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S60RT["Task_Order"] = S60RT["Task_Order"].astype("int")
    S60RT["cumsum"] = S60RT["cumsum"].astype("int")
    S60RT['Changing_Point_Per_Task'] = S60RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S60RT["Error_Type"] = S60RT.apply(perse, axis = "columns")
    S60RT.apply(perse, axis = "columns")
    S60all= pd.concat([S60I,S60RT]).sort_index(kind="mergesort")
    S60all["Trial_ID"] = S60all["Trial_ID"].fillna(method='bfill')
    S60all = S60all.replace(r'^s*$', np.nan, regex=True)
    S60all = S60all.fillna(method='ffill')
    S60all.iloc[0,10] = S60all.iloc[1,10] # 10 == Conf
    S60all.iloc[0,11] = S60all.iloc[1,11]
    S60all.iloc[0,13] = S60all.iloc[1,13] # 12 == Error_Type
    S60all.iloc[0,36] = S60all.iloc[1,36] # 32 == cumsum



if "S61" in Set_shifting["Subject"].values:
    S61["Conf"] = S61.apply(conf, axis = "columns")
    S61.apply(conf, axis = "columns")
    S61["Trial"].replace("", np.nan, inplace = True)
    S61.dropna(subset = ["Trial"], inplace = True)
    S61 = S61.reset_index(drop=True)
    S61["RT"] = S61["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S61RT = S61[S61["Trial"] != "trial_start"]
    S61I = S61[S61["Trial"] == "trial_start"]
    S61I["RT"] = S61["RT"] - 7
    S61I = S61I.reset_index(drop=True)
    S61I["Trial_Number"]= range(1, len(S61I) +1)
    S61I.iloc[0,32] = S61I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S61I["Trial_ID"] = S61I["Trial_ID"].replace(0, np.nan, inplace=True)
    S61I['RT_lag'] = S61I['RT'].shift(-1)
    S61RT = S61RT.reset_index(drop=True)
    S61RT["Trial_Number"]= range(1, len(S61RT) +1)
    S61RT["cumsum"] = S61RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S61RT["Task_Order"] = S61RT["Task_Order"].astype("int")
    S61RT["cumsum"] = S61RT["cumsum"].astype("int")
    S61RT['Changing_Point_Per_Task'] = S61RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S61RT["Error_Type"] = S61RT.apply(perse, axis = "columns")
    S61RT.apply(perse, axis = "columns")
    S61all= pd.concat([S61I,S61RT]).sort_index(kind="mergesort")
    S61all["Trial_ID"] = S61all["Trial_ID"].fillna(method='bfill')
    S61all = S61all.replace(r'^s*$', np.nan, regex=True)
    S61all = S61all.fillna(method='ffill')
    S61all.iloc[0,10] = S61all.iloc[1,10] # 10 == Conf
    S61all.iloc[0,11] = S61all.iloc[1,11]
    S61all.iloc[0,13] = S61all.iloc[1,13] # 12 == Error_Type
    S61all.iloc[0,36] = S61all.iloc[1,36] # 32 == cumsum


if "S62" in Set_shifting["Subject"].values:
    S62["Conf"] = S62.apply(conf, axis = "columns")
    S62.apply(conf, axis = "columns")
    S62["Trial"].replace("", np.nan, inplace = True)
    S62.dropna(subset = ["Trial"], inplace = True)
    S62 = S62.reset_index(drop=True)
    S62["RT"] = S62["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S62RT = S62[S62["Trial"] != "trial_start"]
    S62I = S62[S62["Trial"] == "trial_start"]
    S62I["RT"] = S62["RT"] - 7
    S62I = S62I.reset_index(drop=True)
    S62I["Trial_Number"]= range(1, len(S62I) +1)
    S62I.iloc[0,32] = S62I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S62I["Trial_ID"] = S62I["Trial_ID"].replace(0, np.nan, inplace=True)
    S62I['RT_lag'] = S62I['RT'].shift(-1)
    S62RT = S62RT.reset_index(drop=True)
    S62RT["Trial_Number"]= range(1, len(S62RT) +1)
    S62RT["cumsum"] = S62RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S62RT["Task_Order"] = S62RT["Task_Order"].astype("int")
    S62RT["cumsum"] = S62RT["cumsum"].astype("int")
    S62RT['Changing_Point_Per_Task'] = S62RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S62RT["Error_Type"] = S62RT.apply(perse, axis = "columns")
    S62RT.apply(perse, axis = "columns")
    S62all= pd.concat([S62I,S62RT]).sort_index(kind="mergesort")
    S62all["Trial_ID"] = S62all["Trial_ID"].fillna(method='bfill')
    S62all = S62all.replace(r'^s*$', np.nan, regex=True)
    S62all = S62all.fillna(method='ffill')
    S62all.iloc[0,10] = S62all.iloc[1,10] # 10 == Conf
    S62all.iloc[0,11] = S62all.iloc[1,11]
    S62all.iloc[0,13] = S62all.iloc[1,13] # 12 == Error_Type
    S62all.iloc[0,36] = S62all.iloc[1,36] # 32 == cumsum


if "S63" in Set_shifting["Subject"].values:
    S63["Conf"] = S63.apply(conf, axis = "columns")
    S63.apply(conf, axis = "columns")
    S63["Trial"].replace("", np.nan, inplace = True)
    S63.dropna(subset = ["Trial"], inplace = True)
    S63 = S63.reset_index(drop=True)
    S63["RT"] = S63["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S63RT = S63[S63["Trial"] != "trial_start"]
    S63I = S63[S63["Trial"] == "trial_start"]
    S63I["RT"] = S63["RT"] - 7
    S63I = S63I.reset_index(drop=True)
    S63I["Trial_Number"]= range(1, len(S63I) +1)
    S63I.iloc[0,32] = S63I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S63I["Trial_ID"] = S63I["Trial_ID"].replace(0, np.nan, inplace=True)
    S63I['RT_lag'] = S63I['RT'].shift(-1)
    S63RT = S63RT.reset_index(drop=True)
    S63RT["Trial_Number"]= range(1, len(S63RT) +1)
    S63RT["cumsum"] = S63RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S63RT["Task_Order"] = S63RT["Task_Order"].astype("int")
    S63RT["cumsum"] = S63RT["cumsum"].astype("int")
    S63RT['Changing_Point_Per_Task'] = S63RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S63RT["Error_Type"] = S63RT.apply(perse, axis = "columns")
    S63RT.apply(perse, axis = "columns")
    S63all= pd.concat([S63I,S63RT]).sort_index(kind="mergesort")
    S63all["Trial_ID"] = S63all["Trial_ID"].fillna(method='bfill')
    S63all = S63all.replace(r'^s*$', np.nan, regex=True)
    S63all = S63all.fillna(method='ffill')
    S63all.iloc[0,10] = S63all.iloc[1,10] # 10 == Conf
    S63all.iloc[0,11] = S63all.iloc[1,11]
    S63all.iloc[0,13] = S63all.iloc[1,13] # 12 == Error_Type
    S63all.iloc[0,36] = S63all.iloc[1,36] # 32 == cumsum


if "S64" in Set_shifting["Subject"].values:
    S64["Conf"] = S64.apply(conf, axis = "columns")
    S64.apply(conf, axis = "columns")
    S64["Trial"].replace("", np.nan, inplace = True)
    S64.dropna(subset = ["Trial"], inplace = True)
    S64 = S64.reset_index(drop=True)
    S64["RT"] = S64["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S64RT = S64[S64["Trial"] != "trial_start"]
    S64I = S64[S64["Trial"] == "trial_start"]
    S64I["RT"] = S64["RT"] - 7
    S64I = S64I.reset_index(drop=True)
    S64I["Trial_Number"]= range(1, len(S64I) +1)
    S64I.iloc[0,32] = S64I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S64I["Trial_ID"] = S64I["Trial_ID"].replace(0, np.nan, inplace=True)
    S64I['RT_lag'] = S64I['RT'].shift(-1)
    S64RT = S64RT.reset_index(drop=True)
    S64RT["Trial_Number"]= range(1, len(S64RT) +1)
    S64RT["cumsum"] = S64RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S64RT["Task_Order"] = S64RT["Task_Order"].astype("int")
    S64RT["cumsum"] = S64RT["cumsum"].astype("int")
    S64RT['Changing_Point_Per_Task'] = S64RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S64RT["Error_Type"] = S64RT.apply(perse, axis = "columns")
    S64RT.apply(perse, axis = "columns")
    S64all= pd.concat([S64I,S64RT]).sort_index(kind="mergesort")
    S64all["Trial_ID"] = S64all["Trial_ID"].fillna(method='bfill')
    S64all = S64all.replace(r'^s*$', np.nan, regex=True)
    S64all = S64all.fillna(method='ffill')
    S64all.iloc[0,10] = S64all.iloc[1,10] # 10 == Conf
    S64all.iloc[0,11] = S64all.iloc[1,11]
    S64all.iloc[0,13] = S64all.iloc[1,13] # 12 == Error_Type
    S64all.iloc[0,36] = S64all.iloc[1,36] # 32 == cumsum


if "S65" in Set_shifting["Subject"].values:
    S65["Conf"] = S65.apply(conf, axis = "columns")
    S65.apply(conf, axis = "columns")
    S65["Trial"].replace("", np.nan, inplace = True)
    S65.dropna(subset = ["Trial"], inplace = True)
    S65 = S65.reset_index(drop=True)
    S65["RT"] = S65["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S65RT = S65[S65["Trial"] != "trial_start"]
    S65I = S65[S65["Trial"] == "trial_start"]
    S65I["RT"] = S65["RT"] - 7
    S65I = S65I.reset_index(drop=True)
    S65I["Trial_Number"]= range(1, len(S65I) +1)
    S65I.iloc[0,32] = S65I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S65I["Trial_ID"] = S65I["Trial_ID"].replace(0, np.nan, inplace=True)
    S65I['RT_lag'] = S65I['RT'].shift(-1)
    S65RT = S65RT.reset_index(drop=True)
    S65RT["Trial_Number"]= range(1, len(S65RT) +1)
    S65RT["cumsum"] = S65RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S65RT["Task_Order"] = S65RT["Task_Order"].astype("int")
    S65RT["cumsum"] = S65RT["cumsum"].astype("int")
    S65RT['Changing_Point_Per_Task'] = S65RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S65RT["Error_Type"] = S65RT.apply(perse, axis = "columns")
    S65RT.apply(perse, axis = "columns")
    S65all= pd.concat([S65I,S65RT]).sort_index(kind="mergesort")
    S65all["Trial_ID"] = S65all["Trial_ID"].fillna(method='bfill')
    S65all = S65all.replace(r'^s*$', np.nan, regex=True)
    S65all = S65all.fillna(method='ffill')
    S65all.iloc[0,10] = S65all.iloc[1,10] # 10 == Conf
    S65all.iloc[0,11] = S65all.iloc[1,11]
    S65all.iloc[0,13] = S65all.iloc[1,13] # 12 == Error_Type
    S65all.iloc[0,36] = S65all.iloc[1,36] # 32 == cumsum


if "S58" in Set_shifting["Subject"].values:
    S58["Conf"] = S58.apply(conf, axis = "columns")
    S58.apply(conf, axis = "columns")
    S58["Trial"].replace("", np.nan, inplace = True)
    S58.dropna(subset = ["Trial"], inplace = True)
    S58 = S58.reset_index(drop=True)
    S58["RT"] = S58["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S58RT = S58[S58["Trial"] != "trial_start"]
    S58I = S58[S58["Trial"] == "trial_start"]
    S58I["RT"] = S58["RT"] - 7
    S58I = S58I.reset_index(drop=True)
    S58I["Trial_Number"]= range(1, len(S58I) +1)
    S58I.iloc[0,32] = S58I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S58I["Trial_ID"] = S58I["Trial_ID"].replace(0, np.nan, inplace=True)
    S58I['RT_lag'] = S58I['RT'].shift(-1)
    S58RT = S58RT.reset_index(drop=True)
    S58RT["Trial_Number"]= range(1, len(S58RT) +1)
    S58RT["cumsum"] = S58RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S58RT["Task_Order"] = S58RT["Task_Order"].astype("int")
    S58RT["cumsum"] = S58RT["cumsum"].astype("int")
    S58RT['Changing_Point_Per_Task'] = S58RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S58RT["Error_Type"] = S58RT.apply(perse, axis = "columns")
    S58RT.apply(perse, axis = "columns")
    S58all= pd.concat([S58I,S58RT]).sort_index(kind="mergesort")
    S58all["Trial_ID"] = S58all["Trial_ID"].fillna(method='bfill')
    S58all = S58all.replace(r'^s*$', np.nan, regex=True)
    S58all = S58all.fillna(method='ffill')
    S58all.iloc[0,10] = S58all.iloc[1,10] # 10 == Conf
    S58all.iloc[0,11] = S58all.iloc[1,11]
    S58all.iloc[0,13] = S58all.iloc[1,13] # 12 == Error_Type
    S58all.iloc[0,36] = S58all.iloc[1,36] # 32 == cumsum


if "S59" in Set_shifting["Subject"].values:
    S59["Conf"] = S59.apply(conf, axis = "columns")
    S59.apply(conf, axis = "columns")
    S59["Trial"].replace("", np.nan, inplace = True)
    S59.dropna(subset = ["Trial"], inplace = True)
    S59 = S59.reset_index(drop=True)
    S59["RT"] = S59["Time_in_sec"].diff() # new column which subtract rows values from previous row
    S59RT = S59[S59["Trial"] != "trial_start"]
    S59I = S59[S59["Trial"] == "trial_start"]
    S59I["RT"] = S59["RT"] - 7
    S59I = S59I.reset_index(drop=True)
    S59I["Trial_Number"]= range(1, len(S59I) +1)
    S59I.iloc[0,32] = S59I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    S59I["Trial_ID"] = S59I["Trial_ID"].replace(0, np.nan, inplace=True)
    S59I['RT_lag'] = S59I['RT'].shift(-1)
    S59RT = S59RT.reset_index(drop=True)
    S59RT["Trial_Number"]= range(1, len(S59RT) +1)
    S59RT["cumsum"] = S59RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    S59RT["Task_Order"] = S59RT["Task_Order"].astype("int")
    S59RT["cumsum"] = S59RT["cumsum"].astype("int")
    S59RT['Changing_Point_Per_Task'] = S59RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    S59RT["Error_Type"] = S59RT.apply(perse, axis = "columns")
    S59RT.apply(perse, axis = "columns")
    S59all= pd.concat([S59I,S59RT]).sort_index(kind="mergesort")
    S59all["Trial_ID"] = S59all["Trial_ID"].fillna(method='bfill')
    S59all = S59all.replace(r'^s*$', np.nan, regex=True)
    S59all = S59all.fillna(method='ffill')
    S59all.iloc[0,10] = S59all.iloc[1,10] # 10 == Conf
    S59all.iloc[0,11] = S59all.iloc[1,11]
    S59all.iloc[0,13] = S59all.iloc[1,13] # 12 == Error_Type
    S59all.iloc[0,36] = S59all.iloc[1,36] # 32 == cumsum


if "GR22" in Set_shifting["Subject"].values:
    GR22["Conf"] = GR22.apply(conf, axis = "columns")
    GR22.apply(conf, axis = "columns")
    GR22["Trial"].replace("", np.nan, inplace = True)
    GR22.dropna(subset = ["Trial"], inplace = True)
    GR22 = GR22.reset_index(drop=True)
    GR22["RT"] = GR22["Time_in_sec"].diff() # new column which subtract rows values from previous row
    GR22RT = GR22[GR22["Trial"] != "trial_start"]
    GR22I = GR22[GR22["Trial"] == "trial_start"]
    GR22I["RT"] = GR22["RT"] - 7
    GR22I = GR22I.reset_index(drop=True)
    GR22I["Trial_Number"]= range(1, len(GR22I) +1)
    GR22I.iloc[0,32] = GR22I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    GR22I["Trial_ID"] = GR22I["Trial_ID"].replace(0, np.nan, inplace=True)
    GR22I['RT_lag'] = GR22I['RT'].shift(-1)
    GR22RT = GR22RT.reset_index(drop=True)
    GR22RT["Trial_Number"]= range(1, len(GR22RT) +1)
    GR22RT["cumsum"] = GR22RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    GR22RT["Task_Order"] = GR22RT["Task_Order"].astype("int")
    GR22RT["cumsum"] = GR22RT["cumsum"].astype("int")
    GR22RT['Changing_Point_Per_Task'] = GR22RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    GR22RT["Error_Type"] = GR22RT.apply(perse, axis = "columns")
    GR22RT.apply(perse, axis = "columns")
    GR22all= pd.concat([GR22I,GR22RT]).sort_index(kind="mergesort")
    GR22all["Trial_ID"] = GR22all["Trial_ID"].fillna(method='bfill')
    GR22all = GR22all.replace(r'^s*$', np.nan, regex=True)
    GR22all = GR22all.fillna(method='ffill')
    GR22all.iloc[0,10] = GR22all.iloc[1,10] # 10 == Conf
    GR22all.iloc[0,11] = GR22all.iloc[1,11]
    GR22all.iloc[0,13] = GR22all.iloc[1,13] # 12 == Error_Type
    GR22all.iloc[0,36] = GR22all.iloc[1,36] # 32 == cumsum


if "GR23" in Set_shifting["Subject"].values:
    GR23["Conf"] = GR23.apply(conf, axis = "columns")
    GR23.apply(conf, axis = "columns")
    GR23["Trial"].replace("", np.nan, inplace = True)
    GR23.dropna(subset = ["Trial"], inplace = True)
    GR23 = GR23.reset_index(drop=True)
    GR23["RT"] = GR23["Time_in_sec"].diff() # new column which subtract rows values from previous row
    GR23RT = GR23[GR23["Trial"] != "trial_start"]
    GR23I = GR23[GR23["Trial"] == "trial_start"]
    GR23I["RT"] = GR23["RT"] - 7
    GR23I = GR23I.reset_index(drop=True)
    GR23I["Trial_Number"]= range(1, len(GR23I) +1)
    GR23I.iloc[0,32] = GR23I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    GR23I["Trial_ID"] = GR23I["Trial_ID"].replace(0, np.nan, inplace=True)
    GR23I['RT_lag'] = GR23I['RT'].shift(-1)
    GR23RT = GR23RT.reset_index(drop=True)
    GR23RT["Trial_Number"]= range(1, len(GR23RT) +1)
    GR23RT["cumsum"] = GR23RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    GR23RT["Task_Order"] = GR23RT["Task_Order"].astype("int")
    GR23RT["cumsum"] = GR23RT["cumsum"].astype("int")
    GR23RT['Changing_Point_Per_Task'] = GR23RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    GR23RT["Error_Type"] = GR23RT.apply(perse, axis = "columns")
    GR23RT.apply(perse, axis = "columns")
    GR23all= pd.concat([GR23I,GR23RT]).sort_index(kind="mergesort")
    GR23all["Trial_ID"] = GR23all["Trial_ID"].fillna(method='bfill')
    GR23all = GR23all.replace(r'^s*$', np.nan, regex=True)
    GR23all = GR23all.fillna(method='ffill')
    GR23all.iloc[0,10] = GR23all.iloc[1,10] # 10 == Conf
    GR23all.iloc[0,11] = GR23all.iloc[1,11]
    GR23all.iloc[0,13] = GR23all.iloc[1,13] # 12 == Error_Type
    GR23all.iloc[0,36] = GR23all.iloc[1,36] # 32 == cumsum


if "GR24" in Set_shifting["Subject"].values:
    GR24["Conf"] = GR24.apply(conf, axis = "columns")
    GR24.apply(conf, axis = "columns")
    GR24["Trial"].replace("", np.nan, inplace = True)
    GR24.dropna(subset = ["Trial"], inplace = True)
    GR24 = GR24.reset_index(drop=True)
    GR24["RT"] = GR24["Time_in_sec"].diff() # new column which subtract rows values from previous row
    GR24RT = GR24[GR24["Trial"] != "trial_start"]
    GR24I = GR24[GR24["Trial"] == "trial_start"]
    GR24I["RT"] = GR24["RT"] - 7
    GR24I = GR24I.reset_index(drop=True)
    GR24I["Trial_Number"]= range(1, len(GR24I) +1)
    GR24I.iloc[0,32] = GR24I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    GR24I["Trial_ID"] = GR24I["Trial_ID"].replace(0, np.nan, inplace=True)
    GR24I['RT_lag'] = GR24I['RT'].shift(-1)
    GR24RT = GR24RT.reset_index(drop=True)
    GR24RT["Trial_Number"]= range(1, len(GR24RT) +1)
    GR24RT["cumsum"] = GR24RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    GR24RT["Task_Order"] = GR24RT["Task_Order"].astype("int")
    GR24RT["cumsum"] = GR24RT["cumsum"].astype("int")
    GR24RT['Changing_Point_Per_Task'] = GR24RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    GR24RT["Error_Type"] = GR24RT.apply(perse, axis = "columns")
    GR24RT.apply(perse, axis = "columns")
    GR24all= pd.concat([GR24I,GR24RT]).sort_index(kind="mergesort")
    GR24all["Trial_ID"] = GR24all["Trial_ID"].fillna(method='bfill')
    GR24all = GR24all.replace(r'^s*$', np.nan, regex=True)
    GR24all = GR24all.fillna(method='ffill')
    GR24all.iloc[0,10] = GR24all.iloc[1,10] # 10 == Conf
    GR24all.iloc[0,11] = GR24all.iloc[1,11]
    GR24all.iloc[0,13] = GR24all.iloc[1,13] # 12 == Error_Type
    GR24all.iloc[0,36] = GR24all.iloc[1,36] # 32 == cumsum


if "GR25" in Set_shifting["Subject"].values:
    GR25["Conf"] = GR25.apply(conf, axis = "columns")
    GR25.apply(conf, axis = "columns")
    GR25["Trial"].replace("", np.nan, inplace = True)
    GR25.dropna(subset = ["Trial"], inplace = True)
    GR25 = GR25.reset_index(drop=True)
    GR25["RT"] = GR25["Time_in_sec"].diff() # new column which subtract rows values from previous row
    GR25RT = GR25[GR25["Trial"] != "trial_start"]
    GR25I = GR25[GR25["Trial"] == "trial_start"]
    GR25I["RT"] = GR25["RT"] - 7
    GR25I = GR25I.reset_index(drop=True)
    GR25I["Trial_Number"]= range(1, len(GR25I) +1)
    GR25I.iloc[0,32] = GR25I.iloc[0,19] -7 #30 == RT, 19 == Time_in_sec
    GR25I["Trial_ID"] = GR25I["Trial_ID"].replace(0, np.nan, inplace=True)
    GR25I['RT_lag'] = GR25I['RT'].shift(-1)
    GR25RT = GR25RT.reset_index(drop=True)
    GR25RT["Trial_Number"]= range(1, len(GR25RT) +1)
    GR25RT["cumsum"] = GR25RT.groupby("TaskID")["perseverative_or_regressive"].cumsum()
    GR25RT["Task_Order"] = GR25RT["Task_Order"].astype("int")
    GR25RT["cumsum"] = GR25RT["cumsum"].astype("int")
    GR25RT['Changing_Point_Per_Task'] = GR25RT.groupby('TaskID')['Changing_Point'].transform(pd.Series.cumsum)
    def perse(row):
        random = row["Task_Type"]
        taskorder = row["Task_Order"]
        correctness = row["Trial"]
        cumsum = row["cumsum"]
               
        if (taskorder > 1 and correctness == "incorrect" and cumsum == 1):
            return "1st"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 100 and cumsum > 1):
            return "perseverative"
        elif (taskorder > 1 and correctness == "incorrect" and cumsum < 10000 and cumsum > 100):
            return "post_perseverative"        
        elif (taskorder > 1 and correctness == "incorrect"and cumsum > 10000):
            return "regressive"
        elif (taskorder > 1 and correctness == "correct"):
            return "correct"
        elif (taskorder > 1 and correctness == "omission"):
            return "omission"
        elif random == "Random":
            return "random"
        else:
            return ""
    GR25RT["Error_Type"] = GR25RT.apply(perse, axis = "columns")
    GR25RT.apply(perse, axis = "columns")
    GR25all= pd.concat([GR25I,GR25RT]).sort_index(kind="mergesort")
    GR25all["Trial_ID"] = GR25all["Trial_ID"].fillna(method='bfill')
    GR25all = GR25all.replace(r'^s*$', np.nan, regex=True)
    GR25all = GR25all.fillna(method='ffill')
    GR25all.iloc[0,10] = GR25all.iloc[1,10] # 10 == Conf
    GR25all.iloc[0,11] = GR25all.iloc[1,11]
    GR25all.iloc[0,13] = GR25all.iloc[1,13] # 12 == Error_Type
    GR25all.iloc[0,36] = GR25all.iloc[1,36] # 32 == cumsum



#%% 
ReactionTime = S60all.append([S61all, S62all, S63all, S64all, S65all],ignore_index= True)
#ReactionTime = S62all.append([S63all, S65all],ignore_index= True)
    
#if "S61" in Set_shifting["Subject"].values:
 #   ReactionTime = S61all
# if "S65" in Set_shifting["Subject"].values:
#    ReactionTime = S65all
    
ReactionTimeClean = ReactionTime.drop(["Project", 
                                       "UserID", 
                                       "A1 - Rear NP",
                                       "A2 - Front NP", 
                                       "A3 - MIddle NP",
                                       "A[1] Rear",
                                       "A[2] Front",
                                       "A[3] MIddle NP",
                                       "Station", "Run",
                                       "Current State", 
                                       "RTmask",
                                       "Time",
                                       "Transition State", 
                                       "A4 - ", 
                                       "A[4] ",
                                       "perseverative_or_regressive",
                                       "cumsum"], axis = 1)

#AER = ["S60"]
#GREG = ["S61", "S63"]
#DAWSON = ["S62", "S64", "S65"]

#def site(row):
#    ID = row[7]
        
#    if ID in AER:
#        return "AER"
#    elif ID in GREG:
#        return "GREG"
#    else:
#        return "DAWSON"
    
#ReactionTimeClean["Site"] = ReactionTimeClean.apply(site, axis = "columns")    
#ReactionTimeClean.apply(site, axis = "columns")
#ReactionTimeClean["Site"] = "CG"

All_rats = ["S60", "S61", "S62", "S63", "S64", "S65"]
mid = ["S61", "S62"]
ventral = ["S60"]
dorsomedial = ["S63"]
dorsolateral = ["S64","S65"]



def site(row):
    Subject = row["Subject"]
        
    if Subject in ventral:
        return "ventral"
    elif Subject in mid:
        return "mid"
    elif Subject in dorsomedial:
        return "dorsomedial"
    elif Subject in dorsolateral:
        return "dorsolateral"  
    else:
        return "wrong"

ReactionTimeClean["Site"] = ReactionTimeClean.apply(site, axis = "columns")    
ReactionTimeClean.apply(site, axis = "columns")


#def sex(row):
#    ID = row[7]
        
#    if ID in All_rats:
#        return "Male"
#    else:
#        return ""
    
#ReactionTimeClean["Sex"] = ReactionTimeClean.apply(sex, axis = "columns")    
#ReactionTimeClean.apply(sex, axis = "columns")
ReactionTimeClean["Sex"] = "Male"


Session1 = [1]
Session2 = [2]
Session3 = [3]
Session4 = [4]
Session5 = [5]
Session6 = [6]
Session7 = [7]
Session8 = [8]
Session9 = [9]
Session10 = [10]
Session11 = [11]
Session12 = [12]
Session13 = [13]
Session14 = [14]
Session15 = [15]
Session16 = [16]
Session17 = [17]
Session18 = [18]
Session19 = [19]
Session20 = [20]
Session21 = [21]
Session22 = [22]
Session23 = [23]
Session24 = [24]
Session25 = [25]
Session26 = [26]
Session27 = [27]
Session28 = [28]
Session29 = [29]
Session30 = [30]
Session31 = [31]
Session32 = [32]
Session33 = [33]
Session34 = [34]
Session35 = [35]
Session36 = [36]
Session37 = [37]
Session38 = [38]
Session39 = [39]
Session40 = [40]
Session41 = [41]

Session101 = [101]
Session102 = [102]
Session103 = [103]
Session104 = [104]
Session105 = [105]
Session106 = [106]
Session107 = [107]
Session108 = [108]


Session1_17 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41]
#Session101_108 = [101,102,103,104,105,106,107,108]
#Session1_108 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,101,102,103,104,105,106,107,108]
Session_bl = [100]
Session_test = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41]
#Session_test = [101,102,103,104,105,106,107,108]









def drug(row):
    session = row["Session"]
        
    if session in Session1_17:
        return "none"
          
ReactionTimeClean["Drug"] = ReactionTimeClean.apply(drug, axis = "columns")    
ReactionTimeClean.apply(drug, axis = "columns")

          
def stim(row):
    subject = row["Subject"]
    session = row["Session"]
        
    if subject == "S60" and (session in Session1 or
                                  session in Session3 or
                                  session in Session5 or
                                  session in Session7 or
                                  session in Session9 or 
                                  session in Session11 or
                                  session in Session13 or 
                                  session in Session15):
        return "ON"
    elif subject == "S61" and (session in Session1 or
                                  session in Session3 or
                                  session in Session5 or
                                  session in Session7 or
                                  session in Session9 or 
                                  session in Session11 or
                                  session in Session13 or 
                                  session in Session15):
        return "ON"
    elif subject == "S62" and (session in Session2 or
                                  session in Session4 or
                                  session in Session6 or
                                  session in Session8 or
                                  session in Session10 or 
                                  session in Session12 or
                                  session in Session14 or 
                                  session in Session16):
       return "ON"
    elif subject == "S63" and (session in Session2 or
                                  session in Session4 or
                                  session in Session6 or
                                  session in Session8 or
                                  session in Session10 or 
                                  session in Session12 or
                                  session in Session14 or 
                                  session in Session16):
        return "ON"
    elif subject == "S64" and (session in Session2 or
                                  session in Session4 or
                                  session in Session6 or
                                  session in Session8 or
                                  session in Session10 or 
                                  session in Session12 or
                                  session in Session14 or 
                                  session in Session16):
        return "ON"
    elif subject == "S65" and (session in Session1 or
                                  session in Session3 or
                                  session in Session5 or
                                  session in Session7 or
                                  session in Session9 or 
                                  session in Session11 or
                                  session in Session13 or 
                                  session in Session15):
        return "ON"
    else:
        return "OFF"
    
ReactionTimeClean["Stim"] = ReactionTimeClean.apply(stim, axis = "columns")    
ReactionTimeClean.apply(stim, axis = "columns")

    
def stim_int(row):
    stim_on_off = row["Stim"]
        
    if stim_on_off == "ON":
        return "300"
    elif stim_on_off == "OFF":
        return "0"
    else:
        return "0"

ReactionTimeClean["Stim_Int"] = ReactionTimeClean.apply(stim_int, axis = "columns")    
ReactionTimeClean.apply(stim_int, axis = "columns")

def stim_period(row):
    stim_on_off = row["Stim"]
        
    if stim_on_off == "ON":
        return "60"
    else:
        return "0"

ReactionTimeClean["Pre_Test_Time"] = ReactionTimeClean.apply(stim_period, axis = "columns")    
ReactionTimeClean.apply(stim_period, axis = "columns")


'''
experimental_group = ["S60", "S62", "S65", "S61", "S63", "S64"]
control_group = ["S58", "S59", "GR22", "GR23", "GR24", "GR25"]


def group(row):
    subject = row[7]
            
    if subject in  control_group:
        return "control"
    else:
        return "experimental"
    
ReactionTimeClean["Group"] = ReactionTimeClean.apply(group, axis = "columns")    
ReactionTimeClean.apply(group, axis = "columns")
'''

def stage(row):
    session = row["Session"]
    
        
    if session in Session_bl:
        return "baseline"
    elif session in Session_test: 
        return "test"
  
ReactionTimeClean["Stage"] = ReactionTimeClean.apply(stage, axis = "columns")    
ReactionTimeClean.apply(stage, axis = "columns")

def session_stim_cond(row):
    session = row["Session"]
        
    if session == 1 :
        return 1
    elif session == 2:
        return 1
    elif session == 3:
        return 2
    elif session == 4:
        return 2
    elif session == 5:
        return 3
    elif session == 6:
        return 3
    elif session == 7:
        return 4
    elif session == 8:
        return 4
    elif session == 9:
        return 5
    elif session == 10:
        return 5
    elif session == 11:
        return 6
    elif session == 12:
        return 6
    elif session == 13:
        return 7
    elif session == 14:
        return 7
    elif session == 15:
        return 8
    elif session == 16:
        return 8
    elif session == 17:
        return 9
    elif session == 18:
        return 1
    elif session == 19:
        return 2
    elif session == 20:
        return 3
    elif session == 21:
        return 4 


ReactionTimeClean["Session_Stim_Condition"] = ReactionTimeClean.apply(session_stim_cond, axis = "columns")    
ReactionTimeClean.apply(session_stim_cond, axis = "columns")
    

conditions = [
        (ReactionTimeClean["Session"] == 1),
        (ReactionTimeClean["Session"] == 2),
        (ReactionTimeClean["Session"] == 3),
        (ReactionTimeClean["Session"] == 4),
        (ReactionTimeClean["Session"] == 5),
        (ReactionTimeClean["Session"] == 6),
        (ReactionTimeClean["Session"] == 7),
        (ReactionTimeClean["Session"] == 8),
        (ReactionTimeClean["Session"] == 9),
        (ReactionTimeClean["Session"] == 10),
        (ReactionTimeClean["Session"] == 11),
        (ReactionTimeClean["Session"] == 12),
        (ReactionTimeClean["Session"] == 13),
        (ReactionTimeClean["Session"] == 14),
        (ReactionTimeClean["Session"] == 15),
        (ReactionTimeClean["Session"] == 16),
        (ReactionTimeClean["Session"] == 17),
        (ReactionTimeClean["Session"] == 18),
        (ReactionTimeClean["Session"] == 19),
        (ReactionTimeClean["Session"] == 20),
        (ReactionTimeClean["Session"] == 21),
        (ReactionTimeClean["Session"] == 22),
        (ReactionTimeClean["Session"] == 23),
        (ReactionTimeClean["Session"] == 24),
        (ReactionTimeClean["Session"] == 25),
        (ReactionTimeClean["Session"] == 26),
        (ReactionTimeClean["Session"] == 27),
        (ReactionTimeClean["Session"] == 28),
        (ReactionTimeClean["Session"] == 29),
        (ReactionTimeClean["Session"] == 30),
        (ReactionTimeClean["Session"] == 31),
        (ReactionTimeClean["Session"] == 32),
        (ReactionTimeClean["Session"] == 33),
        (ReactionTimeClean["Session"] == 34),
        (ReactionTimeClean["Session"] == 35),
        (ReactionTimeClean["Session"] == 36),
        (ReactionTimeClean["Session"] == 37),
        (ReactionTimeClean["Session"] == 38),
        (ReactionTimeClean["Session"] == 39),
        (ReactionTimeClean["Session"] == 40),       
        (ReactionTimeClean["Session"] == 41)]
choices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41]
ReactionTimeClean["Session"] = np.select(conditions, choices)


def response_side(row):
    response = row["Transition Event"]
        
    if response == 1 :
        return "Rear"
    elif response == 2:
        return "Front"
    elif response == 3:
        return "Center"

ReactionTimeClean["Response_Side"] = ReactionTimeClean.apply(response_side, axis = "columns")    
ReactionTimeClean.apply(response_side, axis = "columns")



ReactionTime_ok = ReactionTimeClean[["Subject", "Sex", "Drug", "Site", "Stage", "Stim", "Stim_Int", "Pre_Test_Time", "Session", "Session_Stim_Condition", "Protocol", "Task_Order", "Task_Type", "TaskID", "Trial_ID","Trial_Number","Sequence", "Light_Position", "Response_Side",  "Trial","Error_Type", "Conf", "Changing_Point", "Changing_Point_Cumulative", "Changing_Point_Per_Task", "Time_in_sec", "RT", "RT_lag"]]

#%% 
os.chdir("Z:/My Drive/Data and analysis/Raw/S60-S65/")
ReactionTime_ok.to_csv("S60_S65_processed_Session16.csv", index = False)

#%% 

import csv
import glob
import os
import pandas as pd
import numpy as np

path =r"Z:/My Drive/Data and analysis/Raw/S60-S75/Pre_processed/Done"
os.chdir("Z:/My Drive/Data and analysis/Raw/S60-S65/Pre_processed/Done")
all_files = glob.glob("Z:/My Drive/Data and analysis/Raw/S60-S65/Pre_processed/Done/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
All_sessions = pd.concat(df_from_each_file, ignore_index=True)

All_sessions.to_csv("all_sessions_S60_S65.csv", index=False)


Session1 = Session1.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session1 = Session1.replace(to_replace ="protocol44_OE",
                 value ="44")
Session1 = Session1.replace(to_replace ="protocol45",
                 value ="45")
Session1 = Session1.replace(to_replace ="protocol46",
                 value ="46")
Session1 = Session1.replace(to_replace ="protocol47",
                 value ="47")
Session1["Session"] = 1
