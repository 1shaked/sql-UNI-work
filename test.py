import json

with open('rental.csv') as f:
    text = f.read()
    
    res: list[dict[str, str]] = json.loads(text)

# print(res)

customers_time: dict[str, int] = {}


for row in res:
    if '2005-' in row['rental_date']:
        customer_id = row['customer_id']
        if customer_id not in customers_time:
            customers_time[customer_id] = 0
        customers_time[customer_id] = customers_time[customer_id] + 1


current_max = 0
id_max = -1
items: list = list(customers_time.items())

items.sort(key=lambda x: x[1], reverse=True)
for k,v in items:
    if v >= current_max:
        id_max = k
        current_max = v


print(k , current_max)





