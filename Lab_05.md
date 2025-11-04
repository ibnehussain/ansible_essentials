# Lab 5: Ansible Vault for Secrets Management

## Objective
Learn to secure sensitive data using Ansible Vault encryption and decryption features.

## Prerequisites
- Completed Labs 1-4
- Understanding of variables and playbooks

## Lab Steps

### Step 1: Create Encrypted Variable File

Create an encrypted variable file:
```bash
ansible-vault create secret_vars.yml
```

Enter a vault password when prompted. Add the following content:
```yaml
---
db_password: MySecretPassword123
api_key: abc123def456ghi789
admin_password: SuperSecretAdmin
```

### Step 2: View Encrypted File Content

View the encrypted file (requires password):
```bash
ansible-vault view secret_vars.yml
```

Try to view with cat (shows encrypted content):
```bash
cat secret_vars.yml
```

### Step 3: Edit Encrypted Variables

Edit the encrypted file:
```bash
ansible-vault edit secret_vars.yml
```

Add a new variable:
```yaml
ssh_private_key: |
  -----BEGIN RSA PRIVATE KEY-----
  MIIEpAIBAAKCAQEA...
  -----END RSA PRIVATE KEY-----
```

### Step 4: Create Playbook Using Vault Variables

Create `vault-demo-playbook.yml`:
```yaml
---
- name: Vault variables demo
  hosts: localhost
  become: yes
  vars_files:
    - secret_vars.yml
  vars:
    app_name: secure_app
    config_path: /etc/secure_app
  tasks:
    - name: Create application directory
      file:
        path: "{{ config_path }}"
        state: directory
        mode: '0750'
    
    - name: Create configuration file with secrets
      copy:
        content: |
          [database]
          password={{ db_password }}
          
          [api]
          key={{ api_key }}
          
          [admin]
          password={{ admin_password }}
        dest: "{{ config_path }}/app.conf"
        mode: '0600'
    
    - name: Display configuration file location
      debug:
        msg: "Configuration created at {{ config_path }}/app.conf"
```

### Step 5: Run Playbook with Vault

Execute playbook with vault password prompt:
```bash
ansible-playbook vault-demo-playbook.yml --ask-vault-pass
```

Run with vault password file:
```bash
echo "your_vault_password" > .vault_pass
```
```bash
chmod 600 .vault_pass
```
```bash
ansible-playbook vault-demo-playbook.yml --vault-password-file .vault_pass
```

### Step 6: Vault File Operations

Decrypt a vault file:
```bash
ansible-vault decrypt secret_vars.yml
```

Encrypt an existing file:
```bash
ansible-vault encrypt secret_vars.yml
```

Change vault password:
```bash
ansible-vault rekey secret_vars.yml
```

### Step 7: Multiple Vault IDs

Create vault with specific ID:
```bash
ansible-vault create --vault-id prod@prompt prod_secrets.yml
```

Create dev environment vault:
```bash
ansible-vault create --vault-id dev@prompt dev_secrets.yml
```

Run playbook with multiple vault IDs:
```bash
ansible-playbook vault-demo-playbook.yml --vault-id prod@prompt --vault-id dev@prompt
```

## Key Concepts Learned
- Creating encrypted files with `ansible-vault create`
- Viewing and editing encrypted content
- Using vault variables in playbooks with `vars_files:`
- Running playbooks with `--ask-vault-pass`
- Vault password files for automation
- Multiple vault IDs for different environments
- File encryption and decryption operations

## Security Best Practices
- Never commit vault passwords to version control
- Use different vault passwords for different environments
- Set proper file permissions on vault password files
- Regularly rotate vault passwords
- Use vault IDs for better organization

## Troubleshooting
- Ensure correct vault password is provided
- Check file permissions on vault files
- Verify YAML syntax in encrypted files
- Use `ansible-vault view` to debug encrypted content