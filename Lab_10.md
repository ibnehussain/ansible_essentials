# Lab 10: Implementing Ansible Roles

Task 1: Implementing Ansible Roles

Create roles `webrole` and `dbrole` with proper directory structure.

Example `dbrole/tasks/main.yml`:
```yaml
---
- name: Install MariaDB server package
  yum:
    name: mariadb-server
    state: present
- name: Start MariaDB Service
  service:
    name: mariadb
    state: started
    enabled: true
```

Example `webrole/files/index.html` (simple page) and `webrole/tasks/main.yml` to install httpd, copy index, set permissions and start service.

Create a top-level playbook `implement-roles.yml` referencing the roles:
```yaml
---
 - hosts: all
   become: yes

   roles:
     - webrole
     - dbrole
```

Run:
```bash
ansible-playbook implement-roles.yml
```

Task 2: Installing Java through Ansible Galaxy Roles

Install a role from Ansible Galaxy, e.g. `geerlingguy.java`:
```bash
ansible-galaxy install geerlingguy.java
```
Create `implement-java.yml` that uses the role and run:
```bash
ansible-playbook implement-java.yml
```
