# Lab 7: Conditional Execution and Loops

## Objective
Master conditional statements and loops in Ansible for advanced playbook logic and automation.

## Prerequisites
- Completed Labs 1-6
- Understanding of variables and templates

## Lab Steps

### Step 1: Basic Conditional Statements

Create `conditionals-demo.yml`:
```yaml
---
- name: Conditional execution demo
  hosts: all
  become: yes
  vars:
    install_web_server: true
    environment_type: production
    users_to_create:
      - name: developer
        state: present
        create_home: yes
      - name: tester
        state: present
        create_home: yes
      - name: temp_user
        state: absent
        create_home: no
  tasks:
    - name: Install Apache (only if web server needed)
      yum:
        name: httpd
        state: present
      when: install_web_server | bool
    
    - name: Configure firewall for production
      firewalld:
        service: http
        permanent: yes
        state: enabled
      when: environment_type == "production"
      notify: reload firewall
    
    - name: Install development tools (only for dev environment)
      yum:
        name: "{{ item }}"
        state: present
      loop:
        - git
        - vim
        - curl
      when: environment_type == "development"
    
    - name: Create users based on conditions
      user:
        name: "{{ item.name }}"
        state: "{{ item.state }}"
        create_home: "{{ item.create_home }}"
      loop: "{{ users_to_create }}"
      when: item.state == "present"
  
  handlers:
    - name: reload firewall
      service:
        name: firewalld
        state: reloaded
```

### Step 2: Advanced Conditional Logic

Create `advanced-conditionals.yml`:
```yaml
---
- name: Advanced conditional examples
  hosts: all
  become: yes
  vars:
    required_packages:
      - name: httpd
        min_version: "2.4"
        required_for: ["web", "proxy"]
      - name: mysql
        min_version: "5.7"
        required_for: ["database"]
      - name: php
        min_version: "7.4"
        required_for: ["web"]
    
    server_role: web
    
  tasks:
    - name: Gather OS facts
      setup:
    
    - name: Install packages based on multiple conditions
      yum:
        name: "{{ item.name }}"
        state: present
      loop: "{{ required_packages }}"
      when: 
        - server_role in item.required_for
        - ansible_os_family == "RedHat"
    
    - name: Configure service (RedHat family only)
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      loop:
        - httpd
        - firewalld
      when: ansible_os_family == "RedHat"
    
    - name: Ubuntu specific tasks
      apt:
        name: apache2
        state: present
      when: ansible_distribution == "Ubuntu"
    
    - name: Memory-based conditional task
      debug:
        msg: "High memory server detected"
      when: ansible_memtotal_mb > 4096
```

### Step 3: Complex Loops and Iterations

Create `loops-demo.yml`:
```yaml
---
- name: Loops demonstration
  hosts: all
  become: yes
  vars:
    websites:
      - name: site1
        domain: site1.example.com
        port: 8081
        ssl_enabled: true
      - name: site2  
        domain: site2.example.com
        port: 8082
        ssl_enabled: false
      - name: site3
        domain: site3.example.com
        port: 8083
        ssl_enabled: true
    
    databases:
      - name: app_db
        user: app_user
        password: secret123
      - name: test_db
        user: test_user
        password: test456
  
  tasks:
    - name: Create website directories
      file:
        path: "/var/www/{{ item.name }}"
        state: directory
        owner: apache
        group: apache
        mode: '0755'
      loop: "{{ websites }}"
    
    - name: Create SSL directories (only for SSL-enabled sites)
      file:
        path: "/etc/ssl/{{ item.name }}"
        state: directory
        mode: '0700'
      loop: "{{ websites }}"
      when: item.ssl_enabled
    
    - name: Generate index files with site information
      template:
        src: site_index.j2
        dest: "/var/www/{{ item.name }}/index.html"
        owner: apache
        group: apache
      loop: "{{ websites }}"
    
    - name: Create database users (with_items deprecated, use loop)
      debug:
        msg: "Creating database {{ item.name }} for user {{ item.user }}"
      loop: "{{ databases }}"
    
    - name: Loop with dictionary iteration
      debug:
        msg: "Processing {{ item.key }}: {{ item.value }}"
      loop: "{{ ansible_env | dict2items }}"
      when: item.key in ['HOME', 'PATH', 'USER']
```

### Step 4: Loop Control and Filtering

Create `loop-control.yml`:
```yaml
---
- name: Advanced loop control
  hosts: all
  vars:
    large_file_list:
      - config1.conf
      - config2.conf  
      - config3.conf
      - config4.conf
      - config5.conf
    
    services_config:
      web:
        - httpd
        - nginx
      database:
        - mysqld
        - postgresql
      cache:
        - redis
        - memcached
  
  tasks:
    - name: Loop with custom label
      debug:
        msg: "Processing file {{ item }}"
      loop: "{{ large_file_list }}"
      loop_control:
        label: "{{ item | basename }}"
    
    - name: Pause between iterations
      debug:
        msg: "Creating {{ item }}"
      loop: "{{ large_file_list }}"
      loop_control:
        pause: 2
    
    - name: Loop with index
      debug:
        msg: "Item {{ my_idx }}: {{ item }}"
      loop: "{{ large_file_list }}"
      loop_control:
        index_var: my_idx
    
    - name: Nested loop with subelements
      debug:
        msg: "Service type: {{ item.0.key }}, Service: {{ item.1 }}"
      loop: "{{ services_config | dict2items | subelements('value') }}"
```

### Step 5: Execute and Test Conditionals

Run conditional playbook:
```bash
ansible-playbook conditionals-demo.yml
```

Test with different variables:
```bash
ansible-playbook conditionals-demo.yml -e "environment_type=development"
```

Run loops demonstration:
```bash
ansible-playbook loops-demo.yml
```

Test loop control:
```bash
ansible-playbook loop-control.yml
```

## Key Concepts Learned
- Basic conditional statements with `when:`
- Multiple conditions using AND/OR logic
- Fact-based conditionals with `ansible_*` variables
- Simple loops with `loop:` keyword
- Conditional loops combining `when:` and `loop:`
- Loop control with labels, pause, and indexing
- Dictionary iteration with `dict2items`
- Nested loops with `subelements`

## Best Practices
- Use meaningful condition names and variables
- Test conditionals with different variable values
- Keep conditions simple and readable
- Use loop_control for better debugging
- Combine conditions logically with lists for AND operations

## Troubleshooting
- Verify variable types and values for conditions
- Check fact gathering for ansible variables
- Test loop syntax with debug module first
- Use `--check` mode to validate conditional logic