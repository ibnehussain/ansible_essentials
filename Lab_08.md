

---

# 🧪 Lab 8: Ansible Lab - Handlers + Conditionals + Loops

## 🎯 Objective
This lab helps you understand and implement:
1. Handlers — React to changes in tasks.
2. Conditionals — Execute tasks based on conditions.
3. Loops — Repeat tasks efficiently.

---

## 🧩 Prerequisites
- Ansible installed on control node.
- At least **one managed node** configured in `/etc/ansible/hosts`.
- SSH connectivity between control and managed node.
- Become privilege (sudo) access.

---

## 🧱 Step 1: Create Lab Directory

```bash
mkdir ~/ansible-lab
cd ~/ansible-lab
```

---

## ⚙️ Step 2: Create the Playbook

Create a file named `handlers_conditionals_loops.yml`

```bash
vi handlers_conditionals_loops.yml
```

Paste the following content:

```yaml
---
- name: Handlers, Conditionals, and Loops Lab
  hosts: all
  become: yes

  vars:
    package_name: httpd
    service_name: httpd
    copy_dest: /var/www/html/index.html

  tasks:
    # -----------------------------
    # 1️⃣ Install Apache (httpd)
    # -----------------------------
    - name: Install Apache Web Server
      yum:
        name: "{{ package_name }}"
        state: present
      notify: Restart Apache   # Handler trigger
      when: ansible_facts['os_family'] == "RedHat"  # Conditional example

    # -----------------------------
    # 2️⃣ Copy a sample web file
    # -----------------------------
    - name: Deploy sample web page
      copy:
        content: |
          <h1>Welcome to Ansible Lab</h1>
          <p>This is served from {{ ansible_hostname }}</p>
        dest: "{{ copy_dest }}"
      notify: Restart Apache

    # -----------------------------
    # 3️⃣ Install multiple utilities using Loops
    # -----------------------------
    - name: Install useful packages
      yum:
        name: "{{ item }}"
        state: present
      loop:
        - git
        - curl
        - wget

  # -----------------------------
  # 🔔 Handler section
  # -----------------------------
  handlers:
    - name: Restart Apache
      service:
        name: "{{ service_name }}"
        state: restarted
```

---

## 🧠 Step 3: Understand the Logic

| Concept         | Where Used                                     | Explanation                                                                                          |
| --------------- | ---------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Handler**     | `notify: Restart Apache`                       | Runs **only when a task reports "changed"**. It restarts Apache if configuration or content changes. |
| **Conditional** | `when: ansible_facts['os_family'] == "RedHat"` | Ensures Apache is installed **only** if OS is RedHat-based.                                          |
| **Loop**        | `loop:` under "Install useful packages"        | Installs multiple packages **without writing multiple tasks**.                                       |

---

## ▶️ Step 4: Run the Playbook

```bash
ansible-playbook handlers_conditionals_loops.yml
```

### Expected Output:

* Apache (`httpd`) installed
* HTML file created
* Apache restarted (triggered by handler)
* git, curl, wget installed via loop

---

## 🔍 Step 5: Verify on Target Node

```bash
sudo systemctl status httpd
cat /var/www/html/index.html
```

You should see:

```
Welcome to Ansible Lab
This is served from <hostname>
```

---

## ✅ Summary

| Concept          | Key Takeaway                                                 |
| ---------------- | ------------------------------------------------------------ |
| **Handlers**     | React to changes, usually for restarting/reloading services. |
| **Conditionals** | Control when a task should or shouldn’t run.                 |
| **Loops**        | Execute the same task multiple times with different items.   |

---

📘 **End of Lab**
