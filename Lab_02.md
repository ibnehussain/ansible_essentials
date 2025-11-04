# Lab 2: Exploring Ad-Hoc Commands

Edit the inventory:
```bash
sudo vi /etc/ansible/hosts
```
Add the given line (press INSERT):
```text
localhost ansible_connection=local
```
save the file using `ESCAPE + :wq!`

Common ad-hoc examples

Get memory details of the hosts:
```bash
ansible all -m command -a "free -h"
```
Or
```bash
ansible all -a "free -h"
```

Create a user ansible-new on all nodes (including control node):
```bash
ansible all -m user -a "name=ansible-new" --become
```

List users on node1
```bash
ansible node1 -a "cat /etc/passwd"
```

List directories in /home on node2
```bash
ansible node2 -a "ls /home"
```

Change permissions of /home/ansible-new on node1
```bash
ansible node1 -m file -a "dest=/home/ansible-new mode=755" --become
```

Create a file in node1:
```bash
ansible node1 -m file -a "dest=/home/ansible-new/demo.txt mode=600 state=touch" --become
```

Add a line to the file
```bash
ansible node1 -b -m lineinfile -a 'dest=/home/ansible-new/demo.txt line="This server is managed by Ansible"'
```

Copy a local file to node1
```bash
touch test.txt
echo "This file will be copied to managed node using copy module" >> test.txt
ansible node1 -m copy -a "src=test.txt dest=/home/ansible-new/test" -b
```

Remove the localhost entry from inventory when done and save.
```bash
sudo vi /etc/ansible/hosts
# remove: localhost ansible_connection=local
```
