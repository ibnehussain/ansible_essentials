# 🧠 Ansible Lab Steps

## 🔹 Lab 1: Installation and Configuration of Ansible

Follow these steps to set up an **Ansible Control Node** on **RHEL 9** and verify connectivity with managed nodes.

---

### 🖥️ 1) Prepare the Control Node Instance

- Launch a **RHEL 9 EC2 instance** in **us-east-1** (t2.micro).  
- In **Security Group**, allow **SSH (22)** and **HTTP (80)**.  
- Add **Tag Name:** `Ansible-ControlNode`.

#### Set the hostname
```bash
sudo hostnamectl set-hostname Control-Node
```

#### Verify for package updates
```bash
sudo yum check-update
```

#### Install Python 3 package manager
```bash
sudo yum install python3-pip -y
```

#### Confirm Python version
```bash
python3 --version
```

#### Upgrade pip
```bash
sudo pip3 install --upgrade pip
```

---

### ☁️ 2) Install AWS SDKs and Ansible

#### Install AWS command-line tools and SDKs
```bash
sudo pip3 install awscli boto boto3
```

#### Install Ansible (specific version)
```bash
sudo pip3 install ansible==8.5.0
```

#### Confirm installed Ansible details
```bash
pip show ansible
```

#### Install Amazon AWS Ansible collection
```bash
ansible-galaxy collection install amazon.aws --upgrade
```

---

### 🔑 3) Configure AWS Credentials

#### Configure AWS CLI
```bash
aws configure
```

When prompted, enter values like below (for lab/demo):

| Access Key ID | Secret Access Key |
|---------------|-------------------|
| AKIAIOSFODNN7EXAMPLE | wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY |

Use region: **us-east-1**  
Output format: **json**

---

### 📥 4) Fetch the Sample Ansible Playbook

#### Install wget
```bash
sudo yum install wget -y
```

#### Download sample playbook
```bash
wget https://devops-code-sruti.s3.us-east-1.amazonaws.com/ansible_script.yaml
```

#### Execute the playbook
```bash
ansible-playbook ansible_script.yaml
```

---

### 🗂️ 5) Add Managed Nodes to Inventory

#### Open inventory file
```bash
sudo vi /etc/ansible/hosts
```

#### Add private IPs of managed nodes
```text
node1 ansible_ssh_host=<node1-private-ip> ansible_ssh_user=ec2-user
node2 ansible_ssh_host=<node2-private-ip> ansible_ssh_user=ec2-user

e.g.
node1 ansible_ssh_host=172.31.14.113 ansible_ssh_user=ec2-user
node2 ansible_ssh_host=172.31.2.229 ansible_ssh_user=ec2-user
```

#### Save and exit
Press `ESC`, then type:
```bash
:wq!
```

#### List all managed hosts
```bash
ansible all --list-hosts
```

---

### 🖧 6) Set Hostnames on Managed Nodes

#### SSH into Node 1
```bash
ssh ec2-user@<Replace Node 1 IP>
```

#### Set hostname on Node 1
```bash
sudo hostnamectl set-hostname managed-node-1
```

#### Exit from Node 1
```bash
exit
```

#### SSH into Node 2
```bash
ssh ec2-user@<Replace Node 2 IP>
```

#### Set hostname on Node 2
```bash
sudo hostnamectl set-hostname managed-node-2
```

#### Exit from Node 2
```bash
exit
```

---

### ✅ 7) Verify Connectivity from Ansible

#### Test Ansible connectivity
```bash
ansible all -m ping
```

If you see “pong” responses, your Ansible setup is working correctly!

---


