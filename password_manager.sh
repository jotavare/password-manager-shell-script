#!/bin/bash
# author: jotavare
# date: May 18 2024
# version: 0.0.1

# data file path
user_data_file="/home/$USER/Documents/password-manager-shell-script/user_data.csv"

# create account name and password
set_password()
{
    read -p "Insert account name: " account_id
    read -s -p "Insert password: " password
    echo "$account_id,$password" >> "$user_data_file"
    echo "Account name and password saved!"
}

# search specific password with account name
get_password()
{
    read -p "Insert account name to search: " account_id
    password=$(grep "^$account_id," "$user_data_file" | cut -d ',' -f 2)
    if [ -n "$password" ]; then
        echo "Your password is: $password"
    else
        echo "User ID does not exist."
    fi
}

# update with a new password by giving a specific account name
update_password()
{
    read -p "Insert account name to update: " account_id
    if grep -q "^$account_id," "$user_data_file"; then
        read -s -p "Enter new password: " password
        sed -i "s/^\($account_id,\).*/\1$password/" "$user_data_file"
        echo "Password has been updated!"
    else
        echo "User ID does not exist."
    fi
}

# delete account name and password based on the account_id
delete_account()
{
    read -p "Insert account to delete: " account_id
    if grep -q "^$account_id," "$user_data_file"; then
        sed -i "/^$account_id,/d" "$user_data_file"
        echo "Account name and password have been deleted."
    else
        echo "User ID does not exist."
    fi
}

# delete all the data from the csv file
delete_all_accounts()
{
	read -p "Are you sure you want to delete all accounts? (y/n): " answer
	if [ "$answer" == "y" ]; then
		> "$user_data_file"
		echo "All accounts have been deleted."
	else
		echo "No accounts were deleted."
	fi

}

# get user input
inicial_prompt()
{
	echo "---------------------------------------------------------"
	echo "Welcome to the most simple and unsecure password manager!"
	echo "---------------------------------------------------------"
	echo "add	- Insert account name and password"
	echo "get	- Search for specific account"
	echo "update	- Update account password"
	echo "delete	- Delete account name and password"
	echo "delete all	- Delete all accounts"
	echo "exit	- Exit the password manager"
	echo "---------------------------------------------------------"
}

inicial_prompt

# handle the user actions
while true; do
    read -p "> " action
    case "$action" in
        add)
            set_password
            ;;
        get)
            get_password
            ;;
        update)
            update_password
            ;;
        delete)
            delete_account
            ;;
		delete\ all)
			delete_all_accounts
			;;
        exit)
            echo "Exiting password manager..."
            break
            ;;
        *)
            echo "Not a valid action, please try again."
            ;;
    esac
done
