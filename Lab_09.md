
---

# 🧪 Lab 9: Ansible Lab - Jinja2 Templates

**Objective:** Learn how to use Jinja2 templates in Ansible to generate dynamic configuration files.

---

## 🧩 1. **What are Jinja2 Templates?**

* Jinja2 is a **templating language** used by Ansible to dynamically generate text files.
* Templates allow you to insert variables, run loops, and apply conditions.
* File extension: `.j2`

**Example:**
`Hello {{ name }}` → becomes → `Hello Azhar` when rendered.

---

## 🧰 2. **Lab Setup**

Create a new working directory:

```bash
mkdir ansible-jinja2-lab
```

```bash
cd ansible-jinja2-lab
```

---

## 🧾 3. **Create the Jinja2 Template**

Create the template directory first:

```bash
mkdir templates
```

**File:** `templates/welcome.j2`

```bash
cat > templates/welcome.j2 << 'EOF'
Hello {{ user_name }} 👋

Welcome to the {{ environment }} environment.
This message was generated on {{ ansible_date_time.date }}.

Server Details:
- Hostname: {{ ansible_hostname }}
- OS: {{ ansible_facts['os_family'] }}
- IP Address: {{ ansible_default_ipv4.address }}

{% if environment == "Production" %}
⚠️  Be careful! This is a production server.
{% else %}
🧪  Safe to test and experiment here.
{% endif %}
EOF
```

---

## 🧾 4. **Create the Playbook**

**File:** `playbook.yml`

```bash
cat > playbook.yml << 'EOF'
---
- name: Jinja2 Template Demonstration
  hosts: localhost
  connection: local
  vars:
    user_name: Azhar
    environment: Development

  tasks:
    - name: Generate welcome file using Jinja2 template
      template:
        src: templates/welcome.j2
        dest: /tmp/welcome_message.txt

    - name: Show the rendered output
      command: cat /tmp/welcome_message.txt
      register: message_output

    - name: Display file content on console
      debug:
        var: message_output.stdout
EOF
```

---

## ▶️ 5. **Run the Playbook**

```bash
ansible-playbook playbook.yml
```

---

## 🧩 6. **Expected Output**

**Console Output:**

```
TASK [Display file content on console] ****************************************
ok: [localhost] => {
    "message_output.stdout": "Hello Azhar 👋

Welcome to the Development environment.
This message was generated on 2025-11-11.

Server Details:
- Hostname: localhost
- OS: Debian
- IP Address: 127.0.0.1

🧪  Safe to test and experiment here."
}
```

**Rendered File:**

```
cat /tmp/welcome_message.txt
```

---

## 🔄 7. **Test the Dynamic Nature**

Change variable values in playbook:

```yaml
vars:
  user_name: Trainer
  environment: Production
```

Re-run:

```bash
ansible-playbook playbook.yml
```

**Observe:**

* The `environment` value changes in the output.
* Conditional message now shows “⚠️ Be careful! This is a production server.”

---

## 🔁 8. **Bonus: Add a Loop**

Edit the same template to include a list of applications.

**Updated `templates/welcome.j2`**

```bash
cat > templates/welcome.j2 << 'EOF'
Hello {{ user_name }} 👋
Welcome to {{ environment }} environment.

{% if applications is defined %}
Applications Deployed:
{% for app in applications %}
- {{ app }}
{% endfor %}
{% else %}
No applications listed.
{% endif %}
EOF
```

**Update Playbook Variables:**

```yaml
vars:
  user_name: Azhar
  environment: Development
  applications:
    - Nginx
    - PostgreSQL
    - Redis
```

Run again — now it lists all apps dynamically.

---

## 🧠 9. **Key Takeaways**

| Feature         | Example                   | Description                         |
| --------------- | ------------------------- | ----------------------------------- |
| Variable        | `{{ variable }}`          | Inserts values dynamically          |
| Condition       | `{% if %}` / `{% else %}` | Adds logic to templates             |
| Loop            | `{% for x in list %}`     | Repeats content                     |
| Facts           | `{{ ansible_hostname }}`  | Uses system data                    |
| Template Module | `template:`               | Renders `.j2` files to remote nodes |

---

## ✅ **Lab Summary**

You learned how to:

1. Create and use Jinja2 templates in Ansible
2. Use variables, facts, and conditionals inside templates
3. Render templates dynamically and verify output
4. Extend templates with loops for more advanced usage

---

