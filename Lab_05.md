```markdown
# Lab 5: Implementing Ansible Variables

Task 1: Configuring packages in ansible using variables

Create a folder and playbook `implement-vars.yml` demonstrating use of variables:
```yaml
---
- hosts: '{{ hostname }}'
  become: yes
  vars:
    hostname: all
    package1: httpd
    destination: /var/www/html/index.html 
    source: /home/ec2-user/ansible-labs/index.html
  tasks:
    - name: Install defined package
      yum:
        name: '{{ package1 }}'
        update_cache: yes
        state: latest
    - name: Start desired service
      service:
        name: '{{ package1 }}'
        state: started
    - name: copy required index.html to the document folder for httpd.
      copy:
        src: '{{ source }}'
        dest: '{{ destination }}'
```

Run:
```bash
ansible-playbook implement-vars.yml
```

Task 2: Create alternate index1.html and run with `--extra-vars` to override `source`.

Task 3: Move variables into `myvariables.yml` and use `vars_files` in the playbook.

*** End Patch