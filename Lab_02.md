# Lab 2: Exploring Ad-Hoc Commands

## Objective
Learn to execute Ansible ad-hoc commands for common administrative tasks on managed nodes.

## Prerequisites
- Completed Lab 1 (Ansible installation and configuration)
- Control node and managed nodes are accessible

## Lab Steps

### Step 1: Configure Localhost in Inventory

Edit the inventory:
```bash
sudo vi /etc/ansible/hosts
```

Add the given line (press INSERT):
```text
localhost ansible_connection=local
```

Save the file using `ESCAPE + :wq!`

### Step 2: Common Ad-Hoc Command Examples

Get memory details of the hosts:
```bash
ansible all -m command -a "free -h"
```

Alternative command:
```bash
ansible all -a "free -h"
```

Create a user ansible-new on all nodes (including control node):
```bash
ansible all -m user -a "name=ansible-new" --become
```

List users on node1:
```bash
ansible node1 -a "cat /etc/passwd"
```

List directories in /home on node2:
```bash
ansible node2 -a "ls /home"
```

Change permissions of /home/ansible-new on node1:
```bash
ansible node1 -m file -a "dest=/home/ansible-new mode=755" --become
```

Create a file in node1:
```bash
ansible node1 -m file -a "dest=/home/ansible-new/demo.txt mode=600 state=touch" --become
```

Add a line to the file:
```bash
ansible node1 -b -m lineinfile -a 'dest=/home/ansible-new/demo.txt line="This server is managed by Ansible"'
```

### Step 3: File Operations

Create a local test file:
```bash
touch test.txt
```

Add content to the file:
```bash
echo "This file will be copied to managed node using copy module" >> test.txt
```

Copy the local file to node1:
```bash
ansible node1 -m copy -a "src=test.txt dest=/home/ansible-new/test" -b
```

### Step 4: Cleanup

Remove the localhost entry from inventory:
```bash
sudo vi /etc/ansible/hosts
```

Remove the line: `localhost ansible_connection=local` and save the file.

## Key Concepts Learned
- Ad-hoc command syntax: `ansible <pattern> -m <module> -a "<arguments>"`
- Common modules: command, user, file, lineinfile, copy
- Using `--become` or `-b` for privilege escalation
- File and user management operations

## Troubleshooting
- If commands fail with permission errors, ensure you're using `--become`
- Verify SSH connectivity to managed nodes
- Check inventory file syntax and host accessibility