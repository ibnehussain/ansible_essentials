# Lab 3: Implementing Ansible Playbook

## Objective
Learn to create and execute Ansible playbooks for installing and configuring Apache web server.

## Prerequisites
- Completed Labs 1 and 2
- Access to managed nodes with sudo privileges

## Lab Steps

### Step 1: Create Working Directory

Create a labs directory and work there:
```bash
mkdir ansible-labs
```
```bash
cd ansible-labs
```

### Step 2: Create Apache Installation Playbook

Create `install-apache-pb.yml` with the following content:
```yaml
---
- name: This play will install apache web servers on all the hosts
  hosts: all
  become: yes
  tasks:
    - name: Task1 will install httpd using yum
      yum:
        name: httpd
        update_cache: yes
        state: latest
    - name: Task2 will upload custom index.html into all hosts
      copy:
        src: /home/ec2-user/ansible-labs/index.html
        dest: /var/www/html
    - name: Task3 will setup attributes for file
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode:  0644
    - name: Task4 will start the httpd
      service:
        name: httpd
        state: started
```

### Step 3: Create Index HTML File

Create `index.html` used by the playbook:
```html
<html>
  <body>
  <h1>Welcome to Ansible Training from CloudThat</h1>
  </body>
</html>
```

### Step 4: Execute the Playbook

Run the playbook:
```bash
ansible-playbook install-apache-pb.yml
```

Verify the installation by checking if Apache is running:
```bash
ansible all -a "systemctl status httpd" --become
```

Test the web server:
```bash
ansible all -a "curl -s localhost"
```

### Step 5: Playbook Validation

Check playbook syntax before execution:
```bash
ansible-playbook install-apache-pb.yml --syntax-check
```

Perform a dry run:
```bash
ansible-playbook install-apache-pb.yml --check
```

## Key Concepts Learned
- Playbook structure: hosts, become, tasks
- Common modules: yum, copy, file, service
- YAML syntax and indentation
- Task naming and organization
- Privilege escalation with become

## Troubleshooting
- Ensure proper YAML indentation (use spaces, not tabs)
- Verify file paths in copy module source
- Check firewall settings if web server is not accessible
- Ensure managed nodes have internet connectivity for package installation