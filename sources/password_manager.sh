#!/bin/bash
# author: jotavare
# date: May 18 2024
# version: 0.0.2

# color values
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

# data file path
user_data_file="/home/$USER/Documents/password-manager-shell-script/user_data.csv"

# function to check if account name exists
account_exists() {
    local account_id="$1"
    grep -q "^$account_id," "$user_data_file"
}

# create account name and password
set_password()
{
    while true; do
        read -p "Insert account name: " account_id
        if account_exists "$account_id"; then
            echo -e "${RED}Account name already exists. Please choose another name.${RESET}"
        else
            break
        fi
    done
    read -s -p "Insert password: " password
    echo
    echo "$account_id,$password" >> "$user_data_file"
    echo -e "${GREEN}Account name and password saved!${RESET}"
}

# search specific password with account name
get_password()
{
    read -p "Insert account name to search: " account_id
    password=$(grep "^$account_id," "$user_data_file" | cut -d ',' -f 2)
    if [ -n "$password" ]; then
        echo -e "${GREEN}Your password is: $password${RESET}"
    else
        echo -e "${RED}User ID does not exist.${RESET}"
    fi
}

# update with a new password by giving a specific account name and verifying current password
update_password()
{
    read -p "Insert account name to update: " account_id
    current_password=$(grep "^$account_id," "$user_data_file" | cut -d ',' -f 2)
    if [ -n "$current_password" ]; then
        read -s -p "Enter current password: " old_password
        echo
        if [ "$old_password" == "$current_password" ]; then
            read -s -p "Enter new password: " new_password
            echo
            sed -i "s/^$account_id,.*/$account_id,$new_password/" "$user_data_file"
            echo -e "${GREEN}Password has been updated!${RESET}"
        else
            echo -e "${RED}Current password is incorrect.${RESET}"
        fi
    else
        echo -e "${RED}User ID does not exist.${RESET}"
    fi
}

# delete account name and password based on the account_id
delete_account()
{
    read -p "Insert account to delete: " account_id
    if grep -q "^$account_id," "$user_data_file"; then
        sed -i "/^$account_id,/d" "$user_data_file"
        echo -e "${RED}Account name and password have been deleted.${RESET}"
    else
        echo -e "${RED}User ID does not exist.${RESET}"
    fi
}

# delete all the data from the csv file
delete_all_accounts()
{
    read -p "Are you sure you want to delete all accounts? (y/n): " answer
    if [ "$answer" == "y" ]; then
        > "$user_data_file"
        echo -e "${RED}All accounts have been deleted.${RESET}"
    else
        echo -e "${RED}No accounts were deleted.${RESET}"
    fi
}

# initial prompt
initial_prompt()
{
    echo "---------------------------------------------------------"
    echo "Welcome to the most simple and unsecure password manager!"
    echo "---------------------------------------------------------"
    echo -e "${GREEN}add${RESET}        -> Insert account name and password."
    echo -e "${GREEN}get${RESET}        -> Search for specific account."
    echo -e "${GREEN}update${RESET}     -> Update account password."
    echo -e "${RED}delete${RESET}     -> Delete account name and password."
    echo -e "${RED}delete all${RESET} -> Delete all accounts."
    echo -e "${RED}exit${RESET}       -> Exit the password manager."
    echo "---------------------------------------------------------"
}

initial_prompt

# Enable command history
history_file="/tmp/password_manager_history"
touch "$history_file"
history -r "$history_file"

# handle the user actions
while true; do
    read -e -p "> " action
    history -s "$action"
    history -w "$history_file"
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
            echo -e "${RED}Not a valid action, please try again.${RESET}"
            ;;
    esac
done
