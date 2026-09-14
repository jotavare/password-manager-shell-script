<p align="center">
	<img src="https://img.shields.io/badge/status-finished-success?color=%2312bab9&style=flat-square"/>
	<img src="https://img.shields.io/github/languages/top/jotavare/password-manager-shell-script?color=%2312bab9&style=flat-square"/>
	<img src="https://img.shields.io/github/last-commit/jotavare/password-manager-shell-script?color=%2312bab9&style=flat-square"/>
	<a href='https://www.linkedin.com/in/jotavare' target="_blank"><img alt='Linkedin' src='https://img.shields.io/badge/LinkedIn-blue?style=flat-square'/></a>
</p>

<p align="center">
	<a href="#about">About</a> •
	<a href="#requirements">Requirements</a> •
	<a href="#usage">Usage</a> •
	<a href="#not-implemented">Not implemented</a> •
	<a href="#contributing">Contributing</a> •
	<a href="#license">License</a>
</p>

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

An example session, with the password hidden as it is typed:

```
---------------------------------------------------------
Welcome to the most simple and unsecure password manager!
---------------------------------------------------------
add        -> Insert account name and password.
get        -> Search for specific account.
update     -> Update account password.
delete     -> Delete account name and password.
delete all -> Delete all accounts.
exit       -> Exit the password manager.
---------------------------------------------------------
> add
Insert account name: github
Insert password:
Account name and password saved!
> get
Insert account name to search: github
Your password is: hunter2
> exit
Exiting password manager...
```


## NOT IMPLEMENTED

The absences that matter for something holding passwords:

- Encryption, the store is plain text
- A master password, anything that can read the file can read every entry
- Password generation
- Password strength validation

## CONTRIBUTING

This repository holds a finished learning exercise and is not open to changes.

## LICENSE

This project is available under the MIT License. For further details, please refer to the [LICENSE](https://github.com/jotavare/password-manager-shell-script/blob/main/LICENSE) file.
