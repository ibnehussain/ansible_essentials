# Lab 4: Working with Variables and Facts

## Objective
Learn to define, use, and manage variables in Ansible, including system facts and custom variables.

## Prerequisites
- Completed Labs 1-3
- Understanding of playbook structure and basic modules

## Lab Steps

### Step 1: Understanding Ansible Facts

Gather and display system facts:
```bash
ansible all -m setup
```

Display specific facts:
```bash
ansible all -m setup -a "filter=ansible_os_family"
```

Display memory information:
```bash
ansible all -m setup -a "filter=ansible_memory_mb"
```

Display network facts:
```bash
ansible all -m setup -a "filter=ansible_default_ipv4"
```

### Step 2: Create Variables File

Create `group_vars/all.yml`:
```yaml
---
# Global variables for all hosts
application_name: MyWebApp
application_version: "2.1.0"
application_port: 8080
application_user: webapp
application_group: webapp

# Database configuration
db_name: mywebapp_db
db_user: webapp_user
db_password: SecurePassword123

# Package lists
web_packages:
  - httpd
  - php
  - php-mysql
  - mod_ssl

# File paths
app_directory: /opt/mywebapp
config_directory: /etc/mywebapp
log_directory: /var/log/mywebapp
```

### Step 3: Create Host-Specific Variables

Create `host_vars/localhost.yml`:
```yaml
---
# Host-specific variables for localhost
server_role: development
debug_mode: true
backup_enabled: false
max_connections: 50

# Development-specific settings
development_features:
  - debug_toolbar
  - test_data
  - logging_verbose
```

### Step 4: Variables in Playbook

Create `variables-demo.yml`:
```yaml
---
- name: Variables and facts demonstration
  hosts: all
  become: yes
  vars:
    # Playbook-level variables
    deployment_date: "{{ ansible_date_time.date }}"
    deployment_user: "{{ ansible_user_id }}"
    
  vars_files:
    - group_vars/all.yml
    
  tasks:
    - name: Display system facts
      debug:
        msg: |
          System Information:
          - Hostname: {{ ansible_hostname }}
          - OS Family: {{ ansible_os_family }}
          - Distribution: {{ ansible_distribution }} {{ ansible_distribution_version }}
          - Architecture: {{ ansible_architecture }}
          - Memory: {{ ansible_memtotal_mb }}MB
          - CPU Cores: {{ ansible_processor_cores }}
    
    - name: Display custom variables
      debug:
        msg: |
          Application Configuration:
          - Name: {{ application_name }}
          - Version: {{ application_version }}
          - Port: {{ application_port }}
          - User: {{ application_user }}
          - Directory: {{ app_directory }}
    
    - name: Create application user
      user:
        name: "{{ application_user }}"
        group: "{{ application_group }}"
        create_home: yes
        shell: /bin/bash
        state: present
    
    - name: Create application directories
      file:
        path: "{{ item }}"
        state: directory
        owner: "{{ application_user }}"
        group: "{{ application_group }}"
        mode: '0755'
      loop:
        - "{{ app_directory }}"
        - "{{ config_directory }}"
        - "{{ log_directory }}"
    
    - name: Install web packages
      yum:
        name: "{{ web_packages }}"
        state: present
    
    - name: Create configuration file with variables
      copy:
        content: |
          # {{ application_name }} Configuration
          # Generated on {{ deployment_date }} by {{ deployment_user }}
          
          [application]
          name={{ application_name }}
          version={{ application_version }}
          port={{ application_port }}
          user={{ application_user }}
          
          [paths]
          app_dir={{ app_directory }}
          config_dir={{ config_directory }}
          log_dir={{ log_directory }}
          
          [database]
          name={{ db_name }}
          user={{ db_user }}
          # Note: password stored in vault
          
          [system]
          hostname={{ ansible_hostname }}
          os={{ ansible_distribution }}
          memory_mb={{ ansible_memtotal_mb }}
          
        dest: "{{ config_directory }}/app.conf"
        owner: "{{ application_user }}"
        group: "{{ application_group }}"
        mode: '0644'
```

### Step 5: Variable Precedence and Registration

Create `variable-precedence.yml`:
```yaml
---
- name: Variable precedence demonstration
  hosts: all
  vars:
    test_var: "playbook_level"
    environment_type: "{{ env_type | default('development') }}"
    
  tasks:
    - name: Show initial variable value
      debug:
        var: test_var
    
    - name: Override variable at task level
      debug:
        var: test_var
      vars:
        test_var: "task_level"
    
    - name: Register command output as variable
      command: date +%Y-%m-%d
      register: current_date
      changed_when: false
    
    - name: Use registered variable
      debug:
        msg: "Today's date is {{ current_date.stdout }}"
    
    - name: Register complex command output
      shell: |
        df -h | grep -v tmpfs | head -5
      register: disk_info
      changed_when: false
    
    - name: Display disk information
      debug:
        var: disk_info.stdout_lines
    
    - name: Set fact dynamically
      set_fact:
        dynamic_config:
          server_id: "{{ ansible_hostname }}_{{ ansible_date_time.epoch }}"
          total_memory: "{{ ansible_memtotal_mb }}"
          ip_address: "{{ ansible_default_ipv4.address | default('unknown') }}"
    
    - name: Use dynamic fact
      debug:
        var: dynamic_config
```

### Step 6: Variable Prompts and Runtime Variables

Create `interactive-variables.yml`:
```yaml
---
- name: Interactive variable collection
  hosts: all
  vars_prompt:
    - name: app_environment
      prompt: "Enter application environment (dev/test/prod)"
      default: "dev"
      private: false
    
    - name: admin_password
      prompt: "Enter admin password"
      private: true
      confirm: true
    
    - name: enable_ssl
      prompt: "Enable SSL? (yes/no)"
      default: "no"
      private: false
    
  vars:
    ssl_enabled: "{{ enable_ssl | bool }}"
    
  tasks:
    - name: Display collected variables
      debug:
        msg: |
          Configuration Summary:
          - Environment: {{ app_environment }}
          - SSL Enabled: {{ ssl_enabled }}
          - Admin user configured: {{ admin_password is defined }}
    
    - name: Configure based on environment
      debug:
        msg: "Setting up {{ app_environment }} environment configuration"
      when: app_environment in ['dev', 'test', 'prod']
    
    - name: SSL-specific configuration
      debug:
        msg: "Configuring SSL certificates and keys"
      when: ssl_enabled
```

### Step 7: Execute Variable Playbooks

Run the variables demonstration:
```bash
ansible-playbook variables-demo.yml
```

Test variable precedence:
```bash
ansible-playbook variable-precedence.yml
```

Run with extra variables:
```bash
ansible-playbook variable-precedence.yml -e "env_type=production"
```

Run interactive playbook:
```bash
ansible-playbook interactive-variables.yml
```

Display all variables for debugging:
```bash
ansible-playbook variables-demo.yml -e "debug_mode=true"
```

## Key Concepts Learned
- System facts collection and filtering with `setup` module
- Variable definition in multiple locations (playbook, files, host/group vars)
- Variable precedence order and scope
- Registered variables with `register:` keyword
- Dynamic facts with `set_fact:` module
- Interactive variable collection with `vars_prompt:`
- Using variables in templates and conditionals

## Variable Precedence Order (highest to lowest)
1. Extra vars (-e command line)
2. Task vars (in task)
3. Block vars (in block)
4. Role and include vars
5. Play vars
6. Host facts
7. Registered vars
8. Set_facts
9. Host vars
10. Group vars
11. Role defaults

## Troubleshooting
- Use `debug:` module to inspect variable values and types
- Check variable precedence when unexpected values appear
- Verify YAML syntax in variable files
- Use `ansible-inventory --list` to see effective variables
- Test variable filters and transformations separately