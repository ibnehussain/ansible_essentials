# Ansible Lab Steps# Ansible Lab Steps



Login to AWS ConsoleAnsible Lab Steps



## Lab 1: Installation and Configuration of AnsibleLogin to AWS Console=================



Launch a RHEL 9 instance in us-east-1. Login to AWS Console

Choose t2.micro. 

In security group, allow SSH (22) and HTTP (80) for all incoming traffic. ## Lab 1: Installation and Configuration of Ansible

Add Tag Name: Ansible-ControlNode

## Lab 1: Installation and Configuration of Ansible

Once the EC2 is up & running, SSH into one of it and set the hostname as 'Control-Node'. 

```bashLaunch a RHEL 9 instance in us-east-1. 

sudo hostnamectl set-hostname Control-Node

```Choose t2.micro. Launch a RHEL 9 instance in us-east-1. 

or you can type 'bash' and open another shell which shows new hostname.

In security group, allow SSH (22) and HTTP (80) for all incoming traffic. Choose t2.micro. 

Update the package repository with latest available versions

```bashAdd Tag Name: Ansible-ControlNodeIn security group, allow SSH (22) and HTTP (80) for all incoming traffic. 

sudo yum check-update

```Add Tag Name: Ansible-ControlNode



Install latest version of Python. Once the EC2 is up & running, SSH into one of it and set the hostname as 'Control-Node'. 

```bash

sudo yum install python3-pip -y ```bashOnce the EC2 is up & running, SSH into one of it and set the hostname as 'Control-Node'. 

```

```bashsudo hostnamectl set-hostname Control-Node```

python3 --version

``````sudo hostnamectl set-hostname Control-Node

```bash

sudo pip3 install --upgrade pipor you can type 'bash' and open another shell which shows new hostname.```

```

or you can type 'bash' and open another shell which shows new hostname.

Install awscli, boto, boto3 and ansible

Boto/Boto3 are AWS SDK which will be needed while accessing AWS APIsUpdate the package repository with latest available versions

```bash

sudo pip3 install awscli boto boto3```bashUpdate the package repository with latest available versions

```

```bashsudo yum check-update```

sudo pip3 install ansible==8.5.0

``````sudo yum check-update

```bash

pip show ansible```

```

```bashInstall latest version of Python. 

ansible-galaxy collection install amazon.aws --upgrade

``````bashInstall latest version of Python. 

Authorize aws credentials

```bashsudo yum install python3-pip -y ```

aws configure

``````sudo yum install python3-pip -y 

#### Enter the Credentials as below. Example:

| **Access Key ID** | **Secret Access Key** |```bash```

| ----------------- | --------------------- |

| AKIAIOSFODNN7EXAMPLE | wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY |python3 --version```



Install wget so that we can download playbooks from the training material repository ```python3 --version

```bash

sudo yum install wget -y```bash```

```

sudo pip3 install --upgrade pip```

Download the script using wget

```bash```sudo pip3 install --upgrade pip

wget https://devops-code-sruti.s3.us-east-1.amazonaws.com/ansible_script.yaml

``````



Execute the scriptInstall awscli, boto, boto3 and ansible

```bash

ansible-playbook ansible_script.yamlBoto/Boto3 are AWS SDK which will be needed while accessing AWS APIsInstall awscli, boto, boto3 and ansible

```

```bashBoto/Boto3 are AWS SDK which will be needed while accessing AWS APIs

Once you get the ip addresses, do the following:

```bashsudo pip3 install awscli boto boto3```

sudo vi /etc/ansible/hosts

``````sudo pip3 install awscli boto boto3



Add the prive IP addresses, by pressing "INSERT" ```bash```

```text

node1 ansible_ssh_host=<node1-private-ip> ansible_ssh_user=ec2-usersudo pip3 install ansible==8.5.0```

node2 ansible_ssh_host=<node2-private-ip> ansible_ssh_user=ec2-user

``````sudo pip3 install ansible==8.5.0

e.g. node1 ansible_ssh_host=172.31.14.113 ansible_ssh_user=ec2-user

     node2 ansible_ssh_host=172.31.2.229 ansible_ssh_user=ec2-user```bash```



pip show ansible```

Save the file using "ESCAPE + :wq!"

```pip show ansible

list all managed node ip addresses.

```bash```bash```

ansible all --list-hosts

```ansible-galaxy collection install amazon.aws --upgrade```



### SSH into each of them and set the hostnames.```ansible-galaxy collection install amazon.aws --upgrade

```bash

ssh ec2-user@< Replace Node 1 IP >Authorize aws credentials```

```

```bash```bashAuthorize aws credentials

sudo hostnamectl set-hostname managed-node-1

## Lab 01: Installation and Configuration of Ansible

Follow these steps to set up an Ansible control node on RHEL 9 and verify connectivity to two managed nodes. Each command is in its own copyable block, and every command has a brief explanation.

### 1) Prepare the control node instance

- Launch a RHEL 9 EC2 instance in us-east-1 (t2.micro is fine).
- Security Group: allow inbound SSH (22) and HTTP (80).
- Add tag Name=Ansible-ControlNode.

Set the hostname of the control node to make it easy to identify.

```bash
sudo hostnamectl set-hostname Control-Node
```

Verify the package metadata; this refreshes available updates.

```bash
sudo yum check-update
```

Install Python 3 package manager (pip) which you'll use to install Ansible and AWS tools.

```bash
sudo yum install python3-pip -y
```

Confirm Python is available and note the version.

```bash
python3 --version
```

Upgrade pip to the latest version to avoid installation issues.

```bash
sudo pip3 install --upgrade pip
```

### 2) Install AWS SDKs and Ansible

Install AWS command-line tools and SDKs used by some Ansible modules.

```bash
sudo pip3 install awscli boto boto3
```

Install a specific version of Ansible for consistency with the lab instructions.

```bash
sudo pip3 install ansible==8.5.0
```

Confirm the installed Ansible package details.

```bash
pip show ansible
```

Install the official Amazon AWS Ansible collection for AWS modules and plugins.

```bash
ansible-galaxy collection install amazon.aws --upgrade
```

### 3) Configure AWS credentials

Configure the AWS CLI so Ansible's AWS modules can authenticate.

```bash
aws configure
```

Enter placeholder credentials like the examples below when prompted (do not use real secrets in lab docs):

| Access Key ID             | Secret Access Key                                  |
| ------------------------- | -------------------------------------------------- |
| AKIAIOSFODNN7EXAMPLE      | wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY           |

You can choose region us-east-1 and default output json when prompted.

### 4) Fetch the sample Ansible playbook

Install wget to download the sample playbook from the training repository.

```bash
sudo yum install wget -y
```

Download the example playbook to your home directory.

```bash
wget https://devops-code-sruti.s3.us-east-1.amazonaws.com/ansible_script.yaml
```

Run the playbook. It prints or collects the managed node IPs you'll use next.

```bash
ansible-playbook ansible_script.yaml
```

### 5) Add managed nodes to the inventory

Open the default inventory file to add the private IPs of your managed nodes.

```bash
sudo vi /etc/ansible/hosts
```

Add entries like the following (replace with your private IPs):

```text
node1 ansible_ssh_host=<node1-private-ip> ansible_ssh_user=ec2-user
node2 ansible_ssh_host=<node2-private-ip> ansible_ssh_user=ec2-user

e.g.
node1 ansible_ssh_host=172.31.14.113 ansible_ssh_user=ec2-user
node2 ansible_ssh_host=172.31.2.229 ansible_ssh_user=ec2-user
```

Save and exit (ESC, then :wq!).

List the hosts Ansible sees to confirm the inventory is correct.

```bash
ansible all --list-hosts
```

### 6) Set hostnames on managed nodes

SSH into node 1 using its private IP.

```bash
ssh ec2-user@<Replace Node 1 IP>
```

Set a friendly hostname on node 1.

```bash
sudo hostnamectl set-hostname managed-node-1
```

Disconnect from node 1.

```bash
exit
```

SSH into node 2 using its private IP.

```bash
ssh ec2-user@<Replace Node 2 IP>
```

Set a friendly hostname on node 2.

```bash
sudo hostnamectl set-hostname managed-node-2
```

Disconnect from node 2.

```bash
exit
```

### 7) Verify connectivity from Ansible

Use the ping module to verify Ansible can connect and run Python on the managed nodes.

```bash
ansible all -m ping
```

If you see "pong" responses, your Ansible control node and inventory are set up correctly.
