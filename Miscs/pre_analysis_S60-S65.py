# -*- coding: utf-8 -*-
"""
Created on Mon Aug 24 11:40:32 2020

@author: Tnel-DATA2
"""

import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0911"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session1 = pd.concat(df_from_each_file, ignore_index=True)
Session1 = Session1.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session1 = Session1.replace(to_replace ="protocol44", 
                 value ="44")
Session1 = Session1.replace(to_replace ="protocol45", 
                 value ="45")
Session1 = Session1.replace(to_replace ="protocol46", 
                 value ="46") 
Session1 = Session1.replace(to_replace ="protocol47", 
                 value ="47") 
Session1["Session"] = 1


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0912"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session2 = pd.concat(df_from_each_file, ignore_index=True)
Session2 = Session2.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session2 = Session2.replace(to_replace ="protocol44", 
                 value ="44")
Session2 = Session2.replace(to_replace ="protocol45", 
                 value ="45")
Session2 = Session2.replace(to_replace ="protocol46", 
                 value ="46") 
Session2 = Session2.replace(to_replace ="protocol47", 
                 value ="47") 
Session2["Session"] = 2


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0913"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session3 = pd.concat(df_from_each_file, ignore_index=True)
Session3 = Session3.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session3 = Session3.replace(to_replace ="protocol44", 
                 value ="44")
Session3 = Session3.replace(to_replace ="protocol45", 
                 value ="45")
Session3 = Session3.replace(to_replace ="protocol46", 
                 value ="46") 
Session3 = Session3.replace(to_replace ="protocol47", 
                 value ="47") 
Session3["Session"] = 3


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0914"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session4 = pd.concat(df_from_each_file, ignore_index=True)
Session4 = Session4.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session4 = Session4.replace(to_replace ="protocol44", 
                 value ="44")
Session4 = Session4.replace(to_replace ="protocol45", 
                 value ="45")
Session4 = Session4.replace(to_replace ="protocol46", 
                 value ="46") 
Session4 = Session4.replace(to_replace ="protocol47", 
                 value ="47") 
Session4["Session"] = 4


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0915"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session5 = pd.concat(df_from_each_file, ignore_index=True)
Session5 = Session5.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session5 = Session5.replace(to_replace ="protocol44", 
                 value ="44")
Session5 = Session5.replace(to_replace ="protocol45", 
                 value ="45")
Session5 = Session5.replace(to_replace ="protocol46", 
                 value ="46") 
Session5 = Session5.replace(to_replace ="protocol47", 
                 value ="47") 
Session5["Session"] = 5


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0916"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session6 = pd.concat(df_from_each_file, ignore_index=True)
Session6 = Session6.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session6 = Session6.replace(to_replace ="protocol44", 
                 value ="44")
Session6 = Session6.replace(to_replace ="protocol45", 
                 value ="45")
Session6 = Session6.replace(to_replace ="protocol46", 
                 value ="46") 
Session6 = Session6.replace(to_replace ="protocol47", 
                 value ="47") 
Session6["Session"] = 6


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0917"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session7 = pd.concat(df_from_each_file, ignore_index=True)
Session7 = Session7.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session7 = Session7.replace(to_replace ="protocol44", 
                 value ="44")
Session7 = Session7.replace(to_replace ="protocol45", 
                 value ="45")
Session7 = Session7.replace(to_replace ="protocol46", 
                 value ="46") 
Session7 = Session7.replace(to_replace ="protocol47", 
                 value ="47") 
Session7["Session"] = 7


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0918"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session8 = pd.concat(df_from_each_file, ignore_index=True)
Session8 = Session8.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session8 = Session8.replace(to_replace ="protocol44", 
                 value ="44")
Session8 = Session8.replace(to_replace ="protocol45", 
                 value ="45")
Session8 = Session8.replace(to_replace ="protocol46", 
                 value ="46") 
Session8 = Session8.replace(to_replace ="protocol47", 
                 value ="47") 
Session8["Session"] = 8


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0919"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session9 = pd.concat(df_from_each_file, ignore_index=True)
Session9 = Session9.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session9 = Session9.replace(to_replace ="protocol44", 
                 value ="44")
Session9 = Session9.replace(to_replace ="protocol45", 
                 value ="45")
Session9 = Session9.replace(to_replace ="protocol46", 
                 value ="46") 
Session9 = Session9.replace(to_replace ="protocol47", 
                 value ="47") 
Session9["Session"] = 9


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0920"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session10 = pd.concat(df_from_each_file, ignore_index=True)
Session10 = Session10.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session10 = Session10.replace(to_replace ="protocol44", 
                 value ="44")
Session10 = Session10.replace(to_replace ="protocol45", 
                 value ="45")
Session10 = Session10.replace(to_replace ="protocol46", 
                 value ="46") 
Session10 = Session10.replace(to_replace ="protocol47", 
                 value ="47") 
Session10["Session"] = 10



import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0921"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session11 = pd.concat(df_from_each_file, ignore_index=True)
Session11 = Session11.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session11 = Session11.replace(to_replace ="protocol44", 
                 value ="44")
Session11 = Session11.replace(to_replace ="protocol45", 
                 value ="45")
Session11 = Session11.replace(to_replace ="protocol46", 
                 value ="46") 
Session11 = Session11.replace(to_replace ="protocol47", 
                 value ="47") 
Session11["Session"] = 11


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0922"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session12 = pd.concat(df_from_each_file, ignore_index=True)
Session12 = Session12.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session12 = Session12.replace(to_replace ="protocol44", 
                 value ="44")
Session12 = Session12.replace(to_replace ="protocol45", 
                 value ="45")
Session12 = Session12.replace(to_replace ="protocol46", 
                 value ="46") 
Session12 = Session12.replace(to_replace ="protocol47", 
                 value ="47") 
Session12["Session"] = 12


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0923"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session13 = pd.concat(df_from_each_file, ignore_index=True)
Session13 = Session13.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session13 = Session13.replace(to_replace ="protocol44", 
                 value ="44")
Session13 = Session13.replace(to_replace ="protocol45", 
                 value ="45")
Session13 = Session13.replace(to_replace ="protocol46", 
                 value ="46") 
Session13 = Session13.replace(to_replace ="protocol47", 
                 value ="47") 
Session13["Session"] = 13


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0924"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session14 = pd.concat(df_from_each_file, ignore_index=True)
Session14 = Session14.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session14 = Session14.replace(to_replace ="protocol44", 
                 value ="44")
Session14 = Session14.replace(to_replace ="protocol45", 
                 value ="45")
Session14 = Session14.replace(to_replace ="protocol46", 
                 value ="46") 
Session14 = Session14.replace(to_replace ="protocol47", 
                 value ="47") 
Session14["Session"] = 14


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0925"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session15 = pd.concat(df_from_each_file, ignore_index=True)
Session15 = Session15.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session15 = Session15.replace(to_replace ="protocol44", 
                 value ="44")
Session15 = Session15.replace(to_replace ="protocol45", 
                 value ="45")
Session15 = Session15.replace(to_replace ="protocol46", 
                 value ="46") 
Session15 = Session15.replace(to_replace ="protocol47", 
                 value ="47") 
Session15["Session"] = 15


import glob
import numpy
import pandas as pd
import os
path =r"Z:/My Drive/Data and analysis/Raw/S60-S65/0926"
all_files = glob.glob(path + "/*.csv")
df_from_each_file = (pd.read_csv(f) for f in all_files)
Session16 = pd.concat(df_from_each_file, ignore_index=True)
Session16 = Session16.rename(columns={"Rear": "A1 - Rear NP", "Front": "A2 - Front NP", "Middle" : "A3 - MIddle NP", "Manual Switch" : "A4 - ", "Rear.1" : "A[1] Rear", "Front.1" : "A[2] Front", "Middle.1" : "A[3] MIddle NP", "Manual Switch.1" : "A[4] "})
Session16 = Session16.replace(to_replace ="protocol44", 
                 value ="44")
Session16 = Session16.replace(to_replace ="protocol45", 
                 value ="45")
Session16 = Session16.replace(to_replace ="protocol46", 
                 value ="46") 
Session16 = Session16.replace(to_replace ="protocol47", 
                 value ="47") 
Session16["Session"] = 16



#%%

os.chdir('Z:/My Drive/Data and analysis/Raw/S60-S65/Pre_processed')
Session1.to_csv("S60-S65_Session01.csv", index=False)
Session2.to_csv("S60-S65_Session02.csv", index=False)
Session3.to_csv("S60-S65_Session03.csv", index=False)
Session4.to_csv("S60-S65_Session04.csv", index=False)
Session5.to_csv("S60-S65_Session05.csv", index=False)
Session6.to_csv("S60-S65_Session06.csv", index=False)
Session7.to_csv("S60-S65_Session07.csv", index=False)
Session8.to_csv("S60-S65_Session08.csv", index=False)
Session9.to_csv("S60-S65_Session09.csv", index=False)
Session10.to_csv("S60-S65_Session10.csv", index=False)
Session11.to_csv("S60-S65_Session11.csv", index=False)
Session12.to_csv("S60-S65_Session12.csv", index=False)
Session13.to_csv("S60-S65_Session13.csv", index=False)
Session14.to_csv("S60-S65_Session14.csv", index=False)
Session15.to_csv("S60-S65_Session15.csv", index=False)
Session16.to_csv("S60-S65_Session16.csv", index=False)
#All_Sessions = Session1.append([Session2,Session3,Session4])



