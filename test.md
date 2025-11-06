# Lab 3: Implementing Ansible Playbook

## Objective 🎯
Learn to create and execute **Ansible playbooks** for installing and configuring Apache web server.

## Prerequisites 🧱
- ✅ Completed Labs 1 and 2
- ✅ Access to managed nodes with sudo privileges

## Lab Steps ⚙️

### Step 1: Create Working Directory 🛠️

Create a labs directory and work there:
```bash
mkdir ansible-labs
```
```bash
cd ansible-labs
```

### Step 2: Create Apache Installation Playbook 🛠️

#### Add Task 1: Install httpd using yum 🛠️
Create `install-apache-pb.yml` with the following content:
```yaml
---
- name: This play will install apache web servers on all the hosts
  hosts: all
  become: yes
  tasks:
    - name: Task1 will install httpd using yum
      yum:
        name: httpd
        update_cache: yes
        state: latest
```

#### Deploy Task 1 🚀
Run the playbook to execute Task 1:
```bash
ansible-playbook install-apache-pb.yml
```
#### Verify Installation ✅
Verify the installation:
```bash
ansible all -a "yum list installed httpd" --become
```

#### Add Task 2: Upload custom index.html 🛠️
Update `install-apache-pb.yml` to include the following task:
```yaml
    - name: Task2 will upload custom index.html into all hosts
      copy:
        src: /home/ec2-user/ansible-labs/index.html
        dest: /var/www/html
```

#### Deploy Task 2 🚀
Run the playbook to execute Task 2:
```bash
ansible-playbook install-apache-pb.yml
```
#### Verify File Upload ✅
Verify the file upload:
```bash
ansible all -a "ls -l /var/www/html/index.html" --become
```

#### Add Task 3: Set file attributes 🛠️
Update `install-apache-pb.yml` to include the following task:
```yaml
    - name: Task3 will setup attributes for file
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode:  0644
```

#### Deploy Task 3 🚀
Run the playbook to execute Task 3:
```bash
ansible-playbook install-apache-pb.yml
```
#### Verify File Attributes ✅
Verify file attributes:
```bash
ansible all -a "ls -l /var/www/html/index.html" --become
```

#### Add Task 4: Start the httpd service 🛠️
Update `install-apache-pb.yml` to include the following task:
```yaml
    - name: Task4 will start the httpd
      service:
        name: httpd
        state: started
```

#### Deploy Task 4 🚀
Run the playbook to execute Task 4:
```bash
ansible-playbook install-apache-pb.yml
```
#### Verify Service Status ✅
Verify the service status:
```bash
ansible all -a "systemctl status httpd" --become
```

### Step 3: Create Index HTML File 🛠️

#### Install Git (if not already installed) 🛠️
```bash
sudo yum install git -y
```

#### Download index.html from Repository 🛠️
Use curl to download the index.html file from the repository:
```bash
curl -o index.html https://raw.githubusercontent.com/ibnehussain/ansible_essentials/main/index.html
```

#### Alternative: Create index.html manually 🛠️
If you prefer to create the file manually:
```bash
cat > index.html << EOF
<html>
  <body>
  <h1>Welcome to Ansible Training from CloudThat</h1>
  </body>
</html>
EOF
```

#### Verify the File ✅
Check that the index.html file was created:
```bash
ls -l index.html
cat index.html
```

### Step 4: Execute the Playbook 🚀

Run the playbook:
```bash
ansible-playbook install-apache-pb.yml
```
#### Verify Installation ✅
Verify the installation by checking if Apache is running:
```bash
ansible all -a "systemctl status httpd" --become
```
#### Test the Web Server ✅
Test the web server:
```bash
ansible all -a "curl -s localhost"
```

### Step 5: Uninstall Apache Web Server 🛠️

#### Create Uninstall Playbook 🛠️
Create `uninstall-apache-pb.yml` to remove Apache:
```yaml
---
- name: This play will uninstall apache web servers from all the hosts
  hosts: all
  become: yes
  tasks:
    - name: Task1 will stop the httpd service
      service:
        name: httpd
        state: stopped
    - name: Task2 will remove httpd package
      yum:
        name: httpd
        state: absent
    - name: Task3 will remove web files
      file:
        path: /var/www/html/index.html
        state: absent
```

#### Execute Uninstall Playbook 🚀
Run the uninstall playbook:
```bash
ansible-playbook uninstall-apache-pb.yml
```

#### Verify Uninstallation ✅
Verify Apache has been removed:
```bash
ansible all -a "systemctl status httpd" --become
```
Check if package is removed:
```bash
ansible all -a "yum list installed httpd" --become
```

### Step 6: Playbook Validation 🛠️

#### Check Playbook Syntax ✅
Check playbook syntax before execution:
```bash
ansible-playbook install-apache-pb.yml --syntax-check
```
#### Perform a Dry Run ✅
Perform a dry run:
```bash
ansible-playbook install-apache-pb.yml --check
```

### Step 7: Cleanup 🧹

Make sure to delete AWS EC2 instances to avoid billing!

---

## Key Concepts Learned 🧠

✅ **Playbook syntax:**
```bash
ansible-playbook <playbook-name>.yml
```

✅ **Common modules:**
- `yum`: Install and manage packages
- `copy`: Copy files to managed nodes
- `file`: Manage file attributes
- `service`: Manage services

✅ **YUM Module State Options:**

| State | Description | Action |
|-------|-------------|--------|
| `present` | Ensures package is installed | Installs if not present, no update |
| `installed` | Ensures package is installed | Same as `present` (interchangeable) |
| `latest` | Ensures latest version is installed | Installs + updates to latest version |
| `absent` | Ensures package is removed | Uninstalls the package |

📝 **Note**: `present` and `installed` are used interchangeably and perform the same function. `latest` provides additional functionality by ensuring the most recent version is installed.

✅ **Privilege escalation:**
Use `--become` or `-b` for root-level tasks

✅ **Practical tasks covered:**
- Installing packages
- Uploading files
- Setting file permissions
- Starting services

---

## Troubleshooting 🛠️

⚠️ **Permission errors?** → Add `--become` or check sudo access  
⚠️ **Host unreachable?** → Verify SSH connectivity  
⚠️ **Command skipped?** → Ensure correct inventory and host names

---

✨ *You’ve now practiced creating and deploying Ansible playbooks — a key skill for automating IT tasks!*