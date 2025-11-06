# Lab 3.5: Building Smart Playbooks and Understanding Ansible Core Concepts

---

## 🎯 Objective

Bridge the gap between static and dynamic automation by learning how to design **reusable, idempotent**, and **selectively executable** playbooks in Ansible.

This lab focuses on enhancing playbook quality through **core design principles** before we move into **variables and facts** in Lab 4.

---

## 🧱 Prerequisites

* ✅ Completed **Lab 3: Implementing Ansible Playbook**
* ✅ Basic understanding of playbooks and YAML structure
* ✅ Access to managed nodes with sudo privileges

---

## 💡 Concepts Covered

| Concept                    | Description                                                                                  |
| -------------------------- | -------------------------------------------------------------------------------------------- |
| **Idempotency**            | Ensures that running the same playbook multiple times doesn’t cause unintended changes.      |
| **Task Reusability**       | Designing tasks that can apply across multiple environments without modification.            |
| **Inventory Variables**    | Preparing to use variables and facts for dynamic automation (covered in Lab 4).              |
| **Tags**                   | Running only specific sections of a playbook using `--tags` or `--skip-tags`.                |
| **Separation of Concerns** | Keeping configuration logic (playbook) and data (variables) separate for better scalability. |

---

## ⚙️ Lab Steps

### Step 1: Create Working Directory 🛠️

Create a dedicated directory for this lab:

```bash
cd ~/ansible-labs
mkdir lab3_5
cd lab3_5
```

---

### Step 2: Create a Reusable Playbook 🧩

Create a new file:

```bash
vi reusable-playbook.yml
```

Add the following content:

```yaml
---
- name: Demonstrate reusable and idempotent playbook design
  hosts: all
  become: yes
  tasks:
    - name: Ensure required user exists
      user:
        name: devops
        state: present

    - name: Ensure directory exists
      file:
        path: /opt/devops-tools
        state: directory
        owner: devops

    - name: Ensure latest version of git is installed
      yum:
        name: git
        state: latest

    - name: Gather package facts
      package_facts:
        manager: auto

    - name: Verify file content only if git is installed
      copy:
        dest: /opt/devops-tools/readme.txt
        content: "This is a reusable Ansible task example."
      when: ansible_facts.packages.git is defined

```

Save the file using:
**`ESC + :wq!`**

---

### Step 3: Execute and Verify Idempotency 🚀

Run the playbook:

```bash
ansible-playbook reusable-playbook.yml
```

Run it again to check **idempotency** — tasks should now show **“ok”** instead of **“changed”**, confirming safe re-execution:

```bash
ansible-playbook reusable-playbook.yml
```

---

### Step 4: Introduce Task Tags 🏷️

Tags help you run only selected tasks instead of executing the entire playbook every time.

Edit the playbook:

```bash
vi reusable-playbook.yml
```

Modify it as follows:

```yaml
---
- name: Demonstrate reusable and idempotent playbook design
  hosts: all
  become: yes
  tasks:
    - name: Ensure required user exists
      user:
        name: devops
        state: present
      tags: user

    - name: Ensure directory exists
      file:
        path: /opt/devops-tools
        state: directory
        owner: devops
      tags: setup

    - name: Ensure latest version of git is installed
      yum:
        name: git
        state: latest
      tags: install

    - name: Gather package facts
      package_facts:
        manager: auto

    - name: Verify file content only if git is installed
      copy:
        dest: /opt/devops-tools/readme.txt
        content: "This is a reusable Ansible task example."
      when: ansible_facts.packages.git is defined
      tags: verify
```

---

### Step 5: Execute Using Tags 🚀

Run only tasks tagged with **setup**:

```bash
ansible-playbook reusable-playbook.yml --tags setup
```

Skip certain tags if you want to exclude a section:

```bash
ansible-playbook reusable-playbook.yml --skip-tags install
```

---

### Step 6: Verify Results ✅

Check if directory and files were created:

```bash
ansible all -a "ls -l /opt/devops-tools" --become
```

Confirm the `readme.txt` content:

```bash
ansible all -a "cat /opt/devops-tools/readme.txt" --become
```

Check user existence:

```bash
ansible all -a "id devops" --become
```

---

## 🧠 Key Takeaways

✅ **Idempotency** — running playbooks multiple times is safe and predictable.
✅ **Tags** — run only selected parts of a playbook.
✅ **Conditional Execution** — using `when:` based on Ansible facts.
✅ **Preparation for Variables** — this lab sets the stage for using **variables and facts** dynamically in Lab 4.

---

## 🔗 What’s Next

> In **Lab 4**, we’ll take this further by replacing hardcoded values like usernames and paths with **variables** and **facts**, making automation adaptive and environment-aware.

---

✨ *You've now learned how to make your playbooks smarter, safer, and more reusable — essential traits of professional-grade automation.*
