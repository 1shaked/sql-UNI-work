import pandas as pd

df = pd.read_excel('q8ExcelActorCustomers.xlsx')


df_cus = df[df.typeOfName == 'CUSTOMER']
df_actors = df[df.typeOfName == 'ACTOR']

cus_names: set = set(df_cus.first_name.values)
actors_names: set = set(df_actors.first_name.values)

# we get empty set
print(cus_names.intersection(actors_names))