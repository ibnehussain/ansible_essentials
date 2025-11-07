
---

## 🧪 **Lab 5: Working with Ansible Facts**

---

### **Objective**

In this lab, you will:

* Understand what **Ansible Facts** are.
* Learn how to **view**, **use**, and **filter** them in playbooks.
* Use **facts** to make your playbook dynamic based on system details.

---

### **Background**

**Ansible Facts** are system information collected automatically from managed nodes using the **`setup` module**.
They include details like:

* OS version, distribution, IP addresses, hostname, memory, CPU, and more.

Facts make your automation **smart** — you can write tasks that behave differently depending on the system.

---

### **Task 1: Display All Facts of a Managed Node**



1. **Create a folder for this lab**

   ```bash
   mkdir facts && cd facts
   ```

2. **Run the setup module to collect facts**

   ```bash
   ansible all -m setup
   ```

   **Explanation:**

   * `setup` is a built-in module that gathers all system facts from each managed host.
   * The output is in **JSON format**, showing hundreds of key-value pairs such as:

     ```
     "ansible_distribution": "Amazon",
     "ansible_os_family": "RedHat",
     "ansible_hostname": "ip-172-31-22-230"
     ```

   💡 You can filter facts using `-a 'filter=<pattern>'`.
   Examples:

   ```bash
   ansible all -m setup -a 'filter=ansible_distribution*'
   ```

   ```bash
   ansible all -m setup -a "filter=ansible_os_family"
   ```

   ```bash
   ansible all -m setup -a "filter=ansible_memory_mb"
   ```

   ```bash
   ansible all -m setup -a "filter=ansible_default_ipv4"
   ```

---

### **Task 2: Create a Playbook to Display Selected Facts**

1. **Create a playbook file**

   ```bash
   vi display-facts.yml
   ```

2. **Add the following content (press `i` to INSERT):**

   ```yaml
   ---
   - name: Display system facts using debug module
     hosts: all
     gather_facts: yes
     tasks:
       - name: Show OS distribution
         debug:
           msg: "Operating System: {{ ansible_distribution }}"

       - name: Show Hostname
         debug:
           msg: "Hostname of this node is: {{ ansible_hostname }}"

       - name: Show IP Address
         debug:
           msg: "IP Address: {{ ansible_default_ipv4.address }}"
   ```

   **Explanation:**

   * `gather_facts: yes` → automatically collects facts at the beginning of play execution.
   * `debug:` module → prints values on the screen.
   * Facts like `ansible_distribution`, `ansible_hostname`, and `ansible_default_ipv4.address` are predefined.

3. **Save and exit**
   Press `ESC` → `:wq!` → `Enter`.

4. **Run the playbook**

   ```bash
   ansible-playbook display-facts.yml
   ```

   You should see output like:

   ```
   TASK [Show OS distribution]
   ok: [node1] => {
       "msg": "Operating System: Amazon"
   }
   TASK [Show Hostname]
   ok: [node1] => {
       "msg": "Hostname of this node is: ip-172-31-22-230"
   }
   TASK [Show IP Address]
   ok: [node1] => {
       "msg": "IP Address: 172.31.22.230"
   }
   ```

---

### **Task 3: Use Facts in Conditional Tasks**

Now we’ll use facts to make decisions — for example, install a package **only** if the OS family is `RedHat`.

1. **Create a new playbook**

   ```bash
   vi conditional-facts.yml
   ```

2. **Add the following content:**

   ```yaml
   ---
   - name: Install web server based on OS family
     hosts: all
     become: yes
     gather_facts: yes
     tasks:
       - name: Install Apache if OS family is RedHat
         yum:
           name: httpd
           state: present
         when: ansible_os_family == "RedHat"

       - name: Install Apache2 if OS family is Debian
         apt:
           name: apache2
           state: present
           update_cache: yes
         when: ansible_os_family == "Debian"
   ```

   **Explanation:**

   * `when:` applies a conditional check.
   * Based on the OS type (RedHat or Debian), it installs the correct package.
   * Facts like `ansible_os_family` help make the playbook OS-independent.

3. **Save and exit**
   Press `ESC` → `:wq!` → `Enter`.

4. **Run the playbook**

   ```bash
   ansible-playbook conditional-facts.yml
   ```

   It will automatically choose the correct installation task based on the node’s OS.

---

### **Task 4: Store Facts in a File (Optional but Useful)**

If you want to save the facts of each node for later reference:

```bash
ansible all -m setup --tree ./facts_output
```

**Explanation:**

* The `--tree` option stores each host’s facts in a separate JSON file inside `facts_output/`.

Example output files:

```
facts_output/node1
facts_output/node2
```

You can open them with:

```bash
cat facts_output/node1
```

---

### ✅ **Summary**

| Concept             | Description                                                    |
| ------------------- | -------------------------------------------------------------- |
| **Facts**           | Automatically gathered system information (via `setup` module) |
| **gather_facts**    | Boolean in playbooks to enable/disable fact collection         |
| **debug module**    | Used to display fact values                                    |
| **Conditional use** | Facts can drive OS-aware automation                            |
| **Filtering**       | Use filters to retrieve only specific facts                    |

---

## 🎓 **What You Have Learned**

Congratulations! By completing this lab, you have gained valuable skills in working with Ansible Facts. Here's what you've accomplished:

### **📚 Core Knowledge Gained:**

✅ **Understanding Ansible Facts**
- You now know that facts are automatically collected system information from managed nodes
- You understand how the `setup` module gathers hundreds of system details like OS, IP addresses, memory, and CPU information

✅ **Fact Collection Techniques**
- **Manual fact gathering** using `ansible all -m setup` command
- **Filtered fact collection** using specific patterns to get targeted information
- **Automatic fact collection** in playbooks using `gather_facts: yes`

✅ **Practical Implementation Skills**
- **Created dynamic playbooks** that use system facts to display information
- **Implemented conditional logic** based on OS family (RedHat vs Debian)
- **Used debug module** effectively to display fact values in a readable format

✅ **Advanced Fact Management**
- **Filtering capabilities** to retrieve specific facts like distribution, memory, and IP addresses
- **File storage** of facts for later reference and analysis
- **Cross-platform automation** using facts to make OS-independent playbooks

### **🚀 Real-World Applications You Can Now Handle:**

- **Environment-specific deployments** that adapt based on the target system's characteristics
- **Intelligent automation** that makes decisions based on system resources and configuration
- **Multi-OS playbooks** that work seamlessly across different operating systems
- **System inventory and monitoring** using fact collection and storage
- **Conditional task execution** based on system specifications

### **💡 Key Takeaways:**

> **"Facts transform static automation into intelligent, adaptive systems that respond to their environment."**

You've learned to make your Ansible automation **smarter** and more **flexible** by leveraging the wealth of information that Ansible automatically discovers about your systems!

---


