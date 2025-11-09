
# 🧪 Lab 7: Working with Ansible Vault

This lab will teach you how to **secure sensitive data** in Ansible using **Vault**.

---

## 🎯 Objectives

By the end of this lab, you will be able to:
- Understand what Ansible Vault is and why it’s used
- Create and manage encrypted files using Vault
- Use Vault-encrypted variables inside playbooks
- Manage access securely across users and environments

---

## 🧰 Prerequisites

Before you start, make sure you have:
- **Ansible installed** on your control node
- Basic knowledge of **playbooks** and **variables**
- Access to a terminal with **sudo privileges**

Check your Ansible version:
```bash
ansible --version
```

---

## Step 1️⃣: Create a Sensitive Variable File

First, create a variable file containing sensitive data.

```bash
vi secret_vars.yml
```

Add the following content:

```yaml
db_user: admin
db_password: MySecret123
```

### **🔍 Verify the Plaintext File**

Before encryption, let's examine the file to understand its current state:

**View the file contents:**
```bash
cat secret_vars.yml
```

**Check file size and properties:**
```bash
ls -la secret_vars.yml
```

**Expected Output:**
```
db_user: admin
db_password: MySecret123
```

**💡 Notice:** The file is currently in **plaintext format** - anyone with file access can read the sensitive data.

---

## Step 2️⃣: Encrypt the File

Encrypt the file using Ansible Vault:

```bash
ansible-vault encrypt secret_vars.yml
```

You will be prompted to **enter a vault password** (choose a strong one).

### **🔍 Verify the Encrypted File**

After encryption, let's examine how the file has changed:

**View the encrypted file contents:**
```bash
cat secret_vars.yml
```

**Check if file size changed:**
```bash
ls -la secret_vars.yml
```

**Generate new checksum to see the change:**
```bash
md5sum secret_vars.yml
```

**View just the header of the encrypted file:**
```bash
head -n 3 secret_vars.yml
```

**Expected Output:**
```
$ANSIBLE_VAULT;1.1;AES256
66396634666336366636643935323763653332663266623...
38336533313336333937396363343534396265653735373...
```

**💡 Key Observations:**
- ✅ **File header**: Starts with `$ANSIBLE_VAULT;1.1;AES256`
- ✅ **Content encrypted**: Original YAML is now unreadable ciphertext
- ✅ **File size increased**: Encryption adds metadata and padding

### **🔒 Security Verification**

Try to read the file as YAML to confirm it's properly encrypted:

```bash
ansible-playbook -e "@secret_vars.yml" /dev/null 2>&1 | head -n 3
```

**Expected:** You should see an error indicating the file cannot be parsed as YAML, confirming successful encryption.

---

## Step 3️⃣: Use the Vault File in a Playbook

Create a new playbook `vault_play.yml`:

```yaml
---
- name: Using Ansible Vault Variables
  hosts: localhost
  vars_files:
    - secret_vars.yml
  tasks:
    - name: Print database credentials
      debug:
        msg: "Database user: {{ db_user }}, password: {{ db_password }}"
```

---

## Step 4️⃣: Run the Playbook with Vault Password Prompt

Run the playbook and provide the vault password when prompted:

```bash
ansible-playbook vault_play.yml --ask-vault-pass
```

Expected output:

```
TASK [Print database credentials] ****************************************
ok: [localhost] => {
    "msg": "Database user: admin, password: MySecret123"
}
```

---

## Step 5️⃣: Use a Vault Password File 

If you don’t want to enter the password each time, store it in a file:

```bash
echo "MyVaultPassword" > ~/.vault_pass.txt
chmod 600 ~/.vault_pass.txt
```

Then run your playbook as:

```bash
ansible-playbook vault_play.yml --vault-password-file ~/.vault_pass.txt
```

---

## Step 6️⃣: Edit or View the Encrypted File

To **view** the contents of an encrypted file:
```bash
ansible-vault view secret_vars.yml
```

To **edit** it:
```bash
ansible-vault edit secret_vars.yml
```

To **decrypt** it:
```bash
ansible-vault decrypt secret_vars.yml
```

---

## Step 7️⃣: Rekeying (Changing Vault Password)

If you ever need to change the vault password for all files:

```bash
ansible-vault rekey secret_vars.yml
```

You'll be prompted for the **old password** and then the **new password**.

---

## 📖 **Cloud Secret Management Overview**

For production environments, consider integrating Ansible Vault with cloud secret management services:

### **🔑 Popular Cloud Secret Managers:**
- **AWS Secrets Manager**: Securely store and retrieve vault passwords
- **Azure Key Vault**: Centralized secret management for Azure environments  
- **HashiCorp Vault**: Enterprise-grade secret management across platforms
- **Google Secret Manager**: Secure secret storage for GCP workloads

### **🏢 Multi-User Access Management:**
When multiple users share control nodes, implement proper access controls:
- Use dedicated service accounts for vault access
- Implement role-based permissions (RBAC)
- Store vault passwords in secure, shared locations
- Regular password rotation policies

### **💡 Best Practices:**
- Never commit vault passwords to version control
- Use different vault passwords for different environments
- Implement automated vault password rotation
- Monitor vault access and usage patterns

---

## ✅ Summary

| Command | Description |
|----------|-------------|
| `ansible-vault create file.yml` | Create and encrypt a new file |
| `ansible-vault encrypt file.yml` | Encrypt an existing file |
| `ansible-vault decrypt file.yml` | Decrypt a file |
| `ansible-vault view file.yml` | View encrypted file |
| `ansible-vault edit file.yml` | Edit encrypted file |
| `ansible-vault rekey file.yml` | Change the vault password |
| `ansible-playbook play.yml --ask-vault-pass` | Run with prompt |
| `ansible-playbook play.yml --vault-password-file` | Run with password file |

---

## 🧩 Advanced Lab Exercises: Vault Testing & Security

### **🔒 Before You Begin - Create Backup**

Always make a backup of your Vault file before testing destructive operations:

```bash
cp secret_vars.yml secret_vars.yml.bak
```

---

### **Step 10: Inspect and Checksum the Encrypted File**

**Purpose:** Learn how to view the structure of an encrypted file and verify its integrity.

**View the first few lines of the vault file:**
```bash
head -n 5 secret_vars.yml
```

**Generate a checksum:**
```bash
sha256sum secret_vars.yml > secret_vars.yml.sha256
```

**Display checksum value:**
```bash
cat secret_vars.yml.sha256
```

**Expected Output:**  
- The file begins with `$ANSIBLE_VAULT;1.1;AES256`
- A unique SHA-256 checksum is saved for integrity verification

---

### **Step 11: Corrupt the Vault File (Intentional Tampering)**

**Purpose:** See how Ansible detects tampering or corruption.

```bash
# Make a copy to test on
cp secret_vars.yml secret_vars_corrupt.yml
```

```bash
# Modify a single byte in the file
sed -i 's/a/b/' secret_vars_corrupt.yml
```

```bash
# Attempt to view it with Vault
ansible-vault view secret_vars_corrupt.yml --ask-vault-pass
```

**Expected Output:**  
You will get an error such as:
```
Decryption failed
AnsibleVaultError: Decryption failed (invalid checksum or data)
```

**💡 Learning:** Vault files have built-in integrity checks—any corruption invalidates the file.

---

### **Step 12: Test Wrong Password Behavior**

**Purpose:** Observe how Ansible behaves with incorrect passwords.

```bash
# Create a fake password file
echo "wrongpassword" > /tmp/wrong_pass.txt
```

```bash
# Try running a playbook using the wrong password
ansible-playbook vault_play.yml --vault-password-file /tmp/wrong_pass.txt
```

**Expected Output:**  
```
ERROR! Decryption failed
```

**💡 Learning:** Vault enforces strong password-based access. No partial decryption or hints are given.

---

### **Step 13: Advanced Rekeying (Password Rotation)**

**Purpose:** Practice rotating (changing) the Vault password safely.

```bash
# Change the vault password for an existing file
ansible-vault rekey secret_vars.yml
```

You'll be prompted to enter:
1. The **old password**
2. The **new password**

```bash
# Verify the new password works
ansible-vault view secret_vars.yml --ask-vault-pass
```

**💡 Learning:** Rekeying allows password rotation without touching variable content.

---

### **Step 14: Convert Plaintext Files to Vault and Back**

**Purpose:** Learn to encrypt and decrypt files on demand.

Create a plaintext file first:
```bash
cat > plain_vars.yml << EOF
web_port: 8080
app_name: "MyWebApp"
debug_mode: true
EOF
```

```bash
# Encrypt a plaintext variable file
ansible-vault encrypt plain_vars.yml
```

```bash
# Verify it's now encrypted
head -n 3 plain_vars.yml
```

```bash
# Decrypt it back to plaintext
ansible-vault decrypt plain_vars.yml
```

**Expected Output:**  
- File becomes unreadable after encryption  
- After decryption, it returns to normal YAML

**💡 Learning:** Vault can protect existing plaintext files quickly and restore them later when needed.

---

### **Step 15: Multi-Environment Vault Management**

**Purpose:** Manage different vault files for different environments using Vault IDs.

Create environment-specific vault files:

```bash
# Create dev environment variables
cat > dev_vars.yml << EOF
db_host: dev-db.example.com
db_port: 3306
debug: true
EOF
```

```bash
# Create prod environment variables
cat > prod_vars.yml << EOF
db_host: prod-db.example.com
db_port: 3306
debug: false
EOF
```

```bash
# Encrypt with different vault IDs
ansible-vault encrypt --vault-id dev@prompt dev_vars.yml
ansible-vault encrypt --vault-id prod@prompt prod_vars.yml
```

Create a multi-environment playbook:
```bash
cat > multi_env_play.yml << EOF
---
- name: Multi-Environment Vault Demo
  hosts: localhost
  vars_files:
    - "{{ env }}_vars.yml"
  tasks:
    - name: Display environment info
      debug:
        msg: "Environment: {{ env }}, DB Host: {{ db_host }}, Debug: {{ debug }}"
EOF
```

```bash
# Run for different environments
ansible-playbook multi_env_play.yml --vault-id dev@prompt -e "env=dev"
ansible-playbook multi_env_play.yml --vault-id prod@prompt -e "env=prod"
```

---

## 📊 **Advanced Summary Table**

| Step | Action | Key Command | Purpose |
|------|--------|-------------|---------|
| 10 | Inspect & checksum | `head`, `sha256sum` | File integrity verification |
| 11 | Corrupt file test | `sed`, `ansible-vault view` | Security validation |
| 12 | Wrong password test | `--vault-password-file` | Access control testing |
| 13 | Advanced rekeying | `ansible-vault rekey` | Password rotation |
| 14 | Encrypt/Decrypt plaintext | `encrypt`, `decrypt` | File conversion |
| 15 | Multi-environment | `--vault-id` | Environment separation |

---

## 🚀 **Production Best Practices**

### **Security Recommendations:**
1. **Never commit vault passwords** to version control
2. **Use different passwords** for different environments
3. **Rotate vault passwords** regularly
4. **Store vault passwords** in secure key management systems
5. **Use vault IDs** for multi-environment setups

### **Cloud Integration Examples:**

**AWS Secrets Manager:**
```bash
aws secretsmanager get-secret-value --secret-id ansible/vault-pass --query SecretString --output text > /tmp/.vault_pass.txt
ansible-playbook vault_play.yml --vault-password-file /tmp/.vault_pass.txt
rm /tmp/.vault_pass.txt
```

**Azure Key Vault:**
```bash
az keyvault secret show --vault-name MyKeyVault --name ansible-vault-pass --query value -o tsv > /tmp/.vault_pass.txt
ansible-playbook vault_play.yml --vault-password-file /tmp/.vault_pass.txt
rm /tmp/.vault_pass.txt
```

---

🎉 **Congratulations!**  
You've successfully mastered **Ansible Vault** including advanced security testing, multi-environment management, and production best practices for securing secrets in your automation workflow.
