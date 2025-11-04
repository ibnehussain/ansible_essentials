```markdown
# Lab 3: Implementing Ansible Playbook

Create a labs directory and work there:
```bash
mkdir ansible-labs && cd ansible-labs
```

Task 1: Playbook to install apache web server

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

Create `index.html` used by the playbook:
```html
<html>
  <body>
  <h1>Welcome to Ansible Training from CloudThat</h1>
  </body>
</html>
```

Run the playbook:
```bash
ansible-playbook install-apache-pb.yml
```

Task 2: Uninstall apache (exercise)

Copy and edit the playbook to use `state: absent` to remove httpd and run with `--check` first.
```bash
cp install-apache-pb.yml uninstall-apache-pb.yml
ansible-playbook uninstall-apache-pb.yml --check
ansible-playbook uninstall-apache-pb.yml
```

*** End Patch