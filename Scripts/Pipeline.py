# -*- coding: utf-8 -*-
"""
Created on Wed Feb 21 08:36:05 2024

@author: Andres
"""


import numpy as np
from pydomo import Domo
from pymongo import MongoClient



#Importing data using domo API
domo = Domo('94af109b-7e1f-4f59-9b8c-576abfbc3b5c','4fa65d787381d78e860c08c14bd3703b846020d59be460d5e2ed4b8f946d523c',api_host='api.domo.com')

SOI_v1 = domo.ds_get("a9557991-439f-4533-a761-a0c801a36dad") #Here you put the dataset ID found in the URL


#Check data
#SOI_v1[:10]
#SOI_v1[-10:]





def beastmode(df, column_name='LABEL_SORT'):
    #Conditions for the new column
    conditions = [
        (df['LABEL'] == '15+'),
        (df['LABEL'] == '7+'),
        (df['LABEL'] == 'ON HAND'),
        (df['LABEL'] == 'ORDERED'),
        (df['LABEL'] == 'RESERVED'),
        (df['LABEL'] == 'AVAILABLE'),
        (df['Rank'] == 2),
        (df['Rank'] == 3),
        (df['Rank'] == 4),
        (df['Rank'] == 5),
        (df['Rank'] == 6),
        (df['Rank'] == 7),
        (df['Rank'] == 8),
        (df['Rank'] == 9),
    ]

    #Corresponding values for each condition
    choices = [
        2,   # For "15+"
        1,   # For "7+"
        4,   # For "ON HAND"
        5,   # For "ORDERED"
        3,   # For "RESERVED"
        5.1, # For "AVAILABLE"
        6,   # For Rank == 2
        7,   # For Rank == 3
        8,   # For Rank == 4
        9,   # For Rank == 5
        10,  # For Rank == 6
        11,  # For Rank == 7
        12,  # For Rank == 8
        12,  # For Rank == 9
    ]

    df[column_name] = np.select(conditions, choices, default=13)
    return df


SOI_v1 = beastmode(SOI_v1)





# Converts DataFrame to a list of dictionaries, where each dictionary represents a row in the DataFrame
SOI_dict = SOI_v1.to_dict(orient='records')
SOI_dict

# the ip and port of our mongodb server
CONNECTION_STRING = "mongodb://10.2.124.5:27001"
 
# create a connection
client = MongoClient(CONNECTION_STRING)

# Specify the database and collection
db = client['SOI_data']
collection = db['SOI_v1']


# deletes the old data in Mongo
collection.delete_many({}) 

# Insert the data into the collection
collection.insert_many(SOI_dict)

print("SOI_data", SOI_v1)

# Query all documents in the collection
documents = collection.find()







