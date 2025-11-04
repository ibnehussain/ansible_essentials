# Lab 8: Handlers and Notifications

## Objective
Learn to implement handlers for service management and automated response to configuration changes.

## Prerequisites
- Completed Labs 1-7
- Understanding of playbooks and conditionals

## Lab Steps

### Step 1: Basic Handler Implementation

Create `handlers-demo.yml`:
```yaml
---
- name: Handlers demonstration
  hosts: all
  become: yes
  vars:
    web_server_port: 8080
    enable_ssl: true
  
  tasks:
    - name: Install Apache web server
      yum:
        name: httpd
        state: present
    
    - name: Configure Apache main config
      template:
        src: templates/httpd.conf.j2
        dest: /etc/httpd/conf/httpd.conf
        backup: yes
      notify:
        - restart apache
        - check apache status
    
    - name: Install SSL module
      yum:
        name: mod_ssl
        state: present
      notify: restart apache
      when: enable_ssl
    
    - name: Configure SSL certificate
      copy:
        content: |
          # SSL Certificate Configuration
          SSLEngine on
          SSLCertificateFile /etc/ssl/certs/server.crt
          SSLCertificateKeyFile /etc/ssl/private/server.key
        dest: /etc/httpd/conf.d/ssl.conf
      notify:
        - restart apache
        - reload ssl config
      when: enable_ssl
    
    - name: Create custom index page
      copy:
        content: |
          <html>
          <body>
          <h1>Apache Server with Handlers</h1>
          <p>Server configured with port: {{ web_server_port }}</p>
          <p>SSL Enabled: {{ enable_ssl }}</p>
          <p>Last updated: {{ ansible_date_time.iso8601 }}</p>
          </body>
          </html>
        dest: /var/www/html/index.html
    
    - name: Start Apache service
      service:
        name: httpd
        state: started
        enabled: yes
  
  handlers:
    - name: restart apache
      service:
        name: httpd
        state: restarted
    
    - name: reload apache
      service:
        name: httpd
        state: reloaded
    
    - name: check apache status
      command: systemctl status httpd
      register: apache_status
    
    - name: reload ssl config
      command: systemctl reload httpd
      listen: "reload ssl config"
```

### Step 2: Advanced Handler Scenarios

Create `advanced-handlers.yml`:
```yaml
---
- name: Advanced handlers with dependencies
  hosts: all
  become: yes
  vars:
    services:
      - name: httpd
        config_file: /etc/httpd/conf/httpd.conf
        config_template: httpd.conf.j2
      - name: mysqld
        config_file: /etc/my.cnf
        config_template: my.cnf.j2
    
    firewall_rules:
      - port: 80
        protocol: tcp
      - port: 443
        protocol: tcp
      - port: 3306
        protocol: tcp
  
  tasks:
    - name: Install services
      yum:
        name: "{{ item.name }}"
        state: present
      loop: "{{ services }}"
      notify: 
        - "restart {{ item.name }}"
    
    - name: Configure service files
      template:
        src: "{{ item.config_template }}"
        dest: "{{ item.config_file }}"
        backup: yes
      loop: "{{ services }}"
      notify:
        - "restart {{ item.name }}"
        - validate configuration
    
    - name: Configure firewall rules
      firewalld:
        port: "{{ item.port }}/{{ item.protocol }}"
        permanent: yes
        state: enabled
      loop: "{{ firewall_rules }}"
      notify: reload firewall
    
    - name: Deploy application files
      copy:
        src: "{{ item }}"
        dest: "/opt/myapp/"
      with_fileglob:
        - "files/app/*"
      notify:
        - restart application
        - clear cache
  
  handlers:
    - name: restart httpd
      service:
        name: httpd
        state: restarted
    
    - name: restart mysqld
      service:
        name: mysqld
        state: restarted
    
    - name: reload firewall
      service:
        name: firewalld
        state: reloaded
    
    - name: validate configuration
      command: "{{ item }}"
      loop:
        - "httpd -t"
        - "mysqld --help --verbose > /dev/null"
      ignore_errors: yes
    
    - name: restart application
      systemd:
        name: myapp
        state: restarted
        daemon_reload: yes
    
    - name: clear cache
      command: rm -rf /tmp/app_cache/*
      args:
        removes: /tmp/app_cache
```

### Step 3: Handler Groups and Listening

Create `handler-groups.yml`:
```yaml
---
- name: Handler groups and listen demonstration
  hosts: all
  become: yes
  
  tasks:
    - name: Update web server configuration
      template:
        src: apache-vhost.j2
        dest: /etc/httpd/conf.d/vhost.conf
      notify: "restart web services"
    
    - name: Update database configuration
      template:
        src: database.conf.j2
        dest: /etc/database.conf
      notify: "restart database services"
    
    - name: Update load balancer config
      template:
        src: haproxy.cfg.j2
        dest: /etc/haproxy/haproxy.cfg
      notify: "restart web services"
    
    - name: Update monitoring configuration
      copy:
        content: |
          [monitoring]
          enabled=true
          interval=30
          endpoint=http://monitor.example.com
        dest: /etc/monitor.conf
      notify: "restart monitoring"
  
  handlers:
    # Web services group
    - name: restart apache
      service:
        name: httpd
        state: restarted
      listen: "restart web services"
    
    - name: restart haproxy
      service:
        name: haproxy
        state: restarted
      listen: "restart web services"
    
    - name: validate web config
      uri:
        url: "http://localhost"
        method: GET
      listen: "restart web services"
    
    # Database services group
    - name: restart mysql
      service:
        name: mysqld
        state: restarted
      listen: "restart database services"
    
    - name: restart redis
      service:
        name: redis
        state: restarted
      listen: "restart database services"
    
    # Monitoring group
    - name: restart monitoring agent
      service:
        name: monitoring-agent
        state: restarted
      listen: "restart monitoring"
    
    - name: send notification
      mail:
        to: admin@example.com
        subject: "Monitoring configuration updated"
        body: "Monitoring has been reconfigured on {{ ansible_hostname }}"
      listen: "restart monitoring"
```

### Step 4: Handler Error Handling and Debugging

Create `handler-debugging.yml`:
```yaml
---
- name: Handler debugging and error handling
  hosts: all
  become: yes
  
  tasks:
    - name: Update configuration with potential issues
      copy:
        content: |
          # Configuration that might cause service restart issues
          ServerName {{ ansible_fqdn }}
          Listen 80
        dest: /etc/httpd/conf.d/debug.conf
      notify: debug restart apache
    
    - name: Force handler execution for testing
      meta: flush_handlers
    
    - name: Continue with other tasks
      debug:
        msg: "Handlers have been flushed, continuing..."
  
  handlers:
    - name: debug restart apache
      block:
        - name: Test configuration before restart
          command: httpd -t
          register: config_test
          failed_when: false
        
        - name: Show configuration test results
          debug:
            var: config_test
        
        - name: Restart apache if config is valid
          service:
            name: httpd
            state: restarted
          when: config_test.rc == 0
        
        - name: Show error if config is invalid
          debug:
            msg: "Apache configuration is invalid, not restarting service"
          when: config_test.rc != 0
      rescue:
        - name: Handle restart failure
          debug:
            msg: "Apache restart failed, rolling back configuration"
        
        - name: Restore backup configuration
          copy:
            src: /etc/httpd/conf.d/debug.conf.backup
            dest: /etc/httpd/conf.d/debug.conf
            remote_src: yes
          ignore_errors: yes
```

### Step 5: Execute Handler Demonstrations

Run basic handlers:
```bash
ansible-playbook handlers-demo.yml
```

Test advanced handlers:
```bash
ansible-playbook advanced-handlers.yml
```

Run handler groups:
```bash
ansible-playbook handler-groups.yml
```

Test debugging handlers:
```bash
ansible-playbook handler-debugging.yml
```

Force handler execution:
```bash
ansible-playbook handlers-demo.yml --force-handlers
```

## Key Concepts Learned
- Handler definition and notification with `notify:`
- Handler execution order and timing
- Multiple handlers for single notifications
- Handler groups using `listen:` keyword
- Handler error handling with `block:` and `rescue:`
- Forcing handler execution with `meta: flush_handlers`
- Handler debugging and validation techniques

## Best Practices
- Use descriptive handler names
- Group related handlers with `listen:`
- Test configuration before service restarts
- Handle service restart failures gracefully
- Use `meta: flush_handlers` when needed for dependencies

## Troubleshooting
- Verify handler names match notify statements exactly
- Check service names and states in handler definitions
- Use `--force-handlers` to run handlers even after task failures
- Debug handlers with `register:` and `debug:` modules
- Test handlers individually before full playbook execution