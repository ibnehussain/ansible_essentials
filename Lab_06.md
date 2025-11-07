# 🧪 Lab 6: Task Inclusion in Ansible

---

## Objective
In this lab, you will learn how to:
- Create a **separate task file** containing reusable tasks.  
- Include that task file into multiple playbooks using **`include_tasks`**.  
- Use **conditional task inclusion** based on previous task results.

---

## Task 1: Create a Separate Task File

1. **Create a file named `second.yml`** that contains tasks to install and start the **httpd (Apache)** service.
   ```bash
   vi second.yml
   ```

2. **Add the following content:**
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

   **Explanation:**
   - `yum:` installs the latest version of **httpd**.  
   - `service:` ensures the **httpd** service is **started** and **enabled** on boot.  
   - This task file will be **included** later in other playbooks.

3. **Save and exit**  
   Press `ESCAPE` → type `:wq!` → press `Enter`.

---

## Task 2: Create a Playbook to Include the Task File

1. **Create a new playbook named `first.yml`**
   ```bash
   vi first.yml
   ```

2. **Add the following content:**
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

       - name: inclue task for httpd installation
         include_tasks: second.yml
   ```

   **Explanation:**
   - `include_tasks:` is used to include another YAML file containing tasks.  
   - This allows for **modular** and **reusable** playbook design.  
   - The `yum` module installs `wget` and `curl` before including the httpd installation tasks.

3. **Save and exit**  
   Press `ESCAPE` → `:wq!` → `Enter`.

4. **Execute the playbook**
   ```bash
   ansible-playbook first.yml
   ```

   The playbook will:
   - Install `wget` and `curl`.  
   - Include and execute tasks from `second.yml` (installing and starting `httpd`).

---

## Task 3: Include Tasks Conditionally

1. **Create another playbook named `third.yml`**
   ```bash
   vi third.yml
   ```

2. **Add the following content:**
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

       - name: inclue task for httpd installation
         include_tasks: second.yml
         when: out.rc == 0
   ```

   **Explanation:**
   - The first task installs common utilities and **registers** its result in the variable `out`.  
   - The `debug` task displays the **return code (`rc`)** of the previous task (0 = success).  
   - The `include_tasks:` for `second.yml` is executed **only if the previous task succeeded** (`when: out.rc == 0`).

3. **Save and exit**  
   Press `ESCAPE` → `:wq!` → `Enter`.

4. **Run the playbook**
   ```bash
   ansible-playbook third.yml
   ```

   **Expected outcome:**
   - The playbook installs `wget` and `curl`.  
   - Displays the return code (`0` on success).  
   - Includes and runs the `second.yml` tasks conditionally.

---

## Task 4: Verify Installed Packages

Check whether `wget` and `curl` are installed on all managed nodes.

```bash
ansible all -m command -a "yum list wget curl" -b
```

**Explanation:**
- `-m command` executes a command module.  
- `-a` specifies the actual shell command to run on the nodes.  
- `-b` runs the command with **sudo (become)** privileges.

---

## ✅ Summary

| Concept | Description |
|----------|--------------|
| **Task File (`second.yml`)** | Contains reusable tasks for installing and starting httpd |
| **Playbook (`first.yml`)** | Includes `second.yml` directly using `include_tasks` |
| **Playbook (`third.yml`)** | Includes tasks conditionally, only if previous task succeeds |
| **Verification Command** | Confirms installation of `wget` and `curl` |

---

## 🎓 **What You Have Learned**

Congratulations! By completing this lab, you have mastered the powerful concept of task inclusion in Ansible. Here's what you've accomplished:

### **📚 Core Knowledge Gained:**

✅ **Modular Ansible Design**
- You understand how to break down complex automation into **reusable task files**
- You've learned to create **separate YAML files** containing specific sets of tasks
- You can now design **maintainable and organized** playbook structures

✅ **Task Inclusion Techniques**
- **Direct inclusion** using `include_tasks:` directive to incorporate external task files
- **Conditional inclusion** using `when:` statements to control task execution flow
- **Result registration** using `register:` to capture and use task outcomes

✅ **Advanced Playbook Orchestration**
- **Error handling** and conditional logic based on previous task results
- **Return code evaluation** using `out.rc` to determine task success/failure
- **Dynamic workflow control** where tasks execute based on runtime conditions

✅ **Best Practices Implementation**
- **DRY Principle** (Don't Repeat Yourself) - reusing task files across multiple playbooks
- **Separation of concerns** - organizing tasks by functionality
- **Debugging techniques** using the `debug` module to troubleshoot task execution

### **🚀 Real-World Applications You Can Now Handle:**

- **Infrastructure as Code** with modular, reusable automation components
- **Multi-environment deployments** where task inclusion varies by environment
- **Complex application deployments** with conditional installation steps
- **Maintenance playbooks** that adapt based on system state and previous operations
- **CI/CD pipelines** with conditional deployment stages based on test results

### **💡 Key Takeaways:**

> **"Task inclusion transforms monolithic playbooks into flexible, modular automation that adapts to changing requirements and promotes code reusability."**

### **🛠️ Skills You Can Apply Immediately:**

- **Create reusable task libraries** for common operations (web server setup, database configuration, etc.)
- **Build intelligent playbooks** that make decisions based on runtime conditions
- **Design scalable automation** that grows with your infrastructure needs
- **Implement robust error handling** in your automation workflows
- **Collaborate effectively** with teams using shared, modular task components

You've learned to write **smarter, more flexible** Ansible automation that adapts to real-world scenarios and promotes best practices in infrastructure management! 🎯

---
