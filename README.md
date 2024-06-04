# Vault Keyring Client

This project provides an installable version of the original community script `vault-keyring-client.py` for Ansible, allowing you to manage vault passwords using your OS's native keyring application.

## Description

The `vault-keyring-client` is a CLI tool to store and retrieve Ansible vault passwords in the keyring. This version is implemented using `typer` for a modern CLI interface, making it easy to use and extend.

## Installation

To install the `vault-keyring-client`, you can use [Poetry](https://python-poetry.org/):

```sh
poetry add vault-keyring-client
```

## Usage

The `vault-keyring-client` provides the following commands:

- `get_password`: Retrieve a password from the keyring.
- `set_password`: Store a password in the keyring.
- `delete_password`: Delete a password from the keyring.

### Examples

Retrieve a password:

```sh
poetry run vault-keyring-client --vault-id myservice --username myuser
```

Store a password:

```sh
poetry run vault-keyring-client --vault-id myservice --username myuser --set
```

Delete a password:

```sh
poetry run vault-keyring-client delete-password --vault-id myservice --username myuser
```

## Original Script

This project is based on the original `vault-keyring-client.py` script contributed by Matt Martz and Justin Mayer. The original script can be found in the Ansible Community's contrib-scripts repository:

[Original vault-keyring-client.py script](https://github.com/ansible-community/contrib-scripts/blob/main/vault/vault-keyring-client.py)

## License

This project is licensed under the GNU General Public License v3.0 or later. See the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) file for details.
