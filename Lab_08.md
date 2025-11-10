

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
```

```bash
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
    - name: Install Apache Web Server
      yum:
        name: "{{ package_name }}"
        state: present
      notify: Restart Apache   # Handler trigger
      when: ansible_facts['os_family'] == "RedHat"  # Conditional example

    - name: Deploy sample web page
      copy:
        content: |
          <h1>Welcome to Ansible Lab</h1>
          <p>This is served from {{ ansible_hostname }}</p>
        dest: "{{ copy_dest }}"
      notify: Restart Apache

    - name: Install useful packages
      yum:
        name: "{{ item }}"
        state: present
      loop:
        - git
        - curl
        - wget

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

### **SSH to Managed Node:**

```bash
ssh ec2-user@managed-node-ip
```

### **Direct Verification on Target:**

```bash
sudo systemctl status httpd
```

```bash
cat /var/www/html/index.html
```

**You should see:**

*Welcome to Ansible Lab*  
*This is served from <hostname>*

### **Ad-hoc Commands from Control Node:**


**Check installed packages:**
```bash
ansible all -m package -a "name=git state=present" --become
```

**Verify web content:**
```bash
ansible all -m shell -a "curl -s localhost"
```

---

## ✅ Summary

| Concept          | Key Takeaway                                                 |
| ---------------- | ------------------------------------------------------------ |
| **Handlers**     | React to changes, usually for restarting/reloading services. |
| **Conditionals** | Control when a task should or shouldn’t run.                 |
| **Loops**        | Execute the same task multiple times with different items.   |

---

## 🎓 **What You Have Learned**

Congratulations! In this lab, you have successfully mastered several key Ansible concepts:

### **🔔 Handlers Mastery:**
- Learned how handlers respond only to task changes
- Implemented automatic service restarts when configurations change
- Used `notify` to trigger handlers efficiently

### **❓ Conditionals Expertise:**
- Applied OS-specific conditions with `when` statements
- Used Ansible facts to control task execution
- Implemented smart deployment logic based on system properties

### **🔄 Loops Proficiency:**
- Executed repetitive tasks efficiently using `loop`
- Installed multiple packages without writing duplicate tasks
- Streamlined playbook structure with iteration

### **🛠️ Practical Skills Gained:**
- Set up a complete web server environment
- Deployed dynamic web content using templates
- Performed comprehensive verification using both direct and ad-hoc commands
- Combined multiple Ansible concepts in a real-world scenario

### **🚀 Production-Ready Knowledge:**
- Understanding of when and how to use handlers in production
- Conditional deployment strategies for multi-environment setups
- Efficient task management through loops and iteration
- Verification techniques for ensuring deployment success

**You are now equipped to build sophisticated, efficient, and maintainable Ansible playbooks!** 🎉

---

📘 **End of Lab**
