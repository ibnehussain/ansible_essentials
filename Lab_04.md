# Lab 4: Exploring more on Ansible Playbooks

Task 1: Creating a playbook and adding content to a file

Create `putfile.yml` and add tasks to create a user and directories:
```yaml
---
- hosts: all
  become: yes
  tasks:
    - name: Creating a new user cloudthat
      user:
        name: cloudthat
    - name: Creating a directory for the new user
      file:
        path: /home/cloudthat
        state: directory
```

Modify `putfile.yml` to create child directories, files, set ownership and add content with `blockinfile`.
Run step-by-step with `ansible-playbook putfile.yml --step`.

Verify files and permissions:
```bash
ansible all -a "sudo cat /home/cloudthat/ansible/hello.txt"
ansible all -a "sudo ls -l /home/cloudthat/ansible/"
```
