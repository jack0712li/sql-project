import plot


def display_result(result):
    # print(
    #     "ID\tModel\tProcessor\tPrice\tScreen\tMemory\tRelease\tBattery\tStorage\tColor\tCompany"
    # )
    for row in result:

        # print("\t".join([str(x) for x in row]))
        # print(
        #     f"ID: {row[0]}, Model: {row[1]}, Processor: {row[2]}, Price: {row[3]}, Screen: {row[4]}, Memory: {row[5]}, Release: {row[6]}, Battery: {row[7]}, Storage: {row[8]}, Color: {row[9]}, Company: {row[10]}"
        # )
        print(
            f"ID: {row[0]}, Model: {row[1]}, Color: {row[9]}, Price: {row[3]}, Release: {row[6]}"
        )


def view_all_models(conn, username):
    # Call stored procedure to display all models
    cursor = conn.cursor()
    cursor.callproc("display_all_models")
    result = cursor.fetchall()

    print("\n===== Available models =====")
    display_result(result)

    while True:
        # Prompt user for option
        print("\n===== View options =====")
        print("1. Filter by brand")
        print("2. Filter by color")
        print("3. Filter by price")
        print("4. View item detail")
        print("5. Add item to cart")
        print("6. View price statics")
        print("7. View release year statics")
        print("0. Back to Main menu")

        option = input("Enter option number: ")

        if option == "1":
            # Prompt user for brand keyword
            brand = input("Enter brand keyword: ")
            # Call stored procedure to display models by brand
            cursor.callproc("display_by_brand", [brand])
            result = cursor.fetchall()
            print(f"\n===== Search result for brand '{brand}' =====")
            if result:

                display_result(result)
            else:
                print(f"No result for brand '{brand}'. ")

        elif option == "2":
            # Prompt user for color
            color = input("Enter color: ")
            # Call stored procedure to display models by color
            cursor.callproc("display_by_color", [color])
            result = cursor.fetchall()
            print(f"\n===== Search result for color '{color}' =====")
            if result:

                display_result(result)
            else:
                print(f"No result for color '{color}'.")

        elif option == "3":
            # Prompt user for price range
            price_low = input("Enter lowest price: ")
            price_high = input("Enter highest price: ")
            # Call stored procedure to display models by price range
            cursor.callproc("display_by_price", [price_low, price_high])
            result = cursor.fetchall()
            print(
                f"\n===== Search result for price range: {price_low} - {price_high} ====="
            )
            if result:

                display_result(result)
            else:
                print(f"No result for price range {price_low} - {price_high}. ")
        elif option == "4":
            # view item detail
            item_id = input("Enter item ID: ")
            print(f"\n===== Detail Info of Item: {item_id} =====")

            cursor.callproc("show_item_detail", [item_id])
            result = cursor.fetchall()
            if result:
                info = result[0]
                print(f"\nCompany Info:")
                print(f"  Name: {info[10]}")
                print(f"  Website: {info[11]}")
                print(f"  Address: {info[12]}")
                print(f"  Phone: {info[13]}")

                print(f"\nDiscount Info:")
                print(f"  Discount Code: {info[14]}")
                print(f"  Discount Rate: {info[15]}")
                print(f"  Start Date: {info[16]}")
                print(f"  Expiration Date: {info[17]}")

                print(f"\nModel Specifications:")
                print(f"  Model ID: {info[0]}")
                print(f"  Model Name: {info[1]}")
                print(f"  Processor: {info[2]}")
                print(f"  Price: {info[3]}")
                print(f"  Screen Size: {info[4]}")
                print(f"  Memory Size: {info[5]}")
                print(f"  Release Date: {info[6]}")
                print(f"  Battery Size: {info[7]}")
                print(f"  Storage: {info[8]}")
                print(f"  Color: {info[9]}")

                print(f"\nModel Feature:")
                print(f"  Keyword: {info[18]}")
                print(f"  Description: {info[19]}")

            else:
                print(f"Can not find Item ID: {item_id}.")
            input("(Enter any key, back to View options.)")

        elif option == "5":
            # Prompt user for item ID to add to cart
            item_id = input("Enter item ID: ")
            cursor.callproc("get_model_inventory", [item_id])
            result = cursor.fetchall()
            if result:
                max_qty = result[0][0]
                print(f"\n===== Current storage: {max_qty} =====")
                item_qty = input("Enter item quantity: ")

                while int(item_qty) > max_qty or int(item_qty) < 1:
                    print(
                        f"\n===== Invalid quantity!! (Current storage: {max_qty}) ====="
                    )
                    item_qty = input("Enter item quantity: ")

                # Call stored procedure to add item to cart
                cursor.callproc("user_add_cart_item", [username, item_id, item_qty])
                conn.commit()
                print(f"DONE: {item_qty} Item {item_id} added to cart!!")
            else:
                print(f"FAIL: Can not find Item ID: {item_id}.")

        elif option == "6":
            cursor = conn.cursor()
            cursor.callproc("display_all_models")
            result = cursor.fetchall()
            prices = [int(row[3]) for row in result]
            # print(prices)
            plot.plot(prices, 500, "Price")

        elif option == "7":
            cursor = conn.cursor()
            cursor.callproc("display_all_models")
            result = cursor.fetchall()
            years = [int(str(row[6])[:4]) for row in result]
            plot.plot(years, 10, "Price")

        elif option == "0":
            # Return to main menu
            break

        else:
            print("Invalid option. Try again.")
