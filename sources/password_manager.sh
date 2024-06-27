#!/bin/bash
# author: jotavare
# date: May 18 2024
# version: 0.0.2

# color values
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

# data file path, resolved next to this script so it works from any clone
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
user_data_file="$script_dir/user_data.csv"

# the store holds plaintext credentials: create it private to this user
if [ ! -e "$user_data_file" ]; then
    (umask 077 && touch "$user_data_file")
fi

# function to check if account name exists
account_exists() {
    local account_id="$1"
    # -F and the field split keep an account name from acting as a pattern
    cut -d ',' -f 1 "$user_data_file" | grep -qxF "$account_id"
}

# print the password field for an account, or nothing if there is no match.
# cuts from field 2 to the end so a password may contain commas
lookup_password() {
    local account_id="$1"
    awk -F ',' -v id="$account_id" \
        'index($0, id ",") == 1 { print substr($0, length(id) + 2); exit }' \
        "$user_data_file"
}

# reject names that would corrupt the one-record-per-line format
valid_account_id() {
    local account_id="$1"
    if [ -z "$account_id" ]; then
        echo -e "${RED}Account name cannot be empty.${RESET}"
        return 1
    fi
    case "$account_id" in
        *,*)
            echo -e "${RED}Account name cannot contain a comma.${RESET}"
            return 1
            ;;
    esac
    return 0
}

# create account name and password
set_password()
{
    while true; do
        if ! read -p "Insert account name: " account_id; then
            echo
            return
        fi
        if ! valid_account_id "$account_id"; then
            continue
        fi
        if account_exists "$account_id"; then
            echo -e "${RED}Account name already exists. Please choose another name.${RESET}"
        else
            break
        fi
    done
    read -s -p "Insert password: " password
    echo
    if [ -z "$password" ]; then
        echo -e "${RED}Password cannot be empty. Nothing was saved.${RESET}"
        return
    fi
    echo "$account_id,$password" >> "$user_data_file"
    echo -e "${GREEN}Account name and password saved!${RESET}"
}

# search specific password with account name
get_password()
{
    read -p "Insert account name to search: " account_id
    password=$(lookup_password "$account_id")
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
    current_password=$(lookup_password "$account_id")
    if [ -n "$current_password" ]; then
        read -s -p "Enter current password: " old_password
        echo
        if [ "$old_password" == "$current_password" ]; then
            read -s -p "Enter new password: " new_password
            echo
            if [ -z "$new_password" ]; then
                echo -e "${RED}Password cannot be empty. Nothing was changed.${RESET}"
                return
            fi
            # rewrite through a temporary file so a failure cannot truncate
            # the store, and report what actually happened
            local tmp
            tmp=$(mktemp "$script_dir/.pm_XXXXXX") || return
            chmod 600 "$tmp"
            if awk -F ',' -v id="$account_id" -v pw="$new_password" \
                'index($0, id ",") == 1 { print id "," pw; next } { print }' \
                "$user_data_file" > "$tmp" && mv "$tmp" "$user_data_file"; then
                echo -e "${GREEN}Password has been updated!${RESET}"
            else
                rm -f "$tmp"
                echo -e "${RED}Could not write to the data file. Nothing was changed.${RESET}"
                return
            fi
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
    if account_exists "$account_id"; then
        local tmp
        tmp=$(mktemp "$script_dir/.pm_XXXXXX") || return
        chmod 600 "$tmp"
        if awk -F ',' -v id="$account_id" \
            'index($0, id ",") == 1 { next } { print }' \
            "$user_data_file" > "$tmp" && mv "$tmp" "$user_data_file"; then
            echo -e "${RED}Account name and password have been deleted.${RESET}"
        else
            rm -f "$tmp"
            echo -e "${RED}Could not write to the data file. Nothing was deleted.${RESET}"
        fi
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

# Enable command history. Kept beside the store rather than in /tmp, which
# every user on the machine can read
history_file="$script_dir/.password_manager_history"
(umask 077 && touch "$history_file")
history -r "$history_file"

# handle the user actions
while true; do
    if ! read -e -p "> " action; then
        echo
        echo "Exiting password manager..."
        break
    fi
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
