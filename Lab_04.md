---

## 🧪 **Lab 4: Implementing Ansible Variables**

---

### **Task 1: Configuring Packages in Ansible Using Variables**


1. **Create a dedicated folder for variables practice**

   ```bash
   mkdir variables-lab && cd variables-lab
   ```

   This creates a clean workspace specifically for learning Ansible variables.

2. **Create Index HTML File** 🛠️

   Create the HTML file manually:
   ```bash
   cat > index.html << EOF
   <html>
     <body>
     <h1>Welcome to Ansible Training from CloudThat</h1>
     </body>
   </html>
   EOF
   ```

   Verify the file was created:
   ```bash
   ls -l index.html
   cat index.html
   ```

4. **Create the playbook file**

   ```bash
   vi implement-vars.yml
   ```

   We are using variables such as `hostname`, `package1`, `package2`, `portno`, and `path`.
   Instead of hardcoding values directly, we'll define them as variables to make the playbook reusable.

5. **Add the following content (press `i` to enter INSERT mode):**

   ```yaml
   ---
   - hosts: '{{ hostname }}'
     become: yes
     vars:
       hostname: all
       package1: httpd
       destination: /var/www/html/index.html
       source: /home/ec2-user/variables-labs/index.html
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

       - name: Copy required index.html to the document folder for httpd
         copy:
           src: '{{ source }}'
           dest: '{{ destination }}'
   ```

   **Explanation:**

   * `vars:` — Defines variables within the playbook.
   * `{{ variable_name }}` — Jinja2 syntax used to reference variable values.
   * The `yum` module installs packages.
   * The `service` module ensures the service is running.
   * The `copy` module transfers the HTML file to the web server’s document root.

6. **Save and exit**
   Press `ESC` → type `:wq!` → press `Enter`.

7. **Run the playbook**

   ```bash
   ansible-playbook implement-vars.yml
   ```

8. **Verify the web page**

   * Go to the **AWS Console**, copy the **Public IPv4 DNS** of your instance.
   * Paste it into a web browser.
   * The webpage should display:
     👉 **“This is the Selected Home Page”**

---

### **Task 2: Create an Alternate `index_new.html` File**

1. **Create a new HTML file**

   ```bash
   vi index1.html
   ```

2. **Add the following HTML content:**

   ```html
   <html>
     <body>
       <h1>This is the alternate Home Page</h1>
     </body>
   </html>
   ```

3. **Save and exit**
   Press `ESC` → `:wq!` → `Enter`.

4. **Run the same playbook but override the `source` variable**

   ```bash
   ansible-playbook implement-vars.yml --extra-vars "source=/home/ec2-user/ansible-labs/file/index1.html"
   ```

   **Explanation:**

   * `--extra-vars` (or `-e`) allows passing variables dynamically from the command line, overriding any values defined inside the playbook.

5. **Verify the updated webpage**

   * Refresh the browser.
   * It should now display:
     👉 **“This is the revised Home Page !!”**

---

### **Task 3: Use a Separate Variables File**

1. **Move variables into a dedicated YAML file**

   ```bash
   vi myvariables.yml
   ```

2. **Add the following content:**

   ```yaml
   ---
   hostname: all
   package1: httpd
   destination: /var/www/html/index.html
   source: /home/ec2-user/ansible-labs/index.html
   ...
   ```

   **Explanation:**

   * This file stores all variable definitions separately for better maintainability and reuse.

3. **Save and exit**
   Press `ESC` → `:wq!` → `Enter`.

4. **Edit the main playbook to reference the variable file**

   ```bash
   vi implement-vars.yml
   ```

5. **Update the playbook as follows:**

   ```yaml
   ---
   - hosts: '{{ hostname }}'
     become: yes
     vars_files:
       - myvariables.yml
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

       - name: Copy required index.html to the document folder for httpd
         copy:
           src: '{{ source }}'
           dest: '{{ destination }}'
   ```

   **Explanation:**

   * `vars_files:` — References external YAML files that contain variables.
   * This approach separates configuration from logic, making playbooks more modular and cleaner.

6. **Save and exit**
   Press `ESC` → `:wq!` → `Enter`.

7. **Run the playbook**

   ```bash
   ansible-playbook implement-vars.yml
   ```

8. **Verify the webpage again**

   * Refresh your browser.
   * It should revert to the original message:
     👉 **“This is the Selected Home Page”**

---

✅ **Summary**

* Task 1: Variables defined **inside** the playbook.
* Task 2: Variables overridden **at runtime** using `--extra-vars`.
* Task 3: Variables moved to an **external YAML file** using `vars_files`.

---


