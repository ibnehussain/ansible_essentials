
# 🧪 Lab 10: Ansible Roles - Organization and Reusability

**Objective:** Understand and create Ansible Roles using modern naming conventions to deploy a web server with reusable components.


## 🎯 **What are Ansible Roles?**

* Ansible Roles are a way to **organize and reuse** playbook components
* They provide a **standardized directory structure** for tasks, variables, files, and handlers
* Roles make your automation **modular, maintainable, and shareable**
* Follow **modern naming conventions** using `ansible.builtin.*` modules

**Benefits:**
- 📦 **Modular**: Break complex playbooks into manageable pieces
- 🔄 **Reusable**: Use the same role across multiple projects
- 🎯 **Organized**: Standardized structure for easy maintenance

---

## 🧰 **Lab Setup**

### **Step 1: Create Project Directory**

```bash
mkdir ansible-role-lab
```

```bash
cd ansible-role-lab
```

---

## 🏗️ **Create Role Structure**

### **Step 2: Generate Role Skeleton**

```bash
ansible-galaxy init roles/webserver
```

**Generated Structure:**

```
roles/webserver/
├── defaults/
│   └── main.yml
├── files/
├── handlers/
│   └── main.yml
├── meta/
│   └── main.yml
├── tasks/
│   └── main.yml
├── templates/
├── tests/
├── vars/
│   └── main.yml
```

---

## ⚙️ **Role Implementation**

> **📝 Important Note:** When creating YAML files with `vi`, the `ansible-galaxy init` command automatically generates template files with `---` delimiters and comment headers (like `# tasks file for webserver`). You can either:
> - **Keep them** (recommended for clarity)
> - **Remove them** if you prefer cleaner files
> 
> The examples below show the complete file content including these elements.

### **Step 3: Define Role Variables**

**Create the variables file:**

```bash
vi roles/webserver/vars/main.yml
```

**File content for:** `roles/webserver/vars/main.yml`

> **💡 YAML Tip:** The `---` at the beginning is optional for single-document YAML files but is good practice for clarity.

```yaml
---
web_package: httpd
web_service: httpd
web_page: index.html
```

---

### **Step 4: Create HTML Content**

**Create the HTML file:**

```bash
vi roles/webserver/files/index.html
```

**File content for:** `roles/webserver/files/index.html`

```html
<html>
  <body>
    <h1>Welcome to Apache Webserver (Managed by Ansible Role)</h1>
  </body>
</html>
```

---

### **Step 5: Define Role Tasks**

**Create the tasks file:**

```bash
vi roles/webserver/tasks/main.yml
```

**File content for:** `roles/webserver/tasks/main.yml`

```yaml
---
# tasks file for webserver

- name: Install web server package
  ansible.builtin.package:
    name: "{{ web_package }}"
    state: present

- name: Copy homepage
  ansible.builtin.copy:
    src: "{{ web_page }}"
    dest: /var/www/html/index.html
  notify: Restart Web Service

- name: Ensure web service is running and enabled
  ansible.builtin.service:
    name: "{{ web_service }}"
    state: started
    enabled: yes
```

---

### **Step 6: Configure Handlers**

**Create the handlers file:**

```bash
vi roles/webserver/handlers/main.yml
```

**File content for:** `roles/webserver/handlers/main.yml`

```yaml
---
# handlers file for webserver

- name: Restart Web Service
  ansible.builtin.service:
    name: "{{ web_service }}"
    state: restarted
```

---

## 📘 **Main Playbook**

### **Step 7: Create Playbook**

**Create the main playbook file:**

```bash
vi site.yml
```

**File content for:** `site.yml`

```yaml
---
- name: Deploy Apache Web Server using Role
  hosts: web
  become: yes

  roles:
    - roles/webserver
```

---

## ▶️ **Execute Role**

### **Step 8: Run the Playbook**

```bash
ansible-playbook site.yml
```

---

## 🔍 **Verify Deployment**

### **Step 9: Test the Web Server**

**Check service status:**

```bash
sudo systemctl status httpd
```

**Test in browser:**

Open: `http://<your_target_ip>`

**Expected Output:**

*Welcome to Apache Webserver (Managed by Ansible Role)*

---

## 🧠 **Key Takeaways**

| Topic                  | Key Concept                                             |
| ---------------------- | ------------------------------------------------------- |
| `ansible.builtin.*`    | Modern module naming standard (since Ansible 2.10)    |
| `roles:` section       | Automatically calls `tasks/main.yml`                   |
| `notify:` + `handlers` | Restart service only when file changes                 |
| `vars/`                | Role-specific variables                                 |
| `files/`               | Stores static files for copying                        |
| `reusability`          | Same role can be reused for Nginx by changing variables|

---

## ✅ **Lab Summary**

You learned how to:

1. Create and structure Ansible roles using modern conventions
2. Organize tasks, variables, files, and handlers in a standardized way
3. Use `ansible.builtin.*` modules for future-proof automation
4. Deploy a complete web server using reusable role components
5. Implement handlers for efficient service management

---

## 🎉 **Congratulations!**

**🏆 Outstanding Achievement!** You've mastered Ansible Roles - the foundation of scalable automation!

**🎯 Skills Unlocked:**
- ✅ Modular automation design with roles
- ✅ Standardized project organization
- ✅ Reusable component development
- ✅ Modern Ansible best practices

**🚀 You're now ready to:**
- Build enterprise-scale automation frameworks
- Create shareable automation libraries
- Implement complex multi-service deployments
- Lead infrastructure-as-code initiatives

**Amazing work! You've completed the Ansible essentials journey and are now equipped to automate at scale!** 🌟

---

