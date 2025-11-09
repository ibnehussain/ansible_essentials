# 🚀 **Quick Ansible Installation Guide**

## **Automated Setup for AWS RHEL 9 EC2 Instance**

This guide provides step-by-step instructions to quickly set up an Ansible Control Node using our automated installation script.

---

## 📋 **Prerequisites**

Before starting, ensure you have:

✅ **AWS EC2 Instance Requirements:**
- **OS:** Red Hat Enterprise Linux (RHEL 9/10) / CentOS 9 / Rocky Linux 9
- **Instance Type:** t2.micro/t3.micro or larger
- **Region:** us-east-1 (recommended)
- **Security Groups:** SSH (port 22) and HTTP (port 80) access
- **Key Pair:** For SSH access

✅ **User Requirements:**
- SSH access to the EC2 instance
- `sudo` privileges on the instance
- Basic familiarity with Linux command line

---

## 🛠️ **Installation Steps**

### **Step 1: Connect to Your EC2 Instance**

Connect to your RHEL 9 EC2 instance via SSH:

```bash
ssh -i your-key.pem ec2-user@your-instance-public-ip
```

**Example:**
```bash
ssh -i ansible-lab-key.pem ec2-user@54.123.45.67
```

---

### **Step 2: Download the Installation Script**

Once connected to your EC2 instance, download the automated installation script:

```bash
curl -O https://raw.githubusercontent.com/ibnehussain/ansible_essentials/main/install_ansible.sh
```

**Alternative download method using wget:**
```bash
wget https://raw.githubusercontent.com/ibnehussain/ansible_essentials/main/install_ansible.sh
```

---

### **Step 3: Make the Script Executable**

Set the proper permissions to make the script executable:

```bash
chmod +x install_ansible.sh
```

---

### **Step 4: Run the Installation Script**

Execute the installation script:

```bash
./install_ansible.sh
```

**What the script will do:**
- ✅ Set hostname to 'Control-Node'
- ✅ Check for system updates
- ✅ Install Python 3 and pip
- ✅ Install AWS CLI and SDKs (boto, boto3)
- ✅ Install Ansible version 8.5.0
- ✅ Install Amazon AWS Ansible collection
- ✅ Install wget utility
- ✅ Create `~/ansible-labs` working directory
- ✅ Download sample playbook
- ✅ Verify all installations

---

### **Step 5: Configure AWS Credentials**

After successful installation, configure your AWS credentials:

```bash
aws configure
```

**Enter your AWS credentials when prompted:**
- **AWS Access Key ID:** Your access key
- **AWS Secret Access Key:** Your secret key  
- **Default region name:** `us-east-1`
- **Default output format:** `json`

---

### **Step 6: Create AWS EC2 Managed Nodes**

Navigate to your working directory and execute the managed nodes creation playbook:

```bash
cd ~/ansible-labs
```

```bash
ansible-playbook create_managed_nodes.yml
```

**What this playbook will do:**
- ✅ Automatically discover your current EC2 configuration
- ✅ Create 2 new EC2 instances (`managed-node-1` and `managed-node-2`)
- ✅ Configure SSH keys for passwordless access
- ✅ Set up hostnames automatically
- ✅ Generate an inventory file (`managed_nodes_inventory`)
- ✅ Display private IP addresses for your reference

**Expected output:**
```
🎉 EC2 Managed Nodes Created Successfully!

📁 Files Created:
- SSH keys: /home/ec2-user/.ssh/id_rsa (private) & id_rsa.pub (public)
- Ansible inventory: /etc/ansible/hosts (automatically configured)

🚀 Ready to start managing your infrastructure with Ansible!
```

---

### **Step 7: Verify Managed Nodes Setup**

After the playbook completes successfully, verify your managed nodes:

#### **Check the generated inventory file:**

```bash
sudo cat /etc/ansible/hosts
```

**Example inventory content:**
```ini
[managed_nodes]
node1 ansible_ssh_host=172.31.14.113 ansible_ssh_user=ec2-user
node2 ansible_ssh_host=172.31.2.229 ansible_ssh_user=ec2-user

[webservers]
node1
node2

[all:vars]
ansible_ssh_private_key_file=/home/ec2-user/.ssh/id_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

#### **Verify EC2 instances in AWS Console:**
- Check EC2 Dashboard for 2 new instances
- Names: `managed-node-1` and `managed-node-2`
- Status: Running with public and private IP addresses

---

### **Step 8: Test Your Ansible Setup**

**Test Ansible installation:**
```bash
ansible --version
```

**Test connectivity to managed nodes:**
```bash
ansible all -m ping
```

**Expected successful output:**
```
node1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
node2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

**Alternative: Test specific groups:**
```bash
ansible managed_nodes -m ping
ansible webservers -m ping
```

**Run a quick command on all managed nodes:**
```bash
ansible all -m shell -a "hostname"
```

**List all hosts in inventory:**
```bash
ansible all --list-hosts
```

---

## 🎯 **Expected Output**

Upon successful installation, you should see:

```
🎉 INSTALLATION COMPLETED SUCCESSFULLY!

=== INSTALLATION SUMMARY ===
✅ Hostname: Control-Node
✅ Python: Python 3.x.x
✅ pip: pip 23.x.x
✅ Ansible: ansible [core 2.15.x]
✅ AWS CLI: aws-cli/2.x.x
✅ Working Directory: ~/ansible-labs

📋 NEXT STEPS:
1. Configure AWS credentials: aws configure
2. Create managed nodes: ansible-playbook create_managed_nodes.yml
3. Test connectivity: ansible all -m ping
4. Navigate to working directory: cd ~/ansible-labs
5. Start managing your infrastructure with Ansible!

🚀 Your Ansible Control Node is ready!
```

**After running the managed nodes creation playbook:**

```
🎉 EC2 Managed Nodes Created Successfully!

📁 Files Created:
- SSH keys: /home/ec2-user/.ssh/id_rsa (private) & id_rsa.pub (public)
- Ansible inventory: /etc/ansible/hosts (automatically configured)

🚀 Ready to start managing your infrastructure with Ansible!

💡 Quick Commands:
- Test connectivity: ansible all -m ping
- List all hosts: ansible all --list-hosts
- Run ad-hoc commands: ansible all -m shell -a "hostname"
```

---

## 🚨 **Troubleshooting**

### **Common Issues and Solutions:**

**❌ Permission Denied Error:**
```bash
# Solution: Ensure script is executable
chmod +x install_ansible.sh
```

**❌ Script fails on OS check:**
- Ensure you're using RHEL 9, CentOS 9, or Rocky Linux 9
- The script will prompt if you want to continue on other versions

**❌ Network connectivity issues:**
- Check your security group allows outbound HTTPS (port 443)
- Ensure your instance has internet connectivity

**❌ Package installation fails:**
- Verify you have sudo privileges
- Check if yum repositories are properly configured

---

## 📚 **What Gets Installed**

The script installs the following components:

| Component | Version | Purpose |
|-----------|---------|---------|
| **Python 3** | Latest available | Ansible runtime environment |
| **pip3** | Latest | Python package manager |
| **Ansible** | Latest stable | Infrastructure automation tool |
| **AWS CLI** | Latest | AWS command line interface |
| **boto/boto3** | Latest | AWS SDK for Python |
| **Amazon AWS Collection** | Latest | Ansible modules for AWS |
| **wget** | Latest | File download utility |

---

## 🔗 **Next Steps**

After successful installation:

1. **Complete Lab 1:** Follow the remaining steps in `Lab_01.md`
2. **Set up managed nodes:** Configure additional EC2 instances
3. **Explore other labs:** Progress through Labs 2-10
4. **Build playbooks:** Start creating your own automation

---

## 💡 **Tips for Success**

- **Always run updates:** Keep your system updated with `sudo yum update`
- **Use version control:** Store your playbooks in Git repositories
- **Practice regularly:** The more you use Ansible, the more proficient you become
- **Read documentation:** Ansible has excellent official documentation
- **Join communities:** Participate in Ansible forums and communities

---

## 📞 **Support**

If you encounter issues:

1. **Check the script output** for specific error messages
2. **Verify prerequisites** are met (OS version, internet connectivity)
3. **Review logs** in `/var/log/` for system-level issues
4. **Consult Lab_01.md** for manual installation steps if needed

---

**🎊 Happy Learning with Ansible! 🎊**