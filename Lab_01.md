# Lab 1 — Installation and Configuration of Ansible

## Objective
- Install and configure an Ansible control node on a RHEL 9 EC2 instance.
- Configure AWS CLI and the Ansible Amazon collection so you can manage cloud resources.

## Prerequisites
- An AWS account and a keypair to SSH into EC2 instances.
- Basic familiarity with Linux commands and SSH.
- A local terminal with network access to your EC2 instances.

## Estimated time
~ 30–45 minutes

---

## Overview
This lab shows how to launch a RHEL 9 instance to act as the Ansible control node, install required packages (Python, pip, awscli, boto3 and Ansible), configure AWS credentials, and prepare a simple Ansible inventory for managing hosts.

> Note: Do NOT paste real AWS secret keys into shared documents. Use `aws configure` on your control node and keep credentials private.

---

## Steps

1. Launch an EC2 instance

- Region: us-east-1 (or your preferred region)
- AMI: RHEL 9
- Instance type: t2.micro (or equivalent)
- Security group: allow SSH (22) from your IP and HTTP (80) if you plan to run a web server
- Add a tag like Name=Ansible-ControlNode

2. SSH to the control node and set a hostname (optional)

```bash
# from your local shell
ssh -i /path/to/your-key.pem ec2-user@<control-node-ip>

# on the instance
sudo hostnamectl set-hostname Control-Node
```

You can open a new shell to observe the changed hostname.

3. Update packages

```bash
sudo yum check-update
```

4. Install Python3 and pip (required by Ansible)

```bash
sudo yum install python3-pip -y
python3 --version
sudo pip3 install --upgrade pip
```

5. Install awscli, boto, boto3 and Ansible

These packages let Ansible interact with AWS (boto/boto3) and run playbooks.

```bash
sudo pip3 install awscli boto boto3
sudo pip3 install "ansible==8.5.0"

# Verify installation
pip show ansible
ansible --version
```

6. Install the AWS Ansible collection

```bash
ansible-galaxy collection install amazon.aws --upgrade
```

7. Configure your AWS credentials (on the control node)

```bash
aws configure
```

When prompted, enter your Access Key ID and Secret Access Key. Keep these credentials private. If you need to automate credential management, consider using environment variables or IAM roles instead of storing long-lived credentials on disk.

8. Install wget (optional, used for downloading example playbooks)

```bash
sudo yum install wget -y
```

9. (Optional) Download and run an example playbook provided by the trainer

```bash
wget https://devops-code-sruti.s3.us-east-1.amazonaws.com/ansible_script.yaml
ansible-playbook ansible_script.yaml
```

10. Prepare the Ansible inventory

Edit `/etc/ansible/hosts` and add the private IPs of managed nodes. Press `INSERT` in `vi` to edit and then `ESCAPE` + `:wq` to save.

```text
node1 ansible_ssh_host=<node1-private-ip> ansible_ssh_user=ec2-user
node2 ansible_ssh_host=<node2-private-ip> ansible_ssh_user=ec2-user
```

Replace `<node1-private-ip>` and `<node2-private-ip>` with the actual private IP addresses (no angle brackets in the file).

11. Verify Ansible can see hosts

```bash
ansible all --list-hosts
ansible all -m ping
```

12. Example ad-hoc commands (basic management)

Create a user on all hosts (requires privilege escalation):

```bash
ansible all -m user -a "name=ansible-new" --become
```

Change directory permissions on node1:

```bash
ansible node1 -m file -a "dest=/home/ansible-new mode=755" --become
```

Copy a local file from control node to managed node:

```bash
touch test.txt
echo "This file will be copied to managed node using copy module" >> test.txt
ansible node1 -m copy -a "src=test.txt dest=/home/ansible-new/test" -b
```

Use `-b` as shorthand for `--become` when running modules that need elevated privileges.

---

## Verification / Expected outcome

- `ansible all --list-hosts` should list the inventory hosts.
- `ansible all -m ping` should return `pong` for reachable hosts.
- `ansible node1 -a "ls /home"` should show `/home/ansible-new` when created.

---

## Troubleshooting

- SSH connection errors: ensure the security group allows your IP and that the correct keypair is used.
- Permission denied when using `--become`: confirm the remote user (`ec2-user`) has sudo privileges.
- `ansible: command not found`: make sure Python/pip installed and the `ansible` executable is in PATH (pip may have installed to `/usr/local/bin` — log out/in or use full path).
- If a module fails due to missing Python packages on managed nodes, you may need to install Python on those nodes or use `ansible_connection=local` for localhost runs.

---

## Security note
- Do not commit or paste real AWS credentials or secret keys into files that will be shared. Replace secrets with placeholders in training material.

---

## References
- Ansible docs: https://docs.ansible.com/
- AWS CLI docs: https://docs.aws.amazon.com/cli/latest/

---

If you'd like, I can now:
- Apply the same improvements (objectives, prerequisites, verification and troubleshooting) to the other lab files (`Lab_02.md` .. `Lab_10.md`).
- Create a `README.md` index that links to each lab.

Tell me which you prefer and I'll continue.
**save the file using** `ESCAPE + :wq!`
