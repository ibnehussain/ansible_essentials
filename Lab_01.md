# Lab 1: Installing and Configuring Ansible

## Objective
Learn to install Ansible on a control node, configure inventory, and establish connectivity with managed nodes.

## Prerequisites
- AWS EC2 instances (1 control node + 2 managed nodes)
- SSH access to all instances
- Basic Linux command knowledge

## Lab Steps

### Step 1: Launch EC2 Instances

Launch 3 EC2 instances with the following specifications:
- **AMI**: Amazon Linux 2 or RHEL 8
- **Instance Type**: t2.micro (free tier eligible)
- **Security Group**: Allow SSH (port 22) from your IP
- **Key Pair**: Create or use existing key pair

Name the instances:
- `ansible-control` (control node)
- `ansible-node1` (managed node 1)
- `ansible-node2` (managed node 2)

### Step 2: Connect to Control Node

Connect to the control node:
```bash
ssh -i your-key.pem ec2-user@control-node-ip
```

Update the system:
```bash
sudo yum update -y
```

### Step 3: Install Ansible on Control Node

Install EPEL repository:
```bash
sudo yum install -y epel-release
```

Install Ansible:
```bash
sudo yum install -y ansible
```

Verify Ansible installation:
```bash
ansible --version
```

Check Ansible configuration:
```bash
ansible-config view
```

### Step 4: Configure SSH Key-Based Authentication

Generate SSH key pair on control node:
```bash
ssh-keygen -t rsa -b 2048
```

Press Enter for all prompts to use defaults.

Copy SSH public key to managed nodes:
```bash
ssh-copy-id ec2-user@node1-private-ip
```
```bash
ssh-copy-id ec2-user@node2-private-ip
```

Test SSH connectivity:
```bash
ssh ec2-user@node1-private-ip
```
```bash
exit
```
```bash
ssh ec2-user@node2-private-ip
```
```bash
exit
```

### Step 5: Create and Configure Inventory File

Create inventory directory:
```bash
sudo mkdir -p /etc/ansible
```

Edit the main inventory file:
```bash
sudo vi /etc/ansible/hosts
```

Add your managed nodes (replace with actual private IPs):
```ini
[webservers]
node1 ansible_host=10.0.1.10 ansible_user=ec2-user
node2 ansible_host=10.0.1.11 ansible_user=ec2-user

[databases]
node1 ansible_host=10.0.1.10 ansible_user=ec2-user

[all:vars]
ansible_ssh_private_key_file=/home/ec2-user/.ssh/id_rsa
```

### Step 6: Configure Ansible Settings

Create ansible configuration file:
```bash
sudo vi /etc/ansible/ansible.cfg
```

Add basic configuration:
```ini
[defaults]
inventory = /etc/ansible/hosts
remote_user = ec2-user
host_key_checking = False
retry_files_enabled = False
gathering = smart
fact_caching = memory

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
```

### Step 7: Test Ansible Connectivity

Test connection to all hosts:
```bash
ansible all -m ping
```

Test connection to specific group:
```bash
ansible webservers -m ping
```

Get system information from all hosts:
```bash
ansible all -m setup -a "filter=ansible_distribution*"
```

Check uptime on all hosts:
```bash
ansible all -m command -a "uptime"
```

### Step 8: Basic Ad-Hoc Commands

Check disk space:
```bash
ansible all -m command -a "df -h"
```

List running processes:
```bash
ansible all -m command -a "ps aux | head -10"
```

Check memory usage:
```bash
ansible all -m command -a "free -h"
```

Reboot managed nodes (with confirmation):
```bash
ansible all -m reboot --become
```

### Step 9: Verify Installation

List all inventory hosts:
```bash
ansible-inventory --list
```

Show inventory graph:
```bash
ansible-inventory --graph
```

Test ansible-playbook command:
```bash
ansible-playbook --version
```

Validate configuration:
```bash
ansible-config dump --only-changed
```

## Key Concepts Learned
- Ansible architecture (control node vs managed nodes)
- SSH key-based authentication setup
- Inventory file structure and grouping
- Basic ansible.cfg configuration
- Ad-hoc command execution with ansible command
- Testing connectivity with ping module

## Best Practices Implemented
- Disabled host key checking for lab environment
- Used SSH connection optimization
- Organized hosts into logical groups
- Used variables for common settings

## Troubleshooting Tips

**SSH Connection Issues:**
- Verify private key permissions: `chmod 600 ~/.ssh/id_rsa`
- Check security group rules allow SSH access
- Ensure correct private IP addresses in inventory
- Test manual SSH connection first

**Permission Errors:**
- Use `--become` flag for privilege escalation
- Verify sudo access on managed nodes
- Check ansible_user configuration

**Inventory Issues:**
- Validate YAML/INI syntax
- Use `ansible-inventory --list` to debug
- Check host grouping and variables

## Lab Verification
Successful completion indicators:
- `ansible all -m ping` returns SUCCESS for all hosts
- Ad-hoc commands execute without errors  
- Ansible version information displays correctly
- SSH key authentication works without password prompts

## Next Steps
- Proceed to Lab 2 for ad-hoc commands exploration
- Learn about Ansible modules and their usage
- Explore playbook creation and execution