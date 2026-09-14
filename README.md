## ABOUT

This simple password manager was built with **Shell Scripting (Bash)** to add/update/delete user accounts and passwords. It does not have the security features of a typical password manager.

> [!WARNING]
> This is a learning exercise, not a password manager to rely on. Passwords are
> stored in plain text in `sources/user_data.csv`, with no encryption and no
> master password: anyone who can read the file can read every password in it.
> Use it with throwaway values, and keep real credentials in a tool built for
> the job.

## REQUIREMENTS

- Linux environment;
- Bash 4 or newer;
- `awk`, `grep` and `cut`, which are present on a standard install;

## USAGE

```bash
git clone https://github.com/jotavare/password-manager-shell-script.git
cd password-manager-shell-script/sources
bash password_manager.sh
```

The store is created next to the script on first run, as `user_data.csv` with
`0600` permissions, and is ignored by git so it is never committed.

| Action | Effect |
| :-- | :-- |
| `add` | Insert an account name and password. |
| `get` | Print the password for an account. |
| `update` | Replace a password, after confirming the current one. |
| `delete` | Remove a single account. |
| `delete all` | Empty the store, after confirmation. |
| `exit` | Leave the password manager. |

Account names cannot be empty or contain a comma, since one record is one
line. Passwords may contain commas.

## NOT IMPLEMENTED

Features a real password manager has and this one does not:

- Encryption
- Password Strength Validation
- Two-Factor Authentication (2FA)
- Automatic Logout
- Password Generation
- Search and Filter
- Backup and Restore
- Multiple User Support
- Category Tagging
- Audit Logs
- Password Expiry Notifications
- Graphical User Interface (GUI)
- Web Interface
- Browser Integration
- Sync Across Devices

## CONTRIBUTING

This repository holds a finished learning exercise and is not open to changes.

## LICENSE

This project is available under the MIT License. For further details, please refer to the [LICENSE](https://github.com/jotavare/password-manager-shell-script/blob/main/LICENSE) file.
