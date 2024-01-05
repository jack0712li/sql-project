import pymysql, account, viewer, cart

# Connect to MySQL database
def connect_to_database():
    host = "localhost"
    # user = "root"
    # password = "yyc88889999"
    user = input("Enter MySQL username: ")
    password = input("Enter MySQL password: ")
    database = "online_phone_sales_db"

    try:
        conn = pymysql.connect(
            host=host, user=user, password=password, database=database
        )
        print("\nConnected to MySQL database successfully!!")
        return conn
    except pymysql.err.OperationalError as e:
        print("\nConnection failed: {}, please try again.")


# Home page options
def home_page(conn):
    while True:
        print("\n===== HOME PAGE =====")
        print("1. Create New Account")
        print("2. Login")
        print("0. Exit")
        choice = input("Enter your choice: ")

        if choice == "1":
            create_account(conn)
        elif choice == "2":
            login(conn)
        elif choice == "0":
            print("Goodbye!")
            break
        else:
            print("Invalid input. Try again.")


# Create new account
def create_account(conn):
    print("\n===== CREATE ACCOUNT =====")
    first_name = input("First name: ")
    last_name = input("Last name: ")
    email = input("Email: ")
    username = input("Username: ")
    password = input("Password: ")
    phone_no = input("Phone number: ")
    address = input("Address: ")
    zip_code = input("Zip code: ")

    try:
        cursor = conn.cursor()
        cursor.callproc(
            "add_new_account",
            (
                first_name,
                last_name,
                email,
                password,
                phone_no,
                address,
                zip_code,
                username,
            ),
        )
        conn.commit()
        print("Account created successfully!")

    except Exception as e:
        print("Invalid user info input. Try again.")


# Login with existing account
def login(conn):
    print("\n===== LOGIN =====")
    username = input("Enter username: ")
    password = input("Enter password: ")

    # try:
    cursor = conn.cursor()
    cursor.callproc(
        "authentication",
        (username, password),
    )
    result = cursor.fetchone()

    if result:
        print(f"\nLogin successfully!! \nHello {username}, welcome to shop!!")
        main_menu(conn, username)
    else:
        print("Invalid username or password. Try again.")
    # except:
    #     print("An error occurred. Try again.")


# Main menu options
def main_menu(conn, username):
    while True:
        print("\n===== MAIN MENU =====")
        print("1. Manage account")
        print("2. View all models")
        print("3. Go to cart")
        print("0. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            account.manage_account(conn, username)
        elif choice == "2":
            viewer.view_all_models(conn, username)
        elif choice == "3":
            cart.go_to_cart(conn, username)
        elif choice == "0":
            print("Goodbye!")
            conn.close()
            break
        else:
            print("Invalid input. Try again.")


if __name__ == "__main__":
    conn = connect_to_database()
    home_page(conn)
