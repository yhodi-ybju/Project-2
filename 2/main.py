import pandas as pd
from sqlalchemy import create_engine, text
import chardet


def detect_encoding(file_path):
    with open(file_path, 'rb') as f:
        result = chardet.detect(f.read())
    return result['encoding']


def fix_encoding(file_path, correct_encoding='utf-8'):
    detected_encoding = detect_encoding(file_path)
    print(f"Detected encoding for {file_path}: {detected_encoding}")

    with open(file_path, 'r', encoding=detected_encoding) as f:
        content = f.read()

    with open(file_path, 'w', encoding=correct_encoding) as f:
        f.write(content)

    print(f"File {file_path} re-encoded to {correct_encoding}")


def load_csv(file_path, encoding='utf-8'):
    fix_encoding(file_path, correct_encoding=encoding)
    try:
        return pd.read_csv(file_path, delimiter=",", encoding=encoding)
    except UnicodeDecodeError as e:
        print(f"UnicodeDecodeError: {e}")
        return pd.read_csv(file_path, delimiter=",", encoding='cp1252')


def upload_to_database(df, table_name, schema, engine):
    with engine.begin() as connection:
        df.to_sql(table_name, con=connection, schema=schema, if_exists="replace", index=False)


def main():
    engine = create_engine('postgresql+psycopg2://postgres:1234@localhost:5432/dwh')

    product_df = load_csv('../files/product_info.csv', encoding='utf-8')
    product_df['effective_from_date'] = pd.to_datetime(product_df['effective_from_date'], format='%Y-%m-%d',
                                                       errors='coerce')
    product_df['effective_to_date'] = pd.to_datetime(product_df['effective_to_date'], format='%Y-%m-%d',
                                                     errors='coerce')
    upload_to_database(product_df, 'product', 'rd', engine)

    deal_df = load_csv('../files/deal_info.csv', encoding='utf-8')
    deal_df['effective_from_date'] = pd.to_datetime(deal_df['effective_from_date'], format='%Y-%m-%d', errors='coerce')
    deal_df['effective_to_date'] = pd.to_datetime(deal_df['effective_to_date'], format='%Y-%m-%d', errors='coerce')
    upload_to_database(deal_df, 'deal_info', 'rd', engine)


if __name__ == "__main__":
    main()
