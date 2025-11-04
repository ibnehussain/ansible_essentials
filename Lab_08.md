# Lab 8: Working with ansible functions

Task 1: Loops with Ansible Playbook

Create `looplab.yml` to create multiple users:
```yaml
---
- hosts: all
  become: yes
  tasks:
   - name: creating users
     user:
       name: "{{ item }}"
       state: present
     with_items:
      - userX
      - userY
      - userZ
```

Run:
```bash
ansible-playbook looplab.yml
ansible all -a "tail -n 3 /etc/passwd"
```

Task 2: Tags with Ansible Playbooks

Create `tagslabs.yml` demonstrating tags and selective execution.

Examples:
```bash
ansible-playbook -t "create_dir" tagslabs.yml
ansible-playbook -t "create_file" tagslabs.yml
ansible-playbook --skip-tags "install_curl" tagslabs.yml
```

Task 3: Prompts with Ansible Playbooks

Create `promptlab.yml` using `vars_prompt` to ask which package to install.

Task 4: Until function

Create `untillab.yml` demonstrating `until`, `retries` and `delay`.

Task 5: Run Once with Ansible Playbook

Create `rolab.yml` that uses `run_once: true`.

Task 6: Blocks with Ansible Playbook

Create `blklab.yml` demonstrating `block`, `rescue`, and `always`.
