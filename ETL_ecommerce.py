import pandas as pd

import sqlite3



pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.set_option('display.max_colwidth', None)
pd.set_option('display.width', None)

 # Load data from CSV files
users = pd.read_csv('C:\\Users\\Alhouda\\Downloads\\ecommerce_dataset\\user_dataset.csv')
orders = pd.read_csv('C:\\Users\\Alhouda\\Downloads\\ecommerce_dataset\\order_dataset.csv')
order_items = pd.read_csv('C:\\Users\\Alhouda\\Downloads\\ecommerce_dataset\\order_item_dataset.csv')
products = pd.read_csv('C:\\Users\\Alhouda\\Downloads\\ecommerce_dataset\\products_dataset.csv')
sellers = pd.read_csv('C:\\Users\\Alhouda\\Downloads\\ecommerce_dataset\\seller_dataset.csv')
payments = pd.read_csv('C:\\Users\\Alhouda\\Downloads\\ecommerce_dataset\\payment_dataset.csv')
feedbacks = pd.read_csv('C:\\Users\\Alhouda\\Downloads\\ecommerce_dataset\\feedback_dataset.csv')

# Drop rows with NaN values in each DataFrame
users.dropna(inplace=True)
orders.dropna(inplace=True)
order_items.dropna(inplace=True)
products.dropna(inplace=True)
sellers.dropna(inplace=True)
payments.dropna(inplace=True)
feedbacks.dropna(inplace=True)

def check_duplicates(df, column_name):
    duplicates = df[df.duplicated(subset=column_name, keep=False)]
    if not duplicates.empty:
        print(f"Duplicates found in column '{column_name}':")
        print(duplicates)
    else:
        print(f"No duplicates found in column '{column_name}'.")

# Check for duplicates in seller_id and product_id
# check_duplicates(orders, 'order_id')

user_dimension = users.drop_duplicates(subset='customer_zip_code',keep='last')
user_dimension=users[[ 'customer_zip_code','user_name', 'customer_city', 'customer_state']]
# print(users.head())
#  Example for Product_Dimension
product_dimension = products[['product_id', 'product_category', 'product_name_lenght',
       'product_description_lenght', 'product_photos_qty', 'product_weight_g',
       'product_length_cm', 'product_height_cm', 'product_width_cm']]
print(product_dimension.head())
 # Example for Seller_Dimension
seller_dimension = sellers[['seller_id', 'seller_zip_code', 'seller_city', 'seller_state']]
# Generate auto-increment index for payments and products
payments.reset_index(drop=True, inplace=True)
payments['payment_id'] = payments.index + 1

feedbacks.reset_index(drop=True, inplace=True)
feedbacks['feedback_id'] = feedbacks.index + 1

payments_dimension= payments[['payment_id','order_id', 'payment_type', 'payment_installments', 'payment_value']]
feedbacks_dimension= feedbacks[['feedback_id','order_id', 'feedback_score', 'feedback_form_sent_date', 'feedback_answer_date']]
# print(feedbacks_dimension.head())
# print(payments_dimension.head())

# Example for Order_Fact
order_fact = orders[['order_id', 'user_name', 'order_status', 'order_date', 'order_approved_date', 'pickup_date', 'delivered_date', 'estimated_time_delivery']]
# Example for Order_Item_Fact
print(order_items.columns)
order_item_fact = order_items[['order_id', 'order_item_id', 'product_id', 'seller_id',
       'pickup_limit_date', 'price', 'shipping_cost']]
# totalprice
order_total_price = order_items.groupby('order_id').agg({'price': 'sum', 'shipping_cost': 'sum'}).reset_index()
order_total_price['total_order_price'] = order_total_price['price'] + order_total_price['shipping_cost']
order_total_price = order_total_price[['order_id', 'total_order_price']]
# Merge order_fact with user_dimension on customer_zip_code
order_fact = order_fact.merge(user_dimension[['user_name', 'customer_zip_code']], on='user_name', how='left')

# Drop the user_name column if it's no longer needed
order_fact = order_fact.drop(columns=['user_name'])
# Convert date columns to datetime format
order_fact['order_date'] = pd.to_datetime(order_fact['order_date'])
order_fact['order_approved_date'] = pd.to_datetime(order_fact['order_approved_date'])
order_fact['pickup_date'] = pd.to_datetime(order_fact['pickup_date'])
order_fact['delivered_date'] = pd.to_datetime(order_fact['delivered_date'])
order_fact['estimated_time_delivery'] = pd.to_datetime(order_fact['estimated_time_delivery'])
feedbacks_dimension['feedback_form_sent_date'] = pd.to_datetime(feedbacks_dimension['feedback_form_sent_date'])
feedbacks_dimension['feedback_answer_date'] = pd.to_datetime(feedbacks_dimension['feedback_answer_date'])
order_item_fact['pickup_limit_date'] = pd.to_datetime(order_item_fact['pickup_limit_date'])
# Merge payment_id into order_fact
order_fact = order_fact.merge(payments_dimension[['order_id', 'payment_id']], on='order_id', how='left')

# Merge feedback_id into order_fact
order_fact = order_fact.merge(feedbacks_dimension[['order_id', 'feedback_id']], on='order_id', how='left')
# Merge total order price into order_fact
order_fact = order_fact.merge(order_total_price, on='order_id', how='left')
order_fact = order_fact[['order_id','customer_zip_code', 'order_status', 'order_date', 'order_approved_date',
       'pickup_date', 'delivered_date', 'estimated_time_delivery','payment_id','feedback_id',
        'total_order_price']]



# Connect to SQLite database
conn = sqlite3.connect('C:\\Users\\Alhouda\\Downloads\\e_commerc.db')

# Function to load DataFramea to SQLite
def load_to_sqlite(df, table_name):
    df.to_sql(table_name, conn, if_exists='replace', index=False)

# Load data into SQLite
load_to_sqlite(user_dimension, 'User_Dimension')
load_to_sqlite(product_dimension, 'Product_Dimension')
load_to_sqlite(seller_dimension, 'Seller_Dimension')
load_to_sqlite(payments_dimension, 'payments_dimension')
load_to_sqlite(feedbacks_dimension, 'feedbacks_dimension')
load_to_sqlite(order_fact, 'Order_Fact')
load_to_sqlite(order_item_fact, 'Order_Item_Fact')

# Close the connection
conn.close()