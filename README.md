# Vault Keyring Client

[![PyPI](https://img.shields.io/pypi/v/vault-keyring-client)](https://pypi.org/project/vault-keyring-client/)
[![License: GPL-3.0-or-later](https://img.shields.io/badge/license-GPL--3.0--or--later-blue)](LICENSE)

Keep your Ansible vault passwords in your operating system's keyring and let
Ansible fetch them on its own. No plaintext password files, no prompts on every
run.

<p align="center">
  <img src=".github/assets/keyring-flow.svg" width="100%" alt="Diagram: ansible-playbook asks vault-keyring-client for the vault id my_vault_id, the client reads the matching password from the OS keyring and hands it back, and Ansible decrypts ~/.become_passwords.yml without prompting.">
</p>

`vault-keyring-client` is an installable, [Typer](https://typer.tiangolo.com/)
based version of the community script `vault-keyring-client.py`. Ansible calls
it as a vault password client: it looks up the password for a vault id in the
keyring and prints it to stdout.

## Install

Requires Python 3.11 or newer. The package is published on
[PyPI](https://pypi.org/project/vault-keyring-client/) and installs the
`vault-keyring-client` command:

```console
$ uv tool install vault-keyring-client   # or: pipx install vault-keyring-client
$ pip install vault-keyring-client        # into the current environment
```

## Usage

```console
$ vault-keyring-client --set --vault-id my_vault_id   # store a password
$ vault-keyring-client --vault-id my_vault_id         # print it
```

**Options**:

- `--vault-id TEXT`: Name of the vault secret to get from keyring.
- `--username TEXT`: The username whose keyring is queried.
- `--set`: Set the password instead of getting it.
- `--install-completion`: Install completion for the current shell.
- `--show-completion`: Show completion for the current shell, to copy it or
  customize the installation.
- `--help`: Show this message and exit.

When an option is left out, the client falls back to the `[vault]` section of
your Ansible config, then to a built-in default:

| Option       | `ansible.cfg` key  | Default         |
| ------------ | ------------------ | --------------- |
| `--vault-id` | `[vault] keyname`  | `ansible`       |
| `--username` | `[vault] username` | your login name |

If no password is stored for that key, it prints `No password found.` and exits
with code 2.

## Using with Ansible

The client removes the need to type `become_pass` for each host. Set it up once:

1. **Create an entry**: store the vault password with
   `vault-keyring-client --set --vault-id my_vault_id`.

2. **Configure Ansible**: to make Ansible try the passwords stored in your
   keyring, add the following to your `.envrc` or source it from your `.env`
   file:

   ```bash
   export ANSIBLE_VAULT_IDENTITY_LIST="my_vault_id@$(command -v vault-keyring-client),my_other_vault_id@$(command -v vault-keyring-client)"
   ```

3. **Create a secure vault**: create a vault file outside of your repository to
   avoid accidental commits, for example `~/.become_passwords.yml`. Structure
   the key-value pairs as `become_pass_<hostname>: "mytopsecret_host_password"`
   and encrypt the file:

   ```sh
   ansible-vault encrypt --encrypt-vault-id my_vault_id <path_to_vault>
   ```

4. **Update playbooks**: point your playbooks at the stored passwords:

   ```yml
   - name: Playbook that does not require manual sudo passwords
     hosts: amazing_host
     become: true
     vars:
       ansible_become_password:
         "{{ lookup('vars', 'become_pass_' + inventory_hostname) }}"
     vars_files:
       - ~/.become_passwords.yml
     roles:
       - users
   ```

   When you run the playbook, Ansible tries each id in
   `ANSIBLE_VAULT_IDENTITY_LIST` in order, uses the one that unlocks
   `~/.become_passwords.yml`, and picks the password matching each host.

## Credits

This project is based on the original `vault-keyring-client.py` script
contributed by Matt Martz and Justin Mayer to the Ansible Community's
contrib-scripts repository:
[original vault-keyring-client.py script](https://github.com/ansible-community/contrib-scripts/blob/main/vault/vault-keyring-client.py).

## License

Licensed under the GNU General Public License v3.0 or later. See
[LICENSE](LICENSE) for details.
