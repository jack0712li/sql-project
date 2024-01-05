def go_to_cart(conn, username):
    while True:
        cursor = conn.cursor()
        cursor.callproc("display_user_cart", (username,))
        results = cursor.fetchall()
        all_ids = set()

        print("\n===== Your cart =====")
        if results:
            all_ids = set(x[0] for x in results)
            for result in results:
                print(
                    f"ID: {result[0]}, Model: {result[1]}, Price: {result[2]}, Quantity: {result[3]}"
                )
        else:
            print("Your cart is empty. ")

        print("\n===== Cart Options =====")
        print("1. Edit item quantity")
        print("2. Delete item")
        print("3. Submit order")
        print("4. View order history")
        print("0. Back to Main menu")
        choice = input("Enter option number: ")
        if choice == "1":
            item_id = input("Enter ID of item to edit: ")
            # while True:
            #     print(f"FAIL: Item {item_id} not in cart.")
            #     item_id = input("Enter ID of item to edit: ")

            try:
                if int(item_id) in all_ids:
                    cursor.callproc("get_model_inventory", [item_id])
                    result = cursor.fetchall()
                    if result:
                        max_qty = result[0][0]
                        print(f"\n===== Current storage: {max_qty} =====")
                        item_qty = input("Enter new quantity: ")

                        while int(item_qty) > max_qty or int(item_qty) < 1:
                            print(
                                f"\n===== Invalid quantity!! (Current storage: {max_qty}) ====="
                            )
                            item_qty = input("Enter new quantity: ")

                        # Call stored procedure to add item to cart
                        cursor.callproc(
                            "user_edit_cart_item", [username, item_id, item_qty]
                        )
                        conn.commit()
                        print("DONE: Item updated.")
                    else:
                        print(f"FAIL: Item {item_id} out of stock.")

                else:
                    print(f"FAIL: Item {item_id} not in your cart.")

            except:
                break
            input("\n(Input any key, back to cart.)")

        elif choice == "2":
            item_id = input("Enter ID of item to delete: ")
            try:
                if int(item_id) not in all_ids:
                    print(f"FAIL: Item {item_id} not in cart.")
                else:
                    cursor.callproc("user_delete_cart_item", (username, item_id))
                    conn.commit()
                    print("DONE: Item deleted.")
            except:
                break
            input("\n(Input any key, back to cart.)")

        elif choice == "3":
            # 3. Submit order
            print("\n===== Select a payment method =====")

            cursor.callproc("display_user_payment", (username,))
            results = cursor.fetchall()
            if not results:
                print(
                    "You have not added any payment methods yet. \nGo to MAIN MENU >> Manage Account >> Add new payment to add."
                )
            else:

                for result in results:
                    print(
                        f"Card No: {result[0]}, Card Type: {result[1]}, Expiration Date: {result[2]}"
                    )
                all_payment = set(x[0] for x in results)
                payment_id = input("Enter payment ID: ")
                while int(payment_id) not in all_payment:
                    print(f"Invalid payment id: {payment_id}")
                    payment_id = input("Enter payment ID: ")
                else:
                    cursor.callproc("create_order", (username, payment_id))
                    conn.commit()
                    print("Order submitted.")

            input("\n(Input any key, back to cart.)")

        elif choice == "4":
            # display order history
            print("\n===== Your order history =====")
            cursor = conn.cursor()
            cursor.callproc("show_user_order_history", [username])
            results = cursor.fetchall()
            if results:
                for row in results:
                    print(
                        f"Order Id: {row[0]} | Date: {row[1]} {row[2]} | Payment: {row[4]} "
                    )
                    cursor.callproc("show_order_detail", [row[0]])
                    order_detail = cursor.fetchall()
                    tot = 0
                    for d in order_detail:
                        print(
                            f"   Model ID: {d[0]}, Model Name: {d[1]}, Price: {d[3]}, Quantity: {d[10]}"
                        )
                        tot += int(d[3]) * int(d[10])
                    print(f"Order total price: {tot}.\n")

            else:
                print("No order history found.")
            input("\n(Input any key, back to cart.)")

        elif choice == "0":
            return
        else:
            print("Invalid choice. Please try again.")
