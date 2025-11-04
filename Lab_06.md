```markdown
# Lab 6: Task Inclusion

Create `second.yml` with tasks to install and start httpd:
```yaml
---
- name: install the httpd package
  yum:
    name: httpd
    state: latest
    update_cache: yes

- name: start the httpd service
  service:
    name: httpd
    state: started
    enabled: yes
```

Create `first.yml` that includes `second.yml`:
```yaml
---
- hosts: all
  gather_facts: no
  become: yes
  tasks:
  - name: install common packages
    yum:
      name: [wget, curl]
      state: present

  - name: include task for httpd installation
    include_tasks: second.yml
```

Create `third.yml` demonstrating `register` and conditional include:
```yaml
---
- hosts: all
  gather_facts: no
  become: yes
  tasks:
  - name: install common packages
    yum:
      name: [wget, curl]
      state: present
    register: out

  - name: list result of previous task
    debug:
      msg: "{{ out.rc }}"

  - name: include task for httpd installation
    include_tasks: second.yml
    when: out.rc == 0
```

Run the playbooks with:
```bash
ansible-playbook first.yml
ansible-playbook third.yml
```

*** End Patch