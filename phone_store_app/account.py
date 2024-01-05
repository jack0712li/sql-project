def manage_account(conn, username):
    while True:
        # display all user payments
        # with conn.cursor() as cursor:
        #     cursor.callproc("display_user_payment", (username,))
        #     result = cursor.fetchall()
        #     if not result:
        #         print("You haven't added any payment yet.")
        #     else:
        #         print("Your saved payments:")
        #         for i, row in enumerate(result):
        #             print(
        #                 f"{i+1}. Card number: {row[0]}, Card type: {row[1]}, Expiration date: {row[2]}"
        #             )

        # display options
        print("\n===== Manage Account =====")
        print("1. Edit account info")
        print("2. View all payment")
        print("3. Add new payment")
        print("0. Back to main menu")

        # # display options
        # print("\nSelect an option:")
        # print("1. Edit account info")
        # print("2. Add new payment")
        # print("3. Edit payment")
        # print("4. Delete payment")
        # print("5. Back to main menu")

        option = input("Enter your choice: ")

        if option == "1":
            # edit account info
            # prompt user to enter new account info
            print("\n===== Edit account info =====")
            try:

                first_name = input("First name: ")
                last_name = input("Last name: ")
                email = input("Email: ")
                password = input("Password: ")
                phone_no = input("Phone number: ")
                address = input("Address: ")
                zip_code = input("Zip code: ")

                # call stored procedure to update account info
                with conn.cursor() as cursor:
                    cursor.callproc(
                        "edit_account_info",
                        (
                            username,
                            first_name,
                            last_name,
                            email,
                            password,
                            phone_no,
                            address,
                            zip_code,
                        ),
                    )
                    conn.commit()
                    print("DONE: Account info updated!")
            except Exception as e:
                print("Input account info invalid, please try again.")
            input("\n(Input any key, back to Manage Account.)")

        elif option == "2":
            print("\n===== Your added payment methods =====")
            cursor = conn.cursor()
            cursor.callproc("display_user_payment", (username,))
            results = cursor.fetchall()
            if not results:
                print("You have not added any payment methods yet. ")
            else:

                for result in results:
                    print(
                        f"Card No: {result[0]}, Card Type: {result[1]}, Expiration Date: {result[2]}"
                    )
            input("\n(Input any key, back to Manage Account.)")

        elif option == "3":
            # add new payment
            # prompt user to enter new payment info
            print("\n===== Add new payment =====")
            try:
                card_no = input("Card number: ")
                card_type = input(
                    "\nSupport card type: \n   1. Credit Card \n   2. Debit Card \n   3. Gift Card \nChoose card type: "
                )
                while card_type not in ["1", "2", "3"]:
                    card_type = input(
                        f"\nInvalid card type: {card_type}. Support card type: \n   1. Credit Card \n   2. Debit Card \n   3. Gift Card \nChoose card type: "
                    )
                if card_type == "1":
                    card_type_str = "Credit Card"
                elif card_type == "2":
                    card_type_str = "Debit Card"
                else:
                    card_type_str = "Gift Card"

                expiration_date = input("Expiration date (YYYY-MM-DD): ")

                # call stored procedure to add new payment
                with conn.cursor() as cursor:
                    cursor.callproc(
                        "add_new_payment",
                        (username, card_no, card_type_str, expiration_date),
                    )
                    conn.commit()
                    print("New payment added.")
            except Exception as e:
                print("Input payment info invalid, please try again.")
            input("\n(Input any key, back to Manage Account.)")

        # elif option == "3":
        #     # edit payment
        #     payment_id = int(input("Enter payment ID to edit: "))

        #     # prompt user to enter new payment info
        #     card_no = input("Card number: ")
        #     card_type = input("Card type: ")
        #     expiration_date = input("Expiration date (YYYY-MM-DD): ")

        #     # call stored procedure to update payment info
        #     with conn.cursor() as cursor:
        #         cursor.callproc(
        #             "edit_payment", (payment_id, card_no, card_type, expiration_date)
        #         )
        #         conn.commit()
        #         print("Payment info updated.")

        # elif option == "4":
        #     # delete payment
        #     payment_id = int(input("Enter payment ID to delete: "))

        #     # call stored procedure to delete payment
        #     with conn.cursor() as cursor:
        #         cursor.callproc("delete_payment", (payment_id,))
        #         conn.commit()
        #         print("Payment deleted.")

        elif option == "0":
            # go back to main menu
            break

        else:
            print("Invalid option. Please try again.")
