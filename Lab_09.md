# Lab 9: Error Handling and Debugging

## Objective
Master error handling, debugging techniques, and troubleshooting strategies in Ansible playbooks.

## Prerequisites
- Completed Labs 1-8
- Understanding of handlers and advanced playbook features

## Lab Steps

### Step 1: Basic Error Handling

Create `error-handling-basics.yml`:
```yaml
---
- name: Basic error handling demonstration
  hosts: all
  become: yes
  vars:
    continue_on_error: true
    
  tasks:
    - name: Task that might fail
      command: /bin/false
      register: result
      failed_when: false
      changed_when: false
    
    - name: Show result of previous task
      debug:
        var: result
    
    - name: Task with ignore_errors
      command: ls /nonexistent/directory
      ignore_errors: yes
    
    - name: Task continues after ignored error
      debug:
        msg: "This task runs despite the previous error"
    
    - name: Custom failure condition
      command: echo "test output"
      register: command_output
      failed_when: "'error' in command_output.stdout"
    
    - name: Another custom failure condition
      uri:
        url: http://httpbin.org/status/404
        method: GET
      register: web_result
      failed_when: web_result.status != 200
      ignore_errors: "{{ continue_on_error }}"
```

### Step 2: Advanced Error Handling with Blocks

Create `block-error-handling.yml`:
```yaml
---
- name: Block-based error handling
  hosts: all
  become: yes
  
  tasks:
    - name: Attempt risky operations with recovery
      block:
        - name: Try to install a package
          yum:
            name: nonexistent-package
            state: present
        
        - name: Configure the package
          copy:
            content: "config content"
            dest: /etc/nonexistent.conf
        
        - name: Start the service
          service:
            name: nonexistent-service
            state: started
      
      rescue:
        - name: Handle installation failure
          debug:
            msg: "Package installation failed, installing alternative"
        
        - name: Install alternative package
          yum:
            name: curl
            state: present
        
        - name: Create alternative configuration
          copy:
            content: |
              # Alternative configuration
              fallback_mode=true
            dest: /etc/fallback.conf
      
      always:
        - name: Cleanup task that always runs
          debug:
            msg: "Cleanup completed regardless of success or failure"
        
        - name: Log the operation
          lineinfile:
            path: /var/log/ansible-operations.log
            line: "{{ ansible_date_time.iso8601 }} - Error handling block executed"
            create: yes
```

### Step 3: Debugging with Debug Module

Create `debug-techniques.yml`:
```yaml
---
- name: Debugging techniques demonstration
  hosts: all
  gather_facts: yes
  vars:
    debug_mode: true
    app_config:
      name: myapp
      version: "2.1.0"
      ports: [8080, 8443]
      features:
        ssl: true
        logging: debug
        cache: enabled
  
  tasks:
    - name: Debug variable content
      debug:
        var: app_config
      when: debug_mode
    
    - name: Debug with custom message
      debug:
        msg: "Application {{ app_config.name }} version {{ app_config.version }}"
    
    - name: Debug ansible facts
      debug:
        msg: |
          Hostname: {{ ansible_hostname }}
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }}
          Memory: {{ ansible_memtotal_mb }}MB
          IP: {{ ansible_default_ipv4.address | default('N/A') }}
    
    - name: Debug with conditional display
      debug:
        var: item
      loop: "{{ app_config.ports }}"
      when: 
        - debug_mode
        - item > 8000
    
    - name: Register and debug command output
      command: df -h
      register: disk_usage
    
    - name: Show command results
      debug:
        var: disk_usage
        verbosity: 2
    
    - name: Debug complex data structures
      debug:
        msg: |
          Port: {{ item }}
          SSL Available: {{ app_config.features.ssl }}
          Config: {{ app_config | to_nice_json }}
      loop: "{{ app_config.ports }}"
```

### Step 4: Comprehensive Error Recovery

Create `error-recovery.yml`:
```yaml
---
- name: Comprehensive error recovery strategies
  hosts: all
  become: yes
  vars:
    max_retries: 3
    retry_delay: 5
    
  tasks:
    - name: Download with retry logic
      block:
        - name: Attempt file download
          get_url:
            url: http://example.com/myfile.tar.gz
            dest: /tmp/myfile.tar.gz
            timeout: 10
          register: download_result
          retries: "{{ max_retries }}"
          delay: "{{ retry_delay }}"
          until: download_result is succeeded
      
      rescue:
        - name: Use local backup file
          copy:
            src: files/myfile.tar.gz
            dest: /tmp/myfile.tar.gz
          register: backup_copy
        
        - name: Log fallback action
          debug:
            msg: "Used local backup file due to download failure"
    
    - name: Service management with error handling
      block:
        - name: Stop service for maintenance
          service:
            name: httpd
            state: stopped
        
        - name: Update configuration
          template:
            src: httpd.conf.j2
            dest: /etc/httpd/conf/httpd.conf
            backup: yes
          register: config_update
        
        - name: Validate configuration
          command: httpd -t
          register: config_validation
        
        - name: Start service after validation
          service:
            name: httpd
            state: started
      
      rescue:
        - name: Restore configuration backup
          copy:
            src: "{{ config_update.backup_file }}"
            dest: /etc/httpd/conf/httpd.conf
            remote_src: yes
          when: config_update.backup_file is defined
        
        - name: Restart service with old config
          service:
            name: httpd
            state: started
        
        - name: Notify administrators
          debug:
            msg: "Configuration update failed, service restored with backup config"
      
      always:
        - name: Ensure service is running
          service:
            name: httpd
            state: started
          register: final_service_state
        
        - name: Report final status
          debug:
            msg: "Service final state: {{ final_service_state.state | default('unknown') }}"
```

### Step 5: Debugging with Increased Verbosity

Create `verbose-debugging.yml`:
```yaml
---
- name: Verbose debugging examples
  hosts: all
  tasks:
    - name: Task with multiple debug levels
      debug:
        msg: "This appears at default verbosity"
    
    - name: Detailed debug information
      debug:
        msg: "This appears with -v (verbosity 1)"
        verbosity: 1
    
    - name: Very detailed debug
      debug:
        msg: "This appears with -vv (verbosity 2)"
        verbosity: 2
    
    - name: Extremely detailed debug
      debug:
        msg: "This appears with -vvv (verbosity 3)"
        verbosity: 3
    
    - name: Conditional debugging based on facts
      debug:
        msg: |
          Detailed system information:
          - Architecture: {{ ansible_architecture }}
          - Kernel: {{ ansible_kernel }}
          - Python version: {{ ansible_python_version }}
          - All network interfaces: {{ ansible_interfaces }}
        verbosity: 2
      when: ansible_hostname is defined
```

### Step 6: Execute and Test Error Handling

Run basic error handling:
```bash
ansible-playbook error-handling-basics.yml
```

Test block error handling:
```bash
ansible-playbook block-error-handling.yml
```

Run with debugging:
```bash
ansible-playbook debug-techniques.yml
```

Test with different verbosity levels:
```bash
ansible-playbook verbose-debugging.yml -v
```
```bash
ansible-playbook verbose-debugging.yml -vv
```
```bash
ansible-playbook verbose-debugging.yml -vvv
```

Test error recovery:
```bash
ansible-playbook error-recovery.yml
```

Run in check mode for debugging:
```bash
ansible-playbook debug-techniques.yml --check
```

## Key Concepts Learned
- Basic error handling with `ignore_errors` and `failed_when`
- Advanced error handling using `block:`, `rescue:`, and `always:`
- Custom failure conditions and error recovery strategies
- Debugging with `debug:` module and various verbosity levels
- Retry logic with `retries:`, `delay:`, and `until:`
- Using `register:` to capture and analyze task results
- Check mode and diff mode for safe testing

## Best Practices
- Always provide meaningful error messages
- Use block/rescue for complex operations
- Implement proper cleanup in `always:` sections
- Use appropriate verbosity levels for debug output
- Test error conditions explicitly
- Document error handling strategies

## Troubleshooting Commands
- Use `-v`, `-vv`, `-vvv` for increased verbosity
- Use `--check` mode for dry runs
- Use `--diff` to see file changes
- Use `--step` for interactive execution
- Use `--start-at-task` to resume from specific tasks