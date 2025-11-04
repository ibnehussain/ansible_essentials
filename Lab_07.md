# Lab 7: Implementing Ansible Vault

Change to the lab folder and encrypt `implement-vars.yml` using ansible-vault:
```bash
ansible-vault encrypt implement-vars.yml
```

View encrypted file (requires vault password):
```bash
ansible-vault view implement-vars.yml
```

Run encrypted playbook:
```bash
ansible-playbook --ask-vault-pass implement-vars.yml
```

Edit with vault utility:
```bash
ansible-vault edit implement-vars.yml
```

Rekey (change vault password):
```bash
ansible-vault rekey implement-vars.yml
```

To decrypt:
```bash
ansible-vault decrypt implement-vars.yml
```
