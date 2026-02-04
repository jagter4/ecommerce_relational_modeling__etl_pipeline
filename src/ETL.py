import pandas as pd
import logging
from pathlib import Path
from sqlalchemy import text
from utils import get_db_engine

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def etl():
    logger.info("Starting ETL process")
    
    # Define the data directory path
    base_dir = Path(__file__).resolve().parent
    data_dir = base_dir / "datasets"
    
    try:
        #  Extract
        products_df = pd.read_csv(data_dir / 'products_data.csv')
        orders_df = pd.read_csv(data_dir / 'orders_data.csv')
        users_df = pd.read_csv(data_dir / 'users_data.csv')
        payments_df = pd.read_excel(data_dir / 'payments_data.xlsx', engine='openpyxl')
        reviews_df = pd.read_excel(data_dir / 'reviews_data.xlsx', engine='openpyxl')
        logger.info("Data extraction complete")

        #  Transform 
        logger.info("Starting transformation")
        
        # Products Cleaning
        products_df['Description'] = products_df['Description'].fillna('No description available')
        products_df['Price'] = pd.to_numeric(products_df['Price'], errors='coerce').fillna(0.0).round(2)
        
        # Date Standardization
        orders_df['OrderDate'] = pd.to_datetime(orders_df['OrderDate'], errors='coerce').fillna(pd.Timestamp('1970-01-01'))
        payments_df['PaymentDate'] = pd.to_datetime(payments_df['PaymentDate'], errors='coerce').fillna(pd.Timestamp('1970-01-01'))

        # Load
        engine = get_db_engine()
        if not engine:
            return

        with engine.begin() as conn:
            logger.info("Clearing target tables")
            for table in ['Payments', 'Reviews', 'Orders', 'Users', 'Products']:
                conn.execute(text(f"DELETE FROM {table}"))

            # 1. Load Products & Map IDs
            product_id_map = {}
            for i, row in products_df.iterrows():
                res = conn.execute(
                    text("INSERT INTO Products (ProductName, Description, Price, StockQuantity, Category) "
                         "VALUES (:name, :desc, :p, :s, :c)"),
                    {"name": row['ProductName'], "desc": row['Description'], "p": row['Price'], 
                     "s": row['StockQuantity'], "c": row['Category']}
                )
                product_id_map[i] = res.lastrowid

            # 2. Load Users & Map IDs
            user_id_map = {}
            for i, row in users_df.iterrows():
                res = conn.execute(
                    text("INSERT INTO Users (UserName, Email, Address, Password) VALUES (:u, :e, :a, :p)"),
                    {"u": row['UserName'], "e": row['Email'], "a": row['Address'], "p": row['Password']}
                )
                user_id_map[i + 1] = res.lastrowid # Mapping index+1 as per notebook logic

            # 3. Load Orders & Map IDs
            orders_df['UserID'] = orders_df['UserID'].map(user_id_map)
            order_id_map = {}
            for i, row in orders_df.iterrows():
                res = conn.execute(
                    text("INSERT INTO Orders (UserID, OrderDate, TotalAmount) VALUES (:uid, :od, :ta)"),
                    {"uid": row['UserID'], "od": row['OrderDate'], "ta": row['TotalAmount']}
                )
                order_id_map[i] = res.lastrowid

            # 4. Load Payments
            payments_df['OrderID'] = payments_df.index.map(order_id_map)
            for i, row in payments_df.iterrows():
                conn.execute(
                    text("INSERT INTO Payments (OrderID, PaymentMethod, PaymentDate, Amount) VALUES (:oid, :pm, :pd, :am)"),
                    {"oid": row['OrderID'], "pm": row['PaymentMethod'], "pd": row['PaymentDate'], "am": row['Amount']}
                )

            # 5. Load Reviews
            reviews_df['UserID'] = reviews_df['UserID'].map(user_id_map)
            reviews_df['ProductID'] = reviews_df.index.map(product_id_map)
            reviews_df = reviews_df.dropna(subset=['ProductID', 'UserID'])
            for i, row in reviews_df.iterrows():
                conn.execute(
                    text("INSERT INTO Reviews (ProductID, UserID, Rating, ReviewText) VALUES (:pid, :uid, :r, :rt)"),
                    {"pid": row['ProductID'], "uid": row['UserID'], "r": row['Rating'], "rt": row['ReviewText']}
                )

        logger.info("Data load successful")

        # Verification
        with engine.connect() as conn:
            for table in ['Products', 'Users', 'Orders', 'Payments', 'Reviews']:
                count = conn.execute(text(f"SELECT COUNT(*) FROM {table}")).scalar()
                logger.info(f"Verification: {table} has {count} records")

    except Exception as e:
        logger.error(f"ETL failed: {e}")

if __name__ == "__main__":
    etl()