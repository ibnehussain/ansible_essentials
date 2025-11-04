# Lab 6: Ansible Templates with Jinja2

## Objective
Learn to create dynamic configuration files using Ansible templates and Jinja2 templating engine.

## Prerequisites
- Completed Labs 1-5
- Understanding of variables and vault concepts

## Lab Steps

### Step 1: Create Apache Configuration Template

Create `templates/httpd.conf.j2`:
```bash
mkdir templates
```

Create the template file `templates/httpd.conf.j2`:
```jinja2
# Apache Configuration Template
ServerRoot /etc/httpd
Listen {{ apache_port | default(80) }}
ServerName {{ server_name | default(ansible_fqdn) }}
DocumentRoot {{ document_root | default('/var/www/html') }}

# Server Administrator
ServerAdmin {{ server_admin | default('webmaster@localhost') }}

# Directory Configuration
<Directory "{{ document_root }}">
    Options {{ directory_options | default('Indexes FollowSymLinks') }}
    AllowOverride {{ allow_override | default('None') }}
    Require all granted
</Directory>

# Logging Configuration
ErrorLog {{ error_log | default('/var/log/httpd/error_log') }}
LogLevel {{ log_level | default('warn') }}

# Modules
{% for module in apache_modules %}
LoadModule {{ module }}
{% endfor %}

# Virtual Hosts
{% if virtual_hosts is defined %}
{% for vhost in virtual_hosts %}
<VirtualHost *:{{ vhost.port }}>
    ServerName {{ vhost.server_name }}
    DocumentRoot {{ vhost.document_root }}
    ErrorLog {{ vhost.error_log }}
    CustomLog {{ vhost.access_log }} combined
</VirtualHost>
{% endfor %}
{% endif %}
```

### Step 2: Create Variables File for Template

Create `template_vars.yml`:
```yaml
---
apache_port: 8080
server_name: myserver.example.com
server_admin: admin@example.com
document_root: /var/www/html
directory_options: "Indexes FollowSymLinks"
allow_override: "All"
log_level: info
apache_modules:
  - rewrite_module modules/mod_rewrite.so
  - ssl_module modules/mod_ssl.so
  - headers_module modules/mod_headers.so

virtual_hosts:
  - server_name: site1.example.com
    port: 8080
    document_root: /var/www/site1
    error_log: /var/log/httpd/site1_error.log
    access_log: /var/log/httpd/site1_access.log
  - server_name: site2.example.com
    port: 8080
    document_root: /var/www/site2
    error_log: /var/log/httpd/site2_error.log
    access_log: /var/log/httpd/site2_access.log
```

### Step 3: Create Template Deployment Playbook

Create `template-deployment.yml`:
```yaml
---
- name: Apache template deployment
  hosts: all
  become: yes
  vars_files:
    - template_vars.yml
  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: present
    
    - name: Deploy Apache configuration from template
      template:
        src: templates/httpd.conf.j2
        dest: /etc/httpd/conf/httpd.conf
        backup: yes
        owner: root
        group: root
        mode: '0644'
      notify: restart apache
    
    - name: Create virtual host directories
      file:
        path: "{{ item.document_root }}"
        state: directory
        owner: apache
        group: apache
        mode: '0755'
      loop: "{{ virtual_hosts }}"
      when: virtual_hosts is defined
    
    - name: Create sample index files for virtual hosts
      template:
        src: templates/index.html.j2
        dest: "{{ item.document_root }}/index.html"
        owner: apache
        group: apache
        mode: '0644'
      loop: "{{ virtual_hosts }}"
      when: virtual_hosts is defined
    
    - name: Start and enable Apache
      service:
        name: httpd
        state: started
        enabled: yes
  
  handlers:
    - name: restart apache
      service:
        name: httpd
        state: restarted
```

### Step 4: Create Index Template

Create `templates/index.html.j2`:
```html
<!DOCTYPE html>
<html>
<head>
    <title>{{ item.server_name }}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { color: #333; border-bottom: 2px solid #ccc; }
        .info { background: #f4f4f4; padding: 20px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome to {{ item.server_name }}</h1>
    </div>
    
    <div class="info">
        <h3>Server Information</h3>
        <ul>
            <li><strong>Server Name:</strong> {{ item.server_name }}</li>
            <li><strong>Document Root:</strong> {{ item.document_root }}</li>
            <li><strong>Generated:</strong> {{ ansible_date_time.iso8601 }}</li>
            <li><strong>Managed by:</strong> Ansible Template</li>
            <li><strong>Host:</strong> {{ ansible_hostname }}</li>
            <li><strong>IP:</strong> {{ ansible_default_ipv4.address | default('N/A') }}</li>
        </ul>
    </div>
    
    <div>
        <h3>Template Variables Used</h3>
        <pre>
Apache Port: {{ apache_port }}
Log Level: {{ log_level }}
Server Admin: {{ server_admin }}
        </pre>
    </div>
</body>
</html>
```

### Step 5: Deploy Templates

Run the template deployment:
```bash
ansible-playbook template-deployment.yml
```

Verify the generated configuration:
```bash
ansible all -a "head -20 /etc/httpd/conf/httpd.conf"
```

Check virtual host content:
```bash
ansible all -a "cat /var/www/site1/index.html"
```

### Step 6: Template Validation

Check template syntax before deployment:
```bash
ansible-playbook template-deployment.yml --check
```

Validate Apache configuration:
```bash
ansible all -a "httpd -t" --become
```

## Key Concepts Learned
- Jinja2 template syntax and filters
- Using `template` module for dynamic file generation
- Template variables and default values
- Conditional statements and loops in templates
- File backup and permissions with template module
- Integration of templates with playbooks and handlers

## Template Best Practices
- Use meaningful variable names and defaults
- Organize templates in a dedicated directory
- Validate template output before deployment
- Use backup option for critical configuration files
- Comment template files for maintainability

## Troubleshooting
- Check Jinja2 syntax for errors
- Verify variable definitions and scope
- Test templates with `--check` mode first
- Review backup files when templates fail
- Use `debug` module to inspect template variables