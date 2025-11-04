# Lab 9: Implementing Jinja2 Templates

Create a `templates` directory and add `new-motd.j2` with content:
```
System Information:
Operating System: {{ ansible_os_family | default('N/A') }}
Architecture: {{ ansible_architecture | default('N/A') }}
Distribution Version: {{ ansible_distribution | default('N/A') }}
```

Create playbook `implement-jinja2.yml`:
```yaml
---
- name: playbook
  hosts: all
  gather_facts: true
  become: yes
  tasks:
    - name: Render template
      template:
        src: new-motd.j2
        dest: /etc/motd
        owner: ec2-user
        group: ec2-user
        mode: 0644
```

Run the playbook:
```bash
ansible-playbook implement-jinja2.yml -b
```
Check the generated motd:
```bash
ansible all -m shell -a "cat /etc/motd"
```
