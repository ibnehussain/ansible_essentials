# Ansible Lab Steps

Login to AWS Console

## Lab 1: Installation and Configuration of Ansible

Launch a RHEL 9 instance in us-east-1. 
Choose t2.micro. 
In security group, allow SSH (22) and HTTP (80) for all incoming traffic. 
Add Tag Name: Ansible-ControlNode

Once the EC2 is up & running, SSH into one of it and set the hostname as 'Control-Node'. 
```bash
sudo hostnamectl set-hostname Control-Node
```
or you can type 'bash' and open another shell which shows new hostname.

Update the package repository with latest available versions
```bash
sudo yum check-update
```

Install latest version of Python. 
```bash
sudo yum install python3-pip -y 
```
```bash
python3 --version
```
```bash
sudo pip3 install --upgrade pip
```

Install awscli, boto, boto3 and ansible
Boto/Boto3 are AWS SDK which will be needed while accessing AWS APIs
```bash
sudo pip3 install awscli boto boto3
```
```bash
sudo pip3 install ansible==8.5.0
```
```bash
pip show ansible
```
```bash
ansible-galaxy collection install amazon.aws --upgrade
```
Authorize aws credentials
```bash
aws configure
```
#### Enter the Credentials as below. Example:
| **Access Key ID** | **Secret Access Key** |
| ----------------- | --------------------- |
| AKIAIOSFODNN7EXAMPLE | wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY |

Install wget so that we can download playbooks from the training material repository 
```bash
sudo yum install wget -y
```

Download the script using wget
```bash
wget https://devops-code-sruti.s3.us-east-1.amazonaws.com/ansible_script.yaml
```

Execute the script
```bash
ansible-playbook ansible_script.yaml
```

Once you get the ip addresses, do the following:
```bash
sudo vi /etc/ansible/hosts
```

Add the prive IP addresses, by pressing "INSERT" 
```text
node1 ansible_ssh_host=<node1-private-ip> ansible_ssh_user=ec2-user
node2 ansible_ssh_host=<node2-private-ip> ansible_ssh_user=ec2-user
```
e.g. node1 ansible_ssh_host=172.31.14.113 ansible_ssh_user=ec2-user
     node2 ansible_ssh_host=172.31.2.229 ansible_ssh_user=ec2-user


Save the file using "ESCAPE + :wq!"

list all managed node ip addresses.
```bash
ansible all --list-hosts
```

### SSH into each of them and set the hostnames.
```bash
ssh ec2-user@< Replace Node 1 IP >
```
```bash
sudo hostnamectl set-hostname managed-node-1
```
```bash
exit
```
```bash
ssh ec2-user@< Replace Node 2 IP >
```
```bash
sudo hostnamectl set-hostname managed-node-2
```
```bash
exit
```

### Use ping module to check if the managed nodes are able to interpret the ansible modules
```bash
ansible all -m ping
```